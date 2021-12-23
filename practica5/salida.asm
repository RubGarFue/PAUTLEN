;escribir_subseccion_data
segment .data
    msg_error_indice_vector db "Indice fuera de rango", 0
    msg_error_division db "División por cero", 0
;escribir_cabecera_bss
segment .bss
    __esp resd 1
;D:	main
;D:	{
;D:	int
;R10:	<tipo> ::= int
;R9:	<clase_escalar> ::= <tipo>
;R5:	<clase> ::= <clase_escalar>
;D:	x
;declarar_variable
    _x resd 1
;R108:	<identificador> ::= TOK_IDENTIFICADOR
;D:	,
;D:	y
;declarar_variable
    _y resd 1
;R108:	<identificador> ::= TOK_IDENTIFICADOR
;D:	,
;D:	resultado
;declarar_variable
    _resultado resd 1
;R108:	<identificador> ::= TOK_IDENTIFICADOR
;D:	;
;R18:	<identificadores> ::= <identificador>
;R19:	<identificadores> ::= <identificador> , <identificadores>
;R19:	<identificadores> ::= <identificador> , <identificadores>
;R4:	<declaracion> ::= <clase> <identificadores> ;
;D:	function
;R2:	<declaraciones> ::= <declaracion>
;escribir_segmento_codigo
segment .text
    global main
    extern scan_int, scan_boolean
    extern print_int, print_boolean, print_string, print_blank, print_endofline
;D:	int
;R10:	<tipo> ::= int
;D:	suma
;D:	(
;D:	int
;R10:	<tipo> ::= int
;D:	num1
;R27:	<parametro_funcion> ::= <tipo> <identificador>
;D:	;
;D:	int
;R10:	<tipo> ::= int
;D:	num2
;R27:	<parametro_funcion> ::= <tipo> <identificador>
;D:	)
;R26:	<resto_parametros_funcion> ::= 
;R25:	<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>
;R23:	<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>
;D:	{
;D:	return
;R29:	<declaraciones_funcion> ::= 
;declararFuncion
_suma:
   push ebp
   mov ebp, esp
   sub esp, 4*0
;D:	num1
;D:	+
;escribirParametro
    lea eax, [ebp + 12]
    push dword eax
;R80:	<exp> ::= <identificador>
;D:	num2
;D:	;
;escribirParametro
    lea eax, [ebp + 12]
    push dword eax
;R80:	<exp> ::= <identificador>
;sumar
    pop dword edx
    mov dword edx, [edx]
    pop dword eax
    mov dword eax, [eax]
    add eax, edx
    push dword eax
;R72:	<exp> ::= <exp> + <exp> 
;retornarFuncion
   pop dword eax
   mov esp, ebp
   pop dword ebp
   ret
;R61:	<retorno_funcion> ::= return <exp>
;R38:	<sentencia_simple> ::= <retorno_funcon>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	}
;R30:	<sentencias> ::= <sentencia>
;R22:	<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }
;D:	x
;R21:	<funciones> ::= 
;escribir_inicio_main
; -----------------------
; PROCEDIMIENTO PRINCIPAL
main:
    mov dword [__esp], esp
;R20:	<funciones> ::= <funcion> <funciones>
;D:	=
;D:	1
;escribir_operando
    push dword 1
;R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	;
;asignar
    pop dword eax
    mov [_x], eax
;R43:	<asignacion> ::= <identificador> = <exp>
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	y
;D:	=
;D:	3
;escribir_operando
    push dword 3
;R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	;
;asignar
    pop dword eax
    mov [_y], eax
;R43:	<asignacion> ::= <identificador> = <exp>
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	resultado
;D:	=
;D:	suma
;D:	(
;D:	x
;D:	,
;escribir_operando
    push dword _x
;operandoEnPilaAArgumento
    pop eax
    mov eax, [eax]
    push eax
;R80:	<exp> ::= <identificador>
;D:	y
;D:	)
;escribir_operando
    push dword _y
;operandoEnPilaAArgumento
    pop eax
    mov eax, [eax]
    push eax
;R80:	<exp> ::= <identificador>
;R92:	<resto_lista_expresiones> ::= 
;R91:	<resto_lista_expresiones> ::= , <exp>  <resto_lista_expresiones> 
;R89:	<lista_expresiones> ::= <exp>  <resto_lista_expresiones> 
;llamarFuncion
    call _suma
;limpiarPila
    add esp, 8
    push dword eax
;R88:	<exp> ::= <identificador> ( <lista_expresiones> ) 
;D:	;
;asignar
    pop dword eax
    mov [_resultado], eax
;R43:	<asignacion> ::= <identificador> = <exp>
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	printf
;D:	resultado
;D:	;
;escribir_operando
    push dword _resultado
