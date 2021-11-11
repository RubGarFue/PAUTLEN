%{
/*
Ejemplo de Bison - La solución de la práctica debe seguir los parámetros indicados en el documento.
*/
#include <stdio.h>
int yylex();
void yyerror();
extern FILE * out;
extern long yylin;
extern long yycol;
extern int yy_morph_error;
%}


%token TOK_PUNTOYCOMA
%token TOK_ASIGNACION
%token TOK_MAS
%token TOK_MENOS
%token TOK_ASTERISCO

%token TOK_IDENTIFICADOR

%token TOK_CONSTANTE_ENTERA

%token TOK_ERROR

%left TOK_MAS TOK_MENOS

%%

sentencias: sentencia {fprintf(out, "sentencias Opt. 1\n");}
          | sentencia sentencias {fprintf(out, "sentencias Opt. 2\n");}
          ;

sentencia: sentencia_simple TOK_PUNTOYCOMA {fprintf(out, "sentencia \n");}
         ;

sentencia_simple: asignacion {fprintf(out, "sentencia_simple\n");}
                ;

asignacion: identificador TOK_ASIGNACION exp  {fprintf(out, "asignacion\n");}
          ;


exp: exp TOK_MAS exp {fprintf(out, "exp Opt. 1\n");}
   | exp TOK_MENOS exp {fprintf(out, "exp Opt. 1\n");}
   | identificador {fprintf(out, "exp Opt. 1\n");}
   | constante {fprintf(out, "exp Opt. 1\n");}
   ;

identificador: TOK_IDENTIFICADOR {fprintf(out, "identificador\n");}
             ;

constante: TOK_CONSTANTE_ENTERA {fprintf(out, "constante\n");}
         ;

%%

void yyerror(const char * s) {
    if(!yy_morph_error) {
        printf("****Error sintactico en linea: %ld\n", yylin);
    }
}
