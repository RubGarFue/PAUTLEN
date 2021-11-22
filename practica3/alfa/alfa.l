%{
#include <stdio.h>
#include "y.tab.h"

extern FILE * yyout;
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
PARENTESISDERECHO   ")"
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

{MAIN}  { yycol += yyleng; fprintf(yyout, ";D:\tmain\n"); return TOK_MAIN; }
{INT}   { yycol += yyleng; fprintf(yyout, ";D:\tint\n"); return TOK_INT; }
{BOOLEAN}   { yycol += yyleng; fprintf(yyout, ";D:\tboolean\n"); return TOK_BOOLEAN; }
{ARRAY} { yycol += yyleng; fprintf(yyout, ";D:\tarray\n"); return TOK_ARRAY;}
{FUNCTION}  { yycol += yyleng; fprintf(yyout, ";D:\tfunction\n"); return TOK_FUNCTION; }
{IF}    { yycol += yyleng; fprintf(yyout, ";D:\tif\n"); return TOK_IF; }
{ELSE}  { yycol += yyleng; fprintf(yyout, ";D:\telse\n"); return TOK_ELSE; }
{WHILE} { yycol += yyleng; fprintf(yyout, ";D:\twhile\n"); return TOK_WHILE; }
{SCANF} { yycol += yyleng; fprintf(yyout, ";D:\tscanf\n"); return TOK_SCANF; }
{PRINTF}    { yycol += yyleng; fprintf(yyout, ";D:\tprintf\n"); return TOK_PRINTF; }
{RETURN}    { yycol += yyleng; fprintf(yyout, ";D:\treturn\n"); return TOK_RETURN; }
{PUNTOYCOMA}    { yycol += yyleng; fprintf(yyout, ";D:\t;\n"); return TOK_PUNTOYCOMA; }
{COMA}  { yycol += yyleng; fprintf(yyout, ";D:\t,\n"); return TOK_COMA; }
{PARENTESISIZQUIERDO}   { yycol += yyleng; fprintf(yyout, ";D:\t(\n"); return TOK_PARENTESISIZQUIERDO; }
{PARENTESISDERECHO} { yycol += yyleng; fprintf(yyout, ";D:\t)\n"); return TOK_PARENTESISDERECHO; }
{CORCHETEIZQUIERDO} { yycol += yyleng; fprintf(yyout, ";D:\t[\n"); return TOK_CORCHETEIZQUIERDO; }
{CORCHETEDERECHO}   { yycol += yyleng; fprintf(yyout, ";D:\t]\n"); return TOK_CORCHETEDERECHO; }
{LLAVEIZQUIERDA}    { yycol += yyleng; fprintf(yyout, ";D:\t{\n"); return TOK_LLAVEIZQUIERDA; }
{LLAVEDERECHA}   { yycol += yyleng; fprintf(yyout, ";D:\t}\n"); return TOK_LLAVEDERECHA; }
{ASIGNACION}    { yycol += yyleng; fprintf(yyout, ";D:\t=\n"); return TOK_ASIGNACION; }
{MAS}   { yycol += yyleng; fprintf(yyout, ";D:\t+\n"); return TOK_MAS; }
{MENOS} { yycol += yyleng; fprintf(yyout, ";D:\t-\n"); return TOK_MENOS; }
{DIVISION}  { yycol += yyleng; fprintf(yyout, ";D:\t/\n"); return TOK_DIVISION; }
{ASTERISCO}  { yycol += yyleng; fprintf(yyout, ";D:\t*\n"); return TOK_ASTERISCO; }
{AND}  { yycol += yyleng; fprintf(yyout, ";D:\t&&\n"); return TOK_AND; }
{OR}   { yycol += yyleng; fprintf(yyout, ";D:\t||\n"); return TOK_OR; }
{NOT}  { yycol += yyleng; fprintf(yyout, ";D:\t!\n"); return TOK_NOT; }
{IGUAL}  { yycol += yyleng; fprintf(yyout, ";D:\t==\n"); return TOK_IGUAL; }
{DISTINTO}  { yycol += yyleng; fprintf(yyout, ";D:\t!=\n"); return TOK_DISTINTO; }
{MENORIGUAL}    { yycol += yyleng; fprintf(yyout, ";D:\t<=\n"); return TOK_MENORIGUAL; }
{MAYORIGUAL}    { yycol += yyleng; fprintf(yyout, ";D:\t>=\n"); return TOK_MAYORIGUAL; }
{MENOR} { yycol += yyleng; fprintf(yyout, ";D:\t<\n"); return TOK_MENOR; }
{MAYOR} { yycol += yyleng; fprintf(yyout, ";D:\t>\n"); return TOK_MAYOR; }
{TRUE}  { yycol += yyleng; fprintf(yyout, ";D:\ttrue\n"); return TOK_TRUE; }
{FALSE} { yycol += yyleng; fprintf(yyout, ";D:\tfalse\n"); return TOK_FALSE; }
[a-zA-Z][a-zA-Z0-9]{0,99}  { yycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_IDENTIFICADOR; }
[0-9]   { yycol += yyleng; fprintf(yyout, ";D:\t%s\n",yytext); return TOK_CONSTANTE_ENTERA; }
{ERROR} { yycol += yyleng; fprintf(stderr, "****Error en [lin %ld, col %ld]: simbolo no permitido \n", yylin, yycol); yy_morph_error = 1; return TOK_ERROR; }
%%