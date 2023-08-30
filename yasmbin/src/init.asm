; Boot init address
; Must be multiple of 0x0200 (512 bytes)
BOOTINIT_ADDR equ 0x0800

; Boot init offset
; Offset in bytes from the boot sector
BOOTINIT_OFFSET equ (BOOTINIT_ADDR - BOOTSECTOR_ADDR)

; Boot init size
; Must be multiple of 0x0200 (512 bytes)
; Must be less than 0x7000
BOOTINIT_SIZE equ 0x0800

; Boot init start sector
; Start sector for disk load
BOOTINIT_START_SECTOR equ ((BOOTINIT_ADDR - BOOTSECTOR_ADDR)/512)

; Boot init magic number
; To check boot init copy
BOOTINIT_MAGIC equ 0x42FC


; Stack address
STACK_ADDR equ 0x00090000

; Page address
PAGE_ADDR equ 0x00008000
PAGE_SIZE equ 0x00006000
PAGE_SIZE_DQ equ (PAGE_SIZE/4)
; Page Map Level 4 [0x8000 - 0x9000]
; Page Directory Pointer Table [0x9000 - 0xA000]
; Page Directories x4 [0xA000 - 0xE000]

; Memory map address
MEMORYMAP_ADDR equ 0x00010000

; GDT segments refs
CODE_SEG equ (init.gdt_code - init.gdt_start)
DATA_SEG equ (init.gdt_data - init.gdt_start)



; Fill with 0x00 until boot init address
times BOOTINIT_OFFSET-($-$$) db 0x00


; Boot init
; Loaded at [BOOTINIT_ADDR]
[bits 16]
align 8

init:
; Boot init magic number
.initmagic:	dw BOOTINIT_MAGIC

; Start init
.start:

    ; Disable NMI (Non maskable interrupts)
    in al, 0x70     ; Read port 0x70
    or al, 0x80     ; Disable NMI
    ;and al, 0x7F    ; Enable NMI
    out 0x70, al    ; Write port 0x70

    ; Clear interrupts
    cli

    ; Clear direction flag
    cld


; Check A20 line
.check_a20:

    ; Move 0x0000 into es and 0xFFFF into ds
    xor ax, ax
    mov es, ax
    mov ax, 0xFFFF
    mov ds, ax

    ; Move 0x0500 into di and 0x0510 into si
    mov di, 0x0500
    mov si, 0x0510

    mov al, byte [es:di]
    push ax
    mov al, byte [ds:si]
    push ax

    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF

    ; Compare es:di with 0xFF
    cmp byte [es:di], 0xFF

    pop ax
    mov byte [ds:si], al
    pop ax
    mov byte [es:di], al

    mov ax, 0x00
    jne .a20enabled

        ; A20 line is disabled
        ; Reset segment registers
        xor ax, ax
        mov ds, ax  ; 0x0000
        mov es, ax  ; 0x0000

        ; A20 line error
        mov si, .a20_err
        call boot.bios_print
        call boot.bios_reboot

    .a20enabled:

    ; Reset segment registers
    xor ax, ax
    mov ds, ax  ; 0x0000
    mov es, ax  ; 0x0000


