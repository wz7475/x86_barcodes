section	.text

global set_pixel

set_pixel:
    push ebp
    mov ebp, esp
    push ebx
;    push ecx
;    push edx

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

    mov edi, 12
    mov eax, ecx
width_loop:


    imul ecx, 9

    mov  edx, [ebx]
    and edx, 0x000ffff
    cmp edx, 0x000ffff
    je white_pixel
loop:
    ; second pixel
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

; third column
;;     first pixel
;    mov word [ebx+6], 0
;    mov byte [ebx+2+6], 0
;   ; second pixel
;    mov word [ebx + ecx+6], 0
;    mov byte [ebx + ecx + 2+6], 0


;
;    mov word [ebx+3], 0
;    mov byte [ebx+5], 0
;
;    mov word [ebx+6], 0
;    mov byte [ebx+8], 0
;    mov edx, [ebp+20]
;    mov [ebx+3], dx ; copy to ebx GGBB (little endian so we start with B)
;    shr edx, 16
;    mov [ebx+5], dl
;
;    mov edx, [ebp+20]
;    mov [ebx+6], dx ; copy to ebx GGBB (little endian so we start with B)
;    shr edx, 16
;    mov [ebx+8], dl

    mov eax, [ebp+20] ; return value
;    pop edx
;    pop ecx
    pop ebx
    pop ebp
    ret



;global remove_repeat, _remove_repeat
;_remove_repeat:
;remove_repeat:
;	push ebp
;	mov	ebp, esp
;	push ebx
;	push ecx
;	mov	eax, DWORD [ebp+8]
;	mov ecx, eax
;;   first occurrence always written
;	mov bl, [eax]
;	inc eax
;	inc ecx
;
;remove_repeat_loop:
;;    previous char in bh
;    mov bh, bl
;;   current char
;    mov bl, [eax]
;
;    inc eax
;    cmp bl, bh
;    je remove_repeat_loop
;
;write_chars:
;;   bl contains current char
;    mov BYTE [ecx], bl
;    inc ecx
;    cmp bl, 0
;    jne remove_repeat_loop
;
;remove_repeat_exit:
;;   calc length (ecx points at \0)
;	sub ecx, [ebp + 8]
;	sub ecx, 1
;    mov eax, ecx
;    pop ecx
;	pop ebx
;	pop	ebp
;	ret
