%define NUMBER_STRING_LENGTH 19

extern puts
extern putchar

extern cellNumbers

SECTION .data
    numberString \
    db 0x1B, '[1;47m       ', 0x1B, '[0m '
    db 0x1B, '[1;43m     2 ', 0x1B, '[0m '
    db 0x1B, '[1;43m     4 ', 0x1B, '[0m '
    db 0x1B, '[1;43m     8 ', 0x1B, '[0m '
    db 0x1B, '[1;44m    16 ', 0x1B, '[0m '
    db 0x1B, '[1;44m    32 ', 0x1B, '[0m '
    db 0x1B, '[1;44m    64 ', 0x1B, '[0m '
    db 0x1B, '[1;46m   128 ', 0x1B, '[0m '
    db 0x1B, '[1;46m   256 ', 0x1B, '[0m '
    db 0x1B, '[1;46m   512 ', 0x1B, '[0m '
    db 0x1B, '[1;46m  1024 ', 0x1B, '[0m '
    db 0x1B, '[1;46m  2048 ', 0x1B, '[0m '
    db 0x1B, '[1;42m  4096 ', 0x1B, '[0m '
    db 0x1B, '[1;42m  8192 ', 0x1B, '[0m '
    db 0x1B, '[1;42m 16384 ', 0x1B, '[0m '
    db 0x1B, '[1;42m 32768 ', 0x1B, '[0m '
    db 0x1B, '[1;45m 65536 ', 0x1B, '[0m '
    db 0x1B, '[1;45m 00000 ', 0x1B, '[0m '
    db 0x1B, '[1;45m 00001 ', 0x1B, '[0m '
    db 0x1B, '[1;45m 00002 ', 0x1B, '[0m '

SECTION .text
    global print_game_area

put_number:                             ;put_number(rdi int number)
    push rsi
    push rdi

    lea rsi, [rdi*9]
    lea rsi, [rsi*2]
    lea rsi, [rsi+rdi]
    lea rsi, [rsi+numberString]
    mov rdi, NUMBER_STRING_LENGTH
    call puts

    pop rdi
    pop rsi
    ret

print_game_area:
    push rcx
    push rsi
    push rdi
    push rdx

    mov rdx, 0
    mov rcx, 4
    mov rsi, 0

.outside_loop:
    push rcx
    mov rcx, 4
.inside_loop:
    xor rdi, rdi
    mov dil, [rsi+cellNumbers]
    inc rsi
    call put_number
    loop .inside_loop

    mov rdi, 0x0A
    call putchar
    mov rdi, 0x0A
    call putchar

    pop rcx
    loop .outside_loop

    pop rdx
    pop rdi
    pop rsi
    pop rcx
    ret