; Memory mapping using bios
.memory_map:

    xor ebp, ebp                        ; Entry count in ebp
    mov esi, (MEMORYMAP_ADDR + 0x08)    ; Memory mapping write pointer in esi
    mov eax, 0x0000E820                 ; Memory mapping function
    mov edx, 0x534D4150                 ; "SMAP"
    mov ecx, 0x18                       ; Ask 24 bytes
    mov [es:di + 0x14], dword 0x01      ; ACPI 3.X entry
    xor ebx, ebx                        ; Reset ebx
    int 0x15                            ; BIOS call
    jnc .memorymap_supported

        ; Memory mapping error
        mov si, .memorymap_err
        call boot.bios_print
        call boot.bios_reboot

    .memorymap_supported:

    cmp eax, 0x534D4150     ; "SMAP" 
    je .memorymap_eaxok     ; Eax must be equal to "SMAP"

        ; Memory mapping eax error
        mov si, .memorymap_err
        call boot.bios_print
        call boot.bios_reboot

    .memorymap_eaxok:

    test ebx, ebx           ; Check ebx (list entries count)
    jne .memorymap_loop     ; ebx must be greater than 0

        ; Memory mapping ebx error
        mov si, .memorymap_err
        call boot.bios_print
        call boot.bios_reboot

    .memorymap_loop:

        mov eax, 0x0000E820             ; Memory mapping
        mov edx, 0x534D4150             ; "SMAP"
        mov ecx, 0x18                   ; Ask 24 bytes
        mov [es:di + 0x14], dword 0x01  ; ACPI 3.X entry
        int 0x15                        ; BIOS call

        jc .memorymap_end       ; End of list reached (carry set)
        jcxz .memorymap_skip    ; Skip 0 length entries

        cmp cl, 0x14            ; Check for ACPI 3.X response
        jbe .memorymap_noacpi

            ; ACPI 3.X response
            test byte [es:di + 0x14], 0x01  ; Check the "ignore this data" flag
            je .memorymap_skip              ; Ignore this entry as requested

            test byte [es:di + 0x14], 0x02  ; Check the "non-volatile" flag
            jne .memorymap_skip             ; Ignore non-volatile memory

        .memorymap_noacpi:

        mov eax, [es:di + 0x10]     ; Get region type (32 bits)
        cmp eax, 0x01               ; Compare with free memory type
        jne .memorymap_skip         ; Ignore non-free memory entry

        mov ecx, [es:di + 0x0C]     ; Get higher region size part (32 bits)
        test ecx, ecx               ; Test higher region size (> 4Gb)
        jnz .memorymap_store        ; Store memory region infos

            ; Highest region size is 0, check lowest region size part
            mov ecx, [es:di + 0x08]     ; Get lowest region size part (32 bits)
            cmp ecx, 0x04000000         ; Compare with 0x04000000 (60Mb)
            jb .memorymap_skip          ; Ignore entries < 60Mb

        .memorymap_store:
            ; Store region start
            mov eax, [es:di + 0x00]     ; Copy lowest region start into eax
            mov [esi + 0x00], eax       ; Copy into memory_start
            mov eax, [es:di + 0x04]     ; Copy higher region start into eax
            mov [esi + 0x04], eax       ; Copy into memory_start

            ; Store region size
            mov eax, [es:di + 0x08]     ; Copy lowest region size into eax
            mov [esi + 0x08], eax       ; Copy into memory_size
            mov eax, [es:di + 0x0C]     ; Copy higher region size into eax
            mov [esi + 0x0C], eax       ; Copy into memory_size

            add esi, 0x10               ; Next memory map location

        .memorymap_next:

        inc ebp                     ; Increment entry count
        cmp ebp, 0x20               ; For maximum 32 entries
        ja .memorymap_end           ; Stop if maximum entry count is reached
        add di, 0x18                ; Next entry

    .memorymap_skip:

        test ebx, ebx               ; Check ebx (list entries count)
        jne .memorymap_loop         ; ebx must be greater than 0 to continue

    .memorymap_end:

        mov esi, MEMORYMAP_ADDR     ; Load MEMORYMAP_ADDR in ecx
        mov [esi], ebp              ; Store memory map entries
        clc                         ; Clear carry flag (previous jc)


