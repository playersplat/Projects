CFLAGS = -Wall -Werror -Wextra -pedantic -pthread -g
CFLAGSS = -Wall -Werror -Wextra -pedantic
CC = clang

all: httpserver

httpserver: List.o httpserver.o 
	$(CC) $(CFLAGS) httpserver.o List.o -o httpserver 

httpserver.o: httpserver.c
	$(CC) $(CFLAGS) -c httpserver.c 

List.o: List.c
	$(CC) $(CFLAGSS) -c List.c 
clean:
	rm *.o
	rm httpserver
