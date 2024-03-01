SECTION .bss
    randomBuffer resb 8

SECTION .text
    global random

random:
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    ; getrandom(char *ubuf, size_t len, unsigned int flags)
    mov rax, 318           ; getrandom 系统调用号
    lea rdi, [rbp-8]   ; 指向随机数存储缓冲区的指针
    mov rsi, 8             ; 请求 8 字节的随机数据
    xor rdx, rdx           ; 标志设置为 0
    syscall

    mov rax, [rbp-8]

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret
    