; Check CPU support for 64bits
.check_cpu:

    ; Check for CPUID support
    pushfd  ; Push flags register
    pop eax ; Get flags in eax

    ; Set EFLAGS ID flag
    mov ecx, eax            ; Save flags into ecx
    xor eax, CPU_FLAGS_ID   ; Add ID flag
    push eax                ; Push eax into stack
    popfd                   ; Pop stack into flags register

    ; Read EFLAGS ID flag
    pushfd      ; Push flags register
    pop eax     ; Get flags in eax
    push ecx    ; Push original flags into stack
    popfd       ; Pop stack into flags register

    ; Check ID flag
    xor eax, ecx        ; Isolate modified flags
    jz .cpuerror        ; CPUID is not supported (unmodified flags)

    ; Check extended CPUID functions
    mov eax, CPUID_FNC_LFUNCEXT     ; Largest extended CPUID function number
    cpuid                           ; Check CPU extended functions availability
    cmp eax, CPUID_FNC_FEATURE_FLAGS_ID     ; Check for feature flags function
    jb .cpuerror                    ; Feature identifiers function not supported

    ; Check CPU features flags
    mov eax, CPUID_FNC_FEATURE_FLAGS_ID ; Feature flags function number
    cpuid                               ; Check CPU features (returned in edx)
    and edx, CPU_REQ_FEAT_FLAGS         ; Isolate required features flags
    cmp edx, CPU_REQ_FEAT_FLAGS         ; Check required features flags
    jne .cpuerror                       ; CPU is not supported

    ; Check CPU features infos
    mov eax, CPUID_FNC_FEATURE_INFOS_ID ; Feature infos function number
    cpuid                               ; Check CPU features (returned in edx)
    and edx, CPU_REQ_FEAT_INFOS         ; Isolate required features
    cmp edx, CPU_REQ_FEAT_INFOS         ; Check required features
    jne .cpuerror                       ; CPU is not supported

    ; CPU ready
    jmp .load64bits

    .cpuerror:

        ; Unsupported CPU
        mov si, .cpu_err
        call boot.bios_print
        call boot.bios_reboot


; Load 64bits protected mode
.load64bits:

    ; Notify the BIOS about 64bits operations
    mov ax, 0xEC00  ; BIOS function
    mov bx, 0x0002  ; (32bits : 0, 64bits : 1)
    int 0x15        ; BIOS call

    ; Disable PICs IRQs
    mov al, 0xFF
    out CPU_PIC2_DATA, al   ; Disable PIC2 interrupts
    out CPU_PIC1_DATA, al   ; Disable PIC1 interrupts


    ; Load 64bits long mode
    ; Identity maps the first 4Gb of RAM
    mov edi, PAGE_ADDR  ; Set Page address

    ; Clear Pages
    cld
    xor eax, eax            ; Clear eax
    mov ecx, PAGE_SIZE_DQ   ; Total page table size
    rep stosd               ; Move eax into [edi++]
    mov edi, PAGE_ADDR      ; Reset edi page pointer

    ; Build Page Map level 4
    mov eax, PAGE_ADDR+0x1000   ; PDPT location
    or eax, 0x03                ; Pr 1, Rw 1
    mov [PAGE_ADDR], eax        ; Pointer to PDPT

    ; Build PDPT and Page Directories
    xor ebx, ebx                ; Clear directory counter
    .build_all_directories:

        ; Build Page Directory Pointer Table
        mov eax, 0x1000             ; Page directory size
        mul ebx                     ; Multiply by current directory (ebx)
        add eax, (PAGE_ADDR+0x2000) ; Add PAGE_ADDR offset
        mov edi, eax                ; Save into edi for Page Directory
        mov ecx, eax                ; Save into ecx for PDPT entry
        or ecx, 0x03                ; Pr 1, Rw 1

        mov eax, 0x08               ; PDPT entry size
        mul ebx                     ; Multiply by current directory (ebx)
        add eax, (PAGE_ADDR+0x1000) ; Add PAGE_ADDR offset
        mov [eax], ecx              ; Pointer to Page Directories

        xor edx, edx                ; Clear edx for multiply
        mov eax, 0x40000000         ; 1GB directory (512 pages)
        mul ebx                     ; Multiply by current directory (ebx)
        or eax, 0x83                ; Ps 1, Pr 1, Rw 1

        xor ecx, ecx                ; Clear page counter
        .build_page_directories:

            ; Build page directory
            mov [edi], eax          ; Lower half address
            mov [edi+4], edx        ; Upper half address
            add eax, 0x200000       ; Add page size
            add edi, 0x08           ; Increment page index
            inc ecx                 ; Increment page counter
            cmp ecx, 0x200          ; For 512 pages
            jb .build_page_directories

        inc ebx                     ; Increment directory counter
        cmp ebx, 0x04               ; For 4 directories (4Gb)
        jb .build_all_directories


    ; Load IDT (zero length : any NMI will triple fault)
    lidt [.idt_descriptor]

    ; Setup CR4
    mov eax, cr4
    or eax, 0xA0    ; PAE 1, PGE 1
    ;or eax, 0xB0    ; PSE 1, PAE 1, PGE 1
    mov cr4, eax

    ; Point CR3 at PML4
    mov edx, PAGE_ADDR
    mov cr3, edx

    ; Setup MSR (EFER)
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x00000100  ; LME 1
    wrmsr

    ; Setup CR0
    mov eax, cr0
    or eax, 0x80000001  ; PG 1, PE 1
    ;or eax, 0x80010001  ; PG 1, WP 1, PE 1
    mov cr0, eax

    ; Load GDT
    lgdt [.gdt_descriptor]


    ; Far jump to 64bits code segment
    ; Avoid CPU pipelining
    jmp CODE_SEG:init.start_64bits


