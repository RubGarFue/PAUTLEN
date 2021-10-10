#include <stdio.h>
#include "generacion.h"

void escribir_cabecera_bss(FILE* fpasm) {
    fprintf(fpasm, "segment .bss\n");
    fprintf(fpasm, "    __esp resd 1\n");
}

void escribir_subseccion_data(FILE* fpasm) {
    fprintf(fpasm, "segment .data\n");
    fprintf(fpasm, "    msg_error_indice_vector db \"Indice fuera de rango\", 0\n");
    fprintf(fpasm, "    msg_error_division db \"División por cero\", 0\n");

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

void escribir_operando(FILE* fpasm, char* nombre, int es_variable) {
    fprintf(fpasm, "    ; escribir_operando\n");
    if (es_variable == 1) {
        fprintf(fpasm, "    push _%s\n", nombre);
    }
    else {
        fprintf(fpasm, "    push %s\n", nombre);
    }
}

void asignar(FILE* fpasm, char* nombre, int es_variable) {
    fprintf(fpasm, "    ; asignar\n");
    /* cargar en eax la parte derecha de la asignación */
    fprintf(fpasm, "    pop dword eax\n");
    
    if(es_variable == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]%s\n", nombre);

    }

    /* hacer la asignación efectiva */
    fprintf(fpasm, "    mov [_%s], eax\n", nombre);
}

void sumar(FILE* fpasm, int es_variable_1, int es_variable_2) {
    fprintf(fpasm, "    ; sumar\n");
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
    fprintf(fpasm, "    ; restar\n");
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
    fprintf(fpasm, "    ; multiplicar\n");
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
    fprintf(fpasm, "    ; dividir\n");
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
    fprintf(fpasm, "    cdq\n");
    fprintf(fpasm, "    idiv ecx\n");

    /* apilar el resultado */
    fprintf(fpasm, "    push dword eax\n");
}

void o(FILE* fpasm, int es_variable_1, int es_variable_2) {
    fprintf(fpasm, "    ; o\n");
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
    fprintf(fpasm, "    ; y\n");
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
    fprintf(fpasm, "    ; cambiar_signo\n");
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
    fprintf(fpasm, "    ; no\n");

    /* cargar el operando en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* ver si eax es 0 y en ese caso saltar a negar_falso */
    fprintf(fpasm, "    or eax, eax\n");
    fprintf(fpasm, "    jz near negar_falso_%d\n", cuantos_no);

    /* cargar 0 en eax (negación de verdadero) y saltar al final */
    fprintf(fpasm, "    mov dword eax, 0\n");
    fprintf(fpasm, "    jmp near fin_negacion_%d\n", cuantos_no);

    /* cargar 1 en eax (negación de falso) */
    fprintf(fpasm, "negar_falso_%d:\n", cuantos_no);
    fprintf(fpasm, "    mov dword eax, 1\n");

    /* apilar eax */
    fprintf(fpasm, "fin_negacion_%d:\n", cuantos_no);
    fprintf(fpasm, "    push dword eax\n");
}

void igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    ; igual\n");
    
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
    fprintf(fpasm, "    je near igual_%d\n", etiqueta);
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_igual_%d\n", etiqueta);

    fprintf(fpasm, "igual_%d:\n", etiqueta);
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_igual_%d: \n", etiqueta);
}

void distinto(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    ; distinto\n");
    
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
    fprintf(fpasm, "    jne near distinto_%d\n", etiqueta);
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_distinto_%d\n", etiqueta);

    fprintf(fpasm, "distinto_%d:\n", etiqueta);
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_distinto_%d: \n", etiqueta);
}
void menor_igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    ; menor_igual\n");
    
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
    fprintf(fpasm, "    jle near menorigual_%d\n", etiqueta);
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_menorigual_%d\n", etiqueta);

    fprintf(fpasm, "menorigual_%d:\n", etiqueta);
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_menorigual_%d: \n", etiqueta);
}
void mayor_igual(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    ; mayor_igual\n");
    
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
    fprintf(fpasm, "    jge near mayorigual_%d\n", etiqueta);
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_mayorigual_%d\n", etiqueta);

    fprintf(fpasm, "mayorigual_%d:\n", etiqueta);
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_mayorigual_%d: \n", etiqueta);
}

void menor(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    ; menor\n");
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
    fprintf(fpasm, "    jl near menor_%d\n", etiqueta);
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_menor_%d\n", etiqueta);
    fprintf(fpasm, "menor_%d:\n", etiqueta);
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_menor_%d:\n", etiqueta);
}

