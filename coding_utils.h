//
// Created by wojtek on 09.06.2022.
//

#ifndef CODING_UTILS_H
#define CODING_UTILS_H
#include "codes_table.h"

void print_char_codes(int index, uint8_t *final_widths, uint8_t width_offset){
    uint32_t width_copy = widths[index];
    for (int i =0; i < 6; i++){
        final_widths[width_offset + i] = width_copy % 10;
        width_copy /= 10;
    }
}

void print_string_codes(char *code, uint8_t code_len){
    uint8_t *final_widths = (uint8_t *) calloc((code_len / 2) * 6, 2);
//    char code[code_len] = "0134";
    uint8_t loop_counter = 0;
    for (int i = 0; i < code_len ; i++){
        uint8_t code_value = (code[i] - 48) * 10 + code[i+1] - 48;
        print_char_codes(code_value, final_widths, loop_counter * 6);
        i++;
        loop_counter++;
    }
//    debug section
    for (int i = 0; i <( code_len / 2) * 6; i++){
        if (i % 6 == 0 && i >0){
            printf("\n");
        }
        printf("%d ", final_widths[i]);
    }

    free(final_widths);
}


#endif //CODING_UTILS_H
