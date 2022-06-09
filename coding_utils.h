//
// Created by wojtek on 09.06.2022.
//

#ifndef CODING_UTILS_H
#define CODING_UTILS_H
#include "codes_table.h"

void print_char_codes(int index){
    uint32_t *output_width = (uint32_t *) calloc(6,4);
    uint32_t width_copy = widths[index];
    for (int i =0; i < 6; i++){
        output_width[6-1-i] = width_copy % 10;
        width_copy /= 10;
    }

    for (int i =0; i < 6; i++){
        printf("%d ", output_width[i]);
    }

    free(output_width);
}


#endif //CODING_UTILS_H
