# Instructor Manual: Copy Fail Attack Lab

This manual is for instructors only. It provides one complete path through the
lab, including the values needed for the simulator attack and the main points
students should explain in their reports.

## Lab Goal

Students should understand the core idea behind Copy Fail / CVE-2026-31431:
kernel code must not use a destination buffer after a failed or partial copy
from user-controlled memory. If stale data in a kernel-managed buffer is later
used to update page-cache-like state, an attacker may influence data that should
be protected by file permissions.

The lab intentionally uses a user-space simulator. It is not a real Linux
kernel exploit and should not be presented as one.

## Setup

Go to the lab setup folder:

```bash
cd AI/new-labs/Copy_Fail_Attack/Labsetup
make
```

If the build succeeds, the binary should be:

```bash
simulator/copyfail_sim
```

Reset the simulator state before each run:

```bash
./simulator/copyfail_sim --reset
```

Show the simulated protected file in the page cache:

```bash
./simulator/copyfail_sim --show-cache
```

Expected content:

```text
root:enabled:0
daemon:enabled:1
student:disabled:1001
guest:disabled:1002
```

The account `student` should initially fail the login check:

```bash
./simulator/copyfail_sim --check-login student
```

Expected result:

```text
[-] Login check rejected user 'student'.
```

## Task 1 Answer: Copy Operations

Normal copy:

```bash
./simulator/copyfail_sim --mode normal --input hello
```

Expected observation:

- The reusable kernel buffer initially contains dots.
- After the copy, the beginning of the buffer contains `hello`.
- The simulator reports `not_copied=0`.

Forced failed copy:

```bash
./simulator/copyfail_sim --mode fail --input hello --fail-after 2
```

Expected observation:

- Only the first two bytes, `he`, are copied.
- The rest of the buffer remains from the previous state.
- The simulator reports a nonzero `not_copied` value.

Main explanation:

The destination buffer after a failed copy is not automatically trustworthy. It
may contain a mixture of new bytes and stale bytes. Kernel code must check the
copy result before using the buffer.

## Task 2 Answer: Vulnerable Logic

Run:

```bash
./simulator/copyfail_sim --reset
./simulator/copyfail_sim --mode normal --input AAAAAAAA
./simulator/copyfail_sim --mode fail --input BBBBBBBB --fail-after 3
```

Expected observation:

- After the first command, the buffer starts with `AAAAAAAA`.
- After the second command, the buffer starts with `BBBAAAAA`.

Main explanation:

The failed copy writes only three new bytes. The remaining bytes are stale data
from the previous operation. The vulnerable pattern logs the error but still
uses the buffer, which lets old attacker-controlled bytes influence a later
operation.

## Task 3 Answer: Simulated Page-Cache Corruption

The simulated protected file is:

```text
root:enabled:0
daemon:enabled:1
student:disabled:1001
guest:disabled:1002
```

The target is the word `disabled` in the `student` line.

Byte offset calculation:

- `root:enabled:0\n` is 15 bytes.
- `daemon:enabled:1\n` is 17 bytes.
- The `student` line begins at offset 32.
- `student:` is 8 bytes.
- Therefore, `disabled` begins at offset `40`.

Use the following values in `simulator/exploit_skeleton.py`:

```python
TARGET_OFFSET = 40
PRIME_BYTES = "enabled:"
FAIL_AFTER = 0
```

Why `enabled:` instead of `enabled`:

- The original field `disabled` is 8 bytes.
- Replacing it with only `enabled` would leave one stale byte and produce
  `enabledd`.
- Replacing 8 bytes with `enabled:` produces `student:enabled::1001`.
- The simulator's login check looks for the prefix `student:enabled:`, so this
  is accepted.

Run:

```bash
cd simulator
python3 exploit_skeleton.py
```

Expected final cache:

```text
root:enabled:0
daemon:enabled:1
student:enabled::1001
guest:disabled:1002
```

Expected login result:

```text
[+] Login check accepted user 'student'.
```

Main explanation:

The attacker did not write the protected file through normal file permissions.
Instead, the vulnerable service reused stale data from a kernel-buffer-like
object and copied it into simulated page-cache state. A privileged decision was
then made using the corrupted cached data.

## Task 4 Answer: Comparison

Expected high-level comparison:

| Vulnerability | Object affected | Normal file write? | Core lesson |
| --- | --- | --- | --- |
| Copy Fail | Kernel-managed state / page cache via failed copy handling | No | Failed or partial user copies must not be trusted |
| Dirty COW | Private copy-on-write mapping race | No | Races can violate assumptions about read-only mappings |
| Dirty Pipe | Page cache through pipe buffer flag misuse | No | Internal kernel buffer metadata can undermine file permissions |

Students do not need exploit-level details. They should explain that all three
attacks bypass ordinary write permission checks by corrupting or racing internal
kernel state.

## Task 5 Answer: Countermeasures

Defense 1: reject partial copies.

Expected result:

- This should stop the simulated attack.
- If `not_copied != 0`, the service should return an error before any cache
  update.

Defense 2: zero the destination buffer before copying.

Expected result:

- This removes stale attacker-controlled bytes.
- It reduces the risk, but by itself it is not the best policy because later
  code may still use partially valid input after a failed copy.

Defense 3: use an exact valid length.

Expected result:

- This prevents later code from processing bytes that were not actually copied.
- It should be combined with rejecting partial copies for security-sensitive
  operations.

Best answer:

The strongest fix is to reject failed or partial copies before using the buffer.
Zeroing reusable buffers is useful defense-in-depth, but it should not replace
strict error handling.

## Task 6 Answer: Kernel Hardening Discussion

Good student answers should include:

- A failed user-memory copy is security relevant because the kernel cannot
  assume the destination buffer contains the requested user input.
- Reusable buffers are dangerous when stale data can survive across operations.
- Regression tests should include successful copies, partial copies, zero-byte
  failures, boundary lengths, and attempts to reuse buffers after failure.
- Least privilege and timely patching matter because kernel bugs often turn
  small logic mistakes into privilege-escalation paths.
- Unused kernel attack surfaces should be disabled or restricted when possible.

## Grading Suggestions

Suggested grading breakdown:

- Task 1 and Task 2 observations: 20%
- Successful simulator attack in Task 3: 25%
- Correct explanation of page-cache-style corruption: 20%
- Comparison with Dirty COW and Dirty Pipe: 15%
- Countermeasure implementation and evaluation: 15%
- Report clarity, screenshots, and code explanations: 5%

Common mistakes:

- Treating the simulator as a real CVE exploit.
- Saying file permissions are "bypassed" without explaining the page-cache-like
  state.
- Using `enabled` instead of `enabled:` and failing to notice the leftover byte.
- Focusing only on clearing buffers while ignoring the need to reject failed
  copies.

## Instructor Customization

To vary the lab, instructors can edit `Labsetup/files/passwd.template`.

Examples:

- Change the target account from `student` to another name.
- Add padding lines before the target account to change the offset.
- Change `disabled` to another fixed-width status word.
- Require students to calculate the offset using a short Python script.

After changing the template, recompute the target offset and update this manual
or keep the offset as an exercise for instructors.
