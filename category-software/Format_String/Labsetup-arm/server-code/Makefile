FLAGS    = -z execstack -static
TARGET   = server format-64
 
L = 100

all: $(TARGET)

server: server.c
	gcc -static -o server server.c

format-64: format.c
	gcc -DBUF_SIZE=$(L) $(FLAGS) -o $@ format.c

clean:
	rm -f badfile $(TARGET)

install:
	cp server ../fmt-containers
	cp format-* ../fmt-containers

