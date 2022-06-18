section	.text

global put_row, replicate_row

replicate_row:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    mov eax, [ebp+8] ; address of bitmap (header + pixel)
    mov ecx, [eax+18] ; get img width

    lea ecx, [ecx + ecx*2]
    add ecx, 3
    and ecx, 0xFFFFFFFC ; ecx = line_bytes = (width * 3 + 3)~ -3

    mov ebx, [eax+18]
    add eax, 54 ; add offset (header is always 54)

    mov edi, ecx ; edi = line bytes
width_loop:
    mov ecx, edi ; need to preserve base line bytes
    lea ecx, [ecx + ecx*2]
    shl ecx, 4
    add ecx, edi ; ecx *= 49 (height - 1)
    mov  edx, [eax]
    and edx, 0x0000ffff
    cmp edx, 0x0000ffff
    je white_pixel   ; pixels are black of white => it's sufficient to check just 2 out 3 bytes
loop:
    mov word [eax + ecx], 0
    mov byte [eax + ecx + 2], 0
    sub ecx, edi ; 1px down
    jg loop
white_pixel:
    add eax, 3
    dec ebx
    jg width_loop

    pop edi
    pop ebx
    pop ebp
    ret


put_row:
    push ebp
    mov ebp, esp
    push ebx
    push edi
    push esi

    mov ebx, [ebp+8] ; address of bitmap (header + pixel)

    add ebx, 54 ; add offset (header is always 54)
    mov edi, [ebp+20] ; offset
    lea edi, [edi + edi*2]
    add ebx, edi ;; add offset/ 4th argument


;   eax / [ebp+12] / 2nd arg - address of widths
;   ebx / 1 arg - address of first pixel
;   ecx / 3rd argument - counter for stripes
;   edx - read stripe width from table
;   edi - negation white/black
;   esi - current stripe width

    mov eax, [ebp+12] ; stripes' widths
    xor edi, edi ; black /white
    mov ecx, [ebp+16] ; amount of stripes

    mov edi, 0
paint_loop:
    movzx edx, word [eax]
    lea edx, [edx + edx*2]

    cmp edi, 0
    jne white_stripe

    mov esi, edx
    sub esi, 3
inner_loop:
    mov word [ebx+esi], 0
    mov byte [ebx+esi+2], 0
    sub esi, 3
    jge inner_loop
white_stripe:
    not edi
    add eax, 2
    add ebx, edx
    dec ecx
    jg paint_loop

    pop esi
    pop edi
    pop ebx
    pop ebp
    ret
