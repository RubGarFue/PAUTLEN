#include <stdio.h>
#include "generacion.h"

void escribir_cabecera_bss(FILE* fpasm) {
    fprintf(fpasm, "segment .bss\n");
    fprintf(fpasm, "    __esp resd 1\n");
}

void escribir_subseccion_data(FILE* fpasm) {
    fprintf(fpasm, "segment .data\n");
    frpintf(fpasm, "    mensaje_1 db \"Indice fuera de rango\", 0\n");
    frpintf(fpasm, "    mensaje_2 db \"División por cero\", 0\n");

}

void declarar_variable(FILE* fpasm, char * nombre, int tipo, int tamano) {
    if (tipo == BOOLEANO) {
        fprintf(fpasm, "    _%s resb %d\n", nombre, tamano);
    }
    else {
        fprintf(fpasm, "    _%s resd %d\n", nombre, tamano);
    }
}

void escribir_segmento_codigo(FILE* fpasm) {
    fprintf(fpasm, "segment .text\n");
    fprintf(fpasm, "    global main\n");
    fprintf(fpasm, "    extern scan_int, scan_boolean\n");
    fprintf(fpasm, "    extern print_int, print_boolean, print_string, print_blank, print_endofline\n");

}

void escribir_inicio_main(FILE* fpasm) {
    fprintf(fpasm, "main:\n");
    fprintf(fpasm, "    mov [__esp], esp\n");
}

void escribir_fin(FILE* fpasm) {
    fprintf(fpasm, "error_1:\n");
    fprintf(fpasm, "    push dword mensaje_1\n");
    fprintf(fpasm, "    call print_string\n");
    fprintf(fpasm, "    add esp, 4\n");
    fprintf(fpasm, "    jmp near fin\n");
    
    fprintf(fpasm, "error_2:\n");
    fprintf(fpasm, "    push dword mensaje_2\n");
    fprintf(fpasm, "    call print_string\n");
    fprintf(fpasm, "    add esp,4\n");
    fprintf(fpasm, "    jmp near fin\n");
}

void escribir_operando(FILE* fpasm, char* nombre, int es_variable) {
    if (es_variable == 1) {
        fprintf(fpasm, "    push _%s\n", nombre);
    }
    else {
        fprintf(fpasm, "    push %s\n", nombre);
    }
}

void asignar(FILE* fpasm, char* nombre, int es_variable) {
    /* cargar en eax la parte derecha de la asignación */
    fprintf(fpasm, "    pop dword eax\n");
    
    if(es_variable == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]%s\n", nombre);

    }

    /* hacer la asignación efectiva */
    fprintf(fpasm, "    mov _%s, [eax]", nombre);
}

void sumar(FILE* fpasm, int es_variable_1, int es_variable_2) {
    /* cargar el segundo operando en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable_2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable_1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* realizar la suma y dejar el resultado en eax */
    fprintf(fpasm, "    add eax, edx\n");

    /* apilar el resultado */
    fprintf(fpasm, "    push dword eax\n");
}

void restar(FILE* fpasm, int es_variable_1, int es_variable_2) {
    /* cargar el segundo operando en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable_2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable_1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* realizar la suma y dejar el resultado en eax */
    fprintf(fpasm, "    sub eax, edx\n");

    /* apilar el resultado */
    fprintf(fpasm, "    push dword eax\n");
}

