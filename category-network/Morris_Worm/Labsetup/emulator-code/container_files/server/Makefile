FLAGS    = -z execstack -fno-stack-protector
FLAGS_32 = -static -m32
TARGET   = server stack
 
L1 = 100

all: $(TARGET)

server: server.c
	gcc -o server server.c

stack: stack.c
	gcc -DBUF_SIZE=$(L1) -DSHOW_FP $(FLAGS) $(FLAGS_32) -o $@ stack.c

clean:
	rm -f badfile $(TARGET)

install:
	cp server ../morris-worm-base
	cp stack  ../morris-worm-base

