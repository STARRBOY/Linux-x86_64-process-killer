# Linux-x86_64-shellcodes
generate assembly code = nasm -felf64 <program.nasm> -o <program.o>
generate objdect file = ld <program.o> -o <program>
  
generate c program to exploit = gcc -fno-stack-protector -z execstack <program.c> -o <program>
