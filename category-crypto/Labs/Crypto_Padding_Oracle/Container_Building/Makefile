CXXFLAGS = -O2 -Wall -std=c++11
LIBS = -lcrypto

all: server

SECRET = "This is different from the one in the oracle"

server: server.cpp padding_oracle_L1 padding_oracle_L2
	$(CXX) $(CXXFLAGS) $@.cpp -o $@ $(LIBS)

padding_oracle_L1: padding_oracle_L1.cpp
	$(CXX) $(CXXFLAGS) $@.cpp -o $@ $(LIBS)

padding_oracle_L2: padding_oracle_L2.cpp secret_generator
	./secret_generator $(SECRET)
	$(CXX) $(CXXFLAGS) $@.cpp -o $@ $(LIBS)

secret_generator: secret_generator.cpp
	$(CXX) $(CXXFLAGS) $@.cpp -o $@ $(LIBS)

output_dir:
	mkdir -p build

clean:
	-rm -rf build secret_generator secret.hpp server padding_oracle_L1 padding_oracle_L2
