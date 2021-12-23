%{
#include <stdio.h>
#include <string.h>
#include "alfa.h"
#include "generacion.h"
#include "tabla_simbolos.h"

int yylex();
void yyerror();
extern FILE * yyout;
extern long yylin;
extern long yycol;
extern int yy_morph_error;

int pos_parametro_actual = 0;
int num_parametros_actual = 0;
int tipo_actual;
int clase_actual;
int tipo_funcion;
int tamanio_vector_actual = 1;
int pos_variable_local_actual = 0;
int etiqueta = 0;
int num_argumentos_funcion = 0;
int retorno_funcion = 0;
int num_variables_locales_actual = 0;
int en_llamada_a_funcion = 0; /*1 si se esta dentro de los parentesis de una funcion. 0 si se esta fuera*/
TablaSimbolos *tabla;
%}

%union {
  tipo_atributos atributos;
}

%token TOK_MAIN
%token TOK_INT
%token TOK_BOOLEAN
%token <atributos> TOK_ARRAY
%token TOK_FUNCTION
%token TOK_IF
%token TOK_ELSE
%token TOK_WHILE
%token TOK_SCANF
%token TOK_PRINTF
%token TOK_RETURN
%token TOK_PUNTOYCOMA
%token TOK_COMA
%token TOK_PARENTESISIZQUIERDO
%token TOK_PARENTESISDERECHO
%token TOK_CORCHETEIZQUIERDO
%token TOK_CORCHETEDERECHO
%token TOK_LLAVEIZQUIERDA
%token TOK_LLAVEDERECHA
%token TOK_ASIGNACION
%token TOK_MAS
%token TOK_MENOS
%token TOK_DIVISION
%token TOK_ASTERISCO
%token TOK_AND
%token TOK_OR
%token TOK_NOT
%token TOK_IGUAL
%token TOK_DISTINTO
%token TOK_MENORIGUAL
%token TOK_MAYORIGUAL
%token TOK_MENOR
%token TOK_MAYOR
%token TOK_TRUE
%token TOK_FALSE
%token <atributos> TOK_IDENTIFICADOR
%token <atributos> TOK_CONSTANTE_ENTERA
%token TOK_ERROR


%type <atributos> constante
%type <atributos> constante_logica
%type <atributos> constante_entera
%type <atributos> identificador
%type <atributos> comparacion
%type <atributos> exp
%type <atributos> idf_llamada_funcion

%type <atributos> condicional
%type <atributos> if_exp
%type <atributos> if_else_exp
%type <atributos> bucle
%type <atributos> while_exp
%type <atributos> while
%type <atributos> elemento_vector
%type <atributos> funcion
%type <atributos> fn_declaration
%type <atributos> fn_name

%left TOK_IGUAL TOK_MENORIGUAL TOK_MENOR TOK_MAYORIGUAL TOK_MAYOR TOK_DISTINTO
%left TOK_AND TOK_OR
%left TOK_MAS TOK_MENOS
%left TOK_ASTERISCO TOK_DIVISION
%right TOK_NOT
%%


programa: inicioTabla TOK_MAIN TOK_LLAVEIZQUIERDA declaraciones escribir_text funciones sentencias TOK_LLAVEDERECHA
          { 
            fprintf(yyout,";R1:\t<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n");
            escribir_fin(yyout);
            eliminar_tabla(tabla);
          }
        ;

inicioTabla:
             { 
               tabla = crear_tabla();
               if (tabla == NULL) {
                 return -1;
               }
               escribir_subseccion_data(yyout);
               escribir_cabecera_bss(yyout);
             }
           ;

escribir_text:
               {
                 escribir_segmento_codigo(yyout);
               }
             ;

declaraciones: declaracion
               { fprintf(yyout,";R2:\t<declaraciones> ::= <declaracion>\n"); }
             | declaracion declaraciones
               { fprintf(yyout,";R3:\t<declaraciones> ::= <declaracion> <declaraciones>\n"); }
             ;

declaracion: clase identificadores TOK_PUNTOYCOMA
             { fprintf(yyout,";R4:\t<declaracion> ::= <clase> <identificadores> ;\n"); }
           ;

clase: clase_escalar
       { 
         fprintf(yyout,";R5:\t<clase> ::= <clase_escalar>\n");
         clase_actual = ESCALAR;

       }
     | clase_vector
       { 
         fprintf(yyout,";R7:\t<clase> ::= <clase_vector>\n");
         clase_actual = VECTOR;
       }
     ;

