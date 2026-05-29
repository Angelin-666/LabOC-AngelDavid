; p9.asm  (NASM, ELF 32-bit)
; Funciones para ser llamadas desde C (gcc -m32)

global maximo, minimo, sumatoria

section .text


%macro FOR 5
    push ecx
    push edx
    mov  ecx, %1
    mov  edx, %2
.%5:
    call %3
    add  edx, %4
    loop .%5
    pop  edx
    pop  ecx
%endmacro

; ============================================================
; int maximo(int *arr, int len)
;   retorna el valor máximo
; ============================================================
maximo:
    push ebp
    mov  ebp, esp
    push ebx
    push esi
    push edi

    mov esi, [ebp+8]     ; esi = arr
    mov edi, [ebp+12]    ; edi = len

    ; si len <= 0, retorna 0 (por seguridad)
    cmp edi, 0
    jg  .ok
    xor eax, eax
    jmp .fin

.ok:
    mov eax, [esi]       ; max = arr[0]

    ; si len == 1, ya está
    cmp edi, 1
    jle .fin

    ; iterar desde i=1, count = len-1
    mov ecx, edi
    dec ecx
    FOR ecx, 1, .step_max, 1, LMAX

.fin:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

.step_max:
    ; usa: esi=base, edx=i, eax=max actual
    mov ebx, [esi + edx*4]
    cmp ebx, eax
    jle .ret
    mov eax, ebx
.ret:
    ret


; ============================================================
; int minimo(int *arr, int len)
;   retorna el valor mínimo
; ============================================================
minimo:
    push ebp
    mov  ebp, esp
    push ebx
    push esi
    push edi

    mov esi, [ebp+8]     ; arr
    mov edi, [ebp+12]    ; len

    cmp edi, 0
    jg  .ok
    xor eax, eax
    jmp .fin

.ok:
    mov eax, [esi]       ; min = arr[0]

    cmp edi, 1
    jle .fin

    mov ecx, edi
    dec ecx
    FOR ecx, 1, .step_min, 1, LMIN

.fin:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

.step_min:
    mov ebx, [esi + edx*4]
    cmp ebx, eax
    jge .ret
    mov eax, ebx
.ret:
    ret


; ============================================================
; int sumatoria(int *arr, int len)
;   retorna suma de elementos
; ============================================================
sumatoria:
    push ebp
    mov  ebp, esp
    push ebx
    push esi
    push edi

    mov esi, [ebp+8]     ; arr
    mov edi, [ebp+12]    ; len

    xor eax, eax         ; suma = 0

    cmp edi, 0
    jle .fin

    ; iterar i=0..len-1 (count=len)
    mov ecx, edi
    FOR ecx, 0, .step_sum, 1, LSUM

.fin:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

.step_sum:
    add eax, [esi + edx*4]
    ret