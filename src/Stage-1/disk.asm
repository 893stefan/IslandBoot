; disk.asm - this code contains all of the necessary functions allowing init.asm to read disk sectors

;-----------------------INITIALISATION------------------------------------------------------------;

bits 16                                ; real mode, still
disk db 0x80                           ; we are reading the first disk

;----------------------------BODY-----------------------------------------------------------------;

Real_mode_read_disk:
    .start:
        cmp cx, 127
        jbe .good_size                 ; if cx <= 127, jump to good_size (127 bytes = int 13h limit)
        pusha                          ; pushes all GPR onto the stack, acting as a save state
        mov cx, 127
        call Real_mode_read_disk       ; func called to read 127 sectors
        popa                           ; pops all GPR off the stack
        add eax, 127                   ; increment our LBA lower adress by 127
        add dx, 127 * 512 / 16         ; 127 sectors of 512 bytes, divided by a 16 bit offset (real mode)
        sub cx, 127                    ; once 127 sectors are read, we sub them from the sectors to read
        jmp .start                     ; re-iterate until cx below or equal to 127

    .good_size:
        mov [DAP.LBA_lower], ax        ; init LBA at the adress we're trying to read from
        mov [DAP.num_sectors], cx      ; cx contains our number of sectors to read
        mov [DAP.buf_segment], dx      ; segment of adresses to read
        mov [DAP.buf_offset], bx       ; offset from the start of memory
        mov dl, [disk]                 ; dl is used by the BIOS to know what disk to read from
        mov si, DAP                    ; DAP is moved to si so int 13h can read it
        mov ah, 0x42                   ; BIOS-call (LBA read)
        int 0x13                       ; interrupt, triggering BIOS-call
        jc .print_error                ; call print_error func if BIOS-call fails
        ret
    .print_error:
        mov si, disk_error_message     ; move our error message to si
        mov ah, 0x0E                   ; initializing BIOS-call for printing strings on TTY
    mov al, [si]                       ; setting al to the value of si, to establish further comparison
    prtloop:
        int 0x10                       ; interruption, triggers our BIOS-call -> prints char to the TTY
        inc si                         ; increment pointer to our string
        mov al, [si]                   ; update value of al
        cmp al, 0
        jne prtloop                     ; if (al == 0) we break out of the loop
    .hang:
        hlt
        cli
        jmp .hang

;-----------------------DATA/VARIABLES------------------------------------------------------------;

disk_error_message db 'Disk error!'    ; if int 13h (interrupt to adress disk) fails, display msg

DAP:                                   ; Disk Adress Packet

                 db 0x10               ; size of DAP = 16 bytes
                 db 0                  ; always 0
   .num_sectors: dw 127                ; number of sectors to load (max = 127 allowed by int 13h)
   .buf_offset:  dw 0x0                ; 16-bit offset of target buffer
   .buf_segment: dw 0x0                ; 16-bit segment of target buffer
   .LBA_lower:   dd 0x0                ; lower 32 bits of 48-bit starting Logical Block Adressing
   .LBA_upper:   dd 0x0                ; upper 32 bits


;----------------------------END------------------------------------------------------------------;
