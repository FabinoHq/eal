; CPU FLAGS register
; --------------------------------------------------------------
; 31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
; 0   0   0   0   0   0   0   0   0   0   ID  VIP VIF AC  VM  RF
; --------------------------------------------------------------
; 15  14  13  12  11  10  09  08  07  06  05  04  03  02  01  00
; 0   NT  [IOPL]  OF  DF  IF  TF  SF  ZF  0   AF  0   PF  1   CF
; --------------------------------------------------------------
CPU_FLAGS_CF equ 0x00000001 ; Carry flag
CPU_FLAGS_CF_SHIFT equ 0x00 ; Carry flag shift offset

CPU_FLAGS_PF equ 0x00000004 ; Interrupt flag
CPU_FLAGS_PF_SHIFT equ 0x02 ; Interrupt flag shift offset

CPU_FLAGS_AF equ 0x00000010 ; Auxiliary carry flag
CPU_FLAGS_AF_SHIFT equ 0x04 ; Auxiliary carry flag shift offset

CPU_FLAGS_ZF equ 0x00000040 ; Zero flag (Set if 2 operands are equals)
CPU_FLAGS_ZF_SHIFT equ 0x06 ; Zero flag shift offset

CPU_FLAGS_SF equ 0x00000080 ; Sign flag (Set if operation result is negativ)
CPU_FLAGS_SF_SHIFT equ 0x07 ; Sign flag shift offset

CPU_FLAGS_TF equ 0x00000100 ; Trap flag (Debug step by step)
CPU_FLAGS_TF_SHIFT equ 0x08 ; Trap flag shift offset

CPU_FLAGS_IF equ 0x00000200 ; Interrupt flag
CPU_FLAGS_IF_SHIFT equ 0x09 ; Interrupt flag shift offset

CPU_FLAGS_DF equ 0x00000400 ; Direction flag (1: Backward, 0: Forward)
CPU_FLAGS_DF_SHIFT equ 0x0A ; Direction flag shift offset

CPU_FLAGS_OF equ 0x00000800 ; Overflow flag (Arithmetic operation too large)
CPU_FLAGS_OF_SHIFT equ 0x0B ; Overflow flag shift offset

CPU_FLAGS_IOPL equ 0x00003000   ; I/O privilege flag (00: Highest, 03: Lowest)
CPU_FLAGS_IOPL_SHIFT equ 0x0C   ; IOPL flag shift offset

CPU_FLAGS_NT equ 0x00004000 ; Nested task flag (Chaining intterupts, 1: linked)
CPU_FLAGS_NT_SHIFT equ 0x0E ; Nested task flag shift offset

CPU_FLAGS_RF equ 0x00010000 ; Resume flag (Debug resume)
CPU_FLAGS_RF_SHIFT equ 0x10 ; Resume task flag shift offset

CPU_FLAGS_VM equ 0x00020000 ; Virtual 8086 flag (8086 compatibily mode)
CPU_FLAGS_VM_SHIFT equ 0x11 ; Virtual 8086 flag shift offset

CPU_FLAGS_AC equ 0x00040000 ; Aligment check flag (1: align check of memory)
CPU_FLAGS_AC_SHIFT equ 0x12 ; Aligment check flag shift offset

CPU_FLAGS_VIF equ 0x00080000    ; Virtual interrupt flag
CPU_FLAGS_VIF_SHIFT equ 0x13    ; Virtual interrupt flag shift offset

CPU_FLAGS_VIP equ 0x00100000    ; Virtual interrupt pending flag flag
CPU_FLAGS_VIP_SHIFT equ 0x14    ; Virtual interrupt pending flag shift offset

CPU_FLAGS_ID equ 0x00200000 ; ID flag (Can be toggled if CPUID is supported)
CPU_FLAGS_ID_SHIFT equ 0x15 ; ID flag shift offset


