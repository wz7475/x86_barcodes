//
// Created by wojtek on 10.06.2022.
//

#include "../includes/img_helpers.h"
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

void write_bytes_to_bmp(uint8_t *buffer, size_t size) {
    FILE *file;

    file = fopen(OUT_FILE_NAME, "wb");
    if (file==NULL){
        exit(-1);
    }

    fwrite(buffer, 1, size, file);
    fclose(file);
}

unsigned char *generate_empty_bitmap(unsigned int width, size_t *output_size) {
    unsigned int row_size = (width  * 3 + 3) & ~3; // round up to dividable by 4
    *output_size = row_size * 50 + BMP_HEADER_SIZE;
    uint8_t *bitmap = (uint8_t *) malloc(*output_size);

    BmpHeader header;
    init_bmp_header(&header);
    header.size = *output_size;
    header.width = width;
    header.height = 50;

    memcpy(bitmap, &header, BMP_HEADER_SIZE); // copy header to newly allocated memory
    for (int i = BMP_HEADER_SIZE; i < *output_size; ++i){ // paint white
        bitmap[i] = 0xff;
    }
    return bitmap;
}

void init_bmp_header(BmpHeader *header) {
    header->sig_0 = 'B';
    header->sig_1 = 'M';
    header->reserved = 0;
    header->pixel_offset = BMP_PIXEL_OFFSET;
    header->header_size = BMP_DIB_HEADER;
    header->planes = BMP_PLANES;
    header->bpp_type = BMP_BPP; // 24 bit map
    header->compression = 0;
    header->image_size = 0;
    header->horizontal_res= BMP_HORIZONTAL_RES;
    header->vertical_res = BMP_VERTICAL_RES;
    header->important_colors = 0;
}

uint16_t calc_img_width(uint16_t text_len, uint16_t stripe_width){
    return (text_len / 2 + 3) * 11 * stripe_width + 40 * stripe_width;
}
