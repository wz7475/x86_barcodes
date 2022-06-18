section	.text

global put_row, replicate_row

replicate_row:
    push rbp
    mov rbp, rsp

    movzx r10, word [rdi+18]
    lea r10, [r10+r10*2]
    add r10, 3
    and r10, 0xFFFFFFFFFFFFFFFFC

    mov r11, r10
    shr r10, 3
;    if line bytes are divisible by 4 but not by 8, last word of row won't
;   be replicated, it's not at issue because event at stripe width 1px, that word will
;   be part of white silent zone

    mov r9, r11

;   rdi / eax - address of fist pixel
;   r10 / ebx - words per width
;   r11 / ecx - line bytes / address of word in top row
;   r8 / edx - content of replicated row
;   r9  / edi - line bytes copy


    add rdi, 54

width_loop:
    mov r11, r9 ; need to preserve base line bytes
    lea r11, [r11 + r11*2]
    shl r11, 4
    add r11, r9 ; r11 *= 49 (height - 1)
loop:
    mov r8, [rdi]
    mov [rdi+r11], r8
    sub r11, r9 ; 1px down
    jg loop

    add rdi, 8
    dec r10
    jg width_loop

    pop rbp
    ret


put_row:
    push rbp
    mov rbp, rsp

    add rdi, 54
    lea rcx, [rcx + rcx*2]

    add rdi, rcx ; add offset



;   rdi / ebx - first pixel
;   rsi / eax - stripes widths
;   r11 / edi - black/white
;   rdx / ecx  - counter for stripes
;   r8 / edx - read stripe from table
;   r9 / esi - current stipe width
    mov r10, [rsi]
    xor r11, r11
;0x0006 0003 0003 0006

paint_loop:

;    DEBUG add paint first pixel
;    imul r10, 90
    movzx r8, word [rsi] ; read stripe from table
    lea r8, [r8 + r8*2] ; multiply width  by 3

    cmp r11, 0
    jne white_stripe

    mov r9, r8
    sub r9, 3
inner_loop:
    mov word [rdi+r9], 0
    mov byte [rdi +r9+2], 0
    sub r9, 3
    jge inner_loop

white_stripe:
    not r11
    add rsi, 2
    add rdi, r8
    dec rdx
    jg paint_loop

    pop rbp
    ret
