FLAGS    = -z execstack -fno-stack-protector -static
TARGET   = server stack
 
L1 = 100

all: $(TARGET)

server: server.c
	gcc -static -o server server.c

stack: stack.c
	gcc -DBUF_SIZE=$(L1) -DSHOW_FP $(FLAGS) -o $@ stack.c

clean:
	rm -f badfile $(TARGET)

install:
	cp server ../morris-worm-base
	cp stack  ../morris-worm-base

