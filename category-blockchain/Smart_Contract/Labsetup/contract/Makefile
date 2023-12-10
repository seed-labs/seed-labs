
all: EtherFaucet Caller Hello

EtherFaucet: 
	solc --overwrite --abi --bin -o . EtherFaucet.sol

Caller:
	solc --overwrite --abi --bin -o . Caller.sol

Hello:
	solc --overwrite --abi --bin -o . Hello.sol

clean:
	rm -f *.abi *.bin
