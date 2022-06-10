//
// Created by wojtek on 10.06.2022.
//

#ifndef IMG_HELPERS_H
#define IMG_HELPERS_H
#include <stdio.h>
#include <stdint.h>
#pragma pack(1)

#define OUT_FILE_NAME "output.bmp"


#define BMP_HEADER_SIZE 54
#define BMP_PIXEL_OFFSET 54
#define BMP_PLANES 1
#define BMP_BPP 24
#define BMP_HORIZONTAL_RES 500
#define BMP_VERTICAL_RES 500
#define BMP_DIB_HEADER 40

typedef struct {
    uint8_t sig_0;
    uint8_t sig_1;
    uint32_t size;
    uint32_t reserved;
    uint32_t pixel_offset;
    uint32_t header_size;
    uint32_t width;
    uint32_t height;
    uint16_t planes;
    uint16_t bpp_type;
    uint32_t compression;
    uint32_t image_size;
    uint32_t horizontal_res;
    uint32_t vertical_res;
    uint32_t color_palette;
    uint32_t important_colors;

} BmpHeader;


void init_bmp_header(BmpHeader *header);

void write_bytes_to_bmp(uint8_t *buffer, size_t size);

//void write_bytes_to_bmp(uint8_t *buffer, size_t size) {
//    FILE *file;
//
//    file = fopen(OUT_FILE_NAME, "wb");
//    if (file==NULL){
//        exit(-1);
//    }
//
//    fwrite(buffer, 1, size, file);
//    fclose(file);
//}

//unsigned char *generate_empty_bitmap(unsigned int width, unsigned int height, size_t *output_size) {
//    unsigned int row_size = (width  * 3 + 3) & ~3; // round up to dividable by 4
//    *output_size = row_size * height + BMP_HEADER_SIZE;
//    uint8_t *bitmap = (uint8_t *) malloc(*output_size);
//
//    BmpHeader header;
//    init_bmp_header(&header);
//    header.size = *output_size;
//    header.width = width;
//    header.height = height;
//
//    memcpy(bitmap, &header, BMP_HEADER_SIZE); // copy header to newly allocated memory
//    for (int i = BMP_HEADER_SIZE; i < *output_size; ++i){ // paint white
//        bitmap[i] = 0xff;
//    }
//    return bitmap;
//}

unsigned char *generate_empty_bitmap(unsigned int width, unsigned int height, size_t *output_size);


extern int replicate_row(uint8_t *dest_bitmap);
extern int put_row(uint8_t *dest_bitmap, uint16_t *stripes_widths, uint8_t hardcoded_len, uint8_t offset);

#endif //IMG_HELPERS_H
