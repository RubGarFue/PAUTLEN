/**
 * @file tabla_simbolos.c
 * @author Miguel Escribano Ortega, Rubén García de la Fuente
 * @brief Implementación de las estructuras y funciones de la tabla de símbolos
 * @version 0.1
 * @date 2021-11-24
 * 
 * @copyright Copyright (c) 2021
 * 
 */
#include "tabla_simbolos.h"
#include "uthash.h" 

/**
 * @brief TablaSimbolos
 * 
 * Esta estructura define una tabla de símbolos 
 */
struct _TablaSimbolos {
    Elemento** global;
    Elemento** local;
    int ambito;
};

/**
 * @brief Elemento
 * 
 * Esta estructura define un elemento de la tabla de símbolos
 */
struct _Elemento {
    char *nombre;
    int categoria;
    int clase;
    int tipo;
    int tamano;
    int num_var_loc;
    int pos_var_loc;
    int num_par;
    int pos_par;
    UT_hash_handle hh;
};


TablaSimbolos* crear_tabla() {
    TablaSimbolos* tabla = NULL;

    tabla = (TablaSimbolos*) malloc(sizeof(TablaSimbolos));

    if (tabla == NULL) {
        return NULL;
    }

    tabla->global = (Elemento**) malloc(sizeof(Elemento*));
    tabla->local = (Elemento**) malloc(sizeof(Elemento*));

    *(tabla->global) = NULL;
    *(tabla->local) = NULL;

    tabla->ambito = AMBITO_GLOBAL;

    return tabla;
}


Elemento* crear_elemento(char *nombre, int categoria, int clase, int tipo, int tamano,
                         int num_var_loc, int pos_var_loc, int num_par, int pos_par) {

    Elemento* elemento = NULL;
    
    elemento = (Elemento*) malloc(sizeof(Elemento));

    if (elemento == NULL) {
        return NULL;
    }

    elemento->nombre = nombre;
    elemento->categoria = categoria;
    elemento->clase = clase;
    elemento->tipo = tipo;
    elemento->tamano = tamano;
    elemento->num_var_loc = num_var_loc;
    elemento->pos_var_loc = pos_var_loc;
    elemento->num_par = num_par;
    elemento->pos_par = pos_par;

    return elemento;
}


int insercion_elemento(TablaSimbolos* tabla, char *nombre, int categoria, int clase, int tipo,
                       int tamano, int num_var_loc, int pos_var_loc, int num_par, int pos_par) {

    Elemento* elemento = NULL;

    if (tabla->ambito == AMBITO_GLOBAL) {
        HASH_FIND_STR(*(tabla->global), nombre, elemento);
    }

    else {
        HASH_FIND_STR(*(tabla->local), nombre, elemento);
    }

    if(elemento != NULL) {
        return -1;
    }

    elemento = crear_elemento(nombre, categoria, clase, tipo, tamano, num_var_loc, pos_var_loc, num_par, pos_par);

    if (elemento == NULL) {
        return -1;
    }

    if (tabla->ambito == AMBITO_GLOBAL) {
        HASH_ADD_STR(*(tabla->global), nombre, elemento);
    }

    else {
        HASH_ADD_STR(*(tabla->local), nombre, elemento);
    }

    return 0;
}


int busqueda_elemento(TablaSimbolos *tabla, char* identificador) {

    Elemento* elemento = NULL;

    if (tabla->ambito == AMBITO_GLOBAL) {
        HASH_FIND_STR(*(tabla->global), identificador, elemento);
    }

    else {
        HASH_FIND_STR(*(tabla->local), identificador, elemento);

        if (elemento == NULL) {
            HASH_FIND_STR(*(tabla->global), identificador, elemento);
        }
    }

    if(elemento == NULL) {
        return -1;
    }

    return elemento;
}


int apertura_ambito(TablaSimbolos *tabla, char* identificador, int entero) {

    Elemento* elemento1 = NULL;
    Elemento* elemento2 = NULL;

    if (tabla->ambito == AMBITO_LOCAL) {
        return -1;
    }

    elemento1 = crear_elemento(identificador, entero);
    elemento2 = crear_elemento(identificador, entero);

    if (elemento1 == NULL || elemento2 == NULL) {
        return -1;
    }

    HASH_ADD_STR(*(tabla->global), identificador, elemento1);

    HASH_ADD_STR(*(tabla->local), identificador, elemento2);

    tabla->ambito = AMBITO_LOCAL;

    return 0;
}


int cierre_ambito(TablaSimbolos *tabla) {

    Elemento* elemento, *tmp;

    if (tabla->ambito == AMBITO_GLOBAL) {
        return -1;
    }

    HASH_ITER(hh, *(tabla->local), elemento, tmp) {
        HASH_DEL(*(tabla->local), elemento);
        free(elemento);
    }

    tabla->ambito = AMBITO_GLOBAL;

    return 0;
}


void eliminar_tabla(TablaSimbolos *tabla) {

    Elemento* elemento, *tmp;

    HASH_ITER(hh, *(tabla->global), elemento, tmp) {
        HASH_DEL(*(tabla->global), elemento);
        free(elemento);
    }

    free(tabla->local);
    free(tabla->global);

    free(tabla);
}