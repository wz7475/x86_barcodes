section	.text

global put_row

replicate_row:
    push ebp
    mov ebp, esp
    push ebx
    push edi

;    eax is set by caller
;    mov eax, [ebp+8] ; address of bitmap (header + pixel)
    mov ecx, [eax+18] ; get img width

    imul ecx, 3
    add ecx, 3
    and ecx, 0xFFFFFFFC ; ecx = line_bytes = (width * 3 + 3)~ -3

;    mov ebx, [ebp +12] ; copy x
    xor ebx, ebx
    imul ebx, 3 ; 3 bytes per pixel ebx - x

    add ebx, eax ; make address absolute (pos + img_ptr)
    add ebx, 54 ; add offset (header is always 54)

;    mov eax, ecx ; eax = img_width (loop)
    mov eax, [eax+18]
    mov edi, ecx ; edi = line bytes
width_loop:
    mov ecx, edi ; need to preserve base line bytes
    imul ecx, 49 ; last pixel in column
    mov  edx, [ebx]
    and edx, 0x0000ffff
    cmp edx, 0x0000ffff
    je white_pixel   ; pixels are black of white => it's sufficient to check just 2 out 3 bytes
loop:
    mov word [ebx + ecx], 0
    mov byte [ebx + ecx + 2], 0
    sub ecx, edi ; 1px down
    cmp ecx, 0
    jg loop
white_pixel:
    add ebx, 3
    dec eax
    cmp eax, 0
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
;    TODO: is calling convention ok?

; integral promotion each argument is 4 bytes,
; array of unit_16t -> elements separated  by 4 bytes
;    mov eax, [ebp+12]
;    mov eax, [eax+12]

    mov eax, [ebp+8] ; address of bitmap (header + pixel)
    mov ecx, [eax+18] ; get img width

    imul ecx, 3
    add ecx, 3
    and ecx, 0xFFFFFFFC ; ecx = line_bytes = (width * 3 + 3)~ -3

    xor ebx, ebx
    imul ebx, 3 ; 3 bytes per pixel ebx - x

    add ebx, eax ; make address absolute (pos + img_ptr)
    add ebx, 54 ; add offset (header is always 54)

;   eax - address of widths
;   ebx - address of first pixel
;   ecx - counter for stripes
;   edx - offset to stripe
;   edi - negation white/black
;   esi - current stripe width

    mov eax, [ebp+12]

    xor edi, edi
    mov ecx, [ebp+16]
;    mov ecx, 8

    mov edi, 0
paint_loop:
    movzx edx, word [eax]
;    lea edx, []
    imul edx, 3

    cmp edi, 0
    jne white_stripe

    mov esi, edx
    sub esi, 3
inner_loop:
    mov word [ebx+esi], 0
    mov byte [ebx+esi+2], 0
    sub esi, 3
    cmp esi, 0
    jge inner_loop
white_stripe:
    not edi
    add eax, 2
    add ebx, edx
    dec ecx
    cmp ecx, 0
    jg paint_loop

debug_label:
    mov eax, [ebp+8]
    call replicate_row

    pop esi
    pop edi
    pop ebx
    pop ebp
    ret
