%{
#include <stdio.h>
#include "generacion.h"

#include "tabla_simbolos.h"
int yylex();
void yyerror();
extern FILE * yyout;
extern long yylin;
extern long yycol;
extern int yy_morph_error;

int tipo_actual;
int clase_actual;
int tipo_funcion;
int tamanio_vector_actual;
int pos_variable_local_actual;
int etiqueta;
int num_argumentos_funcion;
int retorno_funcion;
int en_llamada_a_funcion; /*1 si se esta dentro de los parentesis de una funcion. 0 si se esta fuera*/
TablaSimbolos *tabla;
%}

%union {
  info_atributos atributos;
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

%left TOK_IGUAL TOK_MENORIGUAL TOK_MENOR TOK_MAYORIGUAL TOK_MAYOR TOK_DISTINTO
%left TOK_AND TOK_OR
%left TOK_MAS TOK_MENOS
%left TOK_ASTERISCO TOK_DIVISION
%right TOK_NOT
%%


programa: inicioTabla TOK_MAIN TOK_LLAVEIZQUIERDA declaraciones funciones sentencias TOK_LLAVEDERECHA
          { 
            fprintf(yyout,";R1:\t<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n");
            escribir_fin(yyout);
            eliminar_tabla(tabla);
          }
        ;

inicioTabla:
             { tabla = crear_tabla();
               if (tabla == NULL) {
                 return -1;
               }
               escribir_subseccion_data(yyout);
               escribir_cabecera_bss(yyout);
               escribir_segmento_codigo(yyout);
               escribir_inicio_main(yyout);
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

                if(tamanio_vector_actual <= 0 || tamanio_vector_actual > MAX_TAMANIO_VECTOR) {
                  print("****Error semantico en lin %ld: El tamanyo del vector <nombre_vector> excede los limites permitidos (1,64).",yylin);
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
           { fprintf(yyout,";R21:\t<funciones> ::= \n"); }
          
         ;

funcion: TOK_FUNCTION tipo identificador TOK_PARENTESISIZQUIERDO parametros_funcion TOK_PARENTESISDERECHO
         TOK_LLAVEIZQUIERDA declaraciones_funcion sentencias TOK_LLAVEDERECHA
         { fprintf(yyout,";R22:\t<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }\n");
           
           if (busqueda_elemento(tabla, $3.nombre) == NULL) {
             strcpy($$.nombre, $3.nombre);
             
             apertura_ambito(tabla, $1.nombre, VARIABLE, tipo_actual,
                                    clase_actual, tamanio_vector_actual, num_total_parametros,
                                    pos_variable_local_actual, 0, num_total_varlocs);
            
             tamanio_vector_actual = 1;
             num_total_varlocs = 0;
             pos_variable_local_actual = 0;
             num_argumentos_funcion = 0;
             retorno_funcion = 0;
             tipo_funcion = tipo;
           }

           else {
             printf("****Error semantico en lin %ld: Declaracion duplicada\n", nlines);
             eliminar_tabla(tabla);
             return -1;
           }

           Elemento *elemento;
           elemento = busqueda_elemento(tabla, $1.nombre);

           if (elemento == NULL) {
             eliminar_tabla(tabla);
             return -1;
           }

           elemento->num_total_parametros = num_total_parametros;
           elemento->num_total_varlocs = num_total_varlocs;
           elemento->tipo = tipo_funcion;
           strcpy($$.nombre, $1.nombre);

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
           
           elemento->num_total_parametros = num_total_parametros;
           elemento->tipo = tipo_funcion;
           num_total_parametros = 0;
           num_total_varlocs = 0;
           pos_variable_local_actual = 0;
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

parametro_funcion: tipo identificador
                   { fprintf(yyout,";R27:\t<parametro_funcion> ::= <tipo> <identificador>\n"); }
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

asignacion: identificador TOK_ASIGNACION exp
            { fprintf(yyout,";R43:\t<asignacion> ::= <identificador> = <exp>\n"); }
          | elemento_vector TOK_ASIGNACION exp
            { fprintf(yyout,";R44:\t<asignacion> ::= <elemento_vector> = <exp>\n"); }
          ;

elemento_vector: identificador TOK_CORCHETEIZQUIERDO exp TOK_CORCHETEDERECHO
                 { fprintf(yyout,";R48:\t<elemento_vector> ::= <identificador> [ <exp> ]\n");
                   Elemento *elemento;
                   elemento = busqueda_elemento(tabla, $1.nombre);
                   if (elemento == NULL) {
                     printf("****Error semantico en lin %ld: Acceso a variable no declarada (%s).\n",yylin, $1.nombre);
                     eliminar_tabla(tabla);
                     return -1;
                   }
                   if(elemento->categoria != VECTOR) {
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
                   escribir_elemento_vector(yyou, elemento->nombre, elemento->tamano, $3.es_direccion);
                   }
               ;

condicional: if_exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA
             { fprintf(yyout,";R50:\t<condicional> ::= if ( <exp> ) { <sentencias> }\n");
               ifthen_fin(yyout, $1.etiqueta); }
           | if_else_exp TOK_ELSE TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA
             { fprintf(yyout,";R51:\t<condicional> ::= if ( <exp> ) { <sentencias> } else { <sentencias> }\n");
               ifthenelse_fin(yyout, $1.etiqueta); }
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
       { fprintf(yyout,";R52:\t<bucle> ::= while ( <exp> ) { <sentencias> }\n");
       while_fin(yyout, $1.etiqueta);
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

lectura: TOK_SCANF identificador
         {
           fprintf(yyout,";R54:\t<lectura> ::= scanf <identificador>\n");
           Elemento *elemento;
           elemento = busqueda_elemento(tabla, $2.nombre);

           if(elemento == NULL){
             printf("****Error semantico en lin %ld: Acceso a variable no declarada (%s).\n", yylin, $2.nombre);
             eliminar_tabla(tabla);
             return -1;
           }
          
           if (elemento->categoria == VECTOR || elemento->categoria == FUNCION) {
             printf("****Error semantico en lin %ld: Variable local de tipo no escalar.\n", yylin);
             eliminar_tabla(tabla);
             return -1;
           }
           leer(yyout, $2.nombre, elemento->tipo);
          }
       ;

escritura: TOK_PRINTF exp
           {
            fprintf(yyout,";R56:\t<escritura> ::= printf <exp>\n");
            operandoEnPilaAArgumento(yyout, $2.es_direccion);
            escribir(yyout, 0, $2.tipo);
            }
         ;

retorno_funcion: TOK_RETURN exp
                 {
                   if(en_llamada_a_funcion==1) {
                     print("****Error semantico en lin %ld: Sentencia de retorno fuera del cuerpo de una función.\n", yylin);
                     eliminar_tabla(tabla);
                     return -1;
                   }
                    fprintf(yyout,";R61:\t<retorno_funcion> ::= return <exp>\n");
                    retornarFuncion(yyout, $2.es_direccion);
                    retorno_funcion++;
                 }
               ;

exp: exp TOK_MAS exp
     { 
       fprintf(yyout,";R72:\t<exp> ::= <exp> + <exp> \n");
       if($1.tipo == BOOLEANO || $3.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       sumar(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = ENTERO;
       $$.es_direccion = 0;
     }
   | exp TOK_MENOS exp
     { 
       fprintf(yyout,";R73:\t<exp> ::= <exp> - <exp> \n");
       if($1.tipo == BOOLEANO || $3.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       restar(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = ENTERO;
       $$.es_direccion = 0;     
     }
   | exp TOK_DIVISION exp
     { 
       fprintf(yyout,";R74:\t<exp> ::= <exp> / <exp> \n");
       if($1.tipo == BOOLEANO || $3.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
      dividir(yyout, $1.es_direccion, $3.es_direccion);
      $$.tipo = ENTERO;
      $$.es_direccion = 0;
     }
   | exp TOK_ASTERISCO exp
     { 
       fprintf(yyout,";R75:\t<exp> ::= <exp> * <exp> \n");
       if($1.tipo == BOOLEANO || $3.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       multiplicar(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = ENTERO;
       $$.es_direccion = 0;
     }
   | TOK_MENOS exp
     { 
       fprintf(yyout,";R76:\t<exp> ::= - <exp> \n");
       if($2.tipo == BOOLEANO) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos boolean.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       cambiar_signo(yyout, $2.es_direccion);
       $$.tipo = ENTERO;
       $$.es_direccion = 0;
     }
   | exp TOK_AND exp
     { 
       fprintf(yyout,";R77:\t<exp> ::= <exp> && <exp> \n");
       if($1.tipo == INT || $3.tipo == INT) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos int.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       y(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = BOOLEAN;
       $$.es_direccion = 0;
     }
   | exp TOK_OR exp
     { 
       fprintf(yyout,";R78:\t<exp> ::= <exp> || <exp> \n");
       if($1.tipo == INT || $3.tipo == INT) {
         printf("****Error semantico en lin %ld: Operacion aritmetica con operandos int.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       } 
       o(yyout, $1.es_direccion, $3.es_direccion);
       $$.tipo = BOOLEAN;
       $$.es_direccion = 0;
     }
   | TOK_NOT exp
     { 
       fprintf(yyout,";R79:\t<exp> ::= ! <exp> \n");
       if($2.tipo == ENTERO) {
         printf("****Error semantico en lin %ld: Operacion logica con operandos int.\n", yylin);
         eliminar_tabla(tabla);
         return -1;
       }
       no(yyout, $2.es_direccion, etiqueta);
       etiqueta++;
       $$.tipo = BOOLEAN;
       $$.es_direccion = 0;
     }
   | identificador
     { 
       fprintf(yyout,";R80:\t<exp> ::= <identificador>\n");
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
       if (elemento->clase == PARAMETRO) {
         escribirParametro(yyout, elemento->pos_par, num_total_parametros);
       }
       else if (elemento->clase == VARIABLE) {
         if (tabla->ambito == AMBITO_LOCAL) {
           escribirVariableLocal(yyout, elemento->pos_var_loc);
         }
       }
       else {
         escribir_operando(yyout, $1.nombre, 1);
         if(en_llamada_a_funcion == 1) {
           operandoEnPilaAArgumento(yyout,1);
         }
       }
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
   | identificador TOK_PARENTESISIZQUIERDO lista_expresiones TOK_PARENTESISDERECHO
     { 
       fprintf(yyout,";R88:\t<exp> ::= <identificador> ( <lista_expresiones> ) \n");
     }
   ;












lista_expresiones: exp resto_lista_expresiones
                   { fprintf(yyout,";R89:\t<lista_expresiones> ::= <exp>  <resto_lista_expresiones> \n");
                   if(en_llamada_a_funcion == 1) {
                     num_argumentos_funcion++;
                   } }
                 |
                   { fprintf(yyout,";R90:\t<lista_expresiones> ::= \n"); }
                 ;

resto_lista_expresiones: TOK_COMA exp resto_lista_expresiones 
                         {
                           fprintf(yyout,";R91:\t<resto_lista_expresiones> ::= , <exp>  <resto_lista_expresiones> \n");
                         }
                       |
                         { fprintf(yyout,";R92:\t<resto_lista_expresiones> ::= \n");
                         if(en_llamada_a_funcion == 1) {
                           num_argumentos_funcion++;
                         } } 
                       ;

comparacion: exp TOK_IGUAL exp
             {
               fprintf(yyout,";R93:\t<comparacion> ::= <exp> == <exp> \n");
               if($1.tipo == BOOLEAN || $3.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n",yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;
             }
           | exp TOK_DISTINTO exp
             {
               fprintf(yyout,";R94:\t<comparacion> ::= <exp> != <exp>\n");
               if($1.tipo == BOOLEAN || $3.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n",yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               distinto(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;
             }
           | exp TOK_MENORIGUAL exp
             {
               fprintf(yyout,";R95:\t<comparacion> ::= <exp> <= <exp>\n");
               if ($1.tipo == BOOLEAN || $2.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n", yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               menor_igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;
             }
           | exp TOK_MAYORIGUAL exp
             {
               fprintf(yyout,";R96:\t<comparacion> ::= <exp> >= <exp>\n");
               if ($1.tipo == BOOLEAN || $2.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n", yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               mayor_igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;
             }
           | exp TOK_MENOR exp
             {
               fprintf(yyout,";R97:\t<comparacion> ::= <exp> < <exp>\n");
               if ($1.tipo == BOOLEAN || $2.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n", yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               menor(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;
             }
           | exp TOK_MAYOR exp
             {
               fprintf(yyout,";R98:\t<comparacion> ::= <exp> > <exp>\n");
               if ($1.tipo == BOOLEAN || $2.tipo == BOOLEAN) {
                 printf("****Error semantico en lin %ld: Comparacion con operandos boolean.\n", yylin);
                 eliminar_tabla(tabla);
                 return -1;
               }
               mayor(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
               etiqueta++;
               $$.tipo = BOOLEAN;
               $$.es_direccion = 0;
             }
           ;

constante: constante_logica
           {
             fprintf(yyout,";R99:\t<constante> ::= <constante_logica>\n");
             $$.tipo = $1.tipo;
             $$.es_direccion = $1.es_direccion;
           }
         | constante_entera
           {
             fprintf(yyout,";R100:\t<constante> ::= <constante_entera>\n");
             $$.tipo = $1.tipo;
             $$.es_direccion = $1.es_direccion;
           }
         ;

constante_logica: TOK_TRUE
                  {
                    fprintf(yyout,";R102:\t<constante_logica> ::= true\n");

                    $$.tipo = BOOLEAN;
                    $$.es_direccion = 0;
                    char c[1];
                    sprint(c,"1");
                    escribir_operando(yyout, c, 0);
                  }
                | TOK_FALSE
                  {
                    fprintf(yyout,";R103:\t<constante_logica> ::= false\n");

                    $$.tipo = BOOLEAN;
                    $$.es_direccion = 0;
                    char c[1];
                    sprint(c,"0");
                    escribir_operando(yyout, c, 0);
                  }
                ;

constante_entera: TOK_CONSTANTE_ENTERA
                  {
                    fprintf(yyout,";R104:\t<constante_entera> ::= TOK_CONSTANTE_ENTERA\n");

                    $$.tipo = INT;
                    $$.es_direccion = 0;
                    $$.valor_entero = $1.valor_entero;
                    char c[MAX_TAMANIO_INT];
                    sprintf(c, "%d", $$.valor_entero);
                    escribir_operando(yyout, c, 0);
                  }
                ;

identificador: TOK_IDENTIFICADOR
               { 
                 fprintf(yyout,";R108:\t<identificador> ::= TOK_IDENTIFICADOR\n");
                 // Esto de aquí hay que cambiarlo
                 if(insercion_elemento(tabla, $1.nombre, VARIABLE, tipo_actual,
                                       clase_actual, tamanio_vector_actual, num_total_parametros,
                                       pos_variable_local_actual, 0, num_total_varlocs) == -1) {
                   printf("****Error semantico en lin %ld: Declaracion duplicada.\n", yylin);
                   eliminar_tabla(tabla);
                   return -1;
                 }
                 pos_variable_local_actual++;
               }
             ;

%%

void yyerror(const char * s) {
    if(!yy_morph_error) {
        printf("****Error sintactico en [lin %ld, col %ld]\n", yylin, yycol);
    }

}