void mayor(FILE* fpasm, int es_variable1, int es_variable2, int etiqueta) {
    fprintf(fpasm, "    ; mayor\n");
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
    fprintf(fpasm, "    jg near mayor_%d\n", etiqueta);
    fprintf(fpasm, "    push dword 0\n");
    fprintf(fpasm, "    jmp near fin_mayor_%d\n", etiqueta);
    fprintf(fpasm, "mayor_%d:\n", etiqueta);
    fprintf(fpasm, "    push dword 1\n");
    fprintf(fpasm, "fin_mayor_%d:\n", etiqueta);
}

void leer(FILE* fpasm, char* nombre, int tipo) {
    fprintf(fpasm, "    ; leer\n");
    
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
    fprintf(fpasm, "    ; escribir\n");
    /* cargar la expresión en eax */
    fprintf(fpasm, "    pop dword eax\n");
    if (es_variable == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /* apilar */
    fprintf(fpasm, "    push dword eax\n");

    /* llamar a la funcion print correspondiente */
    if (tipo == BOOLEANO) {
        fprintf(fpasm, "    call print_boolean\n");
    }
    else {
        fprintf(fpasm, "    call print_int\n");
    }
    fprintf(fpasm, "    call print_endofline\n");
    
    /* actualizar puntero de pila */
    fprintf(fpasm, "    add esp, 4\n");
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
    fprintf(fpasm, "    mov esp, [__esp]\n");                        /*restauracion de puntero de pila*/
    fprintf(fpasm, "    ret\n");                                    /*salida del main*/
}

void ifthenelse_inicio(FILE * fpasm, int exp_es_variable, int etiqueta) {
    /* se saca de la pila el valor de la expresión */
    fprintf(fpasm, "    pop eax\n");
    if (exp_es_variable == 1) {
        fprintf(fpasm, "    mov eax, [eax]\n");
    }
    fprintf(fpasm, "    cmp eax, 0\n");

    /*si es cero se salta al final de la rama then*/
    fprintf(fpasm, "    je near fin_then_%d\n", etiqueta);
}
void if_then_inicio(FILE * fpasm, int exp_es_variable, int etiqueta) {
    /* se saca de la pila el valor de la expresión */
    fprintf(fpasm, "    pop eax\n");
    if (exp_es_variable == 1) {
        fprintf(fpasm, "    mov eax, [eax]\n");
    }
    fprintf(fpasm, "    cmp eax, 0\n");

    /*si es cero se salta al final de la rama then*/
    fprintf(fpasm, "    je near fin_then_%d\n", etiqueta);
}
void ifthenelse_fin_then( FILE * fpasm, int etiqueta) {
    /*se salta al fin del ifthenelse, es decir, la rama else*/
    fprintf(fpasm, "    jmp near fin_ifelse_%d\n", etiqueta);

    /*se escribe la etiqueta de fin de la rama then*/
    fprintf(fpasm, "    fin_then_%d\n", etiqueta);
}


void ifthen_fin(FILE * fpasm, int etiqueta) {
    /*se imprime la etiqueta de final de bloque then*/
    fprintf(fpasm, "    fin_then_%d\n", etiqueta);
}
    

void ifthenelse_fin( FILE * fpasm, int etiqueta) {
    /*se escribe la etiqueta del final de la estructura ifthenelse*/
    fprintf(fpasm, "    fin_ifelse_%d\n", etiqueta);
}

void while_inicio(FILE * fpasm, int etiqueta) {
    fprintf(fpasm, "    inicio_while_%d:\n", etiqueta);
}
void while_exp_pila (FILE * fpasm, int exp_es_variable, int etiqueta) {
    /*se saca de la cima de la pila el valor de la expresion que gobierna el bucle*/
    fprintf(fpasm, "    pop eax\n");

    if (exp_es_variable > 0) {
        fprintf(fpasm, "    mov eax, [eax]\n");
    }
    fprintf(fpasm, "    cmp eax, 0\n");

    /*si es 0 se salta al final del while, habriamos terminado*/
    fprintf(fpasm, "    je near fin_while_%d\n", etiqueta);
}

void while_fin( FILE * fpasm, int etiqueta) {
    /*se salta de nuevo al principio del bucle para volver a evaluar la condicion de salida*/
    fprintf(fpasm, "    jmp near inicio_while_%d\n", etiqueta);

    /*se escribe la etiqueta de fin de bucle*/
    fprintf(fpasm, "fin_while_%d\n", etiqueta);
}

void escribir_elemento_vector(FILE * fpasm,char * nombre_vector, int tam_max, int exp_es_direccion) {
    /*se saca de la pila a un registro el valor del indice*/
    fprintf(fpasm, "    pop dword eax\n");

    /*haciendo lo que proceda en el caso de que sea una direccion (variable o equivalente) */
    if (exp_es_direccion == 1) {
        fprintf(fpasm, "    mov dword eax, [eax]\n");
    }

    /*se programa el control de errores en tiempo de ejecucion
      si el indice es <0 se termina el programa, si no, continua*/
    fprintf(fpasm, "    cmp eax, 0\n");

    /*se supone que en la direccion fin_indice_fuera_rango se procesa este error en tiempo de ejecucion*/
    fprintf(fpasm, "    jl near fin_indice_fuera_rango\n");

    /*si el indice es > maximo permitido se termina el programa, si no, continua*/
    /*el tamaño maximo se proporciona como argumento*/
    fprintf(fpasm, "    cmp eax, %d\n", tam_max-1);
    fprintf(fpasm, "    jg near fin_indice_fuera_rango\n");

    /*una opcion es calcular con lea la direccion efectiva del elemento indexado tras calcularla
      desplazando desde el inicio del vector el valor del indice*/
    fprintf(fpasm, "    mov dword edx, _%s\n", nombre_vector);
    fprintf(fpasm, "    lea eax, [edx + eax*4]\n"); /*direccion elemento indexado en eax*/
    fprintf(fpasm, "    push dword eax\n"); /*direccion elemento indexado en cima pila*/
}

void declararFuncion(FILE * fd_asm, char * nombre_funcion, int num_var_loc) {
    fprintf(fd_asm, "    _%s\n", nombre_funcion); /*etiqueta de inicio de la funcion*/
    fprintf(fd_asm, "   push ebp\n");             /*preservacion de ebp/esp*/
    fprintf(fd_asm, "   mov ebp, esp\n");
    /*reserva de espacio para las variables lcoales en la pila*/
    fprintf(fd_asm, "   sub esp, 4*%d\n", num_var_loc); 

}
void retornarFuncion(FILE * fd_asm, int es_variable) {

    /*retorno de la funcion (el valor de la expresion esta en la pila y tiene que dejarse en eax*/
    fprintf(fd_asm, "   pop eax\n"); 
    if (es_variable == 1) {
        fprintf(fd_asm, "   mov dword eax, [eax]\n");
    }

    /*restaurar el puntero de pila*/
    fprintf(fd_asm, "   mov esp,ebp\n"); 
    /*sacar de la pila ebp*/
    fprintf(fd_asm, "   pop ebp\n");    
    /*vuelve al programa llamante y saca de la pila la dir de retorno*/
    fprintf(fd_asm, "   ret\n");         
}
void escribirParametro(FILE* fpasm, int pos_parametro, int num_total_parametros) {
    int d_ebp;
    d_ebp = 4*(1+(num_total_parametros-pos_parametro));

    /*una alternativa es calcular la direccion efectiva con lea desplazando desde ebp*/
    fprintf(fpasm, "    lea eax, [ebp + %d]\n", d_ebp); 
    fprintf(fpasm, "    push dword eax\n");
}
void escribirVariableLocal(FILE *fpasm, int posicion_variable_local) {
    int d_ebp;
    d_ebp = 4*posicion_variable_local;

    fprintf(fpasm, "    lea eax, [ebp - %d]\n", d_ebp);
    fprintf(fpasm, "    push dword eax\n");

}

void operandoEnPilaAArgumento(FILE *fd_asm, int es_variable) {
    if (es_variable == 1) {
        /*en el caso de que en la pila tengamos una variable y no un valor*/
        fprintf(fd_asm, "   pop eax\n"); 
        
        /*se saca, se accede al valor y se vuelve a introducir en la pila*/
        fprintf(fd_asm, "   mov eax, [eax]\n"); 
        fprintf(fd_asm, "   push eax\n");
    }
}
void llamarFuncion(FILE * fd_asm, char* nombre_funcion, int num_argumentos) {
    
    /*se llama a la funcion*/
    fprintf(fd_asm, "   call %s\n", nombre_funcion); 
    
    /*se limpia la pila de los argumentos usados en la llamada*/
    fprintf(fd_asm, "   add esp, %d*4\n", num_argumentos);
    
    /*en nuestro lenguaje las llamadas a funciones son expresiones por lo que su retorno debe ser dejado en la pila*/
    fprintf(fd_asm, "   push dword eax\n");
}