clase_escalar: tipo
               {
                 fprintf(yyout,";R9:\t<clase_escalar> ::= <tipo>\n");
                 tamanio_vector_actual = 1;
               }
             ;

tipo: TOK_INT
      { 
        fprintf(yyout,";R10:\t<tipo> ::= int\n");
        tipo_actual = INT;
      }
    | TOK_BOOLEAN
      { 
        fprintf(yyout,";R11:\t<tipo> ::= boolean\n");
        tipo_actual = BOOLEAN;
      }
    ;

clase_vector: TOK_ARRAY tipo TOK_CORCHETEIZQUIERDO constante_entera TOK_CORCHETEDERECHO
              {
                fprintf(yyout,";R15:\t<clase_vector> ::= array <tipo> [ <constante_entera> ]\n");
                tamanio_vector_actual = $4.valor_entero;

                if(tamanio_vector_actual < 1 || tamanio_vector_actual > MAX_TAMANIO_VECTOR) {
                  printf("****Error semantico en lin %ld: El tamanyo del vector <nombre_vector> excede los limites permitidos (1,64).",yylin);
                  eliminar_tabla(tabla);
                  return -1;
                }
              }
            ;

identificadores: identificador
                 { fprintf(yyout,";R18:\t<identificadores> ::= <identificador>\n"); }
               | identificador TOK_COMA identificadores
                 { fprintf(yyout,";R19:\t<identificadores> ::= <identificador> , <identificadores>\n"); }
               ;

funciones: funcion funciones
           { fprintf(yyout,";R20:\t<funciones> ::= <funcion> <funciones>\n"); }
         |
           {
             fprintf(yyout,";R21:\t<funciones> ::= \n"); 
             escribir_inicio_main(yyout);
           }
         ;

funcion: fn_declaration sentencias TOK_LLAVEDERECHA
         {
           fprintf(yyout,";R22:\t<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }\n");

           if(retorno_funcion < 1) {
             printf("****Error semantico en lin %ld: Funcion %s sin sentencia de retorno.\n", yylin, $1.nombre);
             eliminar_tabla(tabla);
             return -1;
           } 
           cierre_ambito(tabla);
           /*Guardamos la informacion en el simbolo de la tabla global*/
           Elemento *elemento;
           elemento = busqueda_elemento(tabla, $1.nombre);
           if(elemento == NULL) {
             eliminar_tabla(tabla);
             return -1;
           }
           
           elemento->num_par = num_parametros_actual;
           elemento->tipo = tipo_funcion;
           num_parametros_actual = 0;
           num_variables_locales_actual = 0;
           pos_parametro_actual = 0;
         }
       ;

fn_declaration: fn_name TOK_PARENTESISIZQUIERDO parametros_funcion TOK_PARENTESISDERECHO
                TOK_LLAVEIZQUIERDA declaraciones_funcion
                {
                  Elemento* elemento;
                  elemento = busqueda_elemento(tabla, $1.nombre);
                  if (elemento == NULL) {
                    eliminar_tabla(tabla);
                    return -1;
                  }

                  elemento->num_par = num_parametros_actual;
                  elemento->num_var_loc = num_variables_locales_actual;
                  elemento->tipo = tipo_funcion;
                  strcpy($$.nombre, $1.nombre);
                  declararFuncion(yyout, $1.nombre, num_variables_locales_actual);
                }
              ;

fn_name: TOK_FUNCTION tipo TOK_IDENTIFICADOR
         {
           if (busqueda_elemento(tabla, $3.nombre) == NULL) {
             strcpy($$.nombre, $3.nombre);
             apertura_ambito(tabla, $3.nombre, VARIABLE, clase_actual,
                             tipo_actual, tamanio_vector_actual, num_argumentos_funcion,
                             pos_variable_local_actual, 0, num_argumentos_funcion);
             tamanio_vector_actual = 1;
             num_variables_locales_actual = 0;
             pos_parametro_actual = 0;
             num_parametros_actual = 0;
             retorno_funcion = 0;
             tipo_funcion = tipo_actual;
           }
           else {
             printf("****Error semantico en lin %ld: Declaracion duplicada\n", yylin);
             eliminar_tabla(tabla);
             return -1;
           }
         }
       ;