;R80:	<exp> ::= <identificador>
;operandoEnPilaAArgumento
    pop eax
    mov eax, [eax]
    push eax
;escribir
    pop dword eax
    push dword eax
    call print_int
    call print_endofline
    add esp, 4
;R56:	<escritura> ::= printf <exp>
;R36:	<sentencia_simple> ::= <escritura>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	resultado
;D:	=
;D:	suma
;D:	(
;D:	x
;D:	,
;escribir_operando
    push dword _x
;operandoEnPilaAArgumento
    pop eax
    mov eax, [eax]
    push eax
;R80:	<exp> ::= <identificador>
;D:	1
;escribir_operando
    push dword 1
;R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	)
;R92:	<resto_lista_expresiones> ::= 
;R91:	<resto_lista_expresiones> ::= , <exp>  <resto_lista_expresiones> 
;R89:	<lista_expresiones> ::= <exp>  <resto_lista_expresiones> 
;llamarFuncion
    call _suma
;limpiarPila
    add esp, 8
    push dword eax
;R88:	<exp> ::= <identificador> ( <lista_expresiones> ) 
;D:	;
;asignar
    pop dword eax
    mov [_resultado], eax
;R43:	<asignacion> ::= <identificador> = <exp>
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	printf
;D:	resultado
;D:	;
;escribir_operando
    push dword _resultado
;R80:	<exp> ::= <identificador>
;operandoEnPilaAArgumento
    pop eax
    mov eax, [eax]
    push eax
;escribir
    pop dword eax
    push dword eax
    call print_int
    call print_endofline
    add esp, 4
;R56:	<escritura> ::= printf <exp>
;R36:	<sentencia_simple> ::= <escritura>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	resultado
;D:	=
;D:	suma
;D:	(
;D:	10
;escribir_operando
    push dword 10
;R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	,
;D:	y
;D:	)
;escribir_operando
    push dword _y
;operandoEnPilaAArgumento
    pop eax
    mov eax, [eax]
    push eax
;R80:	<exp> ::= <identificador>
;R92:	<resto_lista_expresiones> ::= 
;R91:	<resto_lista_expresiones> ::= , <exp>  <resto_lista_expresiones> 
;R89:	<lista_expresiones> ::= <exp>  <resto_lista_expresiones> 
;llamarFuncion
    call _suma
;limpiarPila
    add esp, 8
    push dword eax
;R88:	<exp> ::= <identificador> ( <lista_expresiones> ) 
;D:	;
;asignar
    pop dword eax
    mov [_resultado], eax
;R43:	<asignacion> ::= <identificador> = <exp>
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	printf
;D:	resultado
;D:	;
;escribir_operando
    push dword _resultado
;R80:	<exp> ::= <identificador>
;operandoEnPilaAArgumento
    pop eax
    mov eax, [eax]
    push eax
;escribir
    pop dword eax
    push dword eax
    call print_int
    call print_endofline
    add esp, 4
;R56:	<escritura> ::= printf <exp>
;R36:	<sentencia_simple> ::= <escritura>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	resultado
;D:	=
;D:	suma
;D:	(
;D:	3
;escribir_operando
    push dword 3
;R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	,
;D:	5
;escribir_operando
    push dword 5
;R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	)
;R92:	<resto_lista_expresiones> ::= 
;R91:	<resto_lista_expresiones> ::= , <exp>  <resto_lista_expresiones> 
;R89:	<lista_expresiones> ::= <exp>  <resto_lista_expresiones> 
;llamarFuncion
    call _suma
;limpiarPila
    add esp, 8
    push dword eax
;R88:	<exp> ::= <identificador> ( <lista_expresiones> ) 
;D:	;
;asignar
    pop dword eax
    mov [_resultado], eax
;R43:	<asignacion> ::= <identificador> = <exp>
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	printf
;D:	resultado
;D:	;
;escribir_operando
    push dword _resultado
;R80:	<exp> ::= <identificador>
;operandoEnPilaAArgumento
    pop eax
    mov eax, [eax]
    push eax
;escribir
    pop dword eax
    push dword eax
    call print_int
    call print_endofline
    add esp, 4
;R56:	<escritura> ::= printf <exp>
;R36:	<sentencia_simple> ::= <escritura>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	}
;R30:	<sentencias> ::= <sentencia>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R1:	<programa> ::= main { <declaraciones> <funciones> <sentencias> }
;escribir_fin
    jmp near fin
fin_error_division:
    push dword msg_error_division
    call print_string
    add esp, 4
    call print_endofline
    jmp near fin
fin_indice_fuera_rango:
    push dword msg_error_indice_vector
    call print_string
    add esp, 4
    call print_endofline
    jmp near fin
fin:
    mov esp, [__esp]
    ret
