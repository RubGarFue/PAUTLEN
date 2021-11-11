%{
#include <stdio.h>
#include "y.tab.h"

extern FILE * out;
long yylin = 1;
long yycol = 1;
int yy_morph_error = 0;
%}
%option noyywrap
whitespace              [ \t]+
newline                 \n|\n\r|\r
comentario              "//".*
puntoycoma          	";"
asignacion          	"="
mas                 	"+"
menos               	"-"
asterisco           	"*"
constante_entera    	[0-9]+
identificador       	[a-zA-Z][a-zA-Z0-9]*
error               	.
%%
{comentario}          	{/* COMENTARIO */}
{whitespace}            {yycol += yyleng;}
{newline}               {yylin++; yycol = 0;}
{puntoycoma}          	{yycol += yyleng; fprintf(out, "TOK_PUNTOYCOMA\n"); return  TOK_PUNTOYCOMA;}
{asignacion}          	{yycol += yyleng; fprintf(out, "TOK_ASIGNACION\n"); return  TOK_ASIGNACION;}
{mas}                 	{yycol += yyleng; fprintf(out, "TOK_MAS\n"); return  TOK_MAS;}
{asterisco}           	{yycol += yyleng; fprintf(out, "TOK_ASTERISCO\n"); return  TOK_ASTERISCO;}
{constante_entera}    	{yycol += yyleng; fprintf(out, "TOK_CONSTANTE_ENTERA\n"); return  TOK_CONSTANTE_ENTERA;}
{identificador}       	{yycol += yyleng; fprintf(out, "TOK_IDENTIFICADOR\n"); return  TOK_IDENTIFICADOR;}
{error}                 {fprintf(stderr, "****Error en linea (Flex) %ld: \n", yylin); yycol += yyleng; yy_morph_error = 1; return  TOK_ERROR;}
%%
