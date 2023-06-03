#include <stdint.h>
#include <stdio.h>

extern void Encrypt(char* data, int64_t len, char* key);

void main(){
    printf("Hello World!\n\n");

    unsigned char key[16];
    for(char i=0; i<16; i++) key[i] = 'a' + i;

    int64_t len = 2;

    unsigned char data[len * 16];
    for(int i=0; i<len*16; i++) data[i] = 'T';

    Encrypt(data, len, key);

    for(int i=0; i<len*16; i++){
        printf("%02x", data[i]);
    }
    printf("\n");
    printf("\nreturn;\n");
}