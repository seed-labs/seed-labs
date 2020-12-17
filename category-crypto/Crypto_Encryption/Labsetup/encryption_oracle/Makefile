CXXFLAGS = -O2 -Wall -std=c++11
LIBS = -lcrypto

all: server

server: server.cpp known_iv padding_oracle
	$(CXX) $(CXXFLAGS) $@.cpp -o $@ $(LIBS)

known_iv: known_iv.cpp
	$(CXX) $(CXXFLAGS) $@.cpp -o $@ $(LIBS)

padding_oracle: padding_oracle.cpp
	$(CXX) $(CXXFLAGS) $@.cpp -o $@ $(LIBS)

clean:
	-rm -f server known_iv padding_oracle
