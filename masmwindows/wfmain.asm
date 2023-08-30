;//////////////////////////////////////////////////////////////////////////////;
;/        _______                               ______________________        /;
;/        \\ .   \                     ________/ . . . . . . . . . . /        /;
;/         \\ .   \     ____       ___/   . . .     ________________/         /;
;/          \\ .   \   //   \   __/  . .  _________/ .  .  .  .  /            /;
;/           \\ .   \_//     \_//     ___/    //      __________/             /;
;/            \\ .   \/   _   \/    _/       // .    /___                     /;
;/             \\ .      /\\       /        // .    ____/                     /;
;/              \\ .    /  \\     /       _// .   /                           /;
;/               \\ .  /    \\   /     _//  .    /                            /;
;/                \\__/      \\_/    //_________/                             /;
;/                                                                            /;
;//////////////////////////////////////////////////////////////////////////////;
;/  Assembly compiled by WFC (WF Compiler)                                    /;
;//////////////////////////////////////////////////////////////////////////////;

; External functions
EXTRN _kbhit:PROC       ; _kbhit (Keyboard key press)
EXTRN _getch:PROC       ; _getch (Get last pressed key)
EXTRN putchar:PROC      ; putchar (Output one character to terminal)

EXTRN __imp_GetStdHandle:PROC               ; Get std handle
EXTRN __imp_SetConsoleCursorPosition:PROC   ; Set cursor position
EXTRN __imp_GetConsoleScreenBufferInfo:PROC ; Get cursor position

EXTRN fopen_s:PROC      ; fopen_s (Open file)
EXTRN fclose:PROC       ; fclose (Close file)
EXTRN fgetc:PROC        ; fgetc (Read one character from file)
EXTRN fputc:PROC        ; fputc (Write one character into file)
EXTRN fseek:PROC        ; fseek (Set file cursor position)
EXTRN ftell:PROC        ; ftell (Get file cursor position)

EXTRN ??_U@YAPEAX_K@Z:PROC      ; new[]
EXTRN ??_V@YAXPEAX@Z:PROC       ; delete[]

PUBLIC main

; Data segment
.data
    std_handle dq 00h       ; Std output handle
    input_file dq 00h       ; Input file handle
    output_file dq 00h      ; Output file handle
    rw_file dq 00h          ; R/W file handle
    file_io dq 00h          ; File I/O mode

    file_mode_r db "r", 00h     ; File mode read parameter
    file_mode_w db "w", 00h     ; File mode write parameter
    file_mode_rw db "r+", 00h   ; File mode R/W parameter
    file_mode_rwa db "a+", 00h  ; File mode R/W append parameter

    cur_input_file db 4096 dup(0)   ; Current input file path
    cur_output_file db 4096 dup(0)  ; Current output file path

; Code segment
.code
_TEXT SEGMENT
main proc

; WFMain : Main entry point
WFMain:

    ; Program start
    xor rax, rax    ; Clear rax
    xor rbx, rbx    ; Clear rbx
    xor rcx, rcx    ; Clear rcx
    xor rdx, rdx    ; Clear rdx
    xor r8, r8      ; Clear r8
    xor r9, r9      ; Clear r9
    xor r10, r10    ; Clear r10
    xor r11, r11    ; Clear r11
    xor r12, r12    ; Clear r12
    xor r13, r13    ; Clear r13
    xor r14, r14    ; Clear r14
    xor r15, r15    ; Clear r15

    sub rsp, 32     ; Push stack (16 bytes boundary)

    ; Allocate memory
    mov rcx, 67108864       ; 16777216*4 bytes
    call ??_U@YAPEAX_K@Z    ; new[] (size in rcx, return address in rax)
    push rax                ; Push address into stack

    ; Set memory pointer
    mov r10, rax        ; Move memory address into r10
    add r10, 33554432   ; Add memory offset ((16777216*4)/2 bytes)

    ; Get std output handle
    sub rsp, 32     ; Push stack
    xor rax, rax    ; Clear rax
    mov ecx, -11    ; 0FFFFFFF5H (-11) (STD_OUTPUT_HANDLE)
    call qword ptr __imp_GetStdHandle   ; Get std handle in rax
    add rsp, 32     ; Pop stack
    mov [std_handle], rax   ; Store std handle

    mov r11, rsp    ; Store main rsp into r11

    xor r12, r12        ; Set I/O mode to standard mode
    mov [file_io], 0    ; Set I/O file mode to I/O

    xor eax, eax    ; Clear eax  :  Register 
    xor ebx, ebx    ; Clear ebx  :  Back register
    xor ecx, ecx    ; Clear ecx  :  Pointer 
    xor edx, edx    ; Clear edx  :  Back pointer

    jmp WFf2    ; Jump
