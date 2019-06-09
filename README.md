# Linux-x86_64-shellcodes
None of these programs contains any nuls 


generate assembly code = nasm -felf64 <program.nasm> -o <program.o>

generate object file = ld <program.o> -o <program>

dump the binary of the shellcode = for i in $(objdump -d <program> |grep "^ " |cut -f2); do echo -n '\x'$i; done;echo

generate c program to exploit = gcc -fno-stack-protector -z execstack <program.c> -o <program>
  