; 64 Bits protected mode
[bits 64]
align 64
.start_64bits:

    ; Reset segments registers
    xor ax, ax
    mov fs, ax  ; 0x0000
    mov gs, ax  ; 0x0000

    ; Set stack address
    ;mov rbp, STACK_ADDR    ; Use rbp as stack frame pointer
    ;mov rsp, rbp           ; Set stack pointer
    mov rsp, STACK_ADDR     ; Set stack pointer without stack frame

    ; Clear interrupts
    cli

    ; Clear screen
    cld                             ; Clear direction flag
    mov rdi, VIDEO_MEM              ; Move video memory address into edi
    mov rax, 0x0F000F000F000F00     ; White on black, nul character (x4)
    mov rcx, TOTAL_CHARS_DQ         ; for TOTAL_CHARS_DQ,
    rep stosq                       ; Move eax into [edi++]

    ; Set cursor position
    ; Set at 0 (0x0000) : Line 0 Col 0
    mov al, 0x0E
    mov dx, 0x03D4
    out dx, al

    mov al, 0x00   ; High
    mov dx, 0x03D5
    out dx, al

    mov al, 0x0F
    mov dx, 0x03D4
    out dx, al

    mov al, 0x00   ; Low
    mov dx, 0x03D5
    out dx, al

    ; Set stack address
    ; mov rax, [.memory_start]
    ; add rax, [.memory_size]
    ; sub rax, 0x0100
    ; mov rsp, rax     ; Set stack pointer without stack frame

