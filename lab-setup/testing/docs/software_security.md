# Software security lab environment acceptance

Use this reference to select tests and review their prerequisites and scope.
The linked YAML manifests define the exact checks, architecture variants, and
references to the lab manuals.

The framework checks environment conditions and ordinary functionality. It does
not generate attack payloads or complete student tasks. Settings that users
configure according to the manual, including `/etc/hosts`, ASLR, `/bin/sh`, and
browser policies, are neither changed nor required to have been completed by the
framework.

## Buffer_Overflow_Server

- Manifest: [software.buffer_overflow_server](../manifests/software/buffer_overflow_server.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Compile and install the server and L1-L4 programs using the supplied Makefile. Check the target architecture, required static linking, and executable stack.
- Verify the four service addresses, the actual server process privileges, and the identity of deployed binaries.
- Send two ordinary requests per level, each containing only three bytes including a NUL terminator. Check the received length and normal return in fresh logs without overflowing a buffer.

## Buffer_Overflow_Setuid

- Manifest: [software.buffer_overflow_setuid](../manifests/software/buffer_overflow_setuid.yaml); variants: `amd64`; environment: existing Linux host.

- Run the supplied Makefile in the existing Linux host to build all four levels, debug versions, and shellcode invocation harnesses.
- Check 32/64-bit ELF properties, executable stacks, disabled stack canaries, root ownership, mode 4755, and debug symbols.
- Use an independent program that only prints UIDs to verify that an ordinary user can execute a Set-UID program. Do not execute overflow payloads or sample shellcode.

## Environment_Variable_and_SetUID

- Manifest: [software.environment_variable_and_setuid](../manifests/software/environment_variable_and_setuid.yaml); variants: `amd64, arm64`; environment: existing Linux host.

- Compile the supplied myprintenv, myenv, catall, and cap_leak programs. Check native ELF properties and the dynamic loader.
- Check Bash environment-variable builtins, zsh, and the ordinary user identity.
- Verify basic Set-UID support with an independent UID probe. Do not complete the environment inheritance, PATH, or LD_PRELOAD tasks.

## Format_String

- Manifest: [software.format_string](../manifests/software/format_string.yaml); variants: `amd64, arm64`; environment: supplied Compose setup.

- Run the supplied make and make install commands on the host. Check the 32/64-bit combination on amd64 and the two 64-bit services on ARM64.
- Check ELF architecture, required static linking, executable stacks, the actual server process's root privileges, and deployed binary identity.
- Send two ordinary strings to each service on port 9090, using a unique marker, NUL terminator, and EOF. Check the received length, printed content, normal return, and unchanged target value in fresh logs.
- Do not send format specifiers, access additional memory, or trigger crashes.

## Race_Condition

- Manifest: [software.race_condition](../manifests/software/race_condition.yaml); variants: `amd64, arm64`; environment: existing Linux host.

- Compile the supplied vulp program. Check its architecture, root ownership, Set-UID permissions, and the sticky bit on /tmp.
- Verify the renameat2 library symbol and basic support for executing Set-UID programs as an ordinary user.
- Do not run race loops, change /etc/passwd, or modify the host's symlink and regular-file protection settings.

## Return_to_Libc

- Manifest: [software.return_to_libc](../manifests/software/return_to_libc.yaml); variants: `amd64`; environment: existing Linux host.

- Build the 32-bit retlib program using the supplied Makefile. Check ELF architecture, a non-executable stack, root ownership, and mode 4755.
- Verify that a 32-bit Set-UID probe executes and that tools such as gdb and zsh are available.
- Do not calculate libc addresses, construct return chains, or modify the host's /bin/sh or ASLR settings.

## Shellcode

- Manifest: [software.shellcode](../manifests/software/shellcode.yaml); variants: `amd64, arm64`; environment: existing Linux host.

- Assemble and link the three supplied examples using the Makefile for the selected architecture. Check ELF architecture and static linking.
- Execute only the harmless hello program, checking its output and the exit code defined by the supplied example. Check the writable and executable LOAD segment in the self-modifying example.
- Do not execute examples that launch a shell or generate attack payloads.

## Prerequisites and running tests

Follow the [installation instructions](../README.md#installation) and activate your
Python environment. From the repository root, run one case with:

```sh
python lab-setup/testing/run.py all <manifest-path> --variant <variant>
```

Missing a required native architecture, TUN device, or host or lab-container kernel capability
blocks environment acceptance.
