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

    mov ebx, ecx
    shr ebx, 2 ; divide by word -> get amount of words per width

;    mov ebx, [eax+18]
    add eax, 54 ; add offset (header is always 54)

    mov edi, ecx ; edi = line bytes

;   eax - address of first pixel
;   ebx - words per width
;   ecx - line bytes / address of word in top row
;   edx - content of first replicated row
;   edi - line bytes copy

width_loop:
    mov ecx, edi ; need to preserve base line bytes
    lea ecx, [ecx + ecx*2]
    shl ecx, 4
    add ecx, edi ; ecx *= 49 (height - 1)
loop:
    mov edx, [eax]
    mov [eax+ecx], edx
    sub ecx, edi ; 1px down
    jg loop

    add eax, 4
    dec ebx
    jg width_loop

    pop edi
    pop ebx
    pop ebp
    ret