; Load all memory
.load_memory:

    ; Search memory for kernel
    mov rcx, [MEMORYMAP_ADDR]           ; Load memory map entry count
    mov rsi, (MEMORYMAP_ADDR + 0x08)    ; Load memory map first entry address

    .search_kernel_memory:
        mov rax, [rsi + 0x00]           ; Load region start address into rax
        mov rbx, [rsi + 0x08]           ; Load current region size into rbx
        add rsi, 0x10                   ; Next region entry
        cmp rax, 0xF0000000             ; Look for entries in the first 4Gb
        jae .search_kernel_next
            cmp rbx, 0x01000000         ; Look for at least 260 Mb of memory
            jae .kernel_set_pages       ; Enough memory found
        .search_kernel_next:
        loop .search_kernel_memory

    ; Not enough memory for the kernel
    mov rsi, .init_notenoughram     ; Not enough ram error message
    call .init_print                ; Print error message
    jmp $                           ; Halt
    ; Todo : add keyboard wait and reboot procedure

    ; Set pages memory address
    .kernel_set_pages:
    mov rax, [rsi - 0x10]
    mov rbx, 0xFFFFFFFFFFFFF000     ; Low 4kb inverted mask
    and rax, rbx                    ; Align to 4kb boundary
    add rax, 0x1000                 ; Add 4kb margin
    mov [kernel.page_address], rax  ; Store into kernel.page_address
    mov rax, [MEMORYMAP_ADDR]
    sub rax, rcx
    mov [kernel.memory_entry], rax  ; Store kernel memory entry index


    ; Search last memory chunk
    mov rcx, [MEMORYMAP_ADDR]           ; Load memory map entry count
    mov rsi, (MEMORYMAP_ADDR + 0x08)    ; Load memory map first entry address

    xor ebx, ebx                        ; Clear rbx (start address)
    xor edx, edx                        ; Clear rdx (region size)
    .search_last_memory:
        mov rax, [rsi]                  ; Load current start address into rax
        add rsi, 0x10                   ; Next region entry
        cmp rax, rbx                    ; Compare start address with stored one
        ; jb .last_memory_next
        ;     mov rbx, rax
        ;     mov rdx, [rsi-0x08]
        ; .last_memory_next:
        cmovae rbx, rax                 ; Store into rbx if greater
        cmovae rdx, [rsi - 0x08]        ; Store region size into rdx
        loop .search_last_memory

    ; Compute memory page size and pages count
    add rbx, rdx    ; Add last region size to last region start
    shr rbx, 0x1E   ; Divide by 0x40000000 (1Gb) (shift right by 30 bits)
    inc rbx         ; Add 1Gb margin and store number of directories in rbx
    mov rax, 0x04   ; 4Gb minimum
    cmp rbx, rax    ; Compare rbx with the lower 4Gb limit
    cmovbe rbx, rax ; Store 0x04 if rbx is below or equal 0x04
    mov [kernel.pages_count], rbx   ; Store result at kernel.pages_count


    ; Clear Pages
    cld
    mov rdi, [kernel.page_address]  ; Set rdi page pointer
    mov rax, 0x1000                 ; 0x1000 (4kb) every 512 pages: 1 directory
    mul rbx                         ; Multiply by number of directories
    add rax, 0x2000                 ; Add 0x2000 (8kb) for PML4 and PDPT
    mov rcx, rax                    ; Total page table size
    mov rdx, rcx                    ; Store page table size
    xor eax, eax                    ; Clear eax
    rep stosd                       ; Move eax into [rdi++]

    ; Compute kernel code address
    mov rax, rdx                    ; Get stored page table size
    add rax, [kernel.page_address]  ; Add kernel page start address
    mov rbx, 0xFFFFFFFFFFFFF000     ; Low 4kb inverted mask
    and rax, rbx                    ; Align to 4kb boundary
    add rax, 0x1000                 ; Add 4kb margin
    mov [kernel.code_address], rax  ; Store kernel code address

    ; Build Page Map level 4
    mov rdi, [kernel.page_address]  ; Set rdi page pointer
    mov rax, rdi                    ; Load .page_address offset
    add rax, 0x1000                 ; PDPT location (.page_address + 0x1000)
    or rax, 0x03                    ; Pr 1, Rw 1
    mov [rdi], rax                  ; Pointer to PDPT

    ; Build PDPT and Page Directories
    xor ebx, ebx                ; Clear directory counter
    .kernel_set_directories:

        ; Build Page Directory Pointer Table
        mov rax, 0x1000             ; Page directory size
        mul rbx                     ; Multiply by current directory (rbx)
        add rax, [kernel.page_address]  ; Add .page_address offset
        add rax, 0x2000             ; .page_address + 0x2000
        mov rdi, rax                ; Save into rdi for Page Directory
        mov rcx, rax                ; Save into rcx for PDPT entry
        or rcx, 0x03                ; Pr 1, Rw 1

        mov rax, 0x08               ; PDPT entry size
        mul rbx                     ; Multiply by current directory (rbx)
        add rax, [kernel.page_address]  ; Add .page_address offset
        add rax, 0x1000             ; .page_address + 0x1000
        mov [rax], rcx              ; Pointer to Page Directories

        xor edx, edx                ; Clear edx for multiply
        mov rax, 0x40000000         ; 1GB directory (512 pages)
        mul rbx                     ; Multiply by current directory (rbx)
        or rax, 0x83                ; Ps 1, Pr 1, Rw 1

        xor ecx, ecx                ; Clear page counter
        .kernel_fill_directory:

            ; Build page directory
            mov [rdi], rax          ; Copy address
            add rax, 0x200000       ; Add page size
            add rdi, 0x08           ; Increment page index
            inc rcx                 ; Increment page counter
            cmp rcx, 0x200          ; For 512 pages
            jb .kernel_fill_directory

        inc rbx                         ; Increment directory counter
        cmp rbx, [kernel.pages_count]   ; For every Gb of memory
        jb .kernel_set_directories


    .loadPML4:
    ; Point CR3 at PML4
    mov rdx, [kernel.page_address]
    mov cr3, rdx

    nop
    nop
    nop
    nop

    ; Jump to init_done
    jmp .init_done


