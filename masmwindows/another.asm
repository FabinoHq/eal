; Another
Another:
    ; Stack push
    sub rsp, 40h

    ; Call read
    mov r8d, 6 ; Size
    xor ecx, ecx ; FD
    lea rdx, qword ptr test_char ; Str address
    call _read

    ; Call write
    mov r8d, 6 ; Size
    mov ecx, 1 ; FD
    lea rdx, qword ptr test_char ; Str address
    call _write

    ; Stack pop
    add rsp, 40h

    ; Return
    ret
