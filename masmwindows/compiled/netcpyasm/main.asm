; Listing generated by Microsoft (R) Optimizing Compiler Version 19.37.32822.0 

include listing.inc

INCLUDELIB OLDNAMES

EXTRN	__security_check_cookie:PROC
PUBLIC	?__autoclassinit2@Netcpy@@QEAAX_K@Z		; Netcpy::__autoclassinit2
PUBLIC	main
PUBLIC	__real@34000000
PUBLIC	__real@3cb0000000000000
PUBLIC	__real@3e112e0be826d695
PUBLIC	__real@3eb0c6f7a0b5ed8d
PUBLIC	__real@3f50624dd2f1a9fc
PUBLIC	__real@3fe0000000000000
PUBLIC	__real@4059000000000000
PUBLIC	__real@408f400000000000
PUBLIC	__real@412e848000000000
PUBLIC	__real@41cdcd6500000000
PUBLIC	__real@4202a05f20000000
PUBLIC	__real@43088e6d68b00000
PUBLIC	__xmm@00000000000000000000000200000000
PUBLIC	__xmm@0000000000000000ffffffffffffffff
PUBLIC	__xmm@000000000000000f0000000000000000
PUBLIC	__xmm@7fffffffffffffff7fffffffffffffff
EXTRN	__GSHandlerCheck:PROC
EXTRN	memcpy:PROC
EXTRN	memmove:PROC
EXTRN	memset:PROC
EXTRN	__ImageBase:BYTE
EXTRN	__security_cookie:QWORD
EXTRN	_fltused:DWORD
EXTRN	_tls_index:DWORD
;	COMDAT pdata
pdata	SEGMENT
$pdata$main DD	imagerel $LN115
	DD	imagerel $LN115+511
	DD	imagerel $unwind$main
;	COMDAT __xmm@7fffffffffffffff7fffffffffffffff
CONST	SEGMENT
__xmm@7fffffffffffffff7fffffffffffffff DB 0ffH, 0ffH, 0ffH, 0ffH, 0ffH, 0ffH
	DB	0ffH, 07fH, 0ffH, 0ffH, 0ffH, 0ffH, 0ffH, 0ffH, 0ffH, 07fH
CONST	ENDS
;	COMDAT __xmm@000000000000000f0000000000000000
CONST	SEGMENT
__xmm@000000000000000f0000000000000000 DB 00H, 00H, 00H, 00H, 00H, 00H, 00H
	DB	00H, 0fH, 00H, 00H, 00H, 00H, 00H, 00H, 00H
CONST	ENDS
;	COMDAT __xmm@0000000000000000ffffffffffffffff
CONST	SEGMENT
__xmm@0000000000000000ffffffffffffffff DB 0ffH, 0ffH, 0ffH, 0ffH, 0ffH, 0ffH
	DB	0ffH, 0ffH, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
CONST	ENDS
;	COMDAT __xmm@00000000000000000000000200000000
CONST	SEGMENT
__xmm@00000000000000000000000200000000 DB 00H, 00H, 00H, 00H, 02H, 00H, 00H
	DB	00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
