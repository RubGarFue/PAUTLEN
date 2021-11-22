#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#define AMBITO_GLOBAL 0
#define AMBITO_LOCAL 1

typedef struct _TablaSimbolos TablaSimbolos;
typedef struct _Elemento Elemento;

TablaSimbolos* crear_tabla();
int insercion_elemento(TablaSimbolos* tabla, char* identificador, int entero);
int busqueda_elemento(TablaSimbolos *tabla, char* identificador);
int apertura_ambito(TablaSimbolos *tabla, char* identificador, int entero);
int cierre_ambito(TablaSimbolos *tabla);

#endif