//
// Created by wojtek on 09.06.2022.
//

#ifndef CODING_UTILS_H
#define CODING_UTILS_H
#include <stdint.h>
#include <stddef.h>


void code_char(int index, uint16_t *final_widths, uint8_t width_offset, uint8_t stripe_width);

void generate_barcode(uint8_t *dest_bitmap, const char *code, uint8_t code_len, uint8_t stripe_width);


#endif //CODING_UTILS_H
