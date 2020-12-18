CXXFLAGS = -O2 -Wall -std=c++11
LIBS = -lcrypto

all: server

server: output_dir server.cpp known_iv padding_oracle
	$(CXX) $(CXXFLAGS) $@.cpp -o ./build/$@ $(LIBS)

known_iv: output_dir known_iv.cpp
	$(CXX) $(CXXFLAGS) $@.cpp -o ./build/$@ $(LIBS)

padding_oracle: output_dir padding_oracle.cpp secret_generator
	./secret_generator $(SECRET)
	$(CXX) $(CXXFLAGS) $@.cpp -o ./build/$@ $(LIBS)

secret_generator: secret_generator.cpp
	$(CXX) $(CXXFLAGS) $@.cpp -o $@ $(LIBS)

output_dir:
	mkdir build

clean:
	-rm -rf build secret_generator secret.hpp
