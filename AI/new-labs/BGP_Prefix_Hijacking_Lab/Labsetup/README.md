# Labsetup Helper Snippets

This folder contains small BIRD configuration snippets used by the standalone
BGP Prefix Hijacking Lab.

These snippets are not complete BIRD configuration files. Students should paste
the relevant blocks into the existing `/etc/bird/bird.conf` file inside the
selected emulator router container, then run:

```bash
birdc configure
```

Files:

- `as161-hijack-10.154.0.0-24.conf`: equal-prefix hijack route
- `as161-hijack-10.154.0.0-25.conf`: more-specific hijack route
- `as3-filter-as154-prefix.conf`: provider-side filter example
