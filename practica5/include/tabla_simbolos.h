/**
 * @file tabla_simbolos.h
 * @author Miguel Escribano Ortega, Rubén García de la Fuente
 * @brief Definición de las estructuras y funciones de la tabla de símbolos
 * @version 0.1
 * @date 2021-11-24
 * 
 * @copyright Copyright (c) 2021
 */
#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#define AMBITO_GLOBAL 0
#define AMBITO_LOCAL 1

#include "uthash.h"

/**
 * @brief Elemento
 * 
 * Esta estructura define un elemento de la tabla de símbolos
 */
typedef struct _Elemento {
    char *nombre;
    int categoria;  /* variable, parametro o funcion */
    int clase;      /* escalar o vector */
    int tipo;       /* entero o booleano */
    int tamano;     /* numero de elementos de un vector */
    int num_var_loc;
    int pos_var_loc;
    int num_par;
    int pos_par;
    UT_hash_handle hh;
} Elemento;

/**
 * @brief TablaSimbolos
 * 
 * Esta estructura define una tabla de símbolos 
 */
typedef struct _TablaSimbolos {
    Elemento** global;
    Elemento** local;
    int ambito;
} TablaSimbolos;

/**
 * @brief crea una nueba tabla de símbolos
 * 
 * @return TablaSimbolos*
 * puntero a la nueva tabla de símbolos creada
 */
TablaSimbolos* crear_tabla();


/**
 * @brief inserta un elemento en la tabla de símbolos
 * 
 * @param tabla tabla de simbolos a la cual queremos insertar el elemento
 * @param nombre nombre del elemento
 * @param categoria categoria del elemento
 * @param clase clase del elemento
 * @param tipo tipo del elemento
 * @param tamano tamano del elemento
 * @param num_var_loc numero de variables locales
 * @param pos_var_loc posicion de variable local
 * @param num_par numero de parametros
 * @param pos_par posicion de parametro
 * @return int
 * 0 si se insertó correctamente, -1 si hubo algun error
 */
int insercion_elemento(TablaSimbolos* tabla, char *nombre, int categoria, int clase, int tipo,
                       int tamano, int num_var_loc, int pos_var_loc, int num_par, int pos_par);

/**
 * @brief busca un elemento de la tabla de símbolos
 * 
 * @param tabla tabla de símbolos en la cual queremos buscar el elemento
 * @param identificador nombre del elemento
 * @return Elemento*
 * retorna el puntero apuntando al elemento encontrado, NULL si no se encontró en la tabla
 */
Elemento* busqueda_elemento(TablaSimbolos *tabla, char* identificador);

/**
 * @brief abre un ámbito de la tabla de símbolos
 * 
 * @param tabla tabla de símbolos en la cual queremos abrir un ámbito
 * @param identificador nombre del elemento asociado al ámbito
 * @param entero entero característico del elemento asociado al ámbito
 * @return int
 * 0 si se abrió correctamente, -1 si hubo algun error
 */
int apertura_ambito(TablaSimbolos* tabla, char *nombre, int categoria, int clase, int tipo,
                    int tamano, int num_var_loc, int pos_var_loc, int num_par, int pos_par);
/**
 * @brief cierra un ámbito de la tabla de sámbolos
 * 
 * @param tabla tabla de sámbolos en la cual queremos cerrar un ámbito
 * @return int
 * 0 si se cerró correctamente, -1 si hubo algun error
 */
int cierre_ambito(TablaSimbolos *tabla);

/**
 * @brief elimina y libera todos los recursos de una tabla de símbolos
 * @param tabla
 */
void eliminar_tabla(TablaSimbolos *tabla);

#endif