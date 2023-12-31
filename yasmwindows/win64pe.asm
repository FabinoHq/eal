; Windows 64bits AMD64
[bits 64]
[org 0]

; MZ Header
MZHeader:
    db 0x4D, 0x5A   ; MZ Magic number : e_magic
    db 0x90, 0x00   ; Bytes on the last page : e_cblp
    db 0x03, 0x00   ; Pages number : e_cp
    db 0x00, 0x00   ; Relocations : e_crlc

    db 0x04, 0x00   ; Size of header in paragraph : e_cparhdr
    db 0x00, 0x00   ; Minimum extra paragraph needed : e_minalloc
    db 0xFF, 0xFF   ; Maximum extra paragraph needed : e_maxalloc
    db 0x00, 0x00   ; Initial relative stack segment value : e_ss

    db 0xB8, 0x00   ; Initial stack pointer value : e_sp
    db 0x00, 0x00   ; Checksum : e_csum
    db 0x00, 0x00   ; Initial instruction pointer value : e_ip
    db 0x00, 0x00   ; Initial relative c segment value : e_cs

    db 0x40, 0x00   ; Address of relocation table : e_lfarlc
    db 0x00, 0x00   ; Overlay number : e_ovno
    db 0x00, 0x00   ; Reserved : e_res[0]
    db 0x00, 0x00   ; Reserved : e_res[1]

    db 0x00, 0x00   ; Reserved : e_res[2]
    db 0x00, 0x00   ; Reserved : e_res[3]
    db 0x00, 0x00   ; OEM identifier : e_oemid
    db 0x00, 0x00   ; OEM information : e_oeminfo

    db 0x00, 0x00   ; Reserved : e_res2[0]
    db 0x00, 0x00   ; Reserved : e_res2[1]
    db 0x00, 0x00   ; Reserved : e_res2[2]
    db 0x00, 0x00   ; Reserved : e_res2[3]

    db 0x00, 0x00   ; Reserved : e_res2[4]
    db 0x00, 0x00   ; Reserved : e_res2[5]
    db 0x00, 0x00   ; Reserved : e_res2[6]
    db 0x00, 0x00   ; Reserved : e_res2[7]

    db 0x00, 0x00   ; Reserved : e_res2[8]
    db 0x00, 0x00   ; Reserved : e_res2[9]
    ;db 0x80, 0x00, 0x00, 0x00  ; PE header address : e_lfanew
    dd COFFHeader               ; PE header address : e_lfanew

; DOS Stub
DOSStub:
    ; Output DOS error message and return 1
    db 0x0E, 0x1F, 0xBA, 0x0E, 0x00, 0xB4, 0x09, 0xCD
    db 0x21, 0xB8, 0x01, 0x4C, 0xCD, 0x21, 0x54, 0x68
    db 0x69, 0x73, 0x20, 0x70, 0x72, 0x6F, 0x67, 0x72
    db 0x61, 0x6D, 0x20, 0x63, 0x61, 0x6E, 0x6E, 0x6F
    db 0x74, 0x20, 0x62, 0x65, 0x20, 0x72, 0x75, 0x6E
    db 0x20, 0x69, 0x6E, 0x20, 0x44, 0x4F, 0x53, 0x20
    db 0x6D, 0x6F, 0x64, 0x65, 0x2E, 0x0D, 0x0D, 0x0A
    db 0x24, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; COFF Header
COFFHeader:  
    db 0x50, 0x45, 0x00, 0x00   ; PE File signature
    db 0x64, 0x86               ; Machine (AMD64)
    db 0x01, 0x00               ; Number of sections

    db 0x00, 0x00, 0x00, 0x00   ; Time date stamp
    db 0x00, 0x00, 0x00, 0x00   ; Pointer to symbol table

    db 0x00, 0x00, 0x00, 0x00   ; Number of symbols
    ;db 0xF0, 0x00              ; Size of optional header
    dw optionalheadersize       ; Size of optional header

    db 0x22, 0x00               ; Characteristics (Exe & Large address aware)

