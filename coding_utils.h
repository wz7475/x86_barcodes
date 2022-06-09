//
// Created by wojtek on 09.06.2022.
//

#ifndef CODING_UTILS_H
#define CODING_UTILS_H
#include "codes_table.h"
extern int put_row(uint8_t *dest_bitmap, uint16_t *stripes_widths, uint8_t hardcoded_len, uint8_t offset);

void print_char_codes(int index, uint16_t *final_widths, uint8_t width_offset){
    uint32_t width_copy = widths[index];
    for (int i =0; i < 6; i++){
        final_widths[width_offset + i] = width_copy % 10;
        width_copy /= 10;
    }
}

void print_string_codes(uint8_t *dest_bitmap, char *code, uint8_t code_len){
    uint16_t *final_widths = (uint16_t *) calloc((code_len / 2) * 6, 2);
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
    put_row(dest_bitmap, final_widths, (code_len / 2) * 6, 10);
    free(final_widths);
}


#endif //CODING_UTILS_H
