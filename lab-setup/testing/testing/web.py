"""Normal authenticated web flows; no injection or cross-site requests."""
from html.parser import HTMLParser
from http.client import HTTPConnection
from http.cookiejar import CookieJar
import json
from urllib.parse import urlsplit, urlencode, urljoin
from urllib.request import build_opener, ProxyHandler, HTTPHandler, HTTPCookieProcessor, HTTPRedirectHandler, Request

from .errors import CheckFailure


class LoginFields(HTMLParser):
    def __init__(self):
        super().__init__()
        self.values = {}

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        if tag == "input" and attributes.get("name") in ("__elgg_token", "__elgg_ts"):
            self.values[attributes["name"]] = attributes.get("value", "")


def login_probe(runner, check):
    url = urlsplit(check["url"])
    if url.scheme != "http" or not url.hostname or url.username or url.password:
        raise CheckFailure("login URL must use plain HTTP without URL credentials")

    class MappedHTTP(HTTPHandler):
        def http_open(self, request):
            destination = urlsplit(request.full_url)
            if (destination.scheme, destination.hostname, destination.port or 80) != (url.scheme, url.hostname, url.port or 80):
                raise CheckFailure("login attempted to leave the declared lab origin")
            return self.do_open(lambda host, **kw: HTTPConnection(check["connect_address"], url.port or 80, **kw), request)

    class SameOriginRedirect(HTTPRedirectHandler):
        def redirect_request(self, request, fp, code, message, headers, newurl):
            dest = urlsplit(newurl)
            if (dest.scheme, dest.hostname, dest.port or 80) != (url.scheme, url.hostname, url.port or 80):
                raise CheckFailure("login redirect leaves the declared lab origin")
            return super().redirect_request(request, fp, code, message, headers, newurl)

    opener = build_opener(ProxyHandler({}), MappedHTTP(), SameOriginRedirect(), HTTPCookieProcessor(CookieJar()))
    timeout = check.get("timeout", 15)
    with opener.open(check["url"], timeout=timeout) as response:
        page = response.read(1024 * 1024).decode("utf-8", errors="replace")
    fields = LoginFields()
    fields.feed(page)
    payload = {**fields.values, "username": check["username"], "password": check["password"]}
    action = urljoin(check["url"], check.get("login_path", "/action/login"))
    request = Request(action, data=urlencode(payload).encode(), headers={"Content-Type": "application/x-www-form-urlencoded"})
    with opener.open(request, timeout=timeout) as response:
        body = response.read(1024 * 1024).decode("utf-8", errors="replace")
        evidence = {"url": response.url, "http_status": response.status, "user": check["username"],
                    "csrf_fields_present": sorted(fields.values), "expected_authenticated_marker": check["body_contains"],
                    "authenticated_marker_present": check["body_contains"] in body}
    path = runner.run_dir / f"login-{check['id']}.json"
    path.write_text(json.dumps(evidence, indent=2) + "\n")
    if evidence["http_status"] != 200 or not evidence["authenticated_marker_present"]:
        raise CheckFailure(f"normal login did not reach an authenticated page; see {path.name}")
    return {"user": check["username"], "http_status": evidence["http_status"], "evidence": path.name}
