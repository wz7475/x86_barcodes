//
// Created by wojtek on 09.06.2022.
//

#ifndef CODING_UTILS_H
#define CODING_UTILS_H
#include "codes_table.h"

void print_char_codes(int index, uint8_t *final_widths, uint8_t width_offset){
    uint32_t *output_width = (uint32_t *) calloc(6,4);
    uint32_t width_copy = widths[index];
    for (int i =0; i < 6; i++){
        output_width[6-1-i] = width_copy % 10;
        final_widths[width_offset + i] = width_copy % 10;
        width_copy /= 10;
    }

    for (int i =0; i < 6; i++){
//        printf("%d ", output_width[i]);
    }
    free(output_width);
}

void print_string_codes(){
    uint8_t *final_widths = (uint8_t *) calloc(4 / 2, 2);
    char code[4] = "0134";
    uint8_t loop_counter = 0;
    for (int i = 0; i < 4 ; i++){
        uint8_t code_value = (code[i] - 48) * 10 + code[i+1] - 48;
        print_char_codes(code_value, final_widths, loop_counter * 6);
        i++;
        loop_counter++;
    }
    for (int i = 0; i <( 4 / 2) * 6; i++){
        if (i % 6 == 0 && i >0){
            printf("\n");
        }
        printf("%d ", final_widths[i]);

    }

    free(final_widths);
}


#endif //CODING_UTILS_H
