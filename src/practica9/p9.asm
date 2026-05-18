global maximo, minimo, sumatoria

section .text

; -----------------------------
; MACRO FOR
; -----------------------------
%macro FOR 4
    push ecx
    push edx

    mov ecx, %1        ; contador
    mov edx, %2        ; índice/base

.%4:
    call %3
    loop .%4

    pop edx
    pop ecx
%endmacro


; =====================================================
; MAXIMO
; int maximo(int *arr, int len)
; =====================================================
maximo:
    push ebp
    mov ebp, esp

    mov esi, [ebp+8]      ; arr
    mov ecx, [ebp+12]     ; len

    mov eax, [esi]        ; max = arr[0]
    mov edi, 1            ; i = 1

.loop_max:
    cmp edi, ecx
    jge .fin

    mov ebx, [esi + edi*4]
    cmp ebx, eax
    jle .skip
    mov eax, ebx

.skip:
    inc edi
    jmp .loop_max

.fin:
    pop ebp
    ret


; =====================================================
; MINIMO
; =====================================================
minimo:
    push ebp
    mov ebp, esp

    mov esi, [ebp+8]
    mov ecx, [ebp+12]

    mov eax, [esi]        ; min = arr[0]
    mov edi, 1

.loop_min:
    cmp edi, ecx
    jge .fin

    mov ebx, [esi + edi*4]
    cmp ebx, eax
    jge .skip
    mov eax, ebx

.skip:
    inc edi
    jmp .loop_min

.fin:
    pop ebp
    ret


; =====================================================
; SUMATORIA
; =====================================================
sumatoria:
    push ebp
    mov ebp, esp

    mov esi, [ebp+8]
    mov ecx, [ebp+12]

    xor eax, eax        ; suma = 0
    xor edi, edi        ; i = 0

.loop_sum:
    cmp edi, ecx
    jge .fin

    add eax, [esi + edi*4]
    inc edi
    jmp .loop_sum

.fin:
    pop ebp
    ret