; Init done
align 8
.init_done:

    ; Clear interrupts
    cli

    ; Clear screen
    cld                             ; Clear direction flag
    mov rdi, VIDEO_MEM              ; Move video memory address into edi
    mov rax, 0x0F000F000F000F00     ; White on black, nul character (x4)
    mov rcx, TOTAL_CHARS_DQ         ; for TOTAL_CHARS_DQ,
    rep stosq                       ; Move eax into [edi++]

    ; Set cursor position
    ; Set at 0 (0x0000) : Line 0 Col 0
    mov al, 0x0E
    mov dx, 0x03D4
    out dx, al

    mov al, 0x00   ; High
    mov dx, 0x03D5
    out dx, al

    mov al, 0x0F
    mov dx, 0x03D4
    out dx, al

    mov al, 0x00   ; Low
    mov dx, 0x03D5
    out dx, al

    ; Clear 64bits registers
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor ebp, ebp
    xor esi, esi
    xor edi, edi
    xor r8d, r8d
    xor r9d, r9d
    xor r10d, r10d
    xor r11d, r11d
    xor r12d, r12d
    xor r13d, r13d
    xor r14d, r14d
    xor r15d, r15d

    ; Kernel entry
    jmp kernel.start


; Print nul-terminated string using video memory
; param rsi : String pointer
align 8
.init_print:
    ; Print init error message
    mov ebx, VIDEO_MEM          ; Reset ebx pointer
    mov ah, 0x0F                ; Set color
    mov al, [rsi]               ; First character into al

    .init_print_loop:
        mov [ebx], ax           ; Move character into video pointer
        add ebx, 0x02           ; Increment video text pointer
        inc rsi                 ; Increment CPU error string pointer
        mov al, [rsi]           ; Move next character into al
        test al, al             ; Check if character is nul
        jnz .init_print_loop    ; Loop while character is not nul

ret ; End of .init_print


; IDT : 
align 8
.idt_descriptor:
    dw 0x0000
    dd 0x00000000


; GDT : Global descriptor table (64 bits)
align 8
.gdt_descriptor:
    dw .gdt_end - .gdt_start - 1    ; Size of GDT-1
    dd .gdt_start                   ; GDT address

align 8
.gdt_start:
; Null descriptor
    dd 0x00000000
    dd 0x00000000

; Code segment descriptor
.gdt_code:
    dw 0x0000    ; Limit [15:0]
    dw 0x0000    ; Base [15:0]
    db 0x00      ; Base [23:16]
    db 10011010b ; Access (Pr 1, Privl 00, S 1, Ex 1, DC 0, RW(R) 1, Ac 0)
    db 00100000b ; Flags (Gr 1, Sz 1, L 0) + Limit
    db 0x00      ; Base [31:24]

; Data segment descriptor
.gdt_data:
    dw 0x0000    ; Limit [15:0]
    dw 0x0000    ; Base [15:0]
    db 0x00      ; Base [23:16]
    db 10010010b ; Access (Pr 1, Privl 00, S 1, Ex 0, DC 0, RW(W) 1, Ac 0)
    db 00100000b ; Flags (Gr 1, Sz 1, L 0) + Limit
    db 0x00      ; Base [31:24]
.gdt_end:


; Nul-terminated BIOS string messages
align 8
.a20_err:           ; A20 line is disabled
    db "A20 line is disabled", 0x0A, 0x0D, 0x00
.memorymap_err:     ; Memory mapping error
    db "Memory mapping error", 0x0A, 0x0D, 0x00
.cpu_err:           ; CPU is not supported
    db "CPU is not supported", 0x0A, 0x0D, 0x00

; Nul-terminated string messages
align 8
.init_notenoughram:     ; Not enough RAM
    db "Not enough RAM (need 260Mb at least)", 0x00


; Kernel code
%include "kernel.asm"


; Fill remaining boot init with 0x00
times (BOOTSECTOR_SIZE + BOOTINIT_SIZE + BOOTINIT_OFFSET)-($-$$) db 0x00
