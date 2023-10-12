CFLAGS = -Wall -Werror -Wextra -pedantic
CC = clang

all: split

split: split.o
	$(CC) split.o -o split $(CFLAGS)

split.o: split.c
	$(CC) -c split.c $(CFLAGS)

clean:
	rm *.o
	rm split
