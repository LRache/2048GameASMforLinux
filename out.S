SECTION .text
    global putchar
    global puts

puts:                   ; puts(rdi int64 length, rsi byte* string)
    push rdi
    push rsi
    push rax
    push rcx
    push rdx

    mov rdx, rdi
    mov rdi, 1
    mov rax, 1
    syscall

    pop rdx
    pop rcx
    pop rax
    pop rsi
    pop rdi
    ret

putchar:
    push rbp
    mov rbp, rsp
    push rax
    push rbx
    push rcx
    push rdx
    push rsi

    lea rsi, [rbp+16]
    mov rdx, 1
    mov rdi, 1
    mov rax, 1
    syscall

    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop rbp
    ret 8