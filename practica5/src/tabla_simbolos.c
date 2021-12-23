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
#include <stdio.h>
#include <string.h>
#include "tabla_simbolos.h"

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

    elemento->nombre = (char*) malloc(sizeof(char) * (strlen(nombre) + 1));

    strcpy(elemento->nombre, nombre);
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
    Elemento* elemento2 = NULL;

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


Elemento* busqueda_elemento(TablaSimbolos *tabla, char* identificador) {

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

    return elemento;
}


int apertura_ambito(TablaSimbolos* tabla, char *nombre, int categoria, int clase, int tipo,
                    int tamano, int num_var_loc, int pos_var_loc, int num_par, int pos_par) {

    Elemento* elemento1 = NULL;
    Elemento* elemento2 = NULL;

    if (tabla->ambito == AMBITO_LOCAL) {
        return -1;
    }

    elemento1 = crear_elemento(nombre, categoria, clase, tipo, tamano, num_var_loc, pos_var_loc, num_par, pos_par);
    elemento2 = crear_elemento(nombre, categoria, clase, tipo, tamano, num_var_loc, pos_var_loc, num_par, pos_par);

    if (elemento1 == NULL || elemento2 == NULL) {
        return -1;
    }

    HASH_ADD_STR(*(tabla->global), nombre, elemento1);

    HASH_ADD_STR(*(tabla->local), nombre, elemento2);

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
        free(elemento->nombre);
        free(elemento);
    }

    free(tabla->local);
    free(tabla->global);

    free(tabla);
}