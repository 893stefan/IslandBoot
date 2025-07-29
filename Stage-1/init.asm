; boot.asm - Stage 1 code for the rudimentary bootloader IslandBoot

;-----------------------INITIALISATION------------------------------------------------------------;

bits 16                 ; 16 bit ASM code (real mode)
org 0x7C00              ; BIOS loads this code at 0x7C00 after detecting MBR in disk
xor ax, ax              ; Clear ax
mov ds, ax              ; Set data segment to 0
mov es, ax              ; Set extra segment to 0

;----------------------------BODY-----------------------------------------------------------------;

mov si, fetchinfo       ; moves fetchinfo to the pointer
call ClearScreen        ; calls our function to clear the TTY
call PrintStr           ; calls our function to print fetchinfo
mov si, loadinfo        ; moves loadinfo to the pointer
call PrintStr           ; prints loadinfo

hang:
   cli                  ; disable interrupts
   hlt                  ; halt the CPU
   jmp hang             ; hang here, no further instructions

;--------------------------FUNCTIONS--------------------------------------------------------------;

PrintStr:
   mov ah, 0x0E        ; initializing BIOS-call for printing strings on TTY
   mov al, [si]        ; setting al to the value of si, to establish further comparison
   psloop:
       int 0x10        ; interruption, triggers our BIOS-call -> prints char to the TTY
       inc si          ; increment pointer to our string
       mov al, [si]    ; update value of al
       cmp al, 0
       jne psloop      ; if (al == 0) we break out of the loop
   ret

ClearScreen:
   mov al, 02h         ; setting 80x25 graphical mode (text)
   mov ah, 00h         ; allows us to change video mode
   int 10h             ; interruption, triggers our BIOS-call -> clears TTY
   ret

;-----------------------DATA/VARIABLES------------------------------------------------------------;

fetchinfo db "IslandBoot - Alpha 1.0", 13, 10, 0      ; welcome message
loadinfo db "Loading Stage 2...", 13, 10, 0           ; pretty obvious what's going on here

;----------------------------END------------------------------------------------------------------;

times 510 - ($ - $$) db 0        ; padding to reach 512 bytes
dw 0xAA55                        ; MBR end signature
