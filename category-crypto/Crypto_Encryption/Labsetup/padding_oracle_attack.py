#!/usr/bin/python3
import socket
from binascii import hexlify, unhexlify

class PaddingOracle:

    def __init__(self, host, port) -> None:
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.connect((host, port))

        ciphertext = self.s.recv(4096).decode().strip()
        self.ctext = unhexlify(ciphertext)

    def decrypt(self, ctext: bytes) -> None:
        self._send(hexlify(ctext))
        return self._recv()

    def _recv(self):
        resp = self.s.recv(4096).decode().strip()
        return resp 

    def _send(self, hexstr: bytes):
        self.s.send(hexstr + b'\n')

    def __del__(self):
        self.s.close()


if __name__ == "__main__":
    oracle = PaddingOracle('10.9.0.80', 5000)

    # This ciphertext is returned from the oracle
    ctext = oracle.ctext

    ######## Write your code below ########

    # This is a sample for a vaild ciphertext
    print(oracle.decrypt(ctext))

    # This is a sample for a invaild ciphertext
    myctext = bytearray(ctext)
    myctext[-1] = 255-myctext[-1]
    print(oracle.decrypt(myctext))