CONST	ENDS
;	COMDAT __real@43088e6d68b00000
CONST	SEGMENT
__real@43088e6d68b00000 DQ 043088e6d68b00000r	; 8.64e+14
CONST	ENDS
;	COMDAT __real@4202a05f20000000
CONST	SEGMENT
__real@4202a05f20000000 DQ 04202a05f20000000r	; 1e+10
CONST	ENDS
;	COMDAT __real@41cdcd6500000000
CONST	SEGMENT
__real@41cdcd6500000000 DQ 041cdcd6500000000r	; 1e+09
CONST	ENDS
;	COMDAT __real@412e848000000000
CONST	SEGMENT
__real@412e848000000000 DQ 0412e848000000000r	; 1e+06
CONST	ENDS
;	COMDAT __real@408f400000000000
CONST	SEGMENT
__real@408f400000000000 DQ 0408f400000000000r	; 1000
CONST	ENDS
;	COMDAT __real@4059000000000000
CONST	SEGMENT
__real@4059000000000000 DQ 04059000000000000r	; 100
CONST	ENDS
;	COMDAT __real@3fe0000000000000
CONST	SEGMENT
__real@3fe0000000000000 DQ 03fe0000000000000r	; 0.5
CONST	ENDS
;	COMDAT __real@3f50624dd2f1a9fc
CONST	SEGMENT
__real@3f50624dd2f1a9fc DQ 03f50624dd2f1a9fcr	; 0.001
CONST	ENDS
;	COMDAT __real@3eb0c6f7a0b5ed8d
CONST	SEGMENT
__real@3eb0c6f7a0b5ed8d DQ 03eb0c6f7a0b5ed8dr	; 1e-06
CONST	ENDS
;	COMDAT __real@3e112e0be826d695
CONST	SEGMENT
__real@3e112e0be826d695 DQ 03e112e0be826d695r	; 1e-09
CONST	ENDS
;	COMDAT __real@3cb0000000000000
CONST	SEGMENT
__real@3cb0000000000000 DQ 03cb0000000000000r	; 2.22045e-16
CONST	ENDS
;	COMDAT __real@34000000
CONST	SEGMENT
__real@34000000 DD 034000000r			; 1.19209e-07
CONST	ENDS
;	COMDAT xdata
xdata	SEGMENT
$unwind$main DD	092819H
	DD	01c641aH
	DD	01a341aH
	DD	016011aH
	DD	0700ce00eH
	DD	0500bH
	DD	imagerel __GSHandlerCheck
	DD	0a0H
xdata	ENDS
; Function compile flags: /Ogtpy
;	COMDAT main
_TEXT	SEGMENT
netcpy$ = 32
__$ArrayPad$ = 160
argc$ = 208
argv$ = 216
main	PROC						; COMDAT
; File D:\Dev\GitHub\vtools\netcpy\main.cpp
; Line 50
$LN115:
	mov	QWORD PTR [rsp+8], rbx
	mov	QWORD PTR [rsp+24], rsi
	push	rbp
	push	rdi
	push	r14
	lea	rbp, QWORD PTR [rsp-71]
	sub	rsp, 176				; 000000b0H
	mov	rax, QWORD PTR __security_cookie
	xor	rax, rsp
	mov	QWORD PTR __$ArrayPad$[rbp-105], rax
	xorps	xmm0, xmm0
; File D:\Dev\GitHub\vtools\netcpy\Network\IPAddress.cpp
; Line 51
	xor	r14d, r14d
	movups	XMMWORD PTR netcpy$[rbp-89], xmm0
	xor	eax, eax
	mov	DWORD PTR netcpy$[rbp-89], r14d
	movups	XMMWORD PTR netcpy$[rbp-105], xmm0
; File D:\Dev\GitHub\vtools\netcpy\main.cpp
; Line 50
	mov	rsi, rdx
	mov	edi, ecx
	movups	XMMWORD PTR netcpy$[rbp-73], xmm0
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xstring
; Line 2540
	xor	r8d, r8d
	lea	rdx, OFFSET FLAT:??_C@_00CNPNBAHC@@
	movups	XMMWORD PTR netcpy$[rbp-57], xmm0
	lea	rcx, QWORD PTR netcpy$[rbp-65]
; File D:\Dev\GitHub\vtools\netcpy\Network\TCPSocket.cpp
; Line 49
	mov	QWORD PTR netcpy$[rbp-105], -1
	movups	XMMWORD PTR netcpy$[rbp-41], xmm0
	mov	QWORD PTR netcpy$[rbp-97], -1
; File D:\Dev\GitHub\vtools\netcpy\Netcpy.cpp
; Line 52
	mov	WORD PTR netcpy$[rbp-85], r14w
; Line 53
	mov	QWORD PTR netcpy$[rbp-81], r14
; Line 54
	mov	BYTE PTR netcpy$[rbp-73], al
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xstring
; Line 2284
	movups	XMMWORD PTR netcpy$[rbp-65], xmm0
