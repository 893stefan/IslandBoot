; boot.asm - Stage 1 code for the rudimentary bootloader IslandBoot

BITS 16                 ; 16 bit ASM code
ORG 0x7C00              ; BIOS charges this code at 0x7C00 after detecting MBR in disk

mov si, message         ; moves message to the pointer
call PrintStr           ; calls our function to print message
jmp $
PrintStr:
    mov ah, 0x0E        ; initializing syscall (BIOS-call, technically) for printing strings on TTY
    mov al, [si]        ; setting al to the value of si, to establish further comparison
    loop:
        int 0x10        ; interruption, triggers our syscall -> prints char to the TTY
        inc si          ; increment pointer to our string
        mov al, [si]    ; update value of al
        cmp al, 0
        jne loop        ; if (al == 0) we break out of the loop
    ret
ret

data:
   message db "IslandBoot - Alpha 1.0", 0    ; message to show


times 510 - ($ - $$) db 0        ; making the bootloader 510 bytes
dw 0xAA55                        ; MBR end signature