WF1a:   ; Label :std.output_number:
    mov eax, ecx            ; Get pointer address (r = p)
    xchg ecx, edx           ; Swap pointer (p <=> q)
    mov ecx, eax            ; Set pointer address (p = r)
    dec ecx                 ; Decrement p

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register

    mov ecx, eax            ; Set pointer address (p = r)

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register

    xchg ecx, edx           ; Swap pointer (p <=> q)
    dec ecx                 ; Decrement p
    dec ecx                 ; Decrement p

    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    xchg eax, ebx           ; Swap register (r <=> b)
    mov eax, 01h   ; Move number constant into register
    add eax, ebx            ; Add (r = r + b)
    cmp eax, 0              ; Compare reg with 0
    jg WF5a    ; Jump if greater than zero

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register

    xchg eax, ebx           ; Swap register (r <=> b)
    mov eax, 00h   ; Move number constant into register
    sub eax, ebx            ; Subtract (r = r - b)

    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    mov eax, 02dh   ; Move number constant into register
    call WFStandardOutput   ; Standard output
WF5a:   ; Label :std.output_number.p:

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register

    xchg ecx, edx           ; Swap pointer (p <=> q)
    mov ecx, eax            ; Set pointer address (p = r)
    xchg ecx, edx           ; Swap pointer (p <=> q)
    dec ecx                 ; Decrement p
    mov eax, 01h   ; Move number constant into register

    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    inc ecx                 ; Increment p
WF77:   ; Label :std.output_number.d:
    mov eax, 0ah   ; Move number constant into register
    xchg eax, ebx           ; Swap register (r <=> b)
    dec ecx                 ; Decrement p

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register


    ; Multiply (r = r * b)
    mov r8, rdx             ; Save rdx into r8
    mul ebx                 ; Multiply (r = r * b)
    mov rdx, r8             ; Restore rdx from r8


    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    inc ecx                 ; Increment p
    mov eax, 0ah   ; Move number constant into register
    xchg eax, ebx           ; Swap register (r <=> b)

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register


    ; Divide (r = r / b)
    mov r8, rdx             ; Save rdx into r8
    xor rdx, rdx            ; Clear rdx
    div ebx                 ; Quotient in rax, remainder in rdx
    mov rdx, r8             ; Restore rdx from r8


    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    cmp eax, 0              ; Compare reg with 0
    jg WF77    ; Jump if greater than zero
    mov eax, 0ah   ; Move number constant into register
    xchg eax, ebx           ; Swap register (r <=> b)
    dec ecx                 ; Decrement p

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register


    ; Divide (r = r / b)
    mov r8, rdx             ; Save rdx into r8
    xor rdx, rdx            ; Clear rdx
    div ebx                 ; Quotient in rax, remainder in rdx
    mov rdx, r8             ; Restore rdx from r8


    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    inc ecx                 ; Increment p
    xchg ecx, edx           ; Swap pointer (p <=> q)
    mov eax, ecx            ; Get pointer address (r = p)
    xchg ecx, edx           ; Swap pointer (p <=> q)

    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

WFbb:   ; Label :std.output_number.o:
    dec ecx                 ; Decrement p

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register

    xchg eax, ebx           ; Swap register (r <=> b)
    inc ecx                 ; Increment p

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register


    ; Divide (r = r / b)
    mov r8, rdx             ; Save rdx into r8
    xor rdx, rdx            ; Clear rdx
    div ebx                 ; Quotient in rax, remainder in rdx
    mov rdx, r8             ; Restore rdx from r8

    xchg eax, ebx           ; Swap register (r <=> b)
    mov eax, 0ah   ; Move number constant into register
    xchg eax, ebx           ; Swap register (r <=> b)

    ; Modulo (r = r % b)
    mov r8, rdx             ; Save rdx into r8
    xor rdx, rdx            ; Clear rdx
    div ebx                 ; Quotient in rax, remainder in rdx
    mov eax, edx            ; Move remainder into register
    mov rdx, r8             ; Restore rdx from r8

    xchg eax, ebx           ; Swap register (r <=> b)
    mov eax, 030h   ; Move number constant into register
    add eax, ebx            ; Add (r = r + b)
    call WFStandardOutput   ; Standard output
    mov eax, 0ah   ; Move number constant into register
    xchg eax, ebx           ; Swap register (r <=> b)
    dec ecx                 ; Decrement p

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register


    ; Divide (r = r / b)
    mov r8, rdx             ; Save rdx into r8
    xor rdx, rdx            ; Clear rdx
    div ebx                 ; Quotient in rax, remainder in rdx
    mov rdx, r8             ; Restore rdx from r8


    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    inc ecx                 ; Increment p
    cmp eax, 0              ; Compare reg with 0
    jg WFbb    ; Jump if greater than zero
    inc ecx                 ; Increment p
    inc ecx                 ; Increment p

    ; Return to caller
    cmp rsp, r11            ; Compare current rsp with main rsp
    je WFMainEnd            ; Jump to WFMainEnd if (rsp == r11)
    ret                     ; Return to caller

