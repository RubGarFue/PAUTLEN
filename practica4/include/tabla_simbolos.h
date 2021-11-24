#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#define AMBITO_GLOBAL 0
#define AMBITO_LOCAL 1

typedef struct _TablaSimbolos TablaSimbolos;
typedef struct _Elemento Elemento;

/**
 * @brief crea una nueba tabla se simbolos
 * 
 * @return TablaSimbolos*
 * puntero a la nueva tabla de simbolos creada
 */
TablaSimbolos* crear_tabla();


/**
 * @brief inserta un elemento en la tabla de simbolos
 * 
 * @param tabla tabla de simbolos a la cual queremos insertar el elemento
 * @param identificador nombre del elemento
 * @param entero entero caracteristico del elemento
 * @return int
 * 0 si se inserto correctamente, -1 si hubo algun error
 */
int insercion_elemento(TablaSimbolos* tabla, char* identificador, int entero);

/**
 * @brief busca un elemento de la tabla de simbolos
 * 
 * @param tabla tabla de simbolos en la cual queremos buscar el elemento
 * @param identificador nombre del elemento
 * @return int 
 * retorna el entero caracteristico del elemento, -1 si no se encontro en la tabla
 */
int busqueda_elemento(TablaSimbolos *tabla, char* identificador);

/**
 * @brief abre un ambito de la tabla de simbolos
 * 
 * @param tabla tabla de simbolos en la cual queremos abrir un ambito
 * @param identificador nombre del elemento asociado al ambito
 * @param entero entero caracteristico del elemento asociado al ambito
 * @return int
 * 0 si se abrio correctamente, -1 si hubo algun error
 */
int apertura_ambito(TablaSimbolos *tabla, char* identificador, int entero);

/**
 * @brief cierra un ambito de la tabla de simbolos
 * 
 * @param tabla tabla de simbolos en la cual queremos cerrar un ambito
 * @return int
 * 0 si se cerro correctamente, -1 si hubo algun error
 */
int cierre_ambito(TablaSimbolos *tabla);

#endif