####################################################
CC=gcc
CFLAGS= -g -I./src -I./include -I./obj
####################################################
.PHONY: clean

all:
	@mkdir -p ./obj
	@make pruebaMorfo

pruebaMorfo: pruebaMorfo.o lex.yy.o
	$(CC) -o pruebaMorfo ./obj/lex.yy.o ./obj/pruebaMorfo.o

pruebaMorfo.o: ./src/pruebaMorfo.c ./include/tokens.h
	$(CC) $(CFLAGS) -Wall -ansi -pedantic -c -o pruebaMorfo.o ./src/pruebaMorfo.c
	mv pruebaMorfo.o ./obj

lex.yy.o: ./include/tokens.h
	flex ./alfa/alfa.l
	$(CC) $(CFLAGS) -c -o lex.yy.o lex.yy.c
	mv lex.yy.c ./src
	mv lex.yy.o ./obj

clean:
	@echo "Cleaning:"
	@rm -rf ./obj
	@rm -rf ./src/lex.yy.c
	@rm -rf pruebaMorfo