parametros_funcion: parametro_funcion resto_parametros_funcion
                    { fprintf(yyout,";R23:\t<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n"); }
                  |
                    { fprintf(yyout,";R24:\t<parametros_funcion> ::= \n"); }
                  ;

resto_parametros_funcion: TOK_PUNTOYCOMA parametro_funcion resto_parametros_funcion
                          { fprintf(yyout,";R25:\t<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>\n"); }
                        |
                          { fprintf(yyout,";R26:\t<resto_parametros_funcion> ::= \n"); } 
                        ;

parametro_funcion: tipo idpf
                   { 
                     fprintf(yyout,";R27:\t<parametro_funcion> ::= <tipo> <identificador>\n");
                     pos_parametro_actual++;
                     num_parametros_actual++;
                   }
                 ;

idpf: TOK_IDENTIFICADOR
      {
        if(busqueda_elemento(tabla, $1.nombre) == NULL) {
          if(insercion_elemento(tabla, $1.nombre, PARAMETRO, ESCALAR,
                                tipo_actual, 1, 0, 0, 0, pos_parametro_actual) == -1) {
            eliminar_tabla(tabla);
            return -1;
          }
        }
        else {
          printf("****Error semantico en lin %ld: Declaracion duplicada.\n", yylin);
          eliminar_tabla(tabla);
          return -1;
        }
      }
    ;

declaraciones_funcion: declaraciones
                       { fprintf(yyout,";R28:\t<declaraciones_funcion> ::= <declaraciones>\n"); }
                     |
                       { fprintf(yyout,";R29:\t<declaraciones_funcion> ::= \n"); }
                     ;

sentencias: sentencia
            { fprintf(yyout,";R30:\t<sentencias> ::= <sentencia>\n"); }
          | sentencia sentencias
            { fprintf(yyout,";R31:\t<sentencias> ::= <sentencia> <sentencias>\n"); }
          ;

sentencia: sentencia_simple TOK_PUNTOYCOMA
           { fprintf(yyout,";R32:\t<sentencia> ::= <sentencia_simple> ;\n"); }
         | bloque
           { fprintf(yyout,";R33:\t<sentencia> ::= <bloque>\n"); }
         ;

sentencia_simple: asignacion
                  { fprintf(yyout,";R34:\t<sentencia_simple> ::= <asignacion>\n"); }
                | lectura
                  { fprintf(yyout,";R35:\t<sentencia_simple> ::= <lectura>\n"); }
                | escritura
                  { fprintf(yyout,";R36:\t<sentencia_simple> ::= <escritura>\n"); }
                | retorno_funcion
                  { fprintf(yyout,";R38:\t<sentencia_simple> ::= <retorno_funcon>\n"); }
                ;

bloque: condicional
        { fprintf(yyout,";R40:\t<bloque> ::= <condicional>\n"); }
      | bucle
        { fprintf(yyout,";R41:\t<bloque> ::= <bucle>\n"); }
      ;

asignacion: TOK_IDENTIFICADOR TOK_ASIGNACION exp
            {
              Elemento *elemento;
              elemento = busqueda_elemento(tabla, $1.nombre);

              if(elemento == NULL) {
                printf("****Error semantico en lin %ld: Acceso a variable no declarada (%s).\n", yylin, $1.nombre);
                eliminar_tabla(tabla);
                return -1;  
              }

              if(elemento->clase == VECTOR || elemento->categoria == FUNCION || elemento->tipo != $3.tipo) {
                printf("****Error semantico en lin %ld: Asignacion incompatible.\n", yylin);
                eliminar_tabla(tabla);
                return -1;
              }

              if(tabla->ambito == AMBITO_GLOBAL) {
                asignar(yyout, $1.nombre, $3.es_direccion);
              }

              else {
                escribirVariableLocal(yyout, elemento->pos_par);
                asignarDestinoEnPila(yyout, $3.es_direccion);
              }

              fprintf(yyout,";R43:\t<asignacion> ::= <identificador> = <exp>\n");
            }
          | elemento_vector TOK_ASIGNACION exp
            { 
              Elemento *elemento;
              elemento = busqueda_elemento(tabla, $1.nombre);
              if(elemento == NULL) {
                printf("****Error semantico en lin %ld: Acceso a variable no declarada (%s).\n", yylin, $1.nombre);
                eliminar_tabla(tabla);
                return -1;
              }
              if($1.tipo != $3.tipo) {
                printf("****Error semantico en lin %ld: Asignacion incompatible.\n", yylin);
                eliminar_tabla(tabla);
                return -1;
              }
              char e[MAX_TAMANIO_INT];
              sprintf(e, "%d", $1.valor_entero);
              escribir_operando(yyout, e, 0);
              escribir_elemento_vector(yyout, elemento->nombre, elemento->tamano, $3.es_direccion); 
              asignarDestinoEnPila(yyout, $3.es_direccion);

              fprintf(yyout,";R44:\t<asignacion> ::= <elemento_vector> = <exp>\n");
            }
          ;


