//Wojciech Zarzecki 318748
//The task was to remove repeating characters and return length of new string

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

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


void init_bmp_header(BmpHeader *header){
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

void write_bytes_to_bmp(uint8_t *buffer, size_t size){
    FILE *file;

    file = fopen(OUT_FILE_NAME, "wb");
    if (file==NULL){
        exit(-1);
    }

    fwrite(buffer, 1, size, file);
    fclose(file);
}

unsigned char *generate_empty_bitmap(unsigned int width, unsigned int height, size_t *output_size){
    unsigned int row_size = (width  * 3 + 3) & ~3; // round up to dividable by 4
    *output_size = row_size * height + BMP_HEADER_SIZE;
    uint8_t *bitmap = (uint8_t *) malloc(*output_size);

    BmpHeader header;
    init_bmp_header(&header);
    header.size = *output_size;
    header.width = width;
    header.height = height;

    memcpy(bitmap, &header, BMP_HEADER_SIZE); // copy header to newly allocated memory
    for (int i = BMP_HEADER_SIZE; i < *output_size; ++i){ // paint white
        bitmap[i] = 0xff;
    }
    return bitmap;
}


extern int replicate_row(uint8_t *dest_bitmap);
extern int put_row(uint8_t *dest_bitmap, uint16_t *stripes_widths, uint8_t hardcoded_len);

int main(void)
{
    size_t bmp_size = 0;
    // 100x50 ok; 50x50 malloc exception
    uint8_t *bmp_buffer = generate_empty_bitmap(120, 50, &bmp_size);

    uint16_t *stripes = (uint16_t *) malloc(18*2); //TODO: why 2 * 9 doesn't work
    uint16_t hardcoded_widths [9] = {4,4,2,2,1,1,4,4, 4};
    for (int i=0; i<9; i++){
        *(stripes+i*2) = hardcoded_widths[i];
    }
    printf("%d", (*(stripes+4)));

    put_row(bmp_buffer, stripes, 9);
//    replicate_row(bmp_buffer);
    write_bytes_to_bmp(bmp_buffer, bmp_size);
    free(bmp_buffer);
    return 0;
}