; Line 2293
	mov	QWORD PTR netcpy$[rbp-49], r14
; Line 2294
	mov	QWORD PTR netcpy$[rbp-41], r14
	movups	XMMWORD PTR netcpy$[rbp-25], xmm0
	mov	QWORD PTR netcpy$[rbp+7], rax
	movups	XMMWORD PTR netcpy$[rbp-9], xmm0
; Line 2540
	call	??$_Construct@$00PEBD@?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@AEAAXQEBD_K@Z ; std::basic_string<char,std::char_traits<char>,std::allocator<char> >::_Construct<1,char const *>
; File D:\Dev\GitHub\vtools\netcpy\Netcpy.cpp
; Line 56
	mov	QWORD PTR netcpy$[rbp-33], r14
; Line 57
	mov	QWORD PTR netcpy$[rbp-25], r14
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\__msvc_chrono.hpp
; Line 670
	call	_Query_perf_frequency
	mov	rbx, rax
; Line 671
	call	_Query_perf_counter
; Line 677
	cmp	rbx, 10000000				; 00989680H
	jne	SHORT $LN32@main
; Line 680
	imul	rax, rax, 100				; 00000064H
	jmp	SHORT $LN108@main
$LN32@main:
; Line 688
	cdq
	idiv	rbx
	mov	rcx, rax
	imul	rax, rdx, 1000000000			; 3b9aca00H
	imul	rcx, rcx, 1000000000			; 3b9aca00H
	cdq
	idiv	rbx
; Line 689
	add	rax, rcx
$LN108@main:
; Line 670
	mov	QWORD PTR netcpy$[rbp-17], rax
	call	_Query_perf_frequency
	mov	rbx, rax
; Line 671
	call	_Query_perf_counter
; Line 677
	cmp	rbx, 10000000				; 00989680H
	jne	SHORT $LN46@main
; Line 680
	imul	rax, rax, 100				; 00000064H
	jmp	SHORT $LN109@main
$LN46@main:
; Line 688
	cdq
	idiv	rbx
	mov	rcx, rax
	imul	rax, rdx, 1000000000			; 3b9aca00H
	imul	rcx, rcx, 1000000000			; 3b9aca00H
	cdq
	idiv	rbx
; Line 689
	add	rax, rcx
$LN109@main:
; File D:\Dev\GitHub\vtools\netcpy\Netcpy.cpp
; Line 61
	mov	QWORD PTR netcpy$[rbp-9], rax
	xorps	xmm0, xmm0
; File D:\Dev\GitHub\vtools\netcpy\main.cpp
; Line 53
	lea	rcx, QWORD PTR netcpy$[rbp-105]
; File D:\Dev\GitHub\vtools\netcpy\Netcpy.cpp
; Line 61
	movups	XMMWORD PTR netcpy$[rbp-1], xmm0
; File D:\Dev\GitHub\vtools\netcpy\main.cpp
; Line 53
	cmp	edi, 2
	jl	SHORT $LN2@main
; Line 56
	mov	rdx, QWORD PTR [rsi+8]
	jmp	SHORT $LN111@main
$LN2@main:
; Line 66
	xor	edx, edx
$LN111@main:
	call	?launch@Netcpy@@QEAA_NPEAD@Z		; Netcpy::launch
	mov	ebx, 1
	test	al, al
	je	SHORT $LN8@main
; Line 78
	mov	ebx, r14d
$LN8@main:
; File D:\Dev\GitHub\vtools\netcpy\Netcpy.cpp
; Line 72
	call	?box@SysMessage@@SAAEAV1@XZ		; SysMessage::box
	mov	rcx, rax
	call	?display@SysMessage@@QEAAXXZ		; SysMessage::display
	mov	rcx, QWORD PTR netcpy$[rbp-81]
	test	rcx, rcx
	je	SHORT $LN58@main
	call	??_V@YAXPEAX@Z				; operator delete[]
$LN58@main:
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xstring
; Line 2244
	mov	rdx, QWORD PTR netcpy$[rbp-41]
