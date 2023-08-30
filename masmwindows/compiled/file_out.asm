; CPP
; #include <fcntl.h>
; #include <io.h>
; //#include <cstdint>
; //#include <cstddef>
; //#include <sys/types.h>
; #include <sys/stat.h>


; #define FILE_OPEN _open
; #define FILE_CLOSE _close
; #define FILE_READ _read
; #define FILE_WRITE _write
; #define FILE_FLUSH _commit

; #define FILE_FLAG_READONLY _O_RDONLY
; #define FILE_FLAG_WRITEONLY _O_WRONLY
; #define FILE_FLAG_CREATE _O_CREAT

; #define FILE_MODE_READ _S_IREAD
; #define FILE_MODE_WRITE _S_IWRITE


; int main()
; {
;     char ch = 't';
;     //CONSOLE_WRITE(CONSOLE_OUTPUT_FILEDESC, &ch, 1);
;     //CONSOLE_FLUSH(CONSOLE_OUTPUT_FILEDESC);
;     //char ch = 0;
;     //CONSOLE_READ(CONSOLE_INPUT_FILEDESC, &ch, 1);

;     // File
;     int m_handle = -1;

;     // Open file
;     m_handle = FILE_OPEN("out.txt", _O_WRONLY | _O_CREAT, _S_IWRITE);
;     if (m_handle == -1)
;     {
;         // Could not open file
;         return false;
;     }

;     FILE_WRITE(m_handle, &ch, 1);

;     if (m_handle != -1) { FILE_CLOSE(m_handle); }
;     m_handle = -1;
;     return 0;
; }


; Listing generated by Microsoft (R) Optimizing Compiler Version 19.36.32537.0 

include listing.inc

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	?_open@@YAHQEBDHH@Z				; _open
PUBLIC	main
EXTRN	_close:PROC
EXTRN	_write:PROC
EXTRN	_sopen_dispatch:PROC



CONST	SEGMENT
filepathstr DB 'out.txt', 00H		; `string'
CONST	ENDS
;	COMDAT xdata
xdata	SEGMENT
$unwind$main DD	020601H
	DD	030025206H
xdata	ENDS
;	COMDAT xdata
xdata	SEGMENT
$unwind$?_open@@YAHQEBDHH@Z DD 010401H
	DD	06204H
xdata	ENDS

; Function compile flags: /Ogtpy
;	COMDAT main
_TEXT	SEGMENT
ch$ = 64
_FileHandle$1 = 72

main	PROC						; COMDAT
; File D:\Dev\eal\asmwindows\main.cpp
; Line 24
$LN10:
	push	rbx
	sub	rsp, 48					; 00000030H
; File C:\Program Files (x86)\Windows Kits\10\include\10.0.22000.0\ucrt\corecrt_io.h
; Line 400
	mov	r9d, 128				; 00000080H
	mov	DWORD PTR [rsp+40], 0
	lea	rax, QWORD PTR _FileHandle$1[rsp]
; File D:\Dev\eal\asmwindows\main.cpp
; Line 25
	mov	BYTE PTR ch$[rsp], 116			; 00000074H
; File C:\Program Files (x86)\Windows Kits\10\include\10.0.22000.0\ucrt\corecrt_io.h
; Line 400
	mov	edx, 257				; 00000101H
	mov	QWORD PTR [rsp+32], rax
	lea	rcx, offset filepathstr
	lea	r8d, QWORD PTR [r9-64]
	call	_sopen_dispatch
; Line 401
	mov	ebx, DWORD PTR _FileHandle$1[rsp]
	test	eax, eax
	mov	ecx, -1
	cmovne	ebx, ecx
; File D:\Dev\eal\asmwindows\main.cpp
; Line 36
	cmp	ebx, ecx
	je	SHORT $LN8@main
; Line 42
	lea	r8d, QWORD PTR [rcx+2]
	mov	ecx, ebx
	lea	rdx, QWORD PTR ch$[rsp]
	call	_write
; Line 44
	mov	ecx, ebx
	call	_close
$LN8@main:
; Line 47
	xor	eax, eax
	add	rsp, 48					; 00000030H
	pop	rbx
	ret	0
main	ENDP
_TEXT	ENDS
; Function compile flags: /Ogtpy
;	COMDAT ?_open@@YAHQEBDHH@Z
_TEXT	SEGMENT
_FileName$ = 64
_OFlag$ = 72
_PMode$ = 80
_FileHandle$ = 88
?_open@@YAHQEBDHH@Z PROC				; _open, COMDAT
; File C:\Program Files (x86)\Windows Kits\10\include\10.0.22000.0\ucrt\corecrt_io.h
; Line 397
$LN4:
	sub	rsp, 56					; 00000038H
; Line 400
	lea	rax, QWORD PTR _FileHandle$[rsp]
	mov	DWORD PTR [rsp+40], 0
	mov	r9d, r8d
	mov	QWORD PTR [rsp+32], rax
	mov	r8d, 64					; 00000040H
	call	_sopen_dispatch
; Line 401
	mov	ecx, DWORD PTR _FileHandle$[rsp]
	test	eax, eax
	mov	edx, -1
	cmovne	ecx, edx
	mov	eax, ecx
; Line 402
	add	rsp, 56					; 00000038H
	ret	0
?_open@@YAHQEBDHH@Z ENDP				; _open
_TEXT	ENDS
END
