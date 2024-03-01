extern print_game_area

extern getArrowInput
extern setTermios
extern resetTermios

extern random

SECTION .bss
    global cellNumbers
    cellNumbers resb 16

SECTION .text
    global _start
_start:
    call setTermios

    mov rcx, 16
    mov rsi, 0
.initCellNumbersLoop:
    mov [rsi + cellNumbers], sil
    inc rsi
    loop .initCellNumbersLoop

    call random_spawn_number
    call random_spawn_number

    call print_game_area
    call getArrowInput

    jmp _exit

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
    call resetTermios

    mov rax, 60
    mov rdi, 0
    syscall