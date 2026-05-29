%include "../../lib/pc_io.inc"  ; incluir declaraciones de procedimiento externos
                                ; que se encuentran en la biblioteca libpc_io.a
section .text
    global _start ;referencia para inicio de programa

_start:
    ; Imprime cadena original
    mov edx, msg        ; edx = dirección de la cadena msg
    call puts       ; imprime cadena msg terminada en valor nulo (0)

    ; Base + índice + desplazamiento
    mov ebx, msg      ; base
    mov esi, 10       ; índice
    mov byte [ebx + esi + 5], 'P'

    ; Imprime cadena modificada
    mov edx, msg
    call puts

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789',0xa,0