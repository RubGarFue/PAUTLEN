####################################################
CC=gcc
CFLAGS= -g -I./src -I./include -I./obj
####################################################
.PHONY: clean

all:
	mkdir -p ./include
	mkdir -p ./obj
	@make alfa

alfa: y.tab.o lex.yy.o tabla_simbolos.o
	$(CC) $(CFLAGS) ./src/alfa.c ./obj/y.tab.o ./obj/lex.yy.o ./obj/tabla_simbolos.o ./src/generacion.c -o alfa

tabla_simbolos.o: ./src/tabla_simbolos.c ./include/tabla_simbolos.h
	$(CC) $(CFLAGS) -c ./src/tabla_simbolos.c
	mv tabla_simbolos.o ./obj

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c -o ./obj/lex.yy.o ./src/lex.yy.c

y.tab.o: y.tab.c
	$(CC) $(CFLAGS) -c -o ./obj/y.tab.o ./src/y.tab.c

y.tab.c: ./syntax/alfa.y
	bison -dyv ./syntax/alfa.y
	mv y.tab.c ./src
	mv y.tab.h ./include

lex.yy.c: ./syntax/alfa.l ./include/y.tab.h ./include/alfa.h ./include/generacion.h ./include/tabla_simbolos.h
	flex ./syntax/alfa.l
	mv lex.yy.c ./src

clean:
	@echo "Cleaning:"
	@rm -rf ./obj/lex.yy.o
	@rm -rf ./obj/y.tab.o
	@rm -rf ./obj/tabla_simbolos.o
	@rm -rf ./include/y.tab.h
	@rm -rf ./src/y.tab.c
	@rm -rf ./src/lex.yy.c
	@rm -rf y.output
	@rm -rf alfa