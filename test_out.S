extern puts

SECTION .data
    msg db 'Hello World!', 0x0A

SECTION .text
    global _start
_start:
    mov rdi, 13
    mov rsi, msg
    call puts
    call puts
    call puts

    mov rax, 60
    mov rdi, 0
    syscall
