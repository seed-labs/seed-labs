CXXFLAGS = -O2 -Wall -std=c++11
LIBS = -lcrypto

all: server

server: output_dir server.cpp known_iv 
	$(CXX) $(CXXFLAGS) $@.cpp -o ./build/$@ $(LIBS)

known_iv: output_dir known_iv.cpp
	$(CXX) $(CXXFLAGS) $@.cpp -o ./build/$@ $(LIBS)

output_dir:
	mkdir -p build

clean:
	-rm -rf build 
