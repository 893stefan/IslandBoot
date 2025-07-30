; init.asm - Stage 1 code for the rudimentary bootloader IslandBoot

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
call HangCPU            ; calls our function to hang the CPU execution

EntryPoint:
   .setup-registers
      xor ax, ax
      mov ss, ax
      mov ds, ax
      mov es, ax
      mov fs, ax
      mov gs, ax
      mov sp, EntryPoint
      cld
   mov [disk], dl


;--------------------------INCLUDE----------------------------------------------------------------;

%include "disk.asm"
%include "functions.asm"

;-----------------------DATA/VARIABLES------------------------------------------------------------;

fetchinfo db "IslandBoot - Alpha 1.0", 13, 10, 0      ; welcome message
loadinfo db "Loading Stage 2...", 13, 10, 0           ; status message

;----------------------------END------------------------------------------------------------------;

times 510 - ($ - $$) db 0        ; padding to reach 512 bytes
dw 0xAA55                        ; MBR end signature
