stage1_start:
    times 90 db 0                      ; BIOS parameter block
    %include "Stage-1/main.asm"        ; including our main file for the Stage-1
stage1_end:

stage2_start:
    %include "Stage-2/main.c"          ; including our main file for the Stage-2
    align 512, db 0
stage2_end:
