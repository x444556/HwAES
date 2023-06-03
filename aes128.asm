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
    mov rax, QWORD [rdx]
    mov QWORD [rbp - 16], rax
    mov rax, QWORD [rdx + 8]
    mov QWORD [rbp -  8], rax
    movdqa xmm1, [rbp - 16]

    xor rcx, rcx
    .loop:
        ; Write block into aligned stack-space and move into xmm2
        mov rax, QWORD [rdi]
        mov QWORD [rbp - 16], rax
        mov rax, QWORD [rdi + 8]
        mov QWORD [rbp -  8], rax
        movdqa xmm2, [rbp - 16]

        ; First round
        xorps xmm2, xmm1
        AESKEYGENASSIST xmm3, xmm1, 01h
        AESENC xmm2, xmm3

        ; Rounds 2-9
        AESKEYGENASSIST xmm3, xmm3, 02h
        AESENC xmm2, xmm3
        AESKEYGENASSIST xmm3, xmm3, 04h
        AESENC xmm2, xmm3
        AESKEYGENASSIST xmm3, xmm3, 08h
        AESENC xmm2, xmm3
        AESKEYGENASSIST xmm3, xmm3, 10h
        AESENC xmm2, xmm3
        AESKEYGENASSIST xmm3, xmm3, 20h
        AESENC xmm2, xmm3
        AESKEYGENASSIST xmm3, xmm3, 40h
        AESENC xmm2, xmm3
        AESKEYGENASSIST xmm3, xmm3, 80h
        AESENC xmm2, xmm3
        AESKEYGENASSIST xmm3, xmm3, 1bh
        AESENC xmm2, xmm3

        ; Last round
        AESKEYGENASSIST xmm3, xmm3, 36h
        AESENCLAST xmm2, xmm3

        ; Write block back
        movdqa [rbp - 16], xmm2
        mov rax, QWORD [rbp - 16]
        mov QWORD [rdi], rax
        mov rax, QWORD [rbp - 8]
        mov QWORD [rdi + 8], rax

        add rdi, 16
        inc rcx
        cmp rcx, rsi
        jb .loop

    mov rsp, rbp
    pop rbp
    ret