; File D:\Dev\GitHub\vtools\netcpy\Netcpy.cpp
; Line 73
	mov	QWORD PTR netcpy$[rbp-81], r14
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xstring
; Line 2244
	cmp	rdx, 16
; Line 4832
	jb	SHORT $LN82@main
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xmemory
; Line 969
	mov	rcx, QWORD PTR netcpy$[rbp-65]
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xstring
; Line 4838
	inc	rdx
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xmemory
; Line 969
	mov	rax, rcx
; Line 261
	cmp	rdx, 4096				; 00001000H
	jb	SHORT $LN81@main
; Line 160
	mov	rcx, QWORD PTR [rcx-8]
	add	rdx, 39					; 00000027H
	sub	rax, rcx
; Line 174
	add	rax, -8
	cmp	rax, 31
	ja	SHORT $LN113@main
$LN81@main:
; Line 265
	call	??3@YAXPEAX_K@Z				; operator delete
$LN82@main:
; File D:\Dev\GitHub\vtools\netcpy\Network\TCPSocket.cpp
; Line 126
	mov	rcx, QWORD PTR netcpy$[rbp-97]
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xstring
; Line 4841
	mov	QWORD PTR netcpy$[rbp-49], r14
; Line 4842
	mov	QWORD PTR netcpy$[rbp-41], 15
; Line 4844
	mov	BYTE PTR netcpy$[rbp-65], r14b
; File D:\Dev\GitHub\vtools\netcpy\Netcpy.cpp
; Line 74
	mov	DWORD PTR netcpy$[rbp-89], r14d
; File D:\Dev\GitHub\vtools\netcpy\Network\TCPSocket.cpp
; Line 126
	cmp	rcx, -1
	je	SHORT $LN90@main
; Line 129
	call	QWORD PTR __imp_closesocket
$LN90@main:
; Line 126
	mov	rcx, QWORD PTR netcpy$[rbp-105]
; Line 135
	mov	QWORD PTR netcpy$[rbp-97], -1
; Line 126
	cmp	rcx, -1
	je	SHORT $LN95@main
; Line 129
	call	QWORD PTR __imp_closesocket
$LN95@main:
; File D:\Dev\GitHub\vtools\netcpy\main.cpp
; Line 78
	mov	eax, ebx
; Line 79
	mov	rcx, QWORD PTR __$ArrayPad$[rbp-105]
	xor	rcx, rsp
	call	__security_check_cookie
	lea	r11, QWORD PTR [rsp+176]
	mov	rbx, QWORD PTR [r11+32]
	mov	rsi, QWORD PTR [r11+48]
	mov	rsp, r11
	pop	r14
	pop	rdi
	pop	rbp
	ret	0
$LN113@main:
; File C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.37.32822\include\xmemory
; Line 174
	call	_invalid_parameter_noinfo_noreturn
	int	3
$LN107@main:
main	ENDP
_TEXT	ENDS
; Function compile flags: /Ogtpy
;	COMDAT ?__autoclassinit2@Netcpy@@QEAAX_K@Z
_TEXT	SEGMENT
this$ = 8
classSize$dead$ = 16
?__autoclassinit2@Netcpy@@QEAAX_K@Z PROC		; Netcpy::__autoclassinit2, COMDAT
	xorps	xmm0, xmm0
	xor	eax, eax
	movups	XMMWORD PTR [rcx], xmm0
	movups	XMMWORD PTR [rcx+16], xmm0
	movups	XMMWORD PTR [rcx+32], xmm0
	movups	XMMWORD PTR [rcx+48], xmm0
	movups	XMMWORD PTR [rcx+64], xmm0
	movups	XMMWORD PTR [rcx+80], xmm0
	movups	XMMWORD PTR [rcx+96], xmm0
	mov	QWORD PTR [rcx+112], rax
	ret	0
?__autoclassinit2@Netcpy@@QEAAX_K@Z ENDP		; Netcpy::__autoclassinit2
_TEXT	ENDS
END
