#!/bin/env python3

import socks

s = socks.socksocket()

# Set the proxy
s.set_proxy(socks.SOCKS5, "<proxy's IP>", 9000) 

# Connect to final destination via the proxy
s.connect(("<server's IP or hostname>", 80))

hostname = "www.example.com"
request = b"GET / HTTP/1.0\r\nHost: " + hostname.encode('utf-8') + b"\r\n\r\n"
s.sendall(request)

# Get the response
response = s.recv(2048)
while response:
  print(response.split(b"\r\n"))
  response = s.recv(2048)
