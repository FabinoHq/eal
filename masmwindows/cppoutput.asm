; Listing generated by Microsoft (R) Optimizing Compiler Version 19.36.32537.0 

include listing.inc

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

CONST	SEGMENT
$SG3675	DB	'Test', 0aH, 00H
CONST	ENDS
PUBLIC	?StringLength@@YAHPEBD@Z			; StringLength
PUBLIC	main
EXTRN	_write:PROC
EXTRN	__GSHandlerCheck:PROC
EXTRN	__security_check_cookie:PROC
EXTRN	__security_cookie:QWORD
;	COMDAT pdata
pdata	SEGMENT
$pdata$?StringLength@@YAHPEBD@Z DD imagerel $LN5
	DD	imagerel $LN5+51
	DD	imagerel $unwind$?StringLength@@YAHPEBD@Z
pdata	ENDS
pdata	SEGMENT
$pdata$main DD	imagerel $LN3
	DD	imagerel $LN3+97
	DD	imagerel $unwind$main
pdata	ENDS
voltbl	SEGMENT
_volmd	DD	0ffffffffH
	DDSymXIndex: 	FLAT:main
	DD	011H
	DD	04dH
voltbl	ENDS
xdata	SEGMENT
$unwind$main DD	031619H
	DD	070036207H
	DD	06002H
	DD	imagerel __GSHandlerCheck
	DD	028H
xdata	ENDS
;	COMDAT xdata
xdata	SEGMENT
$unwind$?StringLength@@YAHPEBD@Z DD 010901H
	DD	02209H
xdata	ENDS
; Function compile flags: /Odtp
_TEXT	SEGMENT
ch$ = 32
__$ArrayPad$ = 40
main	PROC
; File D:\Dev\eal\asmwindows\main.cpp
; Line 23
$LN3:
	push	rsi
	push	rdi
	sub	rsp, 56					; 00000038H
	mov	rax, QWORD PTR __security_cookie
	xor	rax, rsp
	mov	QWORD PTR __$ArrayPad$[rsp], rax
; Line 24
	lea	rax, QWORD PTR ch$[rsp]
	lea	rcx, OFFSET FLAT:$SG3675
	mov	rdi, rax
	mov	rsi, rcx
	mov	ecx, 6
	rep movsb
; Line 25
	lea	rcx, QWORD PTR ch$[rsp]
	call	?StringLength@@YAHPEBD@Z		; StringLength
	mov	r8d, eax
	lea	rdx, QWORD PTR ch$[rsp]
	mov	ecx, 1
	call	_write
; Line 28
	xor	eax, eax
; Line 29
	mov	rcx, QWORD PTR __$ArrayPad$[rsp]
	xor	rcx, rsp
	call	__security_check_cookie
	add	rsp, 56					; 00000038H
	pop	rdi
	pop	rsi
	ret	0
main	ENDP
_TEXT	ENDS
; Function compile flags: /Odtp
;	COMDAT ?StringLength@@YAHPEBD@Z
_TEXT	SEGMENT
i$ = 0
array$ = 32
?StringLength@@YAHPEBD@Z PROC				; StringLength, COMDAT
; File D:\Dev\eal\asmwindows\main.cpp
; Line 16
$LN5:
	mov	QWORD PTR [rsp+8], rcx
	sub	rsp, 24
; Line 17
	mov	DWORD PTR i$[rsp], -1
$LN2@StringLeng:
; Line 18
	mov	eax, DWORD PTR i$[rsp]
	inc	eax
	mov	DWORD PTR i$[rsp], eax
	movsxd	rax, DWORD PTR i$[rsp]
	mov	rcx, QWORD PTR array$[rsp]
	movsx	eax, BYTE PTR [rcx+rax]
	test	eax, eax
	je	SHORT $LN3@StringLeng
	jmp	SHORT $LN2@StringLeng
$LN3@StringLeng:
; Line 19
	mov	eax, DWORD PTR i$[rsp]
; Line 20
	add	rsp, 24
	ret	0
?StringLength@@YAHPEBD@Z ENDP				; StringLength
_TEXT	ENDS
END