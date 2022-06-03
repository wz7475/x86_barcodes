//Wojciech Zarzecki 318748
//The task was to remove repeating characters and return length of new string

#include <stdio.h>

extern int remove_repeat(char *a);

int main(void)
{
    int buffer;
    char text1[]="CCCComputerr Arrrrrchitecturrrre Labbbb";
    char text2[]="Computer Architecture Lab";


    printf("Input string      > %s\n", text1);
    buffer = remove_repeat(&text1[0]);
    printf("Conversion results> %s\n", text1);
    printf("%d\n\n", buffer);

    printf("Input string      > %s\n", text2);
    buffer = remove_repeat(&text2[0]);
    printf("Conversion results> %s\n", text2);
    printf("%d\n", buffer);

}