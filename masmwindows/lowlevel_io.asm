; includelib <kernel32.lib>
; includelib <ucrt.lib>
; includelib <legacy_stdio_definitions.lib>
; includelib <legacy_stdio_wide_specifiers.lib>
; includelib <msvcrt.lib>
; includelib <vcruntime.lib>
; includelib <libcmt>
; includelib <oldnames>

; External functions
extrn _read:PROC        ; _read (Low level read)
extrn _write:PROC       ; _write (Low level write)

;PUBLIC main

; Data segment
.data
    test_char db "t", 00h     ; Test character
    test_string db "string", 0Ah, 00h

; Code segment
.code
;_TEXT SEGMENT
main proc

; EALMain : Main entry point
EALMain:
    ; Stack push
    sub rsp, 40h

    ; Call read
    mov r8d, 1 ; Size
    xor ecx, ecx ; FD
    lea rdx, qword ptr test_char ; Str addres
    call _read

    ; Call write
    mov r8d, 6 ; Size
    mov ecx, 1 ; FD
    lea rdx, qword ptr test_string ; Str address
    call _write

    ; Stack pop
    add rsp, 40h

    ; Return 0
    xor eax, eax
    ret 0

main endp
;_TEXT ENDS
end
