CC = gcc
CFLAGS = -Wall -std=c99

all: scanner

scanner: scanner.c
	$(CC) $(CFLAGS) -o scanner scanner.c

run: scanner
	./scanner

clean:
	rm -f scanner
