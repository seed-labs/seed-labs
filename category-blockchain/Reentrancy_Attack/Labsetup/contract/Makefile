
SOLC = solc-0.6.8

all: ReentrancyAttacker.bin  ReentrancyVictim.bin

ReentrancyAttacker.bin: ReentrancyAttacker.sol 
	$(SOLC) --overwrite --abi --bin -o . ReentrancyAttacker.sol

ReentrancyVictim.bin: ReentrancyVictim.sol
	$(SOLC) --overwrite --abi --bin -o . ReentrancyVictim.sol

clean:
	rm *.bin *.abi