elemento_vector: TOK_IDENTIFICADOR TOK_CORCHETEIZQUIERDO exp TOK_CORCHETEDERECHO
                 { 
                   Elemento *elemento;
                   elemento = busqueda_elemento(tabla, $1.nombre);
                   if (elemento == NULL) {
                     printf("****Error semantico en lin %ld: Acceso a variable no declarada (%s).\n",yylin, $1.nombre);
                     eliminar_tabla(tabla);
                     return -1;
                   }
                   if(elemento->clase != VECTOR) {
                     printf("****Error semantico en lin %ld: Intento de indexacion de una variable que no es de tipo vector.\n",yylin);
                     eliminar_tabla(tabla);
                     return -1;
                   }
                   if($3.tipo != INT){
                     printf("****Error semantico en lin %ld: El indice en una operacion de indexacion tiene que ser de tipo entero.\n",yylin);
                     eliminar_tabla(tabla);
                     return -1;
                   }
                   $$.tipo = elemento->tipo;
                   $$.es_direccion = 1;
                   $$.valor_entero = $3.valor_entero;
                   escribir_elemento_vector(yyout, elemento->nombre, elemento->tamano, $3.es_direccion);

                   fprintf(yyout,";R48:\t<elemento_vector> ::= <identificador> [ <exp> ]\n");
                 }
               ;

condicional: if_exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA
             { 
               ifthen_fin(yyout, $1.etiqueta);

               fprintf(yyout,";R50:\t<condicional> ::= if ( <exp> ) { <sentencias> }\n");
             }
           | if_else_exp TOK_ELSE TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA
             { 
               ifthenelse_fin(yyout, $1.etiqueta);

               fprintf(yyout,";R51:\t<condicional> ::= if ( <exp> ) { <sentencias> } else { <sentencias> }\n");
             }
           ;

if_exp: TOK_IF TOK_PARENTESISIZQUIERDO exp
        {
          if($3.tipo != BOOLEAN) {
            printf("****Error semantico en lin %ld: Condicional con condicion de tipo int.\n",yylin);
            eliminar_tabla(tabla);
            return -1;
          }
          $$.etiqueta = etiqueta++;
          ifthen_inicio(yyout, $3.es_direccion, $$.etiqueta);
        };

if_else_exp: if_exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA
            {
              $$.etiqueta = $1.etiqueta;
              ifthenelse_fin_then(yyout, $$.etiqueta);
            };

bucle: while_exp TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA
       { 
         while_fin(yyout, $1.etiqueta);

         fprintf(yyout,";R52:\t<bucle> ::= while ( <exp> ) { <sentencias> }\n");
       } 
     ;

while_exp: while TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO
           {
             if($3.tipo != BOOLEAN) {
               printf("****Error semantico en lin %ld: Bucle con condicion de tipo int.\n",yylin);
               eliminar_tabla(tabla);
               return -1;
             }
             $$.etiqueta = $1.etiqueta;
             while_exp_pila(yyout, $3.es_direccion, $$.etiqueta);  
           };

while: TOK_WHILE
      {
        $$.etiqueta = etiqueta++;
        while_inicio(yyout, $$.etiqueta);
      };

