//Wojciech Zarzecki 318748
//The task was to remove repeating characters and return length of new string

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include "includes/codes_table.h"
#include "includes/coding_utils.h"
#include "includes/img_helpers.h"



int main(void)
{
//    uint32_t *output_width = (uint32_t *) calloc(6,4);
//    uint32_t width_copy = widths[0];
//    for (int i =0; i < 6; i++){
//        output_width[6-1-i] = width_copy % 10;
//        width_copy /= 10;
//    }
//
//    for (int i =0; i < 6; i++){
//        printf("%d ", output_width[i]);
//    }
//
//    free(output_width);
//    code_char(0);



    size_t bmp_size = 0;
    // 100x50 ok; 50x50 malloc exception
    uint8_t *bmp_buffer = generate_empty_bitmap(121, 50, &bmp_size);

//    uint16_t *stripes = (uint16_t *) malloc(18);
////    uint16_t hardcoded_widths [9] = {4,4,2,2,1,1,4,4, 4};
//    uint16_t hardcoded_widths [9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
//    for (int i=0; i<9; i++){
//        stripes[i] = hardcoded_widths[i];
//    }

//    for (int i=0; i<9; i++){
//        printf("%d\n", stripes[i]);
//    }
    print_string_codes(bmp_buffer,"123456", 6, 1);

//    put_row(bmp_buffer, stripes, 9, 10);
    replicate_row(bmp_buffer);
    write_bytes_to_bmp(bmp_buffer, bmp_size);
    free(bmp_buffer);
    return 0;
}