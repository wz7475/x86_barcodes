section	.text

global replicate_row, put_row

replicate_row:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    mov eax, [ebp+8] ; address of bitmap (header + pixel)
    mov ecx, [eax+18] ; get img width

    imul ecx, 3
    add ecx, 3
    and ecx, 0xFFFFFFFC ; ecx = line_bytes = (width * 3 + 3)~ -3

;    mov ebx, [ebp +12] ; copy x
    xor ebx, ebx
    imul ebx, 3 ; 3 bytes per pixel ebx - x

    add ebx, eax ; make address absolute (pos + img_ptr)
    add ebx, 54 ; add offset (header is always 54)

;    ; 1st pixel in first row
;    mov word [ebx], 0
;    mov byte [ebx+2], 0
;
;    ; 3rd pixel in first row
;    mov word [ebx+6], 0
;    mov byte [ebx+2+6], 0
;
;    mov word [ebx+120], 0
;    mov byte [ebx+2+120], 0


    ; last pixel in first row TODO: error here
;    mov word [ebx + ecx -3], 0
;    mov byte [ebx + ecx + 2-3], 0

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

    mov eax, [ebp+12]
    mov eax, [eax+4]

debug_label:
    dec eax
    cmp eax, 0
    jg debug_label

    mov eax, [ebp+16]

    mov eax, [ebp+8] ; address of bitmap (header + pixel)
    mov ecx, [eax+18] ; get img width

    imul ecx, 3
    add ecx, 3
    and ecx, 0xFFFFFFFC ; ecx = line_bytes = (width * 3 + 3)~ -3

   xor ebx, ebx
   imul ebx, 3 ; 3 bytes per pixel ebx - x

   add ebx, eax ; make address absolute (pos + img_ptr)
   add ebx, 54 ; add offset (header is always 54)

   ; 1st pixel in first row
   mov word [ebx], 0
   mov byte [ebx+2], 0

   ; 3rd pixel in first row
   mov word [ebx+6], 0
   mov byte [ebx+2+6], 0

   mov word [ebx+120], 0
   mov byte [ebx+2+120], 0

    pop edi
    pop ebx
    pop ebp
    ret
