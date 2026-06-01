CC     = gcc
CFLAGS = -Wall -Wextra -O2

all: simulator/copyfail_sim

simulator/copyfail_sim: simulator/copyfail_sim.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f simulator/copyfail_sim simulator/*.o .sim_state.bin
