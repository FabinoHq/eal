; Windows 64bits AMD64
[bits 64]

; Code section
code:

    test_char db "t", 00h     ; Test character
    test_string db "string", 0Ah, 00h

; EALMain : Main entry point
EALMain:
    ; Stack push
    sub rsp, 40h

    ; Stack pop
    add rsp, 40h

    ; Return 0
    xor eax, eax
    ret 0

; Align section
align 0x200, db 0x00    ; Align to 512 bytes

