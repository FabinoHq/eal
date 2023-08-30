; Video Memory pointer
VIDEO_MEM equ 0xB8000

; Total text characters in text mode
TOTAL_CHARS equ (80*25)
TOTAL_CHARS_DQ equ (TOTAL_CHARS/4)

DATA_ADDR equ 0x60000


; Kernel entry point
[bits 64]
align 64

kernel:
.start:

    ; Print FOS welcome message
    mov ebx, VIDEO_MEM          ; Reset ebx pointer
    mov rdx, .fos_welcome       ; FOS welcome string
    mov ah, 0x0F                ; Set color
    mov al, [rdx]               ; First character into al

    .print_fos_loop:
        mov [ebx], ax           ; Move character into video pointer
        add ebx, 0x02           ; Increment video text pointer
        inc rdx                 ; Increment CPU error string pointer
        mov al, [rdx]           ; Move next character into al
        test al, al             ; Check if character is nul
        jnz .print_fos_loop     ; Loop while character is not nul


    ; Print memory map
    xor ecx, ecx
    mov rsi, (MEMORYMAP_ADDR + 0x08)
    .print_mem_map:

        ; Print region start address
        mov ebx, (VIDEO_MEM + 0xA0)
        mov eax, 0xA0               ; Line char size
        mul ecx                     ; Multiply by entry number
        add ebx, eax                ; Add to ebx
        mov rdx, [rsi + 0x00]       ; Print start address
        call print_hex

        ; Print region size
        mov ebx, (VIDEO_MEM + 0xA0)
        mov eax, 0xA0               ; Line char size
        mul ecx                     ; Multiply by entry number
        add ebx, eax                ; Add to ebx
        add ebx, 0x28               ; Same line second number
        mov rdx, [rsi + 0x08]       ; Print region size
        call print_hex

        add rsi, 0x10               ; Next memory map entry
        inc rcx                     ; Increment counter
        cmp rcx, [MEMORYMAP_ADDR]   ; Compare counter with entries count
        jb .print_mem_map


    ; Halt
    jmp $


; Kernel memory addresses
align 8
.memory_entry:  ; Memory entry index where kernel is located
    dq 0x0000000000000000
.pages_count:   ; Page directories count (Gb)
    dq 0x0000000000000000
.page_address:  ; Page start address
    dq 0x0000000000000000
.code_address:  ; Kernel code start address
    dq 0x0000000000000000


; Nul-terminated string messages
align 8
.fos_welcome:   ; FOS welcome message
    db "FOS operating system", 0x00

.fos_testmem:   ; FOS test memory message
    db "FOS testing memory...", 0x00

.fos_memok:   ; FOS memory ok message
    db "FOS memory ok !", 0x00

.fos_memerr:   ; FOS memory error message
    db "FOS memory error", 0x00


; Include CPU defs and functions
%include "cpu.asm"


; Print hex number
; rdx : hex value to print
; ebx : video text pointer
align 8
print_hex:
    push rax
    push rcx
    push rdx

    mov ecx, 16                 ; Loop for 16 digits
    print_hex_loop:
        ; Extract current digit
        mov rax, rdx            ; Move hex value into eax
        shr rax, 60             ; Extract current digit value
        add al, '0'             ; Convert to ASCII value

        cmp al, '9'             ; Compare al with '9'
        jle print_hex_digit     ; Jump if less or equal
            add al, ('A'-'9'-1) ; Add ASCII offset for hex digits
        print_hex_digit:

        ; Print current character
        mov ah, 0x0F            ; Set color
        mov [ebx], ax           ; Print current character
        add ebx, 0x02           ; Increment video text pointer

        ; Next hex digit
        shl rdx, 0x04           ; Shift edx right by 4bits
        loop print_hex_loop

    pop rdx
    pop rcx
    pop rax
ret ; End of print_hex


