FLAGS    = -z execstack -fno-stack-protector -static
TARGET   = server stack-L3 stack-L4 stack-L1 stack-L2

L1 = 100
L2 = 80
L3 = 300
L4 = 20

 
all: $(TARGET)

server: server.c
	gcc -static -o server server.c

stack-L1: stack.c
	gcc -DBUF_SIZE=$(L1) -DSHOW_FP $(FLAGS) -o $@ stack.c

stack-L2: stack.c
	gcc -DBUF_SIZE=$(L2) $(FLAGS) -o $@ stack.c

stack-L3: stack.c
	gcc -DBUF_SIZE=$(L3) -DSHOW_FP -DSTRCPY $(FLAGS) -o $@ stack.c

stack-L4: stack.c
	gcc -DBUF_SIZE=$(L4) -DSHOW_FP -DSTRCPY $(FLAGS) -o $@ stack.c

clean:
	rm -f badfile $(TARGET)

install:
	cp server ../bof-containers
	cp stack-* ../bof-containers