lectura: TOK_SCANF TOK_IDENTIFICADOR
         {
           Elemento *elemento;
           elemento = busqueda_elemento(tabla, $2.nombre);

           if(elemento == NULL) {
             printf("****Error semantico en lin %ld: Acceso a variable no declarada (%s).\n", yylin, $2.nombre);
             eliminar_tabla(tabla);
             return -1;
           }
          
           if (elemento->clase == VECTOR || elemento->categoria == FUNCION) {
             printf("****Error semantico en lin %ld: Variable local de tipo no escalar.\n", yylin);
             eliminar_tabla(tabla);
             return -1;
           }
           leer(yyout, $2.nombre, elemento->tipo);
           fprintf(yyout,";R54:\t<lectura> ::= scanf <identificador>\n");
          }
       ;

escritura: TOK_PRINTF exp
           {
             operandoEnPilaAArgumento(yyout, $2.es_direccion);
             escribir(yyout, 0, $2.tipo);

             fprintf(yyout,";R56:\t<escritura> ::= printf <exp>\n");
           }
         ;

retorno_funcion: TOK_RETURN exp
                 {
                   if(en_llamada_a_funcion == 1) {
                     printf("****Error semantico en lin %ld: Sentencia de retorno fuera del cuerpo de una función.\n", yylin);
                     eliminar_tabla(tabla);
                     return -1;
                   }
                   retornarFuncion(yyout, $2.es_direccion);
                   retorno_funcion++;
                   fprintf(yyout,";R61:\t<retorno_funcion> ::= return <exp>\n");

                 }
               ;

