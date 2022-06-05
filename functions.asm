section	.text

global set_pixel

set_pixel:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    mov eax, [ebp+8] ; address of bitmap (header + pixel)
    mov ecx, [eax+18] ; get img width

    imul ecx, 3
    add ecx, 3
    and ecx, 0xFFFFFFFC ; ecx = line_bytes = (width * 3 + 3)~ -3

    mov ebx, [ebp +12] ; copy x
    imul ebx, 3 ; 3 bytes per pixel ebx - x

    add ebx, eax ; make address absolute (pos + img_ptr)
    add ebx, 54 ; add offset (header is always 54)

    ; 1st pixel in first row
    mov word [ebx], 0
    mov byte [ebx+2], 0

    ; 3rd pixel in first row
    mov word [ebx+6], 0
    mov byte [ebx+2+6], 0

    ; last pixel in first row
    mov word [ebx + ecx -3], 0
    mov byte [ebx + ecx + 2-3], 0

    mov edi, ecx ; edi = img_width (loop)
    mov eax, ecx ; ecx = line bytes
width_loop:
    imul ecx, 9
    mov  edx, [ebx]
    and edx, 0x000ffff
    cmp edx, 0x000ffff
    je white_pixel
loop:
    mov word [ebx + ecx], 0
    mov byte [ebx + ecx + 2], 0
    sub ecx, eax
    cmp ecx, 0
    jg loop
white_pixel:
    mov ecx, eax
    add ebx, 3
    dec edi
    cmp edi, 0
    jg width_loop

    pop edi
    pop ebx
    pop ebp
    ret
