global putchar
global puts
global put_decimal
global clear_console

SECTION .data:
    clearCode db 0x1B, 'c'

SECTION .text
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

putchar: ; putchar(rdi byte c)
    push rbp
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    mov rbp, rsp
    
    sub rsp, 8
    mov [rbp-8], rdi

    lea rsi, [rbp-8]
    mov rdx, 1
    mov rdi, 1
    mov rax, 1
    syscall

    mov rsp, rbp
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop rbp
    ret

put_decimal: ; put_decimal(rdi int number)
    push rbp
    push rax
    push rbx
    push rcx
    push rdx
    mov rbp, rsp

    cmp rdi, 0
    jnz .s
    mov rdi, '0'
    call putchar
    jmp .return

.s:
    mov rax, rdi
    xor rcx, rcx
    mov rbx, 10

.div_loop:
    xor rdx, rdx
    div rbx
    inc rcx
    add rdx, '0'
    push rdx
    cmp rax, 0
    jz .out_div_loop
    jmp .div_loop

.out_div_loop:
    
.put_digit_loop:
    pop rdi
    call putchar
    dec rcx
    jnz .put_digit_loop

.return:
    mov rsp, rbp
    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop rbp
    ret


clear_console:
    push rsi
    push rdi

    mov rdi, 2
    mov rsi, clearCode
    call puts

    pop rdi
    pop rsi
    ret
