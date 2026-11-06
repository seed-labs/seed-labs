"""Strict manifest validation and repository-relative path handling."""
from pathlib import Path

import jsonschema
import yaml

ROOT = Path(__file__).resolve().parents[3]
TESTING = Path(__file__).resolve().parents[1]


class ManifestError(ValueError):
    pass


class UniqueLoader(yaml.SafeLoader):
    """Reject duplicate keys rather than silently replacing a requirement."""


def mapping(loader, node):
    result = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node)
        if key in result:
            raise ManifestError(f"duplicate YAML key: {key}")
        result[key] = loader.construct_object(value_node)
    return result


UniqueLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, mapping)


def inside(base, value):
    path = Path(value)
    if path.is_absolute():
        raise ManifestError(f"expected a relative path: {value}")
    resolved = (base / path).resolve()
    if not resolved.is_relative_to(base.resolve()):
        raise ManifestError(f"path escapes {base}: {value}")
    return resolved


class Manifest:
    def __init__(self, path, variant, root=ROOT):
        self.path = Path(path).resolve()
        self.root = Path(root).resolve()
        try:
            self.data = yaml.load(self.path.read_text(), Loader=UniqueLoader)
            schema = yaml.safe_load((TESTING / "schema.yaml").read_text())
            jsonschema.Draft202012Validator(schema).validate(self.data)
        except (OSError, yaml.YAMLError, jsonschema.ValidationError) as exc:
            raise ManifestError(str(exc)) from exc
        if variant not in self.data["variants"]:
            raise ManifestError(f"unknown variant {variant}; choose {list(self.data['variants'])}")
        self.variant = variant
        self.config = self.data["variants"][variant]
        self.setup = inside(self.root, self.config["setup"])
        if not self.setup.is_dir():
            raise ManifestError(f"setup directory missing: {self.setup}")
        inside(self.setup, self.data["runtime"]["compose"])
        for req in self.data["requirements"].values():
            if not inside(self.root, req["source"]).is_file():
                raise ManifestError(f"requirement source missing: {req['source']}")
        ids = set()
        for check in self.data["runtime"]["readiness"] + self.data["checks"]:
            fields = {
                "exec": {"service", "argv", "expect_exit", "stdout_contains"},
                "http": {"url", "connect_address", "headers", "expect_status", "body_contains", "expected_headers"},
                "file": {"service", "path", "source", "executable"},
                "service-state": {"service", "expected"},
                "container-ip": {"service", "expected"},
            }
            common = {"id", "type", "requirement", "required", "timeout", "retries", "interval"}
            unused = set(check) - common - fields[check["type"]]
            if unused:
                raise ManifestError(f"unused fields for {check['type']}: {sorted(unused)}")
            if check["id"] in ids:
                raise ManifestError(f"duplicate check id: {check['id']}")
            ids.add(check["id"])
            if check["requirement"] not in self.data["requirements"]:
                raise ManifestError(f"unknown requirement: {check['requirement']}")
            if check["type"] in ("exec", "file", "service-state", "container-ip"):
                if check["service"] not in self.data["runtime"]["services"]:
                    raise ManifestError(f"undeclared service: {check['service']}")
            if check["type"] == "file":
                if not inside(self.setup, check["source"]).is_file():
                    raise ManifestError(f"comparison source missing: {check['source']}")
        for dependency in self.data.get("dependencies", []):
            if not inside(self.root, dependency).exists():
                raise ManifestError(f"dependency missing: {dependency}")
        for step in self.data.get("prepare", []):
            inside(self.setup, step.get("cwd", "."))
            for output in step["expected"]:
                inside(self.setup, output)
        for service, config in self.data["runtime"]["services"].items():
            if config["role"] == "build-only":
                continue
            expected = "running" if config["role"] == "daemon" else "exited-0"
            if not any(c["type"] == "service-state" and c["service"] == service
                       and c["expected"] == expected and c.get("required", True)
                       for c in self.data["runtime"]["readiness"]):
                raise ManifestError(f"{service} needs a required service-state readiness check for {expected}")

    def static(self):
        """Check inputs without modifying files or contacting Docker."""
        def verify_tree(path, ancestors=frozenset()):
            if path.is_symlink() and not path.exists():
                raise ManifestError(f"broken symlink: {path} -> {path.readlink()}")
            resolved = path.resolve()
            if not resolved.is_relative_to(self.root):
                raise ManifestError(f"symlink leaves repository: {path}")
            if path.is_dir():
                if resolved in ancestors:
                    raise ManifestError(f"directory symlink cycle: {path}")
                for child in path.iterdir():
                    verify_tree(child, ancestors | {resolved})
        for base in [self.setup] + [inside(self.root, p) for p in self.data.get("dependencies", [])]:
            verify_tree(base)
        compose = inside(self.setup, self.data["runtime"]["compose"])
        if not compose.is_file():
            # Generated Compose is allowed only with an explicit preparation pipeline.
            if not self.data.get("prepare"):
                raise ManifestError(f"Compose entry missing: {compose}")
        else:
            cfg = yaml.load(compose.read_text(), Loader=UniqueLoader)
            if not isinstance(cfg, dict) or not isinstance(cfg.get("services"), dict):
                raise ManifestError(f"invalid Compose structure: {compose}")
            if set(self.data["runtime"]["services"]) != set(cfg["services"]):
                raise ManifestError("every Compose service must have a declared role")
            for name, spec in cfg["services"].items():
                build = spec.get("build")
                if build:
                    context = (compose.parent / (build if isinstance(build, str) else build["context"])).resolve()
                    if not context.is_relative_to(self.root):
                        raise ManifestError(f"build context leaves repository: {context}")
                    dockerfile = "Dockerfile" if isinstance(build, str) else build.get("dockerfile", "Dockerfile")
                    if not (context / dockerfile).is_file():
                        raise ManifestError(f"Dockerfile missing for {name}: {context / dockerfile}")
        return f"{self.data['id']} / {self.variant}: manifest and input paths valid"
