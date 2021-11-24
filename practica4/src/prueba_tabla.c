/**
 * @file prueba_tabla.c
 * @author Miguel Escribano Ortega, Rubén García de la Fuente
 * @brief Programa principal para probar la tabla de símbolos
 * @version 0.1
 * @date 2021-11-24
 * 
 * @copyright Copyright (c) 2021
 * 
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabla_simbolos.h"

#define MAX_BUFFER 512


int main(int argc, char *argv[]) {
    FILE *in;
    FILE *out;

    char buffer[MAX_BUFFER];
    char *identificador;
    char *entero_str;
    int entero;
    TablaSimbolos *tabla = NULL;

    if (argc != 3) {
        fprintf(stdout, "Error en el numero de argumentos introducidos\n");
        return 1;
    }

    in = fopen(argv[1], "r");
    if (in == NULL) {
        fprintf(stderr, "Error al abrir el fichero de entrada\n");
        return 1;
    }

    out = fopen(argv[2], "w");
    if (out==NULL) {
        fprintf(stderr, "Error al abrir el archivo de salida\n");

    }

    tabla = crear_tabla();

    if (tabla == NULL) {
        return -1;
    }

    while(fgets(buffer, MAX_BUFFER, in)) {
        identificador = strtok(buffer, " ");

        entero_str = strtok(NULL, "\n");

        if (entero_str == NULL) {
            identificador[strcspn(identificador, "\n")] = '\0';

            entero = busqueda_elemento(tabla, identificador);
            fprintf(out, "%s %d\n", identificador, entero);
        }

        else {
            entero = atoi(entero_str);

            if (entero < 0) {
                
                if (strcmp(identificador, "cierre") == 0 && entero == -999){
                    if(cierre_ambito(tabla) == 0) {
                        fprintf(out, "cierre\n"); //Que se imprime en caso de error?
                    }
                    
                }

                else {
                    if(apertura_ambito(tabla, identificador, entero) == 0) {
                        fprintf(out, "%s\n", identificador);
                    }
                }
            }

            else {
                if (insercion_elemento(tabla, identificador, entero) == -1) {
                    fprintf(out, "-1 %s\n", identificador);
                }

                else {
                    fprintf(out, "%s\n", identificador);
                }
            }
        }
    }

    fclose(in);
    fclose(out);

    return 0;
}