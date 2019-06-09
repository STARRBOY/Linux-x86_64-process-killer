;this code will delete a file declared in section .data

global _start


section .text


_start:
        jmp short _file


delete:
        push 87                             ;sys_unlink
        pop rax
        pop rdi                             ;fname
        syscall
exit:
        xor rax,        rax
        mov al,         60                  ;sys_exit
        syscall

_file:

call delete

fname: db "test.txt"

