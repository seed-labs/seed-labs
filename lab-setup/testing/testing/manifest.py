"""Manifest loading and repository-relative path handling."""
from pathlib import Path

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
        except (OSError, yaml.YAMLError) as exc:
            raise ManifestError(str(exc)) from exc
        required = {"id", "category", "description", "requirements", "variants", "runtime", "checks"}
        if not isinstance(self.data, dict) or required - self.data.keys():
            raise ManifestError(f"manifest must contain: {', '.join(sorted(required))}")
        if self.data["runtime"].get("backend") not in ("host", "compose"):
            raise ManifestError("runtime.backend must be host or compose")
        if variant not in self.data["variants"]:
            raise ManifestError(f"unknown variant {variant}; choose {list(self.data['variants'])}")
        self.variant = variant
        self.config = self.data["variants"][variant]
        self.setup = inside(self.root, self.config["setup"])
        if not self.setup.is_dir():
            raise ManifestError(f"setup directory missing: {self.setup}")
        if "compose" in self.data["runtime"]:
            inside(self.setup, self.data["runtime"]["compose"])
        for req in self.data["requirements"].values():
            if not inside(self.root, req["source"]).is_file():
                raise ManifestError(f"requirement source missing: {req['source']}")
        ids = set()
        for check in self.data["runtime"]["readiness"] + self.data["checks"]:
            fields = {
                "exec": {"service", "argv", "expect_exit", "stdout_contains", "stdout_equals"},
                "host-exec": {"argv", "expect_exit", "stdout_contains", "stdout_equals", "privileged"},
                "http": {"url", "connect_address", "headers", "expect_status", "body_contains", "expected_headers", "absent_headers"},
                "web-login": {"url", "connect_address", "username", "password", "login_path", "body_contains"},
                "file": {"service", "path", "source", "executable"},
                "service-state": {"service", "expected"},
                "container-ip": {"service", "expected"},
                "interface-ip": {"service", "expected"},
                "service-group": {"services", "expected"},
                "interface-addresses": {"addresses"},
                "elf": {"source", "elf_class", "machine", "static", "executable_stack"},
                "process-uid": {"service", "path", "expected_euid"},
                "format-input": {"host", "port", "service", "requests"},
                "buffer-input": {"host", "port", "service", "requests"},
                "tcp": {"host", "port"},
                "container-network-mode": {"service", "expected"},
            }
            if check["type"] not in fields:
                raise ManifestError(f"unknown check type: {check['type']}")
            common = {"id", "type", "requirement", "required", "timeout", "retries", "interval", "variants"}
            unused = set(check) - common - fields[check["type"]]
            if unused:
                raise ManifestError(f"unused fields for {check['type']}: {sorted(unused)}")
            if check["id"] in ids:
                raise ManifestError(f"duplicate check id: {check['id']}")
            ids.add(check["id"])
            if check["requirement"] not in self.data["requirements"]:
                raise ManifestError(f"unknown requirement: {check['requirement']}")
            self.validate_variants(check)
            if check["type"] in ("exec", "file", "service-state", "container-ip", "interface-ip", "process-uid", "format-input", "buffer-input", "container-network-mode"):
                if check["service"] not in self.data["runtime"].get("services", {}):
                    raise ManifestError(f"undeclared service: {check['service']}")
            grouped = check.get("services", list(check.get("addresses", {})))
            if set(grouped) - set(self.data["runtime"].get("services", {})):
                raise ManifestError("grouped probe references undeclared services")
            if check["type"] in ("file", "elf") and self.active(check):
                source = inside(self.setup, check["source"])
                generated = {p for step in self.preparation() for p in step["expected"]}
                if not source.is_file() and check["source"] not in generated:
                    raise ManifestError(f"comparison source missing and not a declared output: {check['source']}")
        for dependency in self.data.get("dependencies", []):
            if not inside(self.root, dependency).exists():
                raise ManifestError(f"dependency missing: {dependency}")
        for step in self.data.get("prepare", []):
            self.validate_variants(step)
            inside(self.setup, step.get("cwd", "."))
            for output in step["expected"]:
                inside(self.setup, output)
        for service, config in self.data["runtime"].get("services", {}).items():
            if config["role"] == "build-only":
                continue
            expected = "running" if config["role"] == "daemon" else "exited-0"
            if not any((c["type"] == "service-state" and c["service"] == service
                        or c["type"] == "service-group" and service in c["services"])
                       and c["expected"] == expected and c.get("required", True)
                       for c in self.checks("readiness")):
                raise ManifestError(f"{service} needs a required service-state readiness check for {expected}")
        for tool in self.data.get("tools", []):
            if not inside(self.root, tool["source"]).is_file():
                raise ManifestError(f"tool missing: {tool['source']}")
            if inside(self.setup, tool["destination"]).exists():
                raise ManifestError(f"tool would replace a supplied lab file: {tool['destination']}")
        if self.data["runtime"]["backend"] == "host":
            if set(self.data["runtime"]) != {"backend", "readiness"}:
                raise ManifestError("host runtime accepts only backend and readiness")
            if any(c["type"] not in ("host-exec", "elf") for stage in ("readiness", "check") for c in self.checks(stage)):
                raise ManifestError("host runtime supports host-exec and elf probes")
        privileged = any(step.get("privileged") for step in self.preparation()) or any(c.get("privileged") for c in self.checks("readiness") + self.checks("check"))
        if privileged and not self.data.get("host", {}).get("sudo"):
            raise ManifestError("privileged host commands require host.sudo")

    def validate_variants(self, item):
        unknown = set(item.get("variants", [])) - set(self.data["variants"])
        if unknown:
            raise ManifestError(f"unknown variant selectors: {sorted(unknown)}")

    def active(self, item):
        return self.variant in item.get("variants", [self.variant])

    def checks(self, stage):
        items = self.data["runtime"]["readiness"] if stage == "readiness" else self.data["checks"]
        return [item for item in items if self.active(item)]

    def preparation(self):
        return [item for item in self.data.get("prepare", []) if self.active(item)]

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
        bases = [self.setup] + [inside(self.root, p) for p in self.data.get("dependencies", [])]
        for base in bases:
            verify_tree(base)
        if self.data["runtime"]["backend"] == "host":
            return f"{self.data['id']} / {self.variant}: host manifest and source paths valid"
        compose = inside(self.setup, self.data["runtime"]["compose"])
        if not compose.is_file():
            # Generated Compose is allowed only with an explicit preparation pipeline.
            if not self.data.get("prepare"):
                raise ManifestError(f"Compose entry missing: {compose}")
        else:
            cfg = yaml.load(compose.read_text(), Loader=UniqueLoader)
            if not isinstance(cfg, dict) or not isinstance(cfg.get("services"), dict):
                raise ManifestError(f"invalid Compose structure: {compose}")
            if set(self.data["runtime"].get("services", {})) != set(cfg["services"]):
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
