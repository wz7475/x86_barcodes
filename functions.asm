section	.text

global remove_repeat, _remove_repeat

_remove_repeat:
remove_repeat:
	push ebp
	mov	ebp, esp
	push ebx
	push ecx
	mov	eax, DWORD [ebp+8]
	mov ecx, eax
;   first occurrence always written
	mov bl, [eax]
	inc eax
	inc ecx

remove_repeat_loop:
;    previous char in bh
    mov bh, bl
;   current char
    mov bl, [eax]

    inc eax
    cmp bl, bh
    je remove_repeat_loop

write_chars:
;   bl contains current char
    mov BYTE [ecx], bl
    inc ecx
    cmp bl, 0
    jne remove_repeat_loop

remove_repeat_exit:
;   calc length (ecx points at \0)
	sub ecx, [ebp + 8]
	sub ecx, 1
    mov eax, ecx
    pop ecx
	pop ebx
	pop	ebp
	ret
