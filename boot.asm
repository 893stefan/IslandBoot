; boot.asm - root file for the rudimentary bootloader IslandBoot

BITS 16                 ; 16 bit ASM code
ORG 0x7C00              ; BIOS charges this code at 0x7C00 after detecting MBR in disk

start:
   mov si, message      ; pointer to the message

.print_loop:
   lodsb                ; loads byte pointed by si, increments al
   cmp al, 0            ; null terminator
   je .hang             ; hang if string terminated


.hang:
   jmp .hang            ; infinite loop to avoid crashes



message db "IslandBoot - Alpha 1.0", 0    ; message to show

times 510 - ($ - $$) db 0        ; making the bootloader 510 bytes
dw 0xAA55                        ; MBR end signature
