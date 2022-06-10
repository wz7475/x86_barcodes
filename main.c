#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include "includes/coding_utils.h"
#include "includes/img_helpers.h"


int main(void)
{
    size_t bmp_size = 0;
    uint8_t *bmp_buffer = generate_empty_bitmap(300, 50, &bmp_size);


    print_string_codes(bmp_buffer,"015689", 6, 2);

    replicate_row(bmp_buffer);
    write_bytes_to_bmp(bmp_buffer, bmp_size);

    free(bmp_buffer);
    return 0;
}