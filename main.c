#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include "includes/coding_utils.h"
#include "includes/img_helpers.h"


int main(void)
{


//    char *input_code = NULL;
    char *input_code = "1234";
//    printf("please input a string to code (event amount of digits (0-9):\n");
//    scanf("%ms",&input_code); // m for measure string and allocate memory
//    if (input_code == NULL){
//        fprintf(stderr, "That string was too long - memory allocation fault\n");
//        exit(3);
//    }
//
//
    uint8_t input_len = strlen(input_code);
//    if (input_len % 2 != 0){
//        fprintf(stderr, "Amount of digits has to be even");
//        exit(1);
//    }
//    for (int i = 0; i < input_len; i++){
//        if (input_code[i] < '0' || input_code[i] > '9'){
//            fprintf(stderr, "Each character has to be a digit");
//            exit(2);
//        }
//    }


    uint16_t stripe_width;
    stripe_width = 3;
//    printf("enter base stripe's width (usually 1-3px)\n");
//    scanf("%hd", &stripe_width);

    uint16_t img_width = calc_img_width(input_len, stripe_width);

    size_t bmp_size = 0;
    uint8_t *bmp_buffer = generate_empty_bitmap(img_width, &bmp_size);


    generate_barcode(bmp_buffer, input_code, input_len, stripe_width);


    write_bytes_to_bmp(bmp_buffer, bmp_size);

    free(bmp_buffer);



//    free(input_code);

    return 0;
}