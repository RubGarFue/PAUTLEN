####################################################
CC=gcc
CFLAGS= -g -Wall -I./src -I./ejs -I./include -I./obj
####################################################
.PHONY: clean

all:
	mkdir -p ./obj_ejs
	@make ej1
	@make ej2
	@make ej3
	@make ej4
	@make ej5
	@make ej6
	@make ej7

ej1: ej1.o generacion.o
	$(CC) -o ej1 ej1.o ./obj/generacion.o
	mv ej1.o ./obj_ejs

ej2: ej2.o generacion.o
	$(CC) -o ej2 ej2.o ./obj/generacion.o
	mv ej2.o ./obj_ejs

ej3: ej3.o generacion.o
	$(CC) -o ej3 ej3.o ./obj/generacion.o
	mv ej3.o ./obj_ejs

ej4: ej4.o generacion.o
	$(CC) -o ej4 ej4.o ./obj/generacion.o
	mv ej4.o ./obj_ejs

ej5: ej5.o generacion.o
	$(CC) -o ej5 ej5.o ./obj/generacion.o
	mv ej5.o ./obj_ejs

ej6: ej6.o generacion.o
	$(CC) -o ej6 ej6.o ./obj/generacion.o
	mv ej6.o ./obj_ejs

ej7: ej7.o generacion.o
	$(CC) -o ej7 ej7.o ./obj/generacion.o
	mv *¡ej7.o ./obj_ejs

ej1.o: ./ejs/ej1.c ./include/generacion.h
	$(CC) $(CFLAGS) -c ./ejs/ej1.c

ej2.o: ./ejs/ej2.c ./include/generacion.h
	$(CC) $(CFLAGS) -c ./ejs/ej2.c

ej3.o: ./ejs/ej3.c ./include/generacion.h
	$(CC) $(CFLAGS) -c ./ejs/ej3.c

ej4.o: ./ejs/ej4.c ./include/generacion.h
	$(CC) $(CFLAGS) -c ./ejs/ej4.c

ej5.o: ./ejs/ej5.c ./include/generacion.h
	$(CC) $(CFLAGS) -c ./ejs/ej5.c

ej6.o: ./ejs/ej6.c ./include/generacion.h
	$(CC) $(CFLAGS) -c ./ejs/ej6.c

ej7.o: ./ejs/ej7.c ./include/generacion.h
	$(CC) $(CFLAGS) -c ./ejs/ej7.c

generacion.o: ./src/generacion.c ./include/generacion.h
	$(CC) $(CFLAGS) -c ./src/generacion.c
	mv generacion.o ./obj

clean:
	@echo "Cleaning:"
	@rm -rf ./obj/generacion.o
	@rm -rf ./obj_ejs
	@rm -rf ej1
	@rm -rf ej2
	@rm -rf ej3
	@rm -rf ej4
	@rm -rf ej5
	@rm -rf ej6
	@rm -rf ej7
