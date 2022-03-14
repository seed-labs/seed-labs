FLAGS    = -z execstack 
FLAGS_32 = -static -m32
TARGET   = server format-32 format-64
 
L = 100

all: $(TARGET)

server: server.c
	gcc -o server server.c

format-32: format.c
	gcc -DBUF_SIZE=$(L) $(FLAGS) $(FLAGS_32) -o $@ format.c

format-64: format.c
	gcc -DBUF_SIZE=$(L) $(FLAGS) -o $@ format.c

clean:
	rm -f badfile $(TARGET)

install:
	mv server ../fmt-containers
	mv format-* ../fmt-containers