; CPUID functions
CPUID_FNC_LFUNCSTD equ 0x00000000   ; Largest standard CPUID function
CPUID_FNC_LFUNCEXT equ 0x80000000   ; Largest extended CPUID function


    ; CPU features flags [cpuid 0x80000001, edx]
    CPUID_FNC_FEATURE_FLAGS_ID equ 0x80000001   ; Feature flags function
    CPUID_FEAT_FLAG_PDPE1GB equ 0x04000000  ; Gigabyte pages support
    CPUID_FEAT_FLAG_RDTSCP equ 0x08000000   ; Read timestamp RDTSCP instruction
    CPUID_FEAT_FLAG_LM equ 0x20000000       ; 64bits long mode support

    ; CPU required flags
    CPU_REQ_FEAT_FLAGS equ (CPUID_FEAT_FLAG_LM)


    ; CPU features flags [cpuid 0x00000001, edx]
    CPUID_FNC_FEATURE_INFOS_ID equ 0x00000001   ; Feature infos function

    CPUID_FEAT_FPU equ 0x00000001   ; FPU x87 floating-point unit on chip
    CPUID_FEAT_VME equ 0x00000002   ; Virtual-mode enhancements
    CPUID_FEAT_DE equ 0x00000004    ; Debugging extensions
    CPUID_FEAT_PSE equ 0x00000008   ; Page-size extensions
    CPUID_FEAT_TSC equ 0x00000010   ; Time stamp counter
    CPUID_FEAT_MSR equ 0x00000020   ; Model-specific registers
    CPUID_FEAT_PAE equ 0x00000040   ; Physical address extensions
    CPUID_FEAT_MCE equ 0x00000080   ; Machine check exception

    CPUID_FEAT_XCHG8 equ 0x00000100 ; CMPXCHG8B instruction
    CPUID_FEAT_APIC equ 0x00000200  ; Advanced programmable interrupt controller
    ; Reserved equ 0x00000400
    CPUID_FEAT_SEP equ 0x00000800   ; SysCall SysRet instructions
    CPUID_FEAT_MTRR equ 0x00001000  ; Memory-type range registers
    CPUID_FEAT_PGE equ 0x00002000   ; Page global extension
    CPUID_FEAT_MCA equ 0x00004000   ; Machine check architecture
    CPUID_FEAT_CMOV equ 0x00008000  ; Conditional move instructions

    CPUID_FEAT_PAT equ 0x00010000   ; Page attribute table
    CPUID_FEAT_PSE36 equ 0x00020000 ; 36bits page size extension
    CPUID_FEAT_PSN equ 0x00040000   ; Processor Serial Number supported/enabled
    CPUID_FEAT_CLFSH equ 0x00080000 ; CLFLUSH cache flush instruction (SSE2)
    CPUID_FEAT_NX equ 0x00100000    ; No-execute page protection (Itanium only)
    CPUID_FEAT_DS equ 0x00200000    ; Debug store : save trace of executed jumps
    CPUID_FEAT_ACPI equ 0x00400000  ; Onboard thermal control MSRs for ACPI
    CPUID_FEAT_MMX equ 0x00800000   ; MMX instructions extensions (SIMD_64)

    CPUID_FEAT_FXSR equ 0x01000000  ; FXSAVE and FXRSTOR instructions (CR4 bit9)
    CPUID_FEAT_SSE equ 0x02000000   ; Streaming SIMD Extensions (SSE, SIMD_128)
    CPUID_FEAT_SSE2 equ 0x04000000  ; SSE2 instructions support
    CPUID_FEAT_SS equ 0x08000000    ; CPU cache implements self-snoop
    CPUID_FEAT_HTT equ 0x10000000   ; Max APIC IDs reserved filed is valid
    CPUID_FEAT_TM equ 0x20000000    ; Thermal monitor automatically limits temp
    CPUID_FEAT_IA64 equ 0x40000000  ; IA64 processor emulating x86
    CPUID_FEAT_PBE equ 0x80000000   ; Pending Break Enable (PBE) wakeup support

    ; CPU required features
    CPU_REQ_FEAT_INFOS equ (CPUID_FEAT_FPU | CPUID_FEAT_TSC | CPUID_FEAT_PAE \
        | CPUID_FEAT_APIC | CPUID_FEAT_PGE | CPUID_FEAT_CMOV)


; CPU PIC (Programmable Interrupt Controller)
CPU_PIC1_COMMAND equ 0x20   ; PIC1 Command
CPU_PIC1_DATA equ 0x21      ; PIC1 Data

CPU_PIC2_COMMAND equ 0xA0   ; PIC2 Command
CPU_PIC2_DATA equ 0xA1      ; PIC2 Data

CPU_PIC_EOI equ 0x20        ; End of Interupt

CPU_PIC_ICW4 equ 0x01       ; ICW4 mode
CPU_PIC_SINGLE equ 0x02     ; Single (cascade) mode
CPU_PIC_INTERVAL4 equ 0x04  ; Call address interval 4
CPU_PIC_LEVEL equ 0x08      ; Level triggered (edge) mode
CPU_PIC_INIT equ 0x10       ; PIC Initialization

CPU_PIC_8086 equ 0x01       ; 8086/88 mode
CPU_PIC_AUTO equ 0x02       ; Auto (normal) EOI
CPU_PIC_SLAVE equ 0x08      ; Buffered mode (slave)
CPU_PIC_MASTER equ 0x0C     ; Buffered mode (master)
CPU_PIC_SFNM equ 0x10       ; Special fully nested

CPU_PIC_INIT_FLAGS equ (CPU_PIC_ICW4 | CPU_PIC_INIT)    ; Init flags


