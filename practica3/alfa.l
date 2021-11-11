%{
#include <stdio.h>
#include "y.tab.h"

extern FILE * out;
long yylin = 1;
long yycol = 1;
int yy_morph_error = 0;
%}
%option noyywrap
ESPACIO [ \t]+
SALTOLINEA \n|\n\r|\r
COMENTARIO "//".*

MAIN    "main"
INT "int"
BOOLEAN "boolean"
ARRAY   "array"
FUNCTION    "function"
IF  "if"
ELSE    "else"
WHILE   "while"
SCANF   "scanf"
PRINTF  "printf"
RETURN  "return"
PUNTOYCOMA  ";"
COMA    ","
PARENTESISIZQUIERDO "("
PARANTESISDERECHO   ")"
CORCHETEIZQUIERDO   "["
CORCHETEDERECHO "]"
LLAVEIZQUIERDA  "{"
LLAVEDERECHA    "}"
ASIGNACION  "="
MAS "+"
MENOS   "-"
DIVISION    "/"
ASTERISCO   "*"
AND "&&"
OR  "||"
NOT "!"
IGUAL   "=="
DISTINTO    "!="
MENORIGUAL  "<="
MAYORIGUAL  ">="
MENOR   "<"
MAYOR   ">"
TRUE    "true"
FALSE   "false"
IDENTIFICADOR   [a-zA-Z][a-zA-Z0-9]{0,99}
CONSTANTE_ENTERA    [0-9]
ERROR   [a-zA-Z][a-zA-Z0-9]{100,}|.
%%
{ESPACIO}   { yycol += yyleng; }
{SALTOLINEA}    { yycol=0; yylin++; }
{COMENTARIO}

{MAIN}  { yycol += yyleng; fprintf(out, ";D:\tTOK_MAIN\n"); return TOK_MAIN; }
{INT}   { yycol += yyleng; fprintf(out, ";D:\tTOK_INT\n"); return TOK_INT; }
{BOOLEAN}   { yycol += yyleng; fprintf(out, ";D:\tTOK_BOOLEAN\n"); return TOK_BOOLEAN; }
{ARRAY} { yycol += yyleng; fprintf(out, ";D:\tTOK_ARRAY\n"); return TOK_ARRAY;}
{FUNCTION}  { yycol += yyleng; fprintf(out, ";D:\tTOK_FUNCTION\n"); return TOK_FUNCTION; }
{IF}    { yycol += yyleng; fprintf(out, ";D:\tTOK_IF\n"); return TOK_IF; }
{ELSE}  { yycol += yyleng; fprintf(out, ";D:\tTOK_ELSE\n"); return TOK_ELSE; }
{WHILE} { yycol += yyleng; fprintf(out, ";D:\tTOK_WHILE\n"); return TOK_WHILE; }
{SCANF} { yycol += yyleng; fprintf(out, ";D:\tTOK_SCANF\n"); return TOK_SCANF; }
{PRINTF}    { yycol += yyleng; fprintf(out, ";D:\tTOK_PRINTF\n"); return TOK_PRINTF; }
{RETURN}    { yycol += yyleng; fprintf(out, ";D:\tTOK_RETURN\n"); return TOK_RETURN; }
{PUNTOYCOMA}    { yycol += yyleng; fprintf(out, ";D:\tTOK_PUNTOYCOMA\n"); return TOK_PUNTOYCOMA; }
{COMA}  { yycol += yyleng; fprintf(out, ";D:\tTOK_COMA\n"); return TOK_COMA; }
{PARENTESISIZQUIERDO}   { yycol += yyleng; fprintf(out, ";D:\tTOK_PARENTESISIZQUIERDO\n"); return TOK_PARENTESISIZQUIERDO; }
{PARANTESISDERECHO} { yycol += yyleng; fprintf(out, ";D:\tTOK_PARENTESISDERECHO\n"); return TOK_PARENTESISDERECHO; }
{CORCHETEIZQUIERDO} { yycol += yyleng; fprintf(out, ";D:\tTOK_CORCHETEIZQUIERDO\n"); return TOK_CORCHETEIZQUIERDO; }
{CORCHETEDERECHO}   { yycol += yyleng; fprintf(out, ";D:\tTOK_CORCHETEDERECHO\n"); return TOK_CORCHETEDERECHO; }
{LLAVEIZQUIERDA}    { yycol += yyleng; fprintf(out, ";D:\tTOK_LLAVEIZQUIERDA\n"); return TOK_LLAVEIZQUIERDA; }
{LLAVEDERECHA}   { yycol += yyleng; fprintf(out, ";D:\tTOK_LLAVEDERECHA\n"); return TOK_LLAVEDERECHA; }
{ASIGNACION}    { yycol += yyleng; fprintf(out, ";D:\tTOK_ASIGNACION\n"); return TOK_ASIGNACION; }
{MAS}   { yycol += yyleng; fprintf(out, ";D:\tTOK_MAS\n"); return TOK_MAS; }
{MENOS} { yycol += yyleng; fprintf(out, ";D:\tTOK_MENOS\n"); return TOK_MENOS; }
{DIVISION}  { yycol += yyleng; fprintf(out, ";D:\tTOK_DIVISION\n"); return TOK_DIVISION; }
{ASTERISCO}  { yycol += yyleng; fprintf(out, ";D:\tTOK_ASTERISCO\n"); return TOK_ASTERISCO; }
{AND}  { yycol += yyleng; fprintf(out, ";D:\tTOK_AND\n"); return TOK_AND; }
{OR}   { yycol += yyleng; fprintf(out, ";D:\tTOK_OR\n"); return TOK_OR; }
{NOT}  { yycol += yyleng; fprintf(out, ";D:\tTOK_NOT\n"); return TOK_NOT; }
{IGUAL}  { yycol += yyleng; fprintf(out, ";D:\tTOK_IGUAL\n"); return TOK_IGUAL; }
{DISTINTO}  { yycol += yyleng; fprintf(out, ";D:\tTOK_DISTINTO\n"); return TOK_DISTINTO; }
{MENORIGUAL}    { yycol += yyleng; fprintf(out, ";D:\tTOK_MENORIGUAL\n"); return TOK_MENORIGUAL; }
{MAYORIGUAL}    { yycol += yyleng; fprintf(out, ";D:\tTOK_MAYORIGUAL\n"); return TOK_MAYORIGUAL; }
{MENOR} { yycol += yyleng; fprintf(out, ";D:\tTOK_MENOR\n"); return TOK_MENOR; }
{MAYOR} { yycol += yyleng; fprintf(out, ";D:\tTOK_MAYOR\n"); return TOK_MAYOR; }
{TRUE}  { yycol += yyleng; fprintf(out, ";D:\tTOK_TRUE\n"); return TOK_TRUE; }
{FALSE} { yycol += yyleng; fprintf(out, ";D:\tTOK_FALSE\n"); return TOK_FALSE; }
{IDENTIFICADOR} { yycol += yyleng; fprintf(out, ";D:\tTOK_IDENTIFICADOR\n"); return TOK_IDENTIFICADOR; }
{CONSTANTE_ENTERA}   { yycol += yyleng; fprintf(out, ";D:\tTOK_CONSTANTE_ENTERA\n"); return TOK_CONSTANTE_ENTERA; }
{ERROR} { yycol += yyleng; fprintf(stderr, "****Error en la linea (Flex) %ld: \n", yylin); yy_morph_error = 1; return TOK_ERROR; }
%%