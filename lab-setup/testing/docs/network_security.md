# Network lab environment acceptance

Use this reference to select tests and review their prerequisites and scope.
The linked YAML manifests define the exact checks, architecture variants, and
references to the lab manuals.

The framework checks environment conditions and ordinary functionality. It does
not generate attack payloads or complete student tasks. Settings that users
configure according to the manual, including `/etc/hosts`, ASLR, `/bin/sh`, and
browser policies, are neither changed nor required to have been completed by the
framework.

## ARP_Attack

- Manifest: [network.arp_attack](../manifests/network/arp_attack.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check the three node addresses, Telnet services on A/B, and ordinary communication from A to B.
- Use Scapy on M to capture ordinary ICMP traffic triggered by the probe itself, verifying packet capture support.
- Do not forge ARP packets, change neighbor caches, or perform MITM attacks.

## BGP_Basic

- Manifest: [network.bgp_basic_as](../manifests/network/bgp_basic_as.yaml); variants: `amd64`; environment: supplied Compose setup.
- Manifest: [network.bgp_basic_peering](../manifests/network/bgp_basic_peering.yaml); variants: `amd64`; environment: supplied Compose setup.
- Manifest: [network.bgp_basic_transit](../manifests/network/bgp_basic_transit.yaml); variants: `amd64`; environment: supplied Compose setup.

- Test the separate AS, Peering, and Transit scenarios. Build images in the order required by their local base-image dependencies.
- Check all supplied nodes, addresses, BIRD configuration and control interfaces, gateways within each AS, and web services.
- Check establishment of the supplied BGP sessions only in Transit. Do not require neighbors, routing policies, or complete interdomain routing that students have yet to configure.

## BGP_Exploration_Attack

- Manifest: [network.bgp_exploration_attack](../manifests/network/bgp_exploration_attack.yaml); variants: `amd64, arm64`; environment: full container topology generated with a pinned Emulator SDK.

- Run the supplied generator with the pinned Emulator SDK. Verify the complete node inventory and actual Linux interface addresses, including anycast addresses.
- Check all generated nodes, supplied BIRD/web services, ordinary cross-AS web access, and the Internet Map page.
- Do not perform prefix hijacking or modify policies that students are expected to explore.

## DNSSEC

- Manifest: [network.dnssec](../manifests/network/dnssec.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check the initial DNS nodes, zone configuration syntax, named services, and supplied authoritative A record.
- Check the keygen/signzone tools and the initial setting with validation disabled.
- Do not generate students' keys, signatures, DS records, or trust chains. Do not require an already completed DNSSEC deployment.

## DNS_Infrastructure

- Manifest: [network.dns_infrastructure](../manifests/network/dns_infrastructure.yaml); variants: `amd64, arm64`; environment: full container topology generated with a pinned Emulator SDK.

- Check both spare nameserver nodes as part of the generated topology.
- Generate the base and DNS components, then merge them into the full environment. Check every node and its actual interface addresses.
- Check the initial BIRD, web, and DNS services, direct SOA queries for existing authoritative zones, and the map service.
- Preserve zones, delegations, and AS155 resolver settings that students must complete. Do not require the complete recursive resolution chain to be configured in advance.

## DNS_Local

- Manifest: [network.dns_local](../manifests/network/dns_local.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check addresses and routes for the user, resolver, attacker nameserver, and router.
- Check BIND configuration, the initial DNSSEC setting, the query source port, and controlled attacker32.com queries within the lab environment.
- Check host networking, forwarding, and the tc tool. Do not inject forged replies, poison caches, or depend on current public DNS answers.

## DNS_Rebinding

- Manifest: [network.dns_rebinding](../manifests/network/dns_rebinding.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check both subnets, DNS nodes, the IoT and attacker Flask services, and the initial rule blocking forwarding to the IoT network.
- Verify temperature queries, ordinary pages and fixed-response endpoints, and the initial address served by the attacker's authoritative domain.
- Do not rebind DNS to the IoT address, bypass the same-origin policy, or change the IoT temperature or password.

## DNS_Remote

- Manifest: [network.dns_remote](../manifests/network/dns_remote.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check resolver, user, and attacker nameserver addresses, BIND services, and host networking mode.
- Verify the initial DNSSEC and source-port settings, controlled forwarding, and authoritative queries.
- Do not run random-domain races, forge DNS packets, or poison caches.

## Firewall_Evasion

- Manifest: [network.firewall_evasion](../manifests/network/firewall_evasion.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check both subnets, routing nodes, endpoint SSH/Telnet services, and support for temporary TUN interfaces.
- Verify the supplied SSH allow rule, TCP drop rule, ordinary SSH banner, and blocked Telnet connections across the subnets.
- Confirm that the target port is available locally before checking that the remote connection times out. Do not implement the bypass tunnel.

## ICMP_Redirect

- Manifest: [network.icmp_redirect](../manifests/network/icmp_redirect.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check the supplied nodes, both subnets, initial routes, and ordinary ICMP communication across the subnets.
- Read the victim's accept_redirects setting and the routers' initial forwarding/send_redirects settings.
- Target the legacy Docker environment that supports the supplied interface-specific sysctl entries. Preserve the original Compose settings without applying compatibility changes for newer Docker engines.
- Do not forge ICMP Redirect messages or change the victim's route cache.

## Mitnick_Attack

- Manifest: [network.mitnick_attack](../manifests/network/mitnick_attack.yaml); variants: `amd64`; environment: supplied Compose setup.
- Manifest: [network.mitnick_attack_arm64](../manifests/network/mitnick_attack_arm64.yaml); variants: `arm64`; environment: supplied Compose setup.

- Check attacker host networking, target/trusted-host addresses, ordinary communication, and packet capture support.
- Check the supplied seed account, rsh client/server programs, and listening port 514.
- Use a separate manifest for ARM because its service names differ from amd64. Do not forge TCP connections, install a remote backdoor, or modify trust files.

## Morris_Worm

- Manifest: [network.morris_worm_mini](../manifests/network/morris_worm_mini.yaml); variants: `amd64, arm64`; environment: full container topology generated with a pinned Emulator SDK.
- Manifest: [network.morris_worm_nano](../manifests/network/morris_worm_nano.yaml); variants: `amd64, arm64`; environment: full container topology generated with a pinned Emulator SDK.

- Run the supplied nano and full mini generators separately. The fixed expectations cover all 15 target hosts in nano and all 240 target hosts in mini, preserving the complete topology.
- Check every node, interface addresses, supplied routing services, ordinary cross-AS communication for each target AS, the map, and the target ELF architecture/static linking/executable stack.
- Send each target two ordinary three-byte requests. Check fresh server logs for the received length and normal return. Do not run worm.py, copy or propagate programs, or create reverse shells.

## Sniffing_Spoofing

- Manifest: [network.sniffing_spoofing](../manifests/network/sniffing_spoofing.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check node addresses, attacker host networking, and ordinary host communication.
- Capture ordinary ICMP traffic triggered by the probe using the actual routed interface. Build and run a harmless libpcap linking probe on the host.
- Do not require development headers in an attacker image that supplies runtime tools only. Do not forge packets or implement students' sniffing programs.

## TCP_Attacks

- Manifest: [network.tcp_attacks](../manifests/network/tcp_attacks.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Check node addresses, host networking, Telnet services, and ordinary connectivity.
- Read the victim's initially disabled SYN cookies setting and verify Scapy capture of ordinary ICMP traffic.
- Do not perform SYN flooding, RST injection, session hijacking, or reverse-shell attacks.

## VPN

- Manifest: [network.vpn](../manifests/network/vpn.yaml); variants: `amd64, arm64`; environment: existing Linux host.

- This comprehensive lab has no fixed Labsetup. Check the prerequisites for the environment that the manual expects students to build.
- Compile and run an independent OpenSSL TLS context program. Check ordinary-user and root administration capabilities and OpenSSL tools.
- Use host sudo to create and close a nonpersistent TUN interface. Do not supply or execute a student VPN or configure tunnels, certificate authentication, or routes in advance.

## VPN_Tunnel

- Manifest: [network.vpn_tunnel](../manifests/network/vpn_tunnel.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.
- Manifest: [network.vpn_tunnel_site_to_site](../manifests/network/vpn_tunnel_site_to_site.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Test the supplied single-client and two-private-network topologies separately. Check addresses, communication within each private LAN, default routes, and required forwarding settings.
- Verify that the client and server can create and immediately close temporary TUN interfaces.
- Do not implement the tunnel in advance or treat a lack of connectivity between private networks before tunnel setup as an environment defect.

## Prerequisites and running tests

Follow the [installation instructions](../README.md#installation) and activate your
Python environment. From the repository root, run one case with:

```sh
python lab-setup/testing/run.py all <manifest-path> --variant <variant>
```

For Emulator cases, install the additional dependencies and configure the SDK
checkout as described in [Emulator-based labs](../README.md#emulator-based-labs).

Missing a required native architecture, TUN device, or host or lab-container kernel capability
blocks environment acceptance.
