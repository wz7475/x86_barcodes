section	.text

global set_pixel

set_pixel:
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx

    mov eax, [ebp+8] ; address of bitmap (header + pixel)
    mov ebx, [eax+18] ; copy img  width
    mov ecx, [ebp+16]  ; copy img height

    imul ebx, 3
    add ebx, 3
    and ebx, 0xFFFFFFFC ; line_bytes = (width * 3 + 3)~ -3
    imul ebx, ecx ; pos = line_bytes * height

    mov edx, [ebp +12] ; copy x
    imul edx, 3 ; 3 bytes per pixel;
    add ebx, edx ; relative address (pos)
    add ebx, eax ; make address absolute (pos + img_ptr)
    add ebx, 54 ; add offset (header is always 54)

    mov edx, [ebp+20] ; copy color 00RRGGBB
    mov [ebx], dx ; copy to ebx GGBB (little endian so we start with B)
    shr edx, 16
    mov [ebx+2], dl

    mov edx, [ebp+20]
    mov [ebx+3], dx ; copy to ebx GGBB (little endian so we start with B)
    shr edx, 16
    mov [ebx+5], dl

    mov edx, [ebp+20]
    mov [ebx+6], dx ; copy to ebx GGBB (little endian so we start with B)
    shr edx, 16
    mov [ebx+8], dl

    mov eax, [ebp+20] ; return value
    pop edx
    pop ecx
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
