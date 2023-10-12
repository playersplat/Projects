CFLAGS = -Wall -Werror -Wextra -pedantic
CC = clang

all: httpserver

httpserver: httpserver.o
	$(CC) httpserver.o -o httpserver $(CFLAGS)

httpserver.o: httpserver.c
	$(CC) -c httpserver.c $(CFLAGS)

clean:
	rm *.o
	rm httpserver
