# Software Security

## Summary of Changes for Ubuntu 20.04

Detailed changes are described in the README file for each lab.
Here we only summarize how much change is made. 
The Status column states whether the revision is finished or not.
The meaning of the Changes column can be found from 
[this file](../common-files/category_of_revision.md).

| Lab Name | Changes | Status | Container |  Notes |
| ---      | ---     | ---    |  ---      |  ---   |
| Buffer Overflow (32-bit) | Major | Done |     | [README](Buffer_Overflow/README.md)
| Buffer Overflow (64-bit) | New   | Done |     | [README](Buffer_Overflow_x64/README.md) 
| Return-to-Libc           | Minor | Done |     | [README](Return_to_Libc/README.md)
| Format String (32-bit)   | Minor | Done |     | [README](Format_String/README.md) 
| Format String (64-bit)   | New   | Done | Yes | [README](Format_String_x64/README.md)
| Shellcode                | Major | Done |     | [README](Shellcode/README.md)
| Set-UID              | Editorial | Done |     | [README](Environment_Variable_and_SetUID/README.md)
| Race Condition           | Minor | Done |     | [README](Race_Condition/README.md) |
| Shellshock               | Minor | Done | Yes | [README](Shellshock/README.md)
| Dirty COW                | None  | Done |     | Still using Ubuntu 12.04

