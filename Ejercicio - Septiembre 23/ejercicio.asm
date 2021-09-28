extern scan_int, print_int

section .bss
    _z resd 1
section .data
    _x dd 0
    _y dd 0
section .text
    global main

main:
  while:
    cmp  dword [_y], 10
    je endwhile

    add dword [_y], 1

    push _z
    call scan_int
    add esp, 4

    mov eax, [_z]
    
    cmp eax, [_x]
    jg if
    jle endif
  if:
    mov dword [_x], eax
  endif:
    jmp while
  endwhile:
    push dword [_x]
    call print_int
    add esp, 4
    ret