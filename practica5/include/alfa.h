#ifndef ALFA_H
#define ALFA_H

#define ESCALAR 1
#define VECTOR 2


#define VARIABLE 1
#define PARAMETRO 2
#define FUNCION 3


#define INT 1
#define BOOLEAN 2

#define MAX_LONG_ID 100
#define MAX_TAMANIO_VECTOR 64
#define MAX_TAMANIO_INT 64

typedef struct {
    char nombre[MAX_LONG_ID+1];
    int tipo;
    int valor_entero;
    int es_direccion;
    int etiqueta;
} tipo_atributos;

#endif