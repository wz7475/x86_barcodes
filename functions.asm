section	.text

global put_row
;, replicate_row

;replicate_row:
;    push ebp
;    mov ebp, esp
;    push ebx
;    push edi
;
;    mov eax, [ebp+8] ; address of bitmap (header + pixel)
;    mov ecx, [eax+18] ; get img width
;
;    lea ecx, [ecx + ecx*2]
;    add ecx, 3
;    and ecx, 0xFFFFFFFC ; ecx = line_bytes = (width * 3 + 3)~ -3
;
;    mov ebx, [eax+18]
;    add eax, 54 ; add offset (header is always 54)
;
;    mov edi, ecx ; edi = line bytes
;width_loop:
;    mov ecx, edi ; need to preserve base line bytes
;    lea ecx, [ecx + ecx*2]
;    shl ecx, 4
;    add ecx, edi ; ecx *= 49 (height - 1)
;    mov  edx, [eax]
;    and edx, 0x0000ffff
;    cmp edx, 0x0000ffff
;    je white_pixel   ; pixels are black of white => it's sufficient to check just 2 out 3 bytes
;loop:
;    mov word [eax + ecx], 0
;    mov byte [eax + ecx + 2], 0
;    sub ecx, edi ; 1px down
;    cmp ecx, 0
;    jg loop
;white_pixel:
;    add eax, 3
;    dec ebx
;    cmp ebx, 0
;    jg width_loop
;
;    pop edi
;    pop ebx
;    pop ebp
;    ret


put_row:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push rsi


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

    pop rsi
    pop rdi
    pop rbx
    pop rbp
    ret