WFf2:   ; Label :start:

    ; String constant
    push rax                ; Push rax
    xor rax, rax            ; Clear rax
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov al, 'H'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'e'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'l'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'l'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'o'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, ' '           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'W'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'o'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'r'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'l'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, 'd'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    mov al, '!'           ; Write character into al
    mov [r8], rax           ; Write character into memory
    add r8, 4               ; Increment pointer
    xor rax, rax            ; Clear rax
    mov [r8], rax           ; Write nul character into memory
    pop rax                 ; Pop rax

WF106:   ; Label :loop:

    ; Load pointed value (r = *p)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov eax, [r8]           ; Load pointed value into register

    call WFStandardOutput   ; Standard output
    inc ecx                 ; Increment p
    cmp eax, 0              ; Compare reg with 0
    jnz WF106    ; Jump if not zero
    mov eax, 0ah   ; Move number constant into register
    call WFStandardOutput   ; Standard output
WF118:   ; Label :here:
    mov eax, 05h   ; Move number constant into register
    mov ecx, eax            ; Set pointer address (p = r)



    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push r9


    mov eax, 01h  ; Cpuid function 01h
    cpuid


    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rax

    ;mov eax, 02ah   ; Move number constant into register

    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    dec ecx                 ; Decrement p
    mov eax, 05h   ; Move number constant into register

    ; Store register value (*p = r)
    movsxd r9, ecx          ; Convert p into r9
    lea r8, [r10 + r9*4]    ; Load memory address into r8
    mov [r8], eax           ; Store register at pointed address

    inc ecx                 ; Increment p
    jmp WF1a    ; Jump

; WFMainEnd : Main program end
WFMainEnd:
    ; Close opened files
    sub rsp, 32             ; Push stack
    mov rax, input_file     ; Load input file handle
    test rax, rax           ; Check input file handle
    je WFMainEndInputFileOk
        ; Close input file
        mov rcx, input_file     ; Move file handle in rcx
        call fclose             ; Close file (handle in rcx)
    WFMainEndInputFileOk:

    mov rax, output_file    ; Load output file handle
    test rax, rax           ; Check output file handle
    je WFMainEndOutputFileOk
        ; Close output file
        mov rcx, output_file    ; Move file handle in rcx
        call fclose             ; Close file (handle in rcx)
    WFMainEndOutputFileOk:

    mov rax, rw_file        ; Load R/W file handle
    test rax, rax           ; Check R/W  file handle
    je WFMainEndFileOk
        ; Close R/W file
        mov rcx, rw_file        ; Move file handle in rcx
        call fclose             ; Close file (handle in rcx)
    WFMainEndFileOk:
    add rsp, 32     ; Pop stack

    ; Cleanup memory
    pop rcx                     ; Restore address from stack
    call ??_V@YAXPEAX@Z         ; delete[] (address in rcx)

    ; Wait for keyboard input
    xor r12, r12    ; Set I/O mode to standard mode
    call WFStandardInput

    ; End of program
    xor rax, rax    ; Clear rax
    add rsp, 32     ; Pop stack (16 bytes boundary)
    ret 0           ; Return 0

