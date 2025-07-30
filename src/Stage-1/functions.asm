; functions.asm - all necessary functions that will be called from main

;-----------------------INITIALISATION------------------------------------------------------------;

bits 16                 ; 16 bit ASM code (real mode)
xor ax, ax              ; Clear ax
mov ds, ax              ; Set data segment to 0
mov es, ax              ; Set extra segment to 0

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

HangCPU:
   cli                  ; disable interrupts
   hlt                  ; halt the CPU
   jmp HangCPU          ; hang here, no further instructions


;----------------------------END------------------------------------------------------------------;