; Optional Header
OptionalHeader:
    db 0x0B, 0x02               ; Optional header magic number (PE32+)
    db 0x00                     ; Major linker version
    db 0x01                     ; Minor linker version
    ;db 0x00, 0x00, 0x00, 0x00  ; Size of code (sum of all sections)
    dd codesize                 ; Size of code (sum of all sections)

    db 0x00, 0x00, 0x00, 0x00   ; Size of initialized data (.data section)
    db 0x00, 0x00, 0x00, 0x00   ; Size of uninitialized data (.bss section)

    ;db 0x00, 0x00, 0x00, 0x00  ; Address of entry point
    dd main                     ; Address of entry point
    ;db 0x00, 0x00, 0x00, 0x00  ; Base of code
    dd code                     ; Base of code

; Windows specific field
    db 0x00, 0x00, 0x00, 0x40, 0x01, 0x00, 0x00, 0x00   ; Image base (PE32+)

    db 0x00, 0x02, 0x00, 0x00   ; Section alignment (0x200 : 512 bytes)
    db 0x00, 0x02, 0x00, 0x00   ; File alignment (0x200 : 512 bytes)

    db 0x06, 0x00               ; Major operating system version
    db 0x00, 0x00               ; Minor operating system version
    db 0x00, 0x00               ; Major image version
    db 0x00, 0x00               ; Minor image version

    db 0x06, 0x00               ; Major subsystem version
    db 0x00, 0x00               ; Minor subsystem version
    db 0x00, 0x00, 0x00, 0x00   ; Win32 version value

    ;db 0x00, 0x00, 0x00, 0x00  ; Size of image
    dd filesize                 ; Size of image
    ;db 0x00, 0x00, 0x00, 0x00  ; Size of headers
    dd headersize               ; Size of headers

    db 0x00, 0x00, 0x00, 0x00   ; Image file checksum
    db 0x03, 0x00               ; Subsystem (02 : Window, 03 : Console)
    ; DLL Characteristics
    ; (Terminal server aware, NX compatible, Dynamic base, High entropy VA)
    db 0x60, 0x81

    db 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00   ; Size of stack reserve

    db 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   ; Size of stack commit

    db 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00   ; Size of heap reserve

    db 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   ; Size of heap commit

    db 0x00, 0x00, 0x00, 0x00   ; Loader flags
    db 0x10, 0x00, 0x00, 0x00   ; Number of RVA and sizes (16 data-directory)

; Data-directory entries
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

optionalheadersize equ ($ - OptionalHeader)


; Section table
SectionTable:
    db 0x2E, 0x74, 0x65, 0x78, 0x74, 0x00, 0x00, 0x00   ; Name ".text\0\0\0"

    ;db 0x00, 0x00, 0x00, 0x00  ; Virtual size
    dd codesize                 ; Virtual size
    ;db 0x00, 0x00, 0x00, 0x00  ; Virtual address
    dd headersize               ; Virtual address

    ;db 0x00, 0x00, 0x00, 0x00  ; Size of raw data
    dd codesize                 ; Size of raw data
    ;db 0x00, 0x00, 0x00, 0x00  ; Pointer to raw data
    dd code                     ; Pointer to raw data

    db 0x00, 0x00, 0x00, 0x00   ; Pointer to relocations
    db 0x00, 0x00, 0x00, 0x00   ; Pointer to line numbers

    db 0x00, 0x00               ; Number of relocations
    db 0x00, 0x00               ; Number of line numbers
    db 0x20, 0x00, 0x00, 0x60   ; Characteristics (code, read, execute)


; Align section
align 0x200, db 0x00    ; Align to 512 bytes


; Total binary headers size
headersize equ ($ - $$)


; Code section
code:

; Main entry point
main:

    xor eax, eax
    ret


; Align section
align 0x200, db 0x00    ; Align to 512 bytes


; Binary code size
codesize equ ($ - code)

; Total binary file size
filesize equ ($ - $$)
