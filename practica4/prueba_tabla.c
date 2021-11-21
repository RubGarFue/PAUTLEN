#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BUFFER 512


int main(int argc, char *argv[]) {
    FILE * in;
    FILE *out;

    char buffer[MAX_BUFFER];
    char *identificador;
    char *entero;
    int entero_int;

    if(argc != 3) {
        fprintf(stdout, "Error en el numero de argumentos introducidos\n");
        return 1;
    }

    in = fopen(argv[1], "r");
    if(in == NULL) {
        fprintf(stderr, "Error al abrir el fichero de entrada\n");
        return 1;
    }

    out = fopen(argv[2], "w");
    if(out==NULL) {
        fprintf(stderr, "Error al abrir el archivo de salida\n");

    }


    while(fgets(buffer, MAX_BUFFER, in)) {
        identificador = strtok(NULL, " \n");

        entero = strtok(NULL, " \n");

        if(entero == NULL) {
            //busqueda
        } else {
            entero_int = atoi(entero);
            if(atoi(entero) < 0) {
                if(strcmp(identificador, "cierre") == 0 && entero_int == -999){
                    //cierre de ambito
                } else {
                    //ambito local
                }
            } else {
                //añadir elemento
            }
        }


        
    }

    fclose(in);
    fclose(out);
}