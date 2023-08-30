; includelib <kernel32.lib>
; includelib <ucrt.lib>
; includelib <legacy_stdio_definitions.lib>
; includelib <legacy_stdio_wide_specifiers.lib>
; includelib <msvcrt.lib>
; includelib <vcruntime.lib>
; includelib <libcmt>
; includelib <oldnames>

; External functions
extrn _write:PROC       ; _write (Low level write)

PUBLIC main

; Data segment
.data
    test_char db "t", 00h     ; Test character
    test_string db "string", 0Ah, 00h

; Code segment
.code
_TEXT SEGMENT
main proc

; EALMain : Main entry point
EALMain:
    ; Stack push
    sub rsp, 40h

    ; Call write
    mov r8d, 6 ; Size
    mov ecx, 1 ; FD
    lea rdx, QWORD PTR test_string ; Str address
    call _write

    ; Stack pop
    add rsp, 40h

    ; Return 0
    xor eax, eax
    ret 0

main endp
_TEXT ENDS
end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


in0 :
	mov	r8d, 1
	mov	BYTE PTR ch$[rsp], 116			; 00000074H
	lea	rdx, QWORD PTR ch$[rsp]
	xor	ecx, ecx
	call	_write

out1 :

	mov	r8d, 1
	mov	BYTE PTR ch$[rsp], 116			; 00000074H
	mov	ecx, r8d
	lea	rdx, QWORD PTR ch$[rsp]
	call	_write

err2 :

	mov	r8d, 1
	mov	BYTE PTR ch$[rsp], 116			; 00000074H
	lea	rdx, QWORD PTR ch$[rsp]
	lea	ecx, QWORD PTR [r8+1]
	call	_write

