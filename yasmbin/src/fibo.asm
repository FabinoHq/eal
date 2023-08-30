; Bootloader
; Loaded at [0x7C00]
[org 0x7C00]

; Clear interrupts
cli

; Load GDT
lgdt [gdt_descriptor]

; Setup CR0
mov eax, cr0
or eax, 0x1
mov cr0, eax

; Jump to 32bits code segment
; Avoid CPU pipelining
jmp CODE_SEG:start_32bits


; 32 Bits protected mode
[bits 32]
start_32bits:

; Set segments pointers
mov ax, DATA_SEG
mov ss, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

; Clear registers
mov eax, 0x00
mov ebx, 0x00
mov ecx, 0x00
mov edx, 0x00
mov esi, 0x00
mov edi, 0x00

; Set stack address
mov ebp, STACK_ADDR
mov esp, ebp

; Setup screen mode
mov ebx, VIDEO_MEM  ; Move video memory address into ebx
mov ah, 0x0F    ; white on black
mov al, 0x00    ; character to write (nul)

; Clear screen
mov ecx, TOTAL_CHARS    ; Move total characters count into ecx
cls_loop:               ; Loop for total characters count
    mov [ebx], ax
    add ebx, 0x02
loop cls_loop
mov ebx, VIDEO_MEM  ; Reset ebx pointer


; Print "Start"
mov ebx, VIDEO_MEM  ; Reset ebx pointer
mov ah, 0x0F    ; white on black
mov al, 'S'
mov [ebx], ax

mov al, 't'
mov [ebx+0x02], ax

mov al, 'a'
mov [ebx+0x04], ax

mov al, 'r'
mov [ebx+0x06], ax

mov al, 't'
mov [ebx+0x08], ax


; Computation
mov ecx, 0xFFFFFFFE
loop_fibo_compute:
push ecx

    ; Compute Fibonacci sequence
    mov ebx, DATA_ADDR
    mov eax, 0x00
    mov ecx, 0x01
    mov edx, 0x00
    fibonacci_seq:
        mov [ebx], eax  ; fill data with eax
        add ebx, 0x04   ; increment data pointer

        ; Compute fibonacci
        mov edx, eax ; D = A
        add edx, ecx ; D += C
        mov eax, ecx ; A = C
        mov ecx, edx ; C = D

    ; Loop until A <= 0x0FFFFFFF
    cmp eax, 0x0FFFFFFF
    jle fibonacci_seq

pop ecx
loop loop_fibo_compute


; Fill data array
;mov ebx, DATA_ADDR
;mov ecx, 24 ; for 0 to 24
;fill_array:
;    push ebx
;
;    mov ebx, 0x01
;    add ebx, ecx
;    mov eax, ebx
;
;    pop ebx
;    mov [ebx], eax  ; fill data with eax
;    add ebx, 0x04   ; increment data pointer
;loop fill_array

mov ebx, VIDEO_MEM


; Print data array
mov eax, DATA_ADDR
mov ecx, 24 ; for 0 to 24
print_array:
    mov edx, [eax]  ; Put data value into edx
    call print_hex
    add ebx, 160-16
    add eax, 0x04   ; increment data pointer
loop print_array


; Stop
jmp $


; Print hex number
; edx : hex value to print
; ebx : video text pointer
print_hex:
    push eax
    push ecx
    push edx
    mov ecx, 0x08   ; Loop for 8 digits
    print_hex_loop:
        ; Extract current digit
        mov eax, edx    ; Move hex value into eax
        shr eax, 28     ; Extract current digit value
        add al, '0'     ; Convert to ASCII value

        cmp al, '9'     ; Compare al with '9'
        jle print_hex_digit ; Jump if less or equal
            add al, ('A'-'9'-1) ; Add ASCII offset for hex digits
        print_hex_digit:

        ; Print current character
        mov ah, 0x0F    ; Set color
        mov [ebx], ax   ; Print current character
        add ebx, 0x02   ; Increment video text pointer

        ; Next hex digit
        shl edx, 0x04   ; Shift edx right by 4bits
    loop print_hex_loop
    pop edx
    pop ecx
    pop eax
    ret ; End of print_hex


; GDT : Global descriptor table
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size of GDT-1
    dd gdt_start               ; GDT address

gdt_start:
; Null descriptor
    dd 0x00000000
    dd 0x00000000

; Code segment descriptor
gdt_code:
    dw 0xFFFF    ; Limit [15:0]
    dw 0x0000    ; Base [15:0]
    db 0x00      ; Base [23:16]
    db 10011010b ; Access (Pr 1, Privl 00, S 1, Ex 1, DC 0, RW(R) 1, Ac 0)
    db 11001111b ; Flags (Gr 1, Sz 1, L 0) + Limit
    db 0x00      ; Base [31:24]

; Data segment descriptor
gdt_data:
    dw 0xFFFF    ; Limit [15:0]
    dw 0x0000    ; Base [15:0]
    db 0x00      ; Base [23:16]
    db 10010010b ; Access (Pr 1, Privl 00, S 1, Ex 0, DC 0, RW(W) 1, Ac 0)
    db 11001111b ; Flags (Gr 1, Sz 1, L 0) + Limit
    db 0x00      ; Base [31:24]
gdt_end:

; GDT Segments refs
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; Data address
DATA_ADDR equ 0x70004
PTR_ADDR equ 0x70000

; Stack address
STACK_ADDR equ 0x90000

; Total text characters in text mode
TOTAL_CHARS equ (80*25)

; Video Memory pointer
VIDEO_MEM equ 0xB8000



; Fill boot sector with 0x00
times 510-($-$$) db 0x00
; Boot sector magic number
db 0x55
db 0xAA


; End of boot sector [0x7E00]

