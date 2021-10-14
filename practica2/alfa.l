%{
#include <stdio.h>
#include "tokens.h"

long yylin = 1;
long yycol = 1;

%}
%option noyywrap
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
IDENTIFICADOR   [a-zA-Z][a-zA-Z0-9]*{0,99}
CONSTANTE_ENTERA    [0-9]+
TRUE    "true"
FALSE   "false"
ERROR   .
%%
{MAIN}  { yycol += yyleng; return TOK_MAIN; }
{INT}   { yycol += yyleng; return TOK_INT; }
{BOOLEAN}   { yycol += yyleng; return TOK_BOOLEAN; }
{ARRAY} { yycol += yyleng; return TOK_ARRAY;}
{FUNCTION}  { yycol += yyleng; return TOK_FUNCTION; }
{IF}    { yycol += yyleng; return TOK_IF; }
{ELSE}  { yycol += yyleng; return TOK_ELSE; }
{WHILE} { yycol += yyleng; return TOK_WHILE; }
{SCANF} { yycol += yyleng; return TOK_SCANF; }
{PRINTF}    { yycol += yyleng; return TOK_PRINTF; }
{RETURN}    { yycol += yyleng; return TOK_RETURN; }
{PUNTOYCOMA}    { yycol += yyleng; return TOK_PUNTOYCOMA; }
{COMA}  { yycol += yyleng; return TOK_COMA; }
{PARENTESISIZQUIERDO}   { yycol += yyleng; return TOK_PARENTESISIZQUIERDO; }
{PARANTESISDERECHO} { yycol += yyleng; return TOK_PARENTESISDERECHO; }
{CORCHETEIZQUIERDO} { yycol += yyleng; return TOK_CORCHETEIZQUIERDO; }
{CORCHETEDERECHO}   { yycol += yyleng; return TOK_CORCHETEDERECHO; }
{LLAVEIZQUIERDA}    { yycol += yyleng; return TOK_LLLAVEIZQUIERDA; }
{LLAVEDERECHA}   { yycol += yyleng; return TOK_LLAVEDERECHA; }
{ASIGNACION}    { yycol += yyleng; return TOK_ASIGNACION; }
{MAS}   { yycol += yyleng; return TOK_MAS; }
{MENOS} { yycol += yyleng; return TOK_MENOS; }
{DIVISION}  { yycol += yyleng; return TOK_DIVISION; }
{ASTERISCO}  { yycol += yyleng; return TOK_ASTERISCO; }
{AND}  { yycol += yyleng; return TOK_AND; }
{OR}   { yycol += yyleng; return TOK_OR; }
{NOT}  { yycol += yyleng; return TOK_NOT; }
{IGUAL}  { yycol += yyleng; return TOK_IGUAL; }
{DISTINTO}  { yycol += yyleng; return TOK_DISTINTO; }
{MENORIGUAL}    { yycol += yyleng; return TOK_MENORIGUAL; }
{MAYORIGUAL}    { yycol += yyleng; return TOK_MAYORIGUAL; }
{MENOR} { yycol += yyleng; return TOK_MENOR; }
{MAYOR} { yycol += yyleng; return TOK_MAYOR; }
{IDENTIFICADOR} { yycol += yyleng; return TOK_IDENTIFICADOR; }
{CONSTANTE_ENTERA}   { yycol += yyleng; return TOK_CONSTANTE_ENTERA; }
{TRUE}  { yycol += yyleng; return TOK_TRUE; }
{FALSE} { yycol += yyleng; return TOK_FALSE; }
{ERROR} { yycol += yyleng; return TOK_ERROR; }
%%

int main() {
    return yylex();
}