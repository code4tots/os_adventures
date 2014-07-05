[org 0x7c00]

	mov bx, HELLO_MSG
	call print_string

	mov bx, GOODBYE_MSG
	call print_string

	mov dx, 0x1235
	call print_hex

	mov bx, NEWLINE
	call print_string

	mov dx, bp
	call print_hex

	mov bx, NEWLINE
	call print_string

	mov dx, sp
	call print_hex

	mov bx, NEWLINE
	call print_string

	;; jmp $ really heats up my computer.
	;; trying out this alternative
	;; actually, I'm not sure if 'jmp $' is
	;; heating up my computer -- it could just be
	;; that bochs is just really cpu intensive.
	;; but it is kinda nice having something that
	;; acknowledges button presses.
end:	
	mov ah, 0
	int 0x16

	mov bx, KEYPRESS_MSG
	call print_string

	mov ah, 0x0e
	int 0x10

	mov al, `\n`
	int 0x10

	mov al, `\r`
	int 0x10
	
	jmp end

	
%include "print_string.asm"
%include "print_hex.asm"
	
HELLO_MSG:
	db `Hello, World!\n\r`, 0

GOODBYE_MSG:
	db `Goodbye!\n\r`, 0

KEYPRESS_MSG:
	db `A key was pressed!\n\r`, 0

NEWLINE:
	db `\n\r`, 0
	
	times 510-($-$$) db 0
	dw 0xaa55
	
