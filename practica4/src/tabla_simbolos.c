#include "tabla_simbolos.h"
#include "uthash.h" 

struct _TablaSimbolos {
    Elemento* global;
    Elemento* local;
    int len_global;
    int len_local;
    int ambito;
};

struct _Elemento {
    char *identificador;
    int entero;
    UT_hash_handle hh;
};


TablaSimbolos* crear_tabla() {
    TablaSimbolos* tabla = NULL;

    tabla = (TablaSimbolos*) malloc(sizeof(TablaSimbolos));

    if (tabla == NULL) {
        return NULL;
    }

    tabla->global = NULL;
    tabla->local = NULL;

    tabla->len_global = 0;
    tabla->len_local = 0;

    tabla->ambito = AMBITO_GLOBAL;

    return tabla;
}


Elemento* crear_elemento(char* identificador, int entero) {

    Elemento* elemento = NULL;
    
    elemento = (Elemento*) malloc(sizeof(Elemento));

    if (elemento == NULL) {
        return NULL;
    }

    elemento->identificador = identificador;
    elemento->entero = entero;

    return elemento;
}


int insercion_elemento(TablaSimbolos* tabla, char* identificador, int entero) {

    Elemento* elemento = NULL;

    if (busqueda_elemento(tabla, identificador) != -1) {
        return -1;
    }
    
    elemento = crear_elemento(identificador, entero);

    if (elemento == NULL) {
        return -1;
    }

    if (tabla->ambito == AMBITO_GLOBAL) {
        HASH_ADD_STR(tabla->global, identificador, elemento);
    }

    else {
        HASH_ADD_STR(tabla->local, identificador, elemento);
    }

    return 0;
}


int busqueda_elemento(TablaSimbolos *tabla, char* identificador) {

    Elemento* elemento = NULL;

    if (tabla->ambito == AMBITO_GLOBAL) {
        HASH_FIND_STR(tabla->global, identificador, elemento);
    }

    else {
        HASH_FIND_STR(tabla->local, identificador, elemento);
    }

    if(elemento == NULL) {
        return -1;
    }

    return elemento->entero;
}


int apertura_ambito(TablaSimbolos *tabla, char* identificador, int entero) {

    Elemento* elemento = NULL;

    if (tabla->ambito == AMBITO_LOCAL) {
        return -1;
    }

    elemento = crear_elemento(identificador, entero);

    if (elemento == NULL) {
        return -1;
    }

    HASH_ADD_STR(tabla->global, identificador, elemento);

    HASH_ADD_STR(tabla->local, identificador, elemento);

    tabla->ambito = AMBITO_LOCAL;

    return 0;
}


int cierre_ambito(TablaSimbolos *tabla) {

    Elemento* elemento, *tmp;

    if (tabla->ambito == AMBITO_GLOBAL) {
        return -1;
    }
    
    HASH_ITER(hh, tabla->local, elemento, tmp) {
        HASH_DEL(tabla->local, elemento);
        free(elemento);
    }

    tabla->ambito = AMBITO_GLOBAL;

    return 0;
}