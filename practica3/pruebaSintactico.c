#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;
extern int yyparse();

int main(int argc, char *argv[]) {
    if(argc != 3) {
        fprintf(stdout, "Error en los argumentos de entrada\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if(yyin == NULL) {
        fprintf(stdout, "Error al abrir el archivo de entrada\n");
        return 1;

    }

    yyout = fopen(argv[2], "w");
    if(yyout == NULL) {
        fprintf(stdout, "Error al abrir el archivo de salida\n");
        return 1;

    }

    yyparse();

    fclose(yyin);
    fclose(yyout);

    return 0;
}