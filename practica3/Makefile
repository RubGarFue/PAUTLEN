####################################################
CC=gcc
CFLAGS= -g -Wall -I./src -I./ejs -I./include -I./obj
####################################################
.PHONY: clean

all:
	mkdir -p ./include
	mkdir -p ./obj
	@make pruebaSintactico

pruebaSintactico: y.tab.o lex.yy.o pruebaSintactico.o
	$(CC) -o pruebaSintactico ./obj/y.tab.o ./obj/lex.yy.o ./obj/pruebaSintactico.o

pruebaSintactico.o: ./src/pruebaSintactico.c
	$(CC) -c -o ./obj/pruebaSintactico.o ./src/pruebaSintactico.c

lex.yy.o: lex.yy.c
	$(CC) -c -o ./obj/y.tab.o ./src/y.tab.c

y.tab.o: y.tab.c
	$(CC) -c -o ./obj/y.tab.o ./src/y.tab.c

y.tab.c: ./alfa/alfa.y
	bison -dyv ./alfa/alfa.y
	mv y.tab.c ./src
	mv y.tab.h ./include

lex.yy.c: ./alfa/alfa.l  ./include/y.tab.h
	flex ./alfa/alfa.l
	mv lex.yy.c ./src

clean:
	@echo "Cleaning:"
	@rm -rf ./include
	@rm -rf ./obj
	@rm -rf ./src/y.tab.c
	@rm -rf ./src/lex.yy.c
	@rm -rf y.output
	@rm -rf pruebaSintactico