; WFStandardInput : low level standard input
WFStandardInput:
    push rbx        ; Push back register
    push rcx        ; Push pointer
    push rdx        ; Push back pointer
    push r10        ; Push memory address
    push r11        ; Push main esp
    push r12        ; Push iomode

    sub rsp, 40     ; Push stack (16 bytes boundary)

    cmp r12, 0      ; Standard I/O mode
    je WFStandardInputStd      ; Jump to standard input mode
    cmp r12, 4      ; Input file I/O mode
    je WFStandardInputFile     ; Jump to file input mode
    cmp r12, 5      ; Output file I/O mode
    je WFStandardInputEnd      ; No input

    WFStandardInputStd:     ; Standard input mode

        ; Wait for keyboard input
        WFStandardInputChar:
            call _kbhit         ; Call _kbhit
            test eax, eax       ; Set ZF to 1 if eax is equal to 0
            je WFStandardInputChar      ; Loop if _kbhit returned 0

        ; Get character in al
        mov rax, -1         ; Set register to -1 (input error)
        call _getch         ; Call _getch
        and rax, 0FFh       ; Mask low byte

        jmp WFStandardInputEnd

    WFStandardInputFile:    ; File input mode
        mov rax, -1             ; Set register to -1 (input error)
        mov rcx, input_file     ; Load input file handle
        mov rbx, file_io        ; Load file_io mode
        test rbx, rbx           ; Check file_io mode
        je WFStandardInputFileI
            mov rcx, rw_file    ; Load R/W file handle

        WFStandardInputFileI:
        test rcx, rcx           ; Check file handle
        je WFStandardInputEnd   ; No input file

        ; Read character (handle addr in rcx, character in eax)
        call fgetc      ; Call fgetc

    WFStandardInputEnd:
    add rsp, 40     ; Pop stack (16 bytes boundary)

    pop r12         ; Pop iomode
    pop r11         ; Pop main esp
    pop r10         ; Pop memory address
    pop rdx         ; Pop back pointer
    pop rcx         ; Pop pointer
    pop rbx         ; Pop back register

    ret         ; Return to caller

; WFStandardOutput : low level standard output
WFStandardOutput:
    push rax        ; Push register
    push rbx        ; Push back register
    push rcx        ; Push pointer
    push rdx        ; Push back pointer
    push r10        ; Push memory address
    push r11        ; Push main esp
    push r12        ; Push iomode

    sub rsp, 32     ; Push stack (16 bytes boundary)

    cmp r12, 0      ; Standard I/O mode
    je WFStandardOutputStd      ; Jump to standard output mode
    cmp r12, 4      ; Input file I/O mode
    je WFStandardOutputEnd      ; No output
    cmp r12, 5      ; Output file I/O mode
    je WFStandardOutputFile     ; Jump to file output mode

    WFStandardOutputStd:    ; Standard output mode
        xor rcx, rcx    ; Clear rcx
        mov cl, al      ; Move register value into cl
        call putchar    ; Output character from cl
        jmp WFStandardOutputEnd

    WFStandardOutputFile:   ; File output mode
        mov rdx, output_file    ; Load output file handle
        mov rbx, file_io        ; Load file_io mode
        test rbx, rbx           ; Check file_io mode
        je WFStandardOutputFileO
            mov rdx, rw_file    ; Load R/W file handle

        WFStandardOutputFileO:
        test rdx, rdx           ; Check file handle
        je WFStandardOutputEnd  ; No output file

            ; Write character to file
            movsx rcx, al   ; Move register value into rcx
            ; Write character (handle addr in rdx, character in ecx)
            call fputc      ; Call fputc

    WFStandardOutputEnd:
    add rsp, 32     ; Pop stack (16 bytes boundary)

    pop r12         ; Pop iomode
    pop r11         ; Pop main esp
    pop r10         ; Pop memory address
    pop rdx         ; Pop back pointer
    pop rcx         ; Pop pointer
    pop rbx         ; Pop back register
    pop rax         ; Pop register

    ret         ; Return to caller

; WFGetCursorPosition : Get cursor position (x in ax, y in bx, or cur in eax)
WFGetCursorPosition:
    push rcx        ; Push pointer
    push rdx        ; Push back pointer
    push r10        ; Push memory address
    push r11        ; Push main esp
    push r12        ; Push iomode

    sub rsp, 48     ; Push stack (16 bytes boundary)

    cmp r12, 0      ; Standard I/O mode
    je WFGetCursorStd           ; Jump to standard output mode
    cmp r12, 4      ; Input file I/O mode
    je WFGetCursorInputFile     ; Jump to file input mode
    cmp r12, 5      ; Output file I/O mode
    je WFGetCursorOutputFile    ; Jump to file output mode

    WFGetCursorStd:     ; Standard I/O mode
        sub rsp, 256            ; Push stack
        lea rdx, [rsp+128]      ; Load console info array address
        mov rcx, [std_handle]   ; Move handle in rcx
        ; Std handle in rcx, console info array address in rdx
        call qword ptr __imp_GetConsoleScreenBufferInfo
        movsx eax, word ptr [rsp+132]   ; X cursor position
        movsx ebx, word ptr [rsp+134]   ; Y cursor position
        add rsp, 256            ; Pop stack
        jmp WFGetCursorEnd

    WFGetCursorInputFile:   ; File input mode
        mov r15, rbx            ; Store rbx in r15
        mov rcx, input_file     ; Move file handle in rcx
        mov rbx, file_io        ; Load file_io mode
        test rbx, rbx           ; Check file_io mode
        je WFGetCursorInputFileI
            mov rcx, rw_file    ; Load R/W file handle

        WFGetCursorInputFileI:
        ; Get file cursor position (handle in rcx, position in eax)
        call ftell              ; Call ftell
        mov rbx, r15            ; Restore rbx from r15
        jmp WFGetCursorEnd

    WFGetCursorOutputFile:  ; File output mode
        mov r15, rbx            ; Store rbx in r15
        mov rcx, output_file    ; Load output file handle
        mov rbx, file_io        ; Load file_io mode
        test rbx, rbx           ; Check file_io mode
        je WFGetCursorOutputFileO
            mov rcx, rw_file    ; Load R/W file handle

        WFGetCursorOutputFileO:
        ; Get file cursor position (handle in rcx, position in eax)
        call ftell              ; Call ftell
        mov rbx, r15            ; Restore rbx from r15

    WFGetCursorEnd:
    add rsp, 48     ; Pop stack (16 bytes boundary)

    pop r12         ; Pop iomode
    pop r11         ; Pop main esp
    pop r10         ; Pop memory address
    pop rdx         ; Pop back pointer
    pop rcx         ; Pop pointer

    ret       ; Return to caller

