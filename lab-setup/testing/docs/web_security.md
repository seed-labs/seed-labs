# Web lab environment acceptance

Use this reference to select tests and review their prerequisites and scope.
The linked YAML manifests define the exact checks, architecture variants, and
references to the lab manuals.

The framework checks environment conditions and ordinary functionality. It does
not generate attack payloads or complete student tasks. Settings that users
configure according to the manual, including `/etc/hosts`, ASLR, `/bin/sh`, and
browser policies, are neither changed nor required to have been completed by the
framework.

## Web_CSRF_Elgg

- Manifest: [web.csrf_elgg](../manifests/web/csrf_elgg.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check Elgg, MySQL, the attacker site, their addresses, seeded accounts, and an ordinary Alice login.
- Compare the database settings and CSRF customization files. Verify the attacker page and SameSite Lax/Strict example responses.
- Do not issue cross-site requests, add friends, edit profiles, or change the user's browser privacy settings.

## Web_Clickjacking_Cupcakes

- Manifest: [web.clickjacking_cupcakes](../manifests/web/clickjacking_cupcakes.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check the defender and attacker sites, correct virtual hosts, home pages, and local CSS.
- Check that initial responses have no X-Frame-Options or CSP headers. Verify that both mounted pages match the supplied files.
- Do not fill in students' iframes, overlay buttons, or perform clickjacking.

## Web_SQL_Injection

- Manifest: [web.sql_injection](../manifests/web/sql_injection.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check web/MySQL addresses, database initialization, and the six seeded user records.
- Verify the home page, CSS, application database connection, and an ordinary login using valid Alice credentials.
- Compare the supplied login program and defense exercise files. Do not send SQL injection or change salaries, passwords, or database records.

## Web_XSS_Elgg

- Manifest: [web.xss_elgg](../manifests/web/xss_elgg.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check Elgg/MySQL, seeded accounts, an ordinary Alice login, and database settings.
- Compare the supplied input/output customization files. Check the initial Apache/PHP policies on the CSP example sites and the associated resource sites.
- Do not inject scripts, edit profiles, or run self-propagating XSS.

## Prerequisites and running tests

Follow the [installation instructions](../README.md#installation) and activate your
Python environment. From the repository root, run one case with:

```sh
python lab-setup/testing/run.py all <manifest-path> --variant <variant>
```

Missing a required native architecture, TUN device, or host or lab-container kernel capability
blocks environment acceptance.
