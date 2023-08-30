; Boot sector address
BOOTSECTOR_ADDR equ 0x0600

; Boot sector size
; Should be 0x0200 (512 bytes)
BOOTSECTOR_SIZE equ 0x0200

; Real mode stack address
; Starts below relocated boot sector
REALMODE_STACK_ADDR equ 0x0600

; Boot sector magic number
; To check boot sector copy
BOOTSECTOR_MAGIC equ 0xFA93


; Boot sector
; Loaded usually at [0x7C00]
; Relocated at BOOTSECTOR_ADDR
[bits 16]
[org BOOTSECTOR_ADDR]

boot:
; Jump to boot sector
jmp boot.sector

    ; BPB area
    nop
    times 120-($-$$) db 0x00

; Boot sector
.sector:

    ; Clear interrupts
    cli

    ; Clear direction flag
    cld

    ; Clear ax
    xor ax, ax

    ; Setup stack
    mov ss, ax  ; 0x0000
    mov sp, REALMODE_STACK_ADDR
    mov bp, sp

    ; Setup segment registers
    mov ds, ax  ; 0x0000
    mov es, ax  ; 0x0000
    mov fs, ax  ; 0x0000
    mov gs, ax  ; 0x0000

    ; Call will push current
    ; address into the stack
    call boot.copy

; Boot sector copy
.copy:

    ; Get boot sector address
    pop si  ; Pop caller address into si
    sub si, (boot.copy - boot) ; Subtract offset

    ; Copy boot sector to BOOTSECTOR_ADDR
    mov di, BOOTSECTOR_ADDR
    mov cx, 0x0100  ; For 256 words (512 bytes)
    rep movsw       ; Copy [si] to [di]

    ; Check copy operation
    mov ax, [BOOTSECTOR_ADDR + 0x01B6]  ; Read copied magic number
    cmp ax, BOOTSECTOR_MAGIC    ; Compare boot sector magic number
    je .copied                  ; Jump to .copied if equal

        ; Invalid copy
        mov si, .copy_err
        call .bios_print
        call .bios_reboot

    ; Far jump to copied boot sector
    .copied:
    jmp 0x0000:boot.load    ; Reload cs and ip as well

; Load boot init
align 8
.load:

    ; Check boot drive
    cmp dl, 0x00    ; Floppy
    je .loadfloppy

    cmp dl, 0x80    ; HDD
    je .loadhdd

        ; Unsupported boot drive
        mov si, .drive_err
        call .bios_print
        call .bios_reboot

    ; Load from floppy
    .loadfloppy:

        ; Load boot init from floppy disk
        xor ax, ax
        mov bx, BOOTINIT_ADDR       ; Address to load boot init code into
        mov al, (BOOTINIT_SIZE/512) ; Sectors to read (512 bytes/sector)
        mov ch, 0x00    ; Cylinder 0
        mov dh, 0x00    ; Head 0
        mov cl, BOOTINIT_START_SECTOR+0x01  ; Start sector (+0x01)

        mov ah, 0x02    ; Read sector function
        int 0x13        ; BIOS call
        jnc .loaded

            ; Unable to load from floppy
            mov si, .load_err
            call .bios_print
            call .bios_reboot

    ; Load from HDD
    .loadhdd:

        ; Check bios extended functions
        xor ax, ax
        mov ah, 0x41    ; Check extended functions
        mov bx, 0x55AA
        int 0x13        ; BIOS call
        jc .loadfloppy  ; Unsuported extended functions, try floppy

        ; Load boot init code
        mov si, boot.dap
        mov di, (BOOTSECTOR_ADDR + 0x0200)

        xor ax, ax
        mov ah, 0x42    ; LBA function
        int 0x13        ; BIOS call
        jnc .loaded

            ; Unable to load from HDD
            mov si, .load_err
            call .bios_print
            call .bios_reboot

; Boot init loaded
align 8
.loaded:

    ; Check loaded boot init code
    mov ax, [init.initmagic]    ; Read boot init magic number
    cmp ax, BOOTINIT_MAGIC      ; Compare boot init magic number
    je .initloaded              ; Jump to .initloaded if equal

        ; Load error
        mov si, .load_err
        call .bios_print
        call .bios_reboot

    .initloaded:

    ; Jump to boot init
    jmp 0x0000:init.start


; Print nul-terminated string using BIOS
; param si : String pointer
align 8
.bios_print:

    mov ah, 0x0E    ; Print function
    mov al, [si]    ; Load current char
    cmp al, 0x00    ; Compare with nul char
    je .printdone

        int 0x10    ; BIOS call
        inc si      ; Increment current char pointer
        jmp .bios_print

    .printdone:

ret ; End of .bios_print

; Reboot system using bios
align 8
.bios_reboot:

    ; Wait for keyboard input
    xor ax, ax  ; Clear ax
    int 0x16    ; BIOS call

    ; Reboot system
    mov al, 0xFE
    out 0x46, al
    jmp 0xFFFF:0x0000   ; BIOS POST

    ; Halt (never reached)
    jmp $

; End of .bios_reboot (nerver reached)


; DAP : Disk Address Packet
align 8
.dap:
    db 0x10                     ; Packet size (16 bytes)
    db 0x00

    dw (BOOTINIT_SIZE/512)      ; Sectors to read (512 bytes/sector)
    dw BOOTINIT_ADDR            ; Buffer address offset
    dw 0x0000                   ; Buffer address segment

    dw BOOTINIT_START_SECTOR    ; Start sector [15:0]
    dw 0x0000                   ; Start sector [31:16]
    dw 0x0000                   ; Start sector [47:32]
    dw 0x0000                   ; Start sector [63:48]


; Nul-terminated BIOS string messages
align 8
.copy_err:  ; Unable to copy boot sector to BOOTSECTOR_ADDR
    db "Boot copy error", 0x0A, 0x0D, 0x00
.drive_err: ; Unsupported boot drive (should be 0x80 or 0x00)
    db "Boot drive error", 0x0A, 0x0D, 0x00
.load_err:  ; Unable to load code from disk
    db "Boot load error", 0x0A, 0x0D, 0x00


; Fill boot sector with 0x00 until boot sector magic
times 0x01B6-($-$$) db 0x00

dw BOOTSECTOR_MAGIC ; [BOOTSECTOR_ADDR + 0x01B6]


; Fill boot sector with 0x00 until partition table
times 0x01B8-($-$$) db 0x00


; Fill remaining boot sector with 0x00
times 0x01FE-($-$$) db 0x00
; Boot sector magic numbers
dw 0xAA55               ; [BOOTSECTOR_ADDR + 0x01FE]
; End of boot sector [BOOTSECTOR_ADDR + 0x0200]


; Boot init code
%include "init.asm"
