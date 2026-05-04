%include "../../lib/pc_io.inc"

section .text
    global _start

_start:
;agregar tope para backspace!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ; Mensaje
    mov edx, msg
    call puts

    ; Captura
    mov edx, cad       ; destino de la cadena
    mov ax, 64         ; máximo incluyendo nulo
    call capturar

    ; Salto de línea
    mov al, 0x0A
    call putchar

    ; Cadena original
    mov edx, cad
    call puts

    ; MAYÚSCULAS
    mov edx, cad
    call mayusculas
    mov al, 0x0A
    call putchar
    mov edx, cad
    call puts

    ; MINÚSCULAS
    mov edx, cad
    call minusculas
    mov al, 0x0A
    call putchar
    mov edx, cad
    call puts

    ; Fin
    mov al, 0x0A
    call putchar
    mov eax, 1
    int 0x80

;CAPTURAR
; EDX -> inicio de cadena
; AX  -> máximo caracteres



capturar:
    push eax
    push ecx
    push edx
    push edi

    mov edi, edx        ; guardar inicio del buffer
    mov cx, ax
    dec cx              ; espacio para '\0'

.ciclo:
    call getch

    ; -------- ENTER --------
    cmp al, 0x0A
    je .enter

    ; ------ BACKSPACE ------
    
    cmp al, 0x08
    je .backspace
    cmp al, 0x7F
    je .backspace


    ; ---- carácter normal ----
    cmp cx, 0          
    je .ciclo           ; ignorar

    mov [edx], al
    call putchar
    inc edx
    dec cx
    jmp .ciclo

.enter:
    cmp edx, edi        
    je .ciclo           ;ignorar ENTER
    jmp .fin

.backspace:
    cmp edx, edi        
    je .ciclo           ;no hacer nada

    inc cx              ;recuperamos espacio
    dec edx
    mov byte [edx], 0

    ; borrar visualmente: BS SPACE BS
    mov al, 0x08
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x08
    call putchar

    jmp .ciclo

.fin:
    mov byte [edx], 0   ; fin de cadena

    pop edi
    pop edx
    pop ecx
    pop eax
    ret


; Procedimiento: MAYÚSCULAS

mayusculas:
    push eax
.recorre:
    mov al, [edx]
    cmp al, 0
    je .salir

    cmp al, 'a'
    jl .sigue
    cmp al, 'z'
    jg .sigue

    sub al, 32          ; a → A
    mov [edx], al

.sigue:
    inc edx
    jmp .recorre

.salir:
    pop eax
    ret


; Procedimiento: MINÚSCULAS

minusculas:
    push eax
.recorre:
    mov al, [edx]
    cmp al, 0
    je .salir

    cmp al, 'A'
    jl .sigue
    cmp al, 'Z'
    jg .sigue

    add al, 32          ; A → a
    mov [edx], al

.sigue:
    inc edx
    jmp .recorre

.salir:
    pop eax
    ret

section .data
    msg db 0x0A, "Captura una cadena:", 0
    cad times 64 db 0