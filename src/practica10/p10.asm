; p10.asm (NASM, ELF 32-bit)
; extern void set_bit(unsigned char *value, unsigned char bit);
; extern unsigned char get_bit(unsigned char value, unsigned char bit);

global set_bit, get_bit
section .text

; ============================================
; void set_bit(unsigned char *value, unsigned char bit)
; ============================================
set_bit:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx

    mov eax, [ebp+8]        ; eax = value (puntero)
    mov ecx, [ebp+12]       ; ecx = bit (en C llega promovido a int)
    and cl, 7               ; opcional: asegurar rango 0..7

    mov dl, 1
    shl dl, cl              ; dl = (1 << bit)  ***CL es obligatorio***

    mov bl, [eax]           ; bl = *value
    or  bl, dl              ; set bit
    mov [eax], bl           ; *value = bl

    pop ecx
    pop ebx
    pop ebp
    ret


; ============================================
; unsigned char get_bit(unsigned char value, unsigned char bit)
; Retorna 0 o 1 en AL/EAX
; ============================================
get_bit:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx

    mov eax, [ebp+8]        ; eax = value (promovido a int)
    mov ecx, [ebp+12]       ; ecx = bit
    and cl, 7

    mov bl, 1
    shl bl, cl              ; bl = (1 << bit)

    and al, bl              ; aislar el bit en AL
    setnz al                ; al = 1 si no es cero, si no al = 0
    movzx eax, al           ; limpia el resto de eax (retorno “bonito”)

    pop ecx
    pop ebx
    pop ebp
    ret