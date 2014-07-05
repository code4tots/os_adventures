print_hex:
	pusha

	mov bx, dx
	shr bx, 12
	and bx, 0x000F
	call print_hex_digit

	mov bx, dx
	shr bx, 8
	and bx, 0x000F
	call print_hex_digit

	mov bx, dx
	shr bx, 4
	and bx, 0x000F
	call print_hex_digit

	mov bx, dx
	and bx, 0x000F
	call print_hex_digit

	popa
	ret

print_hex_digit:
	pusha

	mov ah, 0x0e
	cmp bx, 10
	jge print_hex_digit_b

	mov al, '0'
	add al, bl
	
	jmp print_hex_digit_end

print_hex_digit_b:
	mov al, 'A'
	sub bl, 10
	add al, bl

print_hex_digit_end:	
	int 0x10
	popa
	ret
