; 64-Bit
; Linux (Windows uses different calling convention)
; github.com/x444556

[BITS 64]

GLOBAL Encrypt

Encrypt:
    push rbp        ; push rbp + align stack 16 bytes
    mov rbp, rsp

    ; rdi = dataPTR
    ; rsi = dataLEN (LEN in bytes / 16)
    ; rdx = keyPTR

    ; xmm1 = originalKey
    ; xmm2 = state
    ; xmm3 = roundKey

    sub rsp, 16 ; 16 bytes as temporary, 16 byte aligned, space used for loading data into xmm registers
    ; access at [rbp - 16]

    ; mov key from keyPTR into alignes memory on stack and mov into xmm1
    mov QWORD [rbp - 16], QWORD [rdx]
    mov QWORD [rbp -  8], QWORD [rdx + 8]
    movdqa xmm1, [rbp - 16]

    xor rcx, rcx
    .loop:
        ; TODO

        add rdi, 16
        inc rcx
        cmp rcx, rsi
        jb .loop

    mov rsp, rbp
    pop rbp
    ret