void multiplicar(FILE* fpasm, int es_variable_1, int es_variable_2) {
    /* cargar el segundo operando en ecx */
    fprintf(fpasm, "    pop dword ecx\n");
    if (es_variable_2 == 1) {
        fprintf(fpasm, "    mov dword ecx, [ecx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable_1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* realizar la multiplicación y dejar el resultado en eax */
    fprintf(fpasm, "    imul ecx\n");

    /* apilar el resultado */
    fprintf(fpasm, "    push dword eax\n");
}

void dividir(FILE* fpasm, int es_variable_1, int es_variable_2) {
    /* cargar el segundo operando en ecx */
    fprintf(fpasm, "    pop dword ecx\n");
    if (es_variable_2 == 1) {
        fprintf(fpasm, "    mov dword ecx, [ecx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable_1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* realizar la división y dejar el resultado en eax */
    fprintf(fpasm, "    cdq 0\n");
    fprintf(fpasm, "    idiv ecx\n");

    /* apilar el resultado */
    fprintf(fpasm, "    push dword eax\n");
}

void o(FILE* fpasm, int es_variable_1, int es_variable_2) {
    /* cargar el segundo operando en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable_2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "pop dword eax\n");
    if (es_variable_1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* operacion dejando el resultado en eax */
    fprintf(fpasm, "    or eax, edx\n");

    /* introducir en la pula el resultado */
    fprintf(fpasm, "    push dword eax\n");

}
void y(FILE* fpasm, int es_variable_1, int es_variable_2) {
    /* cargar el segundo operando en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable_2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "pop dword eax\n");
    if (es_variable_1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* operacion dejando el resultado en eax */
    fprintf(fpasm, "    and eax, edx\n");

    /* introducir en la pila el resultado */
    fprintf(fpasm, "    push dword eax\n");
}

void cambiar_signo(FILE* fpasm, int es_variable) {
    /* cargar el operando en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* realizar la negación. El resultado en eax */
    fprintf(fpasm, "    neg eax\n");

    /* apilar el resultado */
    fprintf(fpasm, "    push dword eax\n");
}

void no(FILE* fpasm, int es_variable, int cuantos_no) {
    fprintf(fpasm, "    pop dword ecx\n");

    /* cargar el operando en eax */
    fprintf(fpasm, "   pop dword eax\n");
    if (es_variable == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* ver si eax es 0 y en ese caso saltar a negar_falso */
    fprintf(fpasm, "    or eax, eax\n");
    frpintf(fpasm, "    jz near negar_falso#\n");

    /* cargar 0 en eax (negación de verdadero) y saltar al final */
    fprintf(fpasm, "    mov dword eax, 0\n");
    fprintf(fpasm, "    jmp near fin_negacion#\n");

    /* cargar 1 en eax (negación de falso) */
    fprintf(fpasm, "negar_falso#:\n");
    fprintf(fpasm, "    mov dword eax, 1\n");

    /* apilar eax */
    fprintf(fpasm, "fin_negacion#:\n");
    fprintf(fpasm, "    push dword eax\n");
}

void igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    pop dword ecx\n");
    
    /* cargar el segundo operando en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }
    
    /* comparar y apilar el resultado */
    fprintf(fpasm, "    cmp eax, edx\n");
    fprintf(fpasm, "    je near igual#\n");
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_igual#\n");

    fprintf(fpasm, "igual#:\n");
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_igual#: \n");
}

void distinto(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    pop dword ecx\n");
    
    /* cargar el segundo operando en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }
    
    /* comparar y apilar el resultado */
    fprintf(fpasm, "    cmp eax, edx\n");
    fprintf(fpasm, "    jne near distinto#\n");
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_distinto#\n");

    fprintf(fpasm, "distinto#:\n");
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_distinto#: \n");
}
void menor_igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    pop dword ecx\n");
    
    /* cargar el segundo operando en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "pop dword eax\n");
    if (es_variable1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }
    
    /* comparar y apilar el resultado */
    fprintf(fpasm, "    cmp eax, edx\n");
    fprintf(fpasm, "    jle near menorigual#\n");
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_menorigual#\n");

    fprintf(fpasm, "menorigual#:\n");
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_menorigual#: \n");
}
void mayor_igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    pop dword ecx\n");
    
    /* cargar el segundo operando en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar el primer operando en eax */
    fprintf(fpasm, "pop dword eax\n");
    if (es_variable1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }
    
    /* comparar y apilar el resultado */
    fprintf(fpasm, "    cmp eax, edx\n");
    fprintf(fpasm, "    jge near mayorigual#\n");
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_mayorigual#\n");

    fprintf(fpasm, "mayorigual#:\n");
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_mayorigual#: \n");
}

void menor(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    /* cargar la segunda expresión en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar la primera expresión en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* comparar y apilar el resultado */
    fprintf(fpasm, "    cmp eax, edx\n");
    fprintf(fpasm, "    jl near menor#\n");
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_menor#\n");
    fprintf(fpasm, "menor#:\n");
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_menor#:\n");
}

void mayor(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    /* cargar la segunda expresión en edx */
    fprintf(fpasm, "    pop dword edx\n");
    if (es_variable2 == 1) {
        fprintf(fpasm, "    mov dword edx, [edx]\n");
    }

    /* cargar la primera expresión en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable1 == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* comparar y apilar el resultado */
    fprintf(fpasm, "    cmp eax, edx\n");
    fprintf(fpasm, "    jg near mayor#\n");
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_mayor#\n");
    fprintf(fpasm, "mayor#:\n");
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_mayor#:\n");
}

void leer(FILE* fpasm, char* nombre, int tipo) {
    
    fprintf(fpasm, "    push _%s\n", nombre);
    
    /* llamar a la funcion scan correspondiente*/
    if(tipo == BOOLEANO) {
        fprintf(fpasm, "    call scan_boolean\n");
    }
    else {
        fprintf(fpasm, "    call scan_int\n");
    }

    /* actualizar puntero de pila */
    fprintf(fpasm, "    add esp, 4\n");
}

void escribir(FILE* fpasm, int es_variable, int tipo) {
    /* cargar la expresión en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* apilar */
    fprintf(fpasm, "   push dword eax\n");

    /* llamar a la funcion print correspondiente */
    if (tipo == BOOLEANO) {
        fprintf(fpasm, "    call print_boolean\n");
    }
    else {
        fprintf(fpasm, "    call print_int\n");
    }
    fprintf(fpasm, "    call print_endofline\n");
    
    /* actualizar puntero de pila */
    fprintf(fpasm, "   add esp, 4\n");
}

void escribir_fin(FILE* fpasm) {
    fprintf(fpasm, "    jmp near fin\n");                           /*fin correcto, salto al fin de programa*/
    fprintf(fpasm, "fin_error_division:\n");                        /*proceso de error division*/
    fprintf(fpasm, "    push dword msg_error_division\n");          /*escritura del mensaje*/
    fprintf(fpasm, "    call print_string\n");
    fprintf(fpasm, "    add esp, 4\n");
    fprintf(fpasm, "    call print_endofline\n");
    fprintf(fpasm, "    jmp near fin\n");                           /*salto al fin de programa*/
    fprintf(fpasm, "fin_indice_fuera_rango:\n");                    /*proceso de error por indice fuera de rango*/
    fprintf(fpasm, "    push dword msg_error_indice_vector\n");     /*escritura del mensaje*/
    fprintf(fpasm, "    call print_string\n");
    fprintf(fpasm, "    add esp, 4\n");
    fprintf(fpasm, "    call print_endofline\n");
    fprintf(fpasm, "    jmp near fin\n");                           /*salto al fin de programa*/
    fprintf(fpasm, "fin:\n");                                       /*fin de programa*/
    fprintf(fpasm, "    mov esp, [_esp]\n");                        /*restauracion de puntero de pila*/
    fprintf(fpasm, "    ret\n");                                    /*salida del main*/
}

void ifthenelse_inicio(FILE * fpasm, int exp_es_variable, int etiqueta) {
    /* se saca de la pila el valor de la expresión */
    fprintf(fpasm, "    pop eax\n");
    if (exp_es_variable == 1) {
        fprintf(fpasm, "    mov eax, [eax]\n");
    }

    fprintf();
}
void if_then_inicio(FILE * fpasm, int exp_es_variable, int etiqueta);
void ifthenelse_fin_then( FILE * fpasm, int etiqueta);



void ifthen_fin(FILE * fpasm, int etiqueta);
    

void ifthenelse_fin( FILE * fpasm, int etiqueta);

void while_inicio(FILE * fpasm, int etiqueta) {
    fprintf(fpasm, "    inicio_while_%d:\n", etiqueta);
}
void while_exp_pila (FILE * fpasm, int exp_es_variable, int etiqueta);
void while_fin( FILE * fpasm, int etiqueta);

void escribir_elemento_vector(FILE * fpasm,char * nombre_vector, int tam_max, int exp_es_direccion);

void declararFuncion(FILE * fd_asm, char * nombre_funcion, int num_var_loc);
void retornarFuncion(FILE * fd_asm, int es_variable);
void escribirParametro(FILE* fpasm, int pos_parametro, int num_total_parametros);
void escribirVariableLocal(FILE *fpasm, int posicion_variable_local);

void operandoEnPilaAArgumento(FILE *fd_asm, int es_variable);
void llamarFuncion(FILE * fd_asm, char* nombre_funcion, int num_argumentos);