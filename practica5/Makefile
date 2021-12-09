####################################################
CC=gcc
CFLAGS= -g -Wall -I./src -I./ejs -I./include -I./obj
####################################################
.PHONY: clean

all:
	mkdir -p ./obj
	@make prueba_tabla

prueba_tabla: prueba_tabla.o tabla_simbolos.o
	$(CC) -o prueba_tabla ./obj/prueba_tabla.o ./obj/tabla_simbolos.o

prueba_tabla.o: ./src/prueba_tabla.c ./include/tabla_simbolos.h
	$(CC) $(CFLAGS) -c ./src/prueba_tabla.c
	mv prueba_tabla.o ./obj

tabla_simbolos.o: ./src/tabla_simbolos.c ./include/tabla_simbolos.h
	$(CC) $(CFLAGS) -c ./src/tabla_simbolos.c
	mv tabla_simbolos.o ./obj

clean:
	@echo "Cleaning:"
	@rm -rf ./obj
	@rm -rf prueba_tabla
