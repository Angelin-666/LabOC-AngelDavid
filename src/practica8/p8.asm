%include "../../lib/pc_io.inc"

section .text
global _start

_start:

    mov esi, 0          ; índice i = 0
    mov ecx, 5          ; capturar 5 números

captura_loop:

    ; Mensaje
    mov edx, msg
    call puts

    ; ---- LIMPIAR BUFFER DE ENTRADA ----
    mov edi, cad
    mov ecx, 8
    xor al, al
    rep stosb

    ; Captura cadena
    mov edx, cad
    mov ax, 8
    call capturar

    ; ATOI
    mov edx, cad
    call atoi                   ; EAX = número convertido

    mov [nums + esi*4], eax     ; guardar entero convertido

    inc esi
    mov ecx, 5
    sub ecx, esi
    jnz captura_loop

    
    mov al, 0x0A
    call putchar


    ; ------------------------------
    ; Ordenar los números (menor a mayor)
    ; ------------------------------
    call ordenar_burbuja

    ; ------------------------------
    ; Mostrar números ordenados
    ; ------------------------------
    mov esi, 0
    mov edi, 5                  ; contador seguro

print_loop:
    mov eax, [nums + esi*4]

    ; ITOA
    mov edx, outcad
    mov ecx, 12
    call itoa

    ; Mostrar resultado
    mov edx, outcad
    call puts
    mov al, 0x0A
    call putchar

    inc esi
    dec edi
    jnz print_loop

    ; Fin
    xor ebx, ebx
    mov eax, 1
    int 0x80


; -------------------------------------------------
; CAPTURAR
; EDX → buffer
; AX  → máximo caracteres
; -------------------------------------------------

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


; -------------------------------------------------
; ATOI
; EDX → inicio cadena
; RET: EAX → entero con signo
; -------------------------------------------------

atoi:
    push ebx
    push ecx
    push edx

    xor eax, eax
    mov ebx, 1

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

    imul eax, eax, 10
    sub cl, '0'
    movzx ecx, cl
    add eax, ecx

    inc edx
    jmp .conv

.fin:
    imul eax, ebx

    pop edx
    pop ecx
    pop ebx
    ret


; -------------------------------------------------
; ITOA
; -------------------------------------------------

itoa:
    push eax
    push ebx
    push ecx
    push esi
    push edi

    mov edi, edx
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


; -------------------------------------------------
; ordenar_burbuja
; -------------------------------------------------

ordenar_burbuja:
    push eax
    push ebx
    push ecx
    push esi

    mov ecx, 4

.outer_loop:
    mov esi, 0

.inner_loop:
    mov eax, [nums + esi*4]
    mov ebx, [nums + esi*4 + 4]

    cmp eax, ebx
    jle .no_swap

    mov [nums + esi*4], ebx
    mov [nums + esi*4 + 4], eax

.no_swap:
    inc esi
    cmp esi, ecx
    jl .inner_loop

    dec ecx
    jnz .outer_loop

    pop esi
    pop ecx
    pop ebx
    pop eax
    ret


section .data
msg     db 0x0A,"Ingresa un numero (max 5 digitos): ",0

cad     times 8  db 0
outcad  times 12 db 0
nums    times 5  dd 0