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

typedef struct _TablaSimbolos TablaSimbolos;
typedef struct _Elemento Elemento;

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
 * @param identificador nombre del elemento
 * @param entero entero característico del elemento
 * @return int
 * 0 si se insertó correctamente, -1 si hubo algun error
 */
int insercion_elemento(TablaSimbolos* tabla, char* identificador, int entero);

/**
 * @brief busca un elemento de la tabla de símbolos
 * 
 * @param tabla tabla de símbolos en la cual queremos buscar el elemento
 * @param identificador nombre del elemento
 * @return int 
 * retorna el entero característico del elemento, -1 si no se encontró en la tabla
 */
int busqueda_elemento(TablaSimbolos *tabla, char* identificador);

/**
 * @brief abre un ámbito de la tabla de símbolos
 * 
 * @param tabla tabla de símbolos en la cual queremos abrir un ámbito
 * @param identificador nombre del elemento asociado al ámbito
 * @param entero entero característico del elemento asociado al ámbito
 * @return int
 * 0 si se abrió correctamente, -1 si hubo algun error
 */
int apertura_ambito(TablaSimbolos *tabla, char* identificador, int entero);

/**
 * @brief cierra un ámbito de la tabla de sámbolos
 * 
 * @param tabla tabla de sámbolos en la cual queremos cerrar un ámbito
 * @return int
 * 0 si se cerró correctamente, -1 si hubo algun error
 */
int cierre_ambito(TablaSimbolos *tabla);

#endif