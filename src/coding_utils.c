//
// Created by wojtek on 10.06.2022.
//
#include "../includes/coding_utils.h"
#include "../includes/codes_table.h"
#include "../includes/img_helpers.h"
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

void code_char(int index, uint16_t *final_widths, uint8_t width_offset, uint8_t stripe_width) {
    uint32_t width_copy = widths[index];
    for (int i =5; i >= 0; i--){
        final_widths[width_offset + i] = (width_copy % 10) * stripe_width;
        width_copy /= 10;
    }
}

void code_stop_char(uint16_t *final_widths, uint8_t width_offset, uint8_t stripe_width){
    uint32_t width_copy = widths[105];
    for (int i =6; i >= 0; i--){
        final_widths[width_offset + i] = (width_copy % 10) * stripe_width;
        width_copy /= 10;
    }
}

void encode_text(uint8_t *dest_bitmap, const char *code, uint8_t code_len, uint8_t stripe_width) {
    uint16_t *final_widths = (uint16_t *) calloc((code_len / 2) * 6+19, 2);
//    char code[code_len] = "0134";
    code_char(103, final_widths, 0, stripe_width); // start code
    uint8_t loop_counter = 1; // 6 stripes were used for start code
    uint16_t checksum = 105; // init with start code value
    for (int i = 0; i < code_len ; i++){
        uint8_t code_value = (code[i] - 48) * 10 + code[i+1] - 48;
        code_char(code_value, final_widths, loop_counter * 6, stripe_width);
        i++;
        checksum += code_value * loop_counter;
        loop_counter++;
    }
//    printf("%d\n", checksum);
    checksum %= 103;

    code_char(checksum, final_widths, loop_counter *6, stripe_width);
//    code_char(104, final_widths, loop_counter *6+6, stripe_width); // stop code
    code_stop_char(final_widths, loop_counter *6+6, stripe_width);
//    debug section
//    printf("%d\t", checksum);
//    printf("%d\n", widths[checksum]);
//    for (int i = 0; i <( code_len / 2) * 6+6+6+6; i++){
//        if (i % 6 == 0 && i >0){
//            printf("\n");
//        }
//        printf("%d ", final_widths[i]);
//    }
//    printf("%d\n", final_widths[( code_len / 2) * 6+6+6+6]);
    put_row(dest_bitmap, final_widths, (code_len / 2) * 6+19, stripe_width * 20);
    free(final_widths);
}
