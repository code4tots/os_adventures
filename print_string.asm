print_string:	
	pusha
	mov ah, 0x0e

print_string_loop:
	cmp byte [bx], 0
	je print_string_loop_exit

	mov al, [bx]
	int 0x10
	add bx, 1
	jmp print_string_loop

print_string_loop_exit:
	popa
	ret
