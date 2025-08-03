; checkA20.asm - function file to check if the A20 gate is enabled, thus alowing us to access more than 1MB of memory

;----------------------------BODY-----------------------------------------------------------------;

.func CheckA20
  CheckA20:
    pushf
    push ds
    push es
    push di
    push si                        ; pushing onto the stack all of the registers that we are going to overwrite

    cli                            ; disabling BIOS interrupts

    xor ax, ax                     ; setting value of ax to 0
    mov es, ax
    mov di, 0x0500

    mov ax, 0xffff
    mov ds, ax
    mov si, 0x0510

    mov al, byte ptr es:[di]
    push ax

    mov al, byte ptr ds:[si]
    push ax

    mov byte ptr es:[di], 0x00
    mov byte ptr ds:[si], 0xFF

    cmp byte ptr es:[di], 0xFF

    pop ax
    mov byte ptr ds:[si], al

    pop ax
    mov byte ptr es:[di], al

    mov ax, 0
    je check_a20__exit

    mov ax, 1

  check_a20__exit:
    pop si                    ]
    pop di
    pop es
    pop ds
    popf
    ret
.endfunc

;----------------------------END------------------------------------------------------------------;
