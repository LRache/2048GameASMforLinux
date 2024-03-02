extern print_game_area

extern inputBuffer
extern get_input
extern setTermios
extern resetTermios

extern putchar
extern puts
extern put_decimal
extern clear_console

extern random

extern op_up
extern op_down
extern op_left
extern op_right

global cellNumbers
global score
global _start

SECTION .data
    goodbyeMsg db 'Goodbye!', 0xA
    tipsMsg db 'Press q to quit, n to new game.', 0xA
    scoreMsg db 'Your score: '
    escString db 'ESC'

SECTION .bss
    cellNumbers resb 16
    score resq 1

SECTION .text
_start:
    call setTermios
    call init_game
    call run_game
    call resetTermios
    jmp _exit

init_game:
    push rax
    push rcx
    push rsi

    mov rcx, 2
    mov rsi, 0
    .init_cell_numbers_loop:
        mov qword [rsi+cellNumbers], 0
        add rsi, 8
        loop .init_cell_numbers_loop

    ;mov dword [cellNumbers+0], 0x01010101
    ;mov dword [cellNumbers+4], 0x01010101
    ;mov dword [cellNumbers+8], 0x01010101
    ;mov dword [cellNumbers+12], 0x01010101
    call random_spawn_number
    call random_spawn_number

    pop rsi
    pop rcx
    pop rax
    ret

run_game:
    push rbp
    mov rbp, rsp
    sub rsp, 4

.run_game:
.game_loop:
    call clear_console
    call puts_score
    call print_game_area
    call puts_tips

.waiting_input:

    mov dword [rbp-4], 0
    mov rdi, 4
    lea rsi, [rbp-4]
    call get_input

    cmp byte [rbp-4], 'q'
    je .input_q
    cmp byte [rbp-4], 'n'
    je .input_n
    
    cmp dword [rbp-4], 0x415b1b
    jz .input_to_up
    cmp dword [rbp-4], 0x425b1b
    jz .input_to_down
    cmp dword [rbp-4], 0x435b1b
    jz .input_to_right
    cmp dword [rbp-4], 0x445b1b
    jz .input_to_left

    cmp byte [rbp-4], 0x1B
    je .input_esc

    .game_loop_tail:
        jmp .game_loop

.input_q:
    mov rdi, 'q'
    call putchar
    mov rdi, 0xA
    call putchar
    jmp .input_to_quit

.input_esc:
    mov rdi, 3
    mov rsi, escString
    call puts

    mov rdi, 0xA
    call putchar
    jmp .input_to_quit

.input_to_quit:
    mov rdi, 9
    mov rsi, goodbyeMsg
    call puts
    
    jmp .return

.input_n:
    call init_game
    jmp .run_game

.input_to_up:
    call op_up
    jmp .op_finish

.input_to_down:
    call op_down
    jmp .op_finish

.input_to_right:
    call op_right
    jmp .op_finish

.input_to_left:
    call op_left
    jmp .op_finish

.op_finish:
    cmp rax, 0
    je .game_loop_tail
    call random_spawn_number
    jmp .game_loop_tail

.return:
    mov rsp, rbp
    pop rbp
    ret

puts_score:
    push rsi
    push rdi
    
    mov rdi, 12
    mov rsi, scoreMsg
    call puts
    mov rdi, [score]
    call put_decimal
    mov rdi, 0xA
    call putchar
    call putchar

    pop rdi
    pop rsi
    ret

puts_tips:
    push rsi
    push rdi

    mov rdi, 32
    mov rsi, tipsMsg
    call puts

    pop rdi
    pop rsi
    ret

random_spawn_number:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi

    xor rsi, rsi
.find_empty_cell_loop:
    cmp byte [cellNumbers+rsi], 0
    jz .try_spawn_number
    inc rsi
    cmp rsi, 16
    jz .return
    jmp .find_empty_cell_loop

.try_spawn_number:
    call random
    xor rbx, rbx
    mov bl, al
    and bl, 0b00001111
    cmp byte [rbx+cellNumbers], 0
    jnz .try_spawn_number

    xor rdx, rdx
    mov dl, ah
    and dl, 0b00000011
    jz .spawn4
.spawn2:
    mov byte [rbx+cellNumbers], 1
    jmp .return
.spawn4:
    mov byte [rbx+cellNumbers], 2
.return:
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

_exit:
    mov rax, 60
    mov rdi, 0
    syscall