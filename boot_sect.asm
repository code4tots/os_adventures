[org 0x7c00]
KERNEL_OFFSET equ 0x1000
SECTOR_COUNT equ 15

[bits 16]
	
	;; BIOS stores our boot drive in DL

	mov bp, 0x9000 		; Set-up the stack
	mov sp, bp

	;; --------------------------------------------------
	;; Load the kernel
	;; note that dl is still set to [BOOT_DRIVE] at this point
	;; --------------------------------------------------
	mov ah, 0x02 		; BIOS read sector function
	mov al, SECTOR_COUNT 	; read SECTOR_COUNT sectors
	mov bx, KERNEL_OFFSET 	; read destination
	mov ch, 0x00		; Select cylinder 0
	mov dh, 0x00		; Select head 0
	mov cl, 0x02 		; Sector 2, after the boot sector
	int 0x13 		; BIOS interrupt for reading from disk

	jc disk_error 		; Jump if error (i.e. if carry is set)

	mov bx, SPLASH_MESSAGE
	call print_string

	;; --------------------------------------------------
	;; Switch to protected mode
	;; --------------------------------------------------
	
	cli 			; Turn off interrupts

	lgdt [gdt_descriptor]

	mov eax, cr0		; To make the switch to protected mode, we set
	or eax, 0x1		; the first bit of CR0, a control register
	mov cr0, eax

	jmp CODE_SEG:init_pm

disk_error:
	;; TODO -- print message about disk error
	jmp $

%include "print_string.asm"

[bits 32]
init_pm:
	mov ax, DATA_SEG	; Now in PM, our old segements are meaningless,
	mov ds, ax		; so we point our segment registers to the
	mov ss, ax		; data selectors we defined in our GDT
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000	; Update our stack position so it is right
	mov esp, ebp		; at the top of the free space.

	call KERNEL_OFFSET	; Enter the kernel.

	jmp $

	;; --------------------------------------------------
	;; Global variables
	;; --------------------------------------------------
SPLASH_MESSAGE:
	db `Hello!\n\r`, 0
	

	;; --------------------------------------------------
	;; Define a flat GDT (Global Descriptor Table)
	;; --------------------------------------------------
gdt_start:

gdt_null:			; mandatory null descriptor
	dd 0x0			; 'dd' means define double word (4 bytes)
	dd 0x0

gdt_code:			; code segment descriptor
	dw 0xfff		; Limit (bits 0-15)
	dw 0x0			; Base (bits 0-15)
	db 0x0 			; Base (bis 16-23)
	db 10011010b		; 1st flags, type flags
	db 11001111b		; 2nd flags, Limit (bits 16-19)
	db 0x0			; Base (bits 24-31)
	
gdt_data:			; data segment descriptor
	dw 0xffff		; Limit (bits 0-15)
	dw 0x0			; Base (bits 0-15)
	db 0x0			; Base (bits 16-23)
	db 10010010b		; 1st flags, type flags
	db 11001111b		; 2nd flags, Limit (bits 16-19)
	db 0x0			; Base (bits 24-31)

gdt_end:			; mark the end of the GDT

gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; 1 less than true size
	dd gdt_start		   ; start address of our GDT

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

	
	;; Bootsector padding
	times 510-($-$$) db 0
	dw 0xaa55
	
	