; WFSetCursorPosition : Set cursor position (x in ax, y in bx, or cur in eax)
WFSetCursorPosition:
    push rax        ; Push register
    push rbx        ; Push back register
    push rcx        ; Push pointer
    push rdx        ; Push back pointer
    push r10        ; Push memory address
    push r11        ; Push main esp
    push r12        ; Push iomode

    sub rsp, 32     ; Push stack (16 bytes boundary)

    cmp r12, 0      ; Standard I/O mode
    je WFSetCursorStd           ; Jump to standard output mode
    cmp r12, 4      ; Input file I/O mode
    je WFSetCursorInputFile     ; Jump to file input mode
    cmp r12, 5      ; Output file I/O mode
    je WFSetCursorOutputFile    ; Jump to file output mode

    WFSetCursorStd:     ; Standard I/O mode
        xor rdx, rdx    ; Clear rdx
        mov dx, bx      ; Y cursor position
        shl edx, 16     ; Shift Y position to high
        mov dx, ax      ; X cursor position

        ; Set cursor position
        mov rcx, std_handle     ; Move handle in rcx
        ; Std handle in rcx, Coords in edx(X : low 4bytes, Y : high 4bytes)
        call qword ptr __imp_SetConsoleCursorPosition

        jmp WFSetCursorEnd

    WFSetCursorInputFile:   ; File input mode
        mov rcx, input_file     ; Move file handle in rcx
        mov rbx, file_io        ; Load file_io mode
        test rbx, rbx           ; Check file_io mode
        je WFSetCursorInputFileI
            mov rcx, rw_file    ; Load R/W file handle

        WFSetCursorInputFileI:
        xor r8, r8              ; Clear r8 (SEEK_SET)
        mov edx, eax            ; Move file cursor position into edx
        ; Set file cursor position (handle in rcx, position in edx)
        call fseek              ; Call fseek
        jmp WFSetCursorEnd

    WFSetCursorOutputFile:  ; File output mode
        mov rcx, output_file    ; Load output file handle
        mov rbx, file_io        ; Load file_io mode
        test rbx, rbx           ; Check file_io mode
        je WFSetCursorOutputFileO
            mov rcx, rw_file    ; Load R/W file handle

        WFSetCursorOutputFileO:
        xor r8, r8              ; Clear r8 (SEEK_SET)
        mov edx, eax            ; Move file cursor position into edx
        ; Set file cursor position (handle in rcx, position in edx)
        call fseek              ; Call fseek

    WFSetCursorEnd:
    add rsp, 32     ; Pop stack (16 bytes boundary)

    pop r12         ; Pop iomode
    pop r11         ; Pop main esp
    pop r10         ; Pop memory address
    pop rdx         ; Pop back pointer
    pop rcx         ; Pop pointer
    pop rbx         ; Pop back register
    pop rax         ; Pop register

    ret       ; Return to caller

