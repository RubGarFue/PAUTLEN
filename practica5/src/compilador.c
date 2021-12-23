/**
 * @file compilador.c
 * @author Miguel Escribano Ortega, Rubén García de la Fuente
 * @brief Programa principal para compilar un fichero escrito en lenguaje alfa
 * @version 0.1
 * @date 2021-11-24
 * 
 * @copyright Copyright (c) 2021
 * 
 */
#include <stdio.h>
#include "alfa.h"
#include "generacion.h"
#include "tabla_simbolos.h"

extern FILE *yyin;
extern FILE *yyout;
extern int yyparse();

int main(int argc, char **argv) {

    if (argc != 3) {
        printf("Debe haber tres argumentos de entrada");
        return -1;
    }

    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2], "w");

    if (yyin == NULL) {
        printf("Error al abrir el fichero de entrada");
        return -1;
    }

    if (yyout == NULL) {
        printf("Error al abrir el fichero de salida");
        return -1;
    }

    yyparse();
    fclose(yyin);
    fclose(yyout);

    return 0;
}