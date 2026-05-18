global set_bit, get_bit

section .text

; -------------------------------
; void set_bit(unsigned char *value, unsigned char bit)
; -------------------------------
set_bit:
    push ebp
    mov ebp, esp
    push ebx
    push ecx

    mov eax, [ebp+8]     ; puntero
    mov ecx, [ebp+12]    ; bit
    and cl, 7

    mov dl, 1
    shl dl, cl           ; mascara

    mov bl, [eax]
    or bl, dl
    mov [eax], bl

    pop ecx
    pop ebx
    pop ebp
    ret


; -------------------------------
; unsigned char get_bit(unsigned char value, unsigned char bit)
; -------------------------------
get_bit:
    push ebp
    mov ebp, esp
    push ebx
    push ecx

    mov eax, [ebp+8]
    mov ecx, [ebp+12]
    and cl, 7

    mov bl, 1
    shl bl, cl

    and al, bl
    setnz al
    movzx eax, al

    pop ecx
    pop ebx
    pop ebp
    ret