exp: exp TOK_MAS exp
     { 
       if($1.tipo == BOOLEANO || $3.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       sumar(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = ENTERO;
       $$.es_direccion = 0;

       fprintf(yyout,";R72:\t<exp> ::= <exp> + <exp> \n");
     }
   | exp TOK_MENOS exp
     { 
       if($1.tipo == BOOLEANO || $3.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       restar(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = ENTERO;
       $$.es_direccion = 0;    

       fprintf(yyout,";R73:\t<exp> ::= <exp> - <exp> \n");

     }
   | exp TOK_DIVISION exp
     { 
       if($1.tipo == BOOLEANO || $3.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
      dividir(yyout, $1.es_direccion, $3.es_direccion);
      $$.tipo = ENTERO;
      $$.es_direccion = 0;

      fprintf(yyout,";R74:\t<exp> ::= <exp> / <exp> \n");
     }
   | exp TOK_ASTERISCO exp
     { 
       
       if($1.tipo == BOOLEANO || $3.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       multiplicar(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = ENTERO;
       $$.es_direccion = 0;
       fprintf(yyout,";R75:\t<exp> ::= <exp> * <exp> \n");

     }
   | TOK_MENOS exp
     { 
       if($2.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       cambiar_signo(yyout, $2.es_direccion);
       $$.tipo = ENTERO;
       $$.es_direccion = 0;

       fprintf(yyout,";R76:\t<exp> ::= - <exp> \n");
     }
   | exp TOK_AND exp
     { 
       if($1.tipo == INT || $3.tipo == INT) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos int.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       y(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = BOOLEAN;
       $$.es_direccion = 0;

       fprintf(yyout,";R77:\t<exp> ::= <exp> && <exp> \n");
     }
   | exp TOK_OR exp
     { 
       if($1.tipo == INT || $3.tipo == INT) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos int.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       o(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = BOOLEAN;
       $$.es_direccion = 0;

       fprintf(yyout,";R78:\t<exp> ::= <exp> || <exp> \n");
     }
   | TOK_NOT exp
     { 
       if($2.tipo == ENTERO) {
         printf("****Error semantico en lin %ld: Operacion logica con operandos int.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       }
       no(yyout, $2.es_direccion, etiqueta);
       etiqueta++;
       $$.tipo = BOOLEAN;
       $$.es_direccion = 0;

       fprintf(yyout,";R79:\t<exp> ::= ! <exp> \n");
     }
   | TOK_IDENTIFICADOR
     { 
       Elemento* elemento;
       elemento = busqueda_elemento(tabla, $1.nombre);
       if (elemento == NULL) {
         printf("****Error semantico en lin %ld: Acceso a la variable no declarada (%s)\n", yylin, $1.nombre);
         eliminar_tabla(tabla);
         return -1;
       }
       if(elemento->categoria == FUNCION || elemento->clase == VECTOR) {
         printf("****Error semantico en lin %ld: Asignacion incompatible.", yylin);
         eliminar_tabla(tabla);
         return -1;
       }
       $$.tipo = elemento->tipo;
       $$.es_direccion = 1;
       if (elemento->categoria == PARAMETRO) {
         escribirParametro(yyout, elemento->pos_par, num_parametros_actual);
       }
       else if (elemento->categoria == VARIABLE) {
         if (tabla->ambito == AMBITO_LOCAL) {
           escribirVariableLocal(yyout, elemento->pos_var_loc);
         }
         else {
           escribir_operando(yyout, $1.nombre, 1);
           if(en_llamada_a_funcion == 1) {
             operandoEnPilaAArgumento(yyout,1);
           }
         }
       }

       fprintf(yyout,";R80:\t<exp> ::= <identificador>\n");
     }
   | constante
     { 
       fprintf(yyout,";R81:\t<exp> ::= <constante>\n");
       $$.tipo = $1.tipo;
       $$.es_direccion = $1.es_direccion;
     }
   | TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO
     { 
       fprintf(yyout,";R82:\t<exp> ::= ( <exp> )\n");
       $$.tipo = $2.tipo;
       $$.es_direccion = $2.es_direccion;
     }
   | TOK_PARENTESISIZQUIERDO comparacion TOK_PARENTESISDERECHO
     { 
       fprintf(yyout,";R83:\t<exp> ::= ( <comparacion> )\n");
       $$.tipo = $2.tipo;
       $$.es_direccion = $2.es_direccion;
     }
   | elemento_vector
     { 
       fprintf(yyout,";R85:\t<exp> ::= <elemento_vector>\n");
       $$.tipo = $1.tipo;
       $$.es_direccion = $1.es_direccion;
     }
   | idf_llamada_funcion TOK_PARENTESISIZQUIERDO lista_expresiones TOK_PARENTESISDERECHO
     {
       Elemento* elemento;
       elemento = busqueda_elemento(tabla, $1.nombre);
       if (elemento == NULL) {
         printf("****Error semantico en lin %ld: Acceso a variable no declarada (%s).\n", yylin, $1.nombre);
         eliminar_tabla(tabla);
         return -1;
       }
       if (num_argumentos_funcion != elemento->num_par) {
         printf("****Error semantico en lin %ld: Numero incorrecto de parametros en llamada a funcion.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       }
       $$.tipo = elemento->tipo;
       llamarFuncion(yyout, $1.nombre, elemento->num_par);
       en_llamada_a_funcion = 0;

       fprintf(yyout,";R88:\t<exp> ::= <identificador> ( <lista_expresiones> ) \n");
     }
   ;

idf_llamada_funcion: TOK_IDENTIFICADOR
                     {
                       Elemento* elemento;
                       if (en_llamada_a_funcion == 1) {
                         printf("****Error semantico en lin %ld: No esta permitido el uso de llamadas a funciones como parametros de otras funciones.\n", yylin);
                         eliminar_tabla(tabla);
                         return -1;
                       }
                       elemento = busqueda_elemento(tabla, $1.nombre);
                       if (elemento == NULL) {
                         printf("****Error semantico en lin %ld: Acceso a variable no declarada (%s).\n", yylin, $1.nombre);
                         eliminar_tabla(tabla);
                         return -1;
                       }
                       num_argumentos_funcion = 0;
                       en_llamada_a_funcion = 1;
                       strcpy($$.nombre, $1.nombre);
                     }
                   ;

lista_expresiones: exp resto_lista_expresiones
                   { 
                     fprintf(yyout,";R89:\t<lista_expresiones> ::= <exp>  <resto_lista_expresiones> \n");
                      if(en_llamada_a_funcion == 1) {
                        num_argumentos_funcion++;
                      }
                   }
                 |
                   { fprintf(yyout,";R90:\t<lista_expresiones> ::= \n"); }
                 ;

resto_lista_expresiones: TOK_COMA exp resto_lista_expresiones 
                         {
                           fprintf(yyout,";R91:\t<resto_lista_expresiones> ::= , <exp>  <resto_lista_expresiones> \n");
                           if(en_llamada_a_funcion == 1) {
                              num_argumentos_funcion++;
                           }
                         }
                       |
                         { fprintf(yyout,";R92:\t<resto_lista_expresiones> ::= \n"); } 
                       ;

comparacion: exp TOK_IGUAL exp
             {
               if($1.tipo == BOOLEAN || $3.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n",yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;

               fprintf(yyout,";R93:\t<comparacion> ::= <exp> == <exp> \n");
             }
           | exp TOK_DISTINTO exp
             {
               if($1.tipo == BOOLEAN || $3.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n",yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               distinto(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;
  
               fprintf(yyout,";R94:\t<comparacion> ::= <exp> != <exp>\n");
             }
           | exp TOK_MENORIGUAL exp
             {
               if ($1.tipo == BOOLEAN || $3.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n", yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               menor_igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;

               fprintf(yyout,";R95:\t<comparacion> ::= <exp> <= <exp>\n");
             }
           | exp TOK_MAYORIGUAL exp
             {
               if ($1.tipo == BOOLEAN || $3.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n", yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               mayor_igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;

               fprintf(yyout,";R96:\t<comparacion> ::= <exp> >= <exp>\n");
             }
           | exp TOK_MENOR exp
             {
               if ($1.tipo == BOOLEAN || $3.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n", yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               menor(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;

               fprintf(yyout,";R97:\t<comparacion> ::= <exp> < <exp>\n");
             }
           | exp TOK_MAYOR exp
             {
               if ($1.tipo == BOOLEAN || $3.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n", yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               mayor(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;

               fprintf(yyout,";R98:\t<comparacion> ::= <exp> > <exp>\n");
             }
           ;

constante: constante_logica
           {
             $$.tipo = $1.tipo;
             $$.es_direccion = $1.es_direccion;
             fprintf(yyout,";R99:\t<constante> ::= <constante_logica>\n");
           }
         | constante_entera
           {
             $$.tipo = $1.tipo;
             $$.es_direccion = $1.es_direccion;
             fprintf(yyout,";R100:\t<constante> ::= <constante_entera>\n");
           }
         ;

constante_logica: TOK_TRUE
                  {
                    $$.tipo = BOOLEAN;
                    $$.es_direccion = 0;
                    char c[2];
                    sprintf(c,"1");
                    escribir_operando(yyout, c, 0);
                    fprintf(yyout,";R102:\t<constante_logica> ::= true\n");
                  }
                | TOK_FALSE
                  {
                    $$.tipo = BOOLEAN;
                    $$.es_direccion = 0;
                    char c[2];
                    sprintf(c,"0");
                    escribir_operando(yyout, c, 0);
                    fprintf(yyout,";R103:\t<constante_logica> ::= false\n");
                  }
                ;

constante_entera: TOK_CONSTANTE_ENTERA
                  {
                    $$.tipo = INT;
                    $$.es_direccion = 0;
                    $$.valor_entero = $1.valor_entero;
                    char c[MAX_TAMANIO_INT];
                    sprintf(c, "%d", $$.valor_entero);
                    escribir_operando(yyout, c, 0);
                    fprintf(yyout,";R104:\t<constante_entera> ::= TOK_CONSTANTE_ENTERA\n");
                  }
                ;

identificador: TOK_IDENTIFICADOR
               {
                 if (tabla->ambito == AMBITO_LOCAL) {
                   pos_variable_local_actual++;
                   num_variables_locales_actual++;
                   if(insercion_elemento(tabla, $1.nombre, VARIABLE, clase_actual,
                                         tipo_actual, tamanio_vector_actual, 0, num_variables_locales_actual,
                                         num_parametros_actual, pos_variable_local_actual) == -1) {
                     printf("****Error semantico en lin %ld: Declaracion duplicada.\n", yylin);
                     eliminar_tabla(tabla);
                     return -1;
                   }
                 }
                 if (tabla->ambito == AMBITO_GLOBAL) {
                   if(insercion_elemento(tabla, $1.nombre, VARIABLE, clase_actual,
                                         tipo_actual, tamanio_vector_actual, 0, num_variables_locales_actual,
                                         num_parametros_actual, pos_variable_local_actual) == -1) {
                     printf("****Error semantico en lin %ld: Declaracion duplicada.\n", yylin);
                     eliminar_tabla(tabla);
                     return -1;
                   }
                   declarar_variable(yyout, $1.nombre, tipo_actual, tamanio_vector_actual);
                 }
                 fprintf(yyout,";R108:\t<identificador> ::= TOK_IDENTIFICADOR\n");
               }
             ;

%%

void yyerror(const char * s) {
    if(!yy_morph_error) {
        printf("****Error sintactico en [lin %ld, col %ld]\n", yylin, yycol);
    }

}