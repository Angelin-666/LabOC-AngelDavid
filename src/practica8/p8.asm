%include "../../lib/pc_io.inc"

section .text
global _start

_start:

    ; Mensaje
    mov edx, msg
    call puts

    ; Captura cadena
    mov edx, cad
    mov ax, 6
    call capturar

    ; ATOI
    mov edx, cad
    call atoi
    mov ebx, eax        ; guardar entero convertido

    ; ITOA
    mov eax, ebx        ; número entero con signo
    mov edx, outcad     ; buffer salida
    mov ecx, 16         ; longitud buffer
    call itoa

    ; Mostrar resultado
    mov al, 0x0A
    call putchar
    mov edx, outcad
    call puts
    call putchar

    ; Fin
    xor ebx, ebx
    mov eax, 1
    int 0x80


; CAPTURAR
; EDX → buffer
; AX  → máximo caracteres

capturar:
    push eax
    push ecx
    push edx

    mov cx, ax
    dec cx

.ciclo:
    call getch
    cmp al, 0x0A
    je .fin
    mov [edx], al
    call putchar
    inc edx
    loop .ciclo

.fin:
    mov byte [edx], 0
    pop edx
    pop ecx
    pop eax
    ret


; ATOI
; EDX → inicio cadena
; RET: EAX → entero con signo

atoi:
    push ebx
    push ecx
    push edx

    xor eax, eax        ; acumulador
    mov ebx, 1          ; signo = +

; ignorar espacios
.espacios:
    mov cl, [edx]
    cmp cl, ' '
    jne .signo
    inc edx
    jmp .espacios

.signo:
    cmp cl, '-'
    jne .checkplus
    mov ebx, -1
    inc edx
    jmp .conv

.checkplus:
    cmp cl, '+'
    jne .conv
    inc edx

.conv:
    mov cl, [edx]
    cmp cl, '0'
    jl .fin
    cmp cl, '9'
    jg .fin

    imul eax, eax, 10   ; eax *= 10
    sub cl, '0'         ; convertir ASCII → número
    movzx ecx, cl       ; limpiar ECX
    add eax, ecx        ; eax += dígito

    inc edx
    jmp .conv

.fin:
    imul eax, ebx       ; aplicar signo

    pop edx
    pop ecx
    pop ebx
    ret


; ITOA
; EAX → entero
; EDX → buffer
; ECX → longitud
; RET: EDX → inicio cadena

itoa:
    push eax
    push ebx
    push ecx
    push esi
    push edi

    mov edi, edx        ; guardar inicio real del buffer

    lea esi, [edx + ecx - 1]
    mov byte [esi], 0

    mov ebx, 10
    cmp eax, 0
    jge .loop

    mov byte [edi], '-'
    inc edi
    neg eax

.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec esi
    mov [esi], dl
    test eax, eax
    jnz .loop

.copy:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne .copy

    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

section .data
msg     db 0x0A,"Ingresa un numero maximo 5 digitos: ",0
cad     times 64 db 0
outcad  times 16 db 0