; WFSetIOMode : Set I/O mode (al : I/O mode, rcx : file path str addr)
WFSetIOMode:
    push rbx        ; Push back register
    push rcx        ; Push pointer
    push rdx        ; Push back pointer
    push r10        ; Push memory address
    push r11        ; Push main esp

    sub rsp, 48     ; Push stack (16 bytes boundary)
    mov r15, r10    ; Store memory address into r15
    movsxd r14, ecx ; Convert pointer into r14
    mov r13, rax    ; Store register into r13

    cmp al, 0       ; Standard I/O mode
    je WFSetIOModeStd           ; Jump to standard I/O mode
    cmp al, 'r'     ; Open input file mode
    je WFSetIOModeOpenInputFile     ; Jump to open input file mode
    cmp al, 'w'     ; Open output file mode
    je WFSetIOModeOpenOutputFile    ; Jump to open output file mode
    cmp al, 'b'     ; Open R/W file mode
    je WFSetIOModeOpenRWFile        ; Jump to open R/W file mode
    cmp al, 'a'     ; Open R/W file append mode
    je WFSetIOModeOpenRWAFile       ; Jump to open R/W A file mode
    cmp al, 'i'     ; Input file I/O mode
    je WFSetIOModeInputFile     ; Jump to file input I/O mode
    cmp al, 'o'     ; Output file I/O mode
    je WFSetIOModeOutputFile    ; Jump to file output I/O mode

    WFSetIOModeStd:             ; Standard I/O mode
        xor r12, r12            ; Set standard I/O mode
        jmp WFSetIOModeEnd

    WFSetIOModeOpenInputFile:   ; Open input file mode
        mov r13, -1             ; Set register to -1 (open error)
        mov r12, 4              ; Set file input I/O mode
        mov [file_io], 0        ; Set I/O file mode to I/O

        ; Clear cur_input_file
        cld                     ; Clear direction flag
        xor eax, eax            ; Clear rax (value to copy)
        mov rcx, 4000           ; String size
        lea rdi, cur_input_file     ; Load cur_input_file address
        rep stosb               ; Erase cur_input_file

        mov rax, input_file     ; Load input file handle
        test rax, rax           ; Check input file handle
        je WFSetIOModeOpenInputFileOk
            ; Close input file
            mov rcx, input_file     ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeOpenInputFileOk:

        mov rax, rw_file        ; Load R/W file handle
        test rax, rax           ; Check R/W file handle
        je WFSetIOModeOpenInputFileRWOk
            ; Close R/W file
            mov rcx, rw_file        ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeOpenInputFileRWOk:

        xor rax, rax                ; Clear rax
        mov input_file, rax         ; Clear input file handle
        mov rw_file, rax            ; Clear R/W file handle

        lea r8, [r15 + r14*4]       ; Load file path memory address into r8
        mov rax, [r8]               ; Move file path into rax
        test rax, rax               ; Check file path
        je WFSetIOModeEnd

        ; Copy 4bytes characters string into 1byte characters string
        sub rsp, 4096               ; Push stack
        mov rbx, rsp                ; Move stack pointer into rbx
        mov rcx, 4000               ; Loop for 4000 characters max
        WFSetIOModeOpenInputFileCpy:
            mov r9, [r8]            ; Move character into r9
            mov [rbx], r9           ; Copy character into stack
            add r8, 4               ; Increment paht string pointer
            inc rbx                 ; Increment destination pointer
            test r9, r9             ; Check if character is nul
            je WFSetIOModeOpenInputFileDone     ; Copy string done
            loop WFSetIOModeOpenInputFileCpy    ; Copy string loop
        WFSetIOModeOpenInputFileDone:
        xor r9, r9                  ; Clear r9
        mov [rbx], r9               ; Add nul character

        lea rdx, [rsp]              ; Load file string address
        lea r8, file_mode_r         ; Load mode string address
        lea rcx, input_file         ; Load file handle address
        sub rsp, 32                 ; Push stack
        ; Open file (handle in rcx, path str addr in rdx, mode str addr in r8)
        call fopen_s                ; Open file
        add rsp, 4128               ; Pop stack

        mov rcx, input_file         ; Move file handle in rcx
        test rcx, rcx               ; Check file handle
        je WFSetIOModeEnd
            mov r13, 0              ; Set register to 0 (open success)
            jmp WFSetIOModeEnd

    WFSetIOModeOpenOutputFile:  ; Open output file mode
        mov r13, -1             ; Set register to -1 (open error)
        mov r12, 5              ; Set file output I/O mode
        mov [file_io], 0        ; Set I/O file mode to I/O

        ; Clear cur_output_file
        cld                     ; Clear direction flag
        xor eax, eax            ; Clear rax (value to copy)
        mov rcx, 4000           ; String size
        lea rdi, cur_output_file    ; Load cur_output_file address
        rep stosb               ; Erase cur_output_file

        mov rax, output_file    ; Load output file handle
        test rax, rax           ; Check output file handle
        je WFSetIOModeOpenOutputFileOk
            ; Close output file
            mov rcx, output_file    ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeOpenOutputFileOk:

        mov rax, rw_file        ; Load R/W file handle
        test rax, rax           ; Check R/W file handle
        je WFSetIOModeOpenOutputFileRWOk
            ; Close R/W file
            mov rcx, rw_file        ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeOpenOutputFileRWOk:

        xor rax, rax                ; Clear rax
        mov output_file, rax        ; Clear output file handle
        mov rw_file, rax            ; Clear R/W file handle

        lea r8, [r15 + r14*4]       ; Load file path memory address into r8
        mov rax, [r8]               ; Move file path into rax
        test rax, rax               ; Check file path
        je WFSetIOModeEnd

        ; Copy 4bytes characters string into 1byte characters string
        sub rsp, 4096               ; Push stack
        mov rbx, rsp                ; Move stack pointer into rbx
        mov rcx, 4000               ; Loop for 4000 characters max
        WFSetIOModeOpenOutputFileCpy:
            mov r9, [r8]            ; Move character into r9
            mov [rbx], r9           ; Copy character into stack
            add r8, 4               ; Increment paht string pointer
            inc rbx                 ; Increment destination pointer
            test r9, r9             ; Check if character is nul
            je WFSetIOModeOpenOutputFileDone    ; Copy string done
            loop WFSetIOModeOpenOutputFileCpy   ; Copy string loop
        WFSetIOModeOpenOutputFileDone:
        xor r9, r9                  ; Clear r9
        mov [rbx], r9               ; Add nul character

        lea rdx, [rsp]              ; Load file string address
        lea r8, file_mode_w         ; Load mode string address
        lea rcx, output_file        ; Load file handle address
        sub rsp, 32                 ; Push stack
        ; Open file (handle in rcx, path str addr in rdx, mode str addr in r8)
        call fopen_s                ; Open file
        add rsp, 4128               ; Pop stack

        mov rcx, output_file        ; Move file handle in rcx
        test rcx, rcx               ; Check file handle
        je WFSetIOModeOpenOutputFileErr
            mov r13, 0              ; Set register to 0 (open success)
            jmp WFSetIOModeEnd

        WFSetIOModeOpenOutputFileErr:
        xor r13, r13                ; Clear register (open error)
        jmp WFSetIOModeEnd

    WFSetIOModeOpenRWFile:      ; Open R/W file mode
        mov r13, -1             ; Set register to -1 (open error)
        mov r12, 5              ; Set file output I/O mode
        mov [file_io], 1        ; Set I/O file mode to R/W

        mov rax, input_file     ; Load input file handle
        test rax, rax           ; Check input file handle
        je WFSetIOModeRWOpenInputFileOk
            ; Close input file
            mov rcx, input_file     ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeRWOpenInputFileOk:

        mov rax, output_file    ; Load output file handle
        test rax, rax           ; Check output file handle
        je WFSetIOModeRWOpenOutputFileOk
            ; Close output file
            mov rcx, output_file    ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeRWOpenOutputFileOk:

        mov rax, rw_file        ; Load R/W file handle
        test rax, rax           ; Check R/W  file handle
        je WFSetIOModeRWOpenRWFileOk
            ; Close R/W file
            mov rcx, rw_file        ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeRWOpenRWFileOk:

        xor rax, rax                ; Clear rax
        mov input_file, rax         ; Clear input file handle
        mov output_file, rax        ; Clear output file handle
        mov rw_file, rax            ; Clear R/W file handle

        lea r8, [r15 + r14*4]       ; Load file path memory address into r8
        mov rax, [r8]               ; Move file path into rax
        test rax, rax               ; Check file path
        je WFSetIOModeEnd

        ; Copy 4bytes characters string into 1byte characters string
        sub rsp, 4096               ; Push stack
        mov rbx, rsp                ; Move stack pointer into rbx
        mov rcx, 4000               ; Loop for 4000 characters max
        WFSetIOModeOpenRWFileCpy:
            mov r9, [r8]            ; Move character into r9
            mov [rbx], r9           ; Copy character into stack
            add r8, 4               ; Increment paht string pointer
            inc rbx                 ; Increment destination pointer
            test r9, r9             ; Check if character is nul
            je WFSetIOModeOpenRWFileDone        ; Copy string done
            loop WFSetIOModeOpenRWFileCpy       ; Copy string loop
        WFSetIOModeOpenRWFileDone:
        xor r9, r9                  ; Clear r9
        mov [rbx], r9               ; Add nul character

        lea rdx, [rsp]              ; Load file string address
        lea r8, file_mode_rw        ; Load mode string address
        lea rcx, rw_file            ; Load file handle address
        sub rsp, 32                 ; Push stack
        ; Open file (handle in rcx, path str addr in rdx, mode str addr in r8)
        call fopen_s                ; Open file
        add rsp, 4128               ; Pop stack

        mov rcx, rw_file            ; Move file handle in rcx
        test rcx, rcx               ; Check file handle
        je WFSetIOModeEnd
            xor r8, r8              ; Clear r8 (SEEK_SET)
            xor edx, edx            ; Clear edx (cursor position)
            ; Set file cursor position (handle in rcx, position in edx)
            call fseek              ; Call fseek
            mov r13, 0              ; Set register to 0 (open success)
            jmp WFSetIOModeEnd

    WFSetIOModeOpenRWAFile:     ; Open R/W A file mode
        mov r13, -1             ; Set register to -1 (open error)
        mov r12, 5              ; Set file output I/O mode
        mov [file_io], 1        ; Set I/O file mode to R/W

        mov rax, input_file     ; Load input file handle
        test rax, rax           ; Check input file handle
        je WFSetIOModeRWAOpenInputFileOk
            ; Close input file
            mov rcx, input_file     ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeRWAOpenInputFileOk:

        mov rax, output_file    ; Load output file handle
        test rax, rax           ; Check output file handle
        je WFSetIOModeRWAOpenOutputFileOk
            ; Close output file
            mov rcx, output_file    ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeRWAOpenOutputFileOk:

        mov rax, rw_file        ; Load R/W file handle
        test rax, rax           ; Check R/W  file handle
        je WFSetIOModeRWAOpenRWAFileOk
            ; Close R/W file
            mov rcx, rw_file        ; Move file handle in rcx
            call fclose             ; Close file (handle in rcx)
        WFSetIOModeRWAOpenRWAFileOk:

        xor rax, rax                ; Clear rax
        mov input_file, rax         ; Clear input file handle
        mov output_file, rax        ; Clear output file handle
        mov rw_file, rax            ; Clear R/W file handle

        lea r8, [r15 + r14*4]       ; Load file path memory address into r8
        mov rax, [r8]               ; Move file path into rax
        test rax, rax               ; Check file path
        je WFSetIOModeEnd

        ; Copy 4bytes characters string into 1byte characters string
        sub rsp, 4096               ; Push stack
        mov rbx, rsp                ; Move stack pointer into rbx
        mov rcx, 4000               ; Loop for 4000 characters max
        WFSetIOModeOpenRWAFileCpy:
            mov r9, [r8]            ; Move character into r9
            mov [rbx], r9           ; Copy character into stack
            add r8, 4               ; Increment paht string pointer
            inc rbx                 ; Increment destination pointer
            test r9, r9             ; Check if character is nul
            je WFSetIOModeOpenRWAFileDone       ; Copy string done
            loop WFSetIOModeOpenRWAFileCpy      ; Copy string loop
        WFSetIOModeOpenRWAFileDone:
        xor r9, r9                  ; Clear r9
        mov [rbx], r9               ; Add nul character

        lea rdx, [rsp]              ; Load file string address
        lea r8, file_mode_rwa       ; Load mode string address
        lea rcx, rw_file            ; Load file handle address
        sub rsp, 32                 ; Push stack
        ; Open file (handle in rcx, path str addr in rdx, mode str addr in r8)
        call fopen_s                ; Open file
        add rsp, 4128               ; Pop stack

        mov rcx, rw_file            ; Move file handle in rcx
        test rcx, rcx               ; Check file handle
        je WFSetIOModeEnd
            mov r8, 2               ; Move 2 to r8 (SEEK_END)
            xor edx, edx            ; Clear edx (cursor position)
            ; Set file cursor position (handle in rcx, position in edx)
            call fseek              ; Call fseek
            mov r13, 0              ; Set register to 0 (open success)
            jmp WFSetIOModeEnd

    WFSetIOModeInputFile:       ; File input mode
        mov r12, 4              ; Set file input I/O mode
        jmp WFSetIOModeEnd

    WFSetIOModeOutputFile:      ; File output mode
        mov r12, 5              ; Set file output I/O mode

    WFSetIOModeEnd:
    mov rax, r13    ; Restore register from r13
    add rsp, 48     ; Pop stack (16 bytes boundary)

    pop r11         ; Pop main esp
    pop r10         ; Pop memory address
    pop rdx         ; Pop back pointer
    pop rcx         ; Pop pointer
    pop rbx         ; Pop back register

    ret       ; Return to caller

main endp
_TEXT ENDS
end
