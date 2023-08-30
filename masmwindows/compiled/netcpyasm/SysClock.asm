; Listing generated by Microsoft (R) Optimizing Compiler Version 19.37.32822.0 

include listing.inc

INCLUDELIB OLDNAMES

PUBLIC	?getAndReset@SysClock@@QEAANXZ			; SysClock::getAndReset
PUBLIC	??1SysClock@@QEAA@XZ				; SysClock::~SysClock
PUBLIC	??0SysClock@@QEAA@XZ				; SysClock::SysClock
;	COMDAT pdata
pdata	SEGMENT
$pdata$?getAndReset@SysClock@@QEAANXZ DD imagerel $LN57
	DD	imagerel $LN57+192
	DD	imagerel $unwind$?getAndReset@SysClock@@QEAANXZ
pdata	ENDS
;	COMDAT pdata
pdata	SEGMENT
$pdata$??0SysClock@@QEAA@XZ DD imagerel $LN18
	DD	imagerel $LN18+103
	DD	imagerel $unwind$??0SysClock@@QEAA@XZ
;	COMDAT xdata
xdata	SEGMENT
$unwind$??0SysClock@@QEAA@XZ DD 040a01H
	DD	06340aH
	DD	07006320aH
xdata	ENDS
;	COMDAT xdata
xdata	SEGMENT
$unwind$?getAndReset@SysClock@@QEAANXZ DD 060f01H
	DD	02680fH
	DD	08340aH
	DD	07006520aH
; Function compile flags: /Ogtpy
;	COMDAT ??0SysClock@@QEAA@XZ
_TEXT	SEGMENT
this$ = 48
??0SysClock@@QEAA@XZ PROC				; SysClock::SysClock, COMDAT
; File D:\Dev\GitHub\vtools\netcpy\System\SysClock.cpp
; Line 50
$LN18:
	mov	QWORD PTR [rsp+8], rbx
	push	rdi
	sub	rsp, 32					; 00000020H
	mov	rbx, rcx
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\__msvc_chrono.hpp
; Line 670
	call	_Query_perf_frequency
	mov	rdi, rax
; Line 671
	call	_Query_perf_counter
; Line 677
	cmp	rdi, 10000000				; 00989680H
	jne	SHORT $LN4@SysClock
; Line 680
	imul	rax, rax, 100				; 00000064H
; File D:\Dev\GitHub\vtools\netcpy\System\SysClock.cpp
; Line 52
	mov	QWORD PTR [rbx], rax
	mov	rax, rbx
	mov	rbx, QWORD PTR [rsp+48]
	add	rsp, 32					; 00000020H
	pop	rdi
	ret	0
$LN4@SysClock:
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\__msvc_chrono.hpp
; Line 688
	cdq
	idiv	rdi
	mov	rcx, rax
	imul	rax, rdx, 1000000000			; 3b9aca00H
	imul	rcx, rcx, 1000000000			; 3b9aca00H
	cdq
	idiv	rdi
; Line 689
	add	rax, rcx
; File D:\Dev\GitHub\vtools\netcpy\System\SysClock.cpp
; Line 52
	mov	QWORD PTR [rbx], rax
	mov	rax, rbx
	mov	rbx, QWORD PTR [rsp+48]
	add	rsp, 32					; 00000020H
	pop	rdi
	ret	0
??0SysClock@@QEAA@XZ ENDP				; SysClock::SysClock
_TEXT	ENDS
; Function compile flags: /Ogtpy
;	COMDAT ??1SysClock@@QEAA@XZ
_TEXT	SEGMENT
this$ = 8
??1SysClock@@QEAA@XZ PROC				; SysClock::~SysClock, COMDAT
; File D:\Dev\GitHub\vtools\netcpy\System\SysClock.cpp
; Line 60
	ret	0
??1SysClock@@QEAA@XZ ENDP				; SysClock::~SysClock
_TEXT	ENDS
; Function compile flags: /Ogtpy
;	COMDAT ?getAndReset@SysClock@@QEAANXZ
_TEXT	SEGMENT
this$ = 64
?getAndReset@SysClock@@QEAANXZ PROC			; SysClock::getAndReset, COMDAT
; File D:\Dev\GitHub\vtools\netcpy\System\SysClock.cpp
; Line 67
$LN57:
	mov	QWORD PTR [rsp+8], rbx
	push	rdi
	sub	rsp, 48					; 00000030H
	movaps	XMMWORD PTR [rsp+32], xmm6
	mov	rbx, rcx
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\__msvc_chrono.hpp
; Line 670
	call	_Query_perf_frequency
	mov	rdi, rax
; Line 671
	call	_Query_perf_counter
; Line 677
	cmp	rdi, 10000000				; 00989680H
	jne	SHORT $LN4@getAndRese
; Line 680
	imul	rax, rax, 100				; 00000064H
	jmp	SHORT $LN5@getAndRese
$LN4@getAndRese:
; Line 688
	cdq
	idiv	rdi
	mov	rcx, rax
	imul	rax, rdx, 1000000000			; 3b9aca00H
	imul	rcx, rcx, 1000000000			; 3b9aca00H
	cdq
	idiv	rdi
; Line 689
	add	rax, rcx
$LN5@getAndRese:
; Line 212
	sub	rax, QWORD PTR [rbx]
	xorps	xmm6, xmm6
; Line 99
	cvtsi2sd xmm6, rax
; File D:\Dev\GitHub\vtools\netcpy\System\SysClock.cpp
; Line 68
	mulsd	xmm6, QWORD PTR __real@3e112e0be826d695
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\__msvc_chrono.hpp
; Line 670
	call	_Query_perf_frequency
	mov	rdi, rax
; Line 671
	call	_Query_perf_counter
; Line 677
	movaps	xmm0, xmm6
	cmp	rdi, 10000000				; 00989680H
	jne	SHORT $LN42@getAndRese
; Line 680
	imul	rax, rax, 100				; 00000064H
; File D:\Dev\GitHub\vtools\netcpy\System\SysClock.cpp
; Line 72
	mov	QWORD PTR [rbx], rax
	mov	rbx, QWORD PTR [rsp+64]
	movaps	xmm6, XMMWORD PTR [rsp+32]
	add	rsp, 48					; 00000030H
	pop	rdi
	ret	0
$LN42@getAndRese:
	movaps	xmm6, XMMWORD PTR [rsp+32]
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\__msvc_chrono.hpp
; Line 688
	cdq
	idiv	rdi
	mov	rcx, rax
	imul	rax, rdx, 1000000000			; 3b9aca00H
	imul	rcx, rcx, 1000000000			; 3b9aca00H
	cdq
	idiv	rdi
; Line 689
	add	rax, rcx
; File D:\Dev\GitHub\vtools\netcpy\System\SysClock.cpp
; Line 72
	mov	QWORD PTR [rbx], rax
	mov	rbx, QWORD PTR [rsp+64]
	add	rsp, 48					; 00000030H
	pop	rdi
	ret	0
?getAndReset@SysClock@@QEAANXZ ENDP			; SysClock::getAndReset
_TEXT	ENDS
END