// main.c - the main file for the Stage-2 of IslandBoot

#include <stdint.h>

extern void read_sectors_lba(uint16_t num_sectors, uint16_t buf_segment, uint16_t buf_offset, uint32_t lba_start);

#define KERNEL_SEGMENT 0x8000
#define KERNEL_OFFSET  0x0000
#define KERNEL_LBA     100
#define KERNEL_SECTORS 20

void print(const char* str);
void hang();

void main() {
    print("Stage 2: Loading kernel...\r\n");

    read_sectors_lba(KERNEL_SECTORS, KERNEL_SEGMENT, KERNEL_OFFSET, KERNEL_LBA);

    print("Jumping to kernel...\r\n");

    void (*kernel_entry)() = (void(*)()) (KERNEL_SEGMENT * 16L + KERNEL_OFFSET);
    kernel_entry();

    hang();
}
