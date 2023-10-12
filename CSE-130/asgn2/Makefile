CFLAGS = -O3 -flto -Wall -Werror -Wextra -pedantic -pthread -g
CFLAGSS = -Wall -Werror -Wextra -pedantic
CC = clang

all: httpserver

httpserver: linkedq.o httpserver.o 
	$(CC) $(CFLAGS) httpserver.o linkedq.o -o httpserver 

httpserver.o: httpserver.c
	$(CC) $(CFLAGS) -c httpserver.c 

linkedq.o: linkedq.c
	$(CC) $(CFLAGSS) -c linkedq.c 
clean:
	rm *.o
	rm httpserver
