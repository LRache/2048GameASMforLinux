extern cellNumbers
extern score

extern putchar

global op_up
global op_down
global op_left
global op_right

SECTION .bss
    flag resb 16

SECTION .text
init_flag:
    mov qword [flag], 0
    mov qword [flag+8], 0
    ret

move_number: ; move_number(r8 int fr, r9 int fc, r10 int tr, r11 int tc)
    push rdx
    xor rax, rax
    mov dl, [r8*4+r9+cellNumbers]
    mov [r10*4+r11+cellNumbers], dl
    mov byte [r8*4+r9+cellNumbers], 0
.return:
    pop rdx
    ret

try_span: ; try_span(r8 int fr, r9 int fc, r10 int tr, r11 int tc)
    push rbx
    push rcx

    xor rax, rax
    mov cl, [r8*4+r9+cellNumbers]
    cmp cl, [r10*4+r11+cellNumbers]
    jne .return
    
    inc cl
    mov byte [r8*4+r9+cellNumbers], 0
    mov [r10*4+r11+cellNumbers], cl
    mov byte [r10*4+r11+flag], 1
    mov rbx, 1
    shl rbx, cl
    add [score], rbx
    mov rax, 1

.return:
    pop rcx
    pop rbx
    ret

op_up:
    push rbp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    mov rbp, rsp
    
    call init_flag
    xor rdx, rdx
    mov rsi, 1
.row_loop:
    mov rdi, 0
    .column_loop:
        cmp byte [rsi*4+rdi+cellNumbers], 0
        je .column_loop_tail

        mov rbx, rsi
        dec rbx
        .op_cell_loop:
            cmp byte [rbx*4+rdi+cellNumbers], 0
            je .l0
            jmp .l1
            .l0:
                jmp .op_cell_loop_tail
            .l1:
                mov r8, rsi
                mov r9, rdi
                mov r10, rbx
                mov r11, rdi
                call try_span
                cmp rax, 1
                je .op_success
                    
                mov r8, rsi
                mov r9, rdi
                lea r10, [rbx+1]
                mov r11, rdi
                cmp rsi, r10
                je .out_op_cell_loop
                call move_number
                jmp .op_success

            .op_success:
                mov rdx, 1
                jmp .column_loop_tail
            
        .op_cell_loop_tail:
            dec rbx
            cmp rbx, -1
            jne .op_cell_loop

        .out_op_cell_loop:
            cmp rbx, -1
            jne .column_loop_tail
            mov r8, rsi
            mov r9, rdi
            mov r10, 0
            mov r11, rdi
            call move_number
            mov rdx, 1
    .column_loop_tail:
        inc rdi
        cmp rdi, 4
        jne .column_loop
    inc rsi
    cmp rsi, 4
    jne .row_loop

    mov rax, rdx

    mov rsp, rbp
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret

op_down:
    push rbp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    mov rbp, rsp
    
    call init_flag
    xor rdx, rdx
    mov rsi, 2
.row_loop:
    mov rdi, 0
    .column_loop:
        cmp byte [rsi*4+rdi+cellNumbers], 0
        je .column_loop_tail

        mov rbx, rsi
        inc rbx
        .op_cell_loop:
            cmp byte [rbx*4+rdi+cellNumbers], 0
            je .l0
            jmp .l1
            .l0:
                jmp .op_cell_loop_tail
            .l1:
                mov r8, rsi
                mov r9, rdi
                mov r10, rbx
                mov r11, rdi
                call try_span
                cmp rax, 1
                je .op_success
                    
                mov r8, rsi
                mov r9, rdi
                lea r10, [rbx-1]
                mov r11, rdi
                cmp rsi, r10
                je .out_op_cell_loop
                call move_number
                jmp .op_success

            .op_success:
                mov rdx, 1
                jmp .column_loop_tail
        
        .op_cell_loop_tail:
            inc rbx
            cmp rbx, 4
            jne .op_cell_loop

        .out_op_cell_loop:
            cmp rbx, 4
            jne .column_loop_tail
            mov r8, rsi
            mov r9, rdi
            mov r10, 3
            mov r11, rdi
            call move_number
            mov rdx, 1

    .column_loop_tail:
        inc rdi
        cmp rdi, 4
        jne .column_loop
    dec rsi
    cmp rsi, -1
    jne .row_loop

    mov rax, rdx

    mov rsp, rbp
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret

op_left:
    push rbp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    mov rbp, rsp

    call init_flag
    xor rdx, rdx
    mov rsi, 1 ; column index
.column_loop:
    mov rdi, 0 ; row index
    .row_loop:
        cmp byte [rdi*4+rsi+cellNumbers], 0
        je .row_loop_tail

        mov rbx, rsi
        dec rbx
        .op_cell_loop:
            cmp byte [rdi*4+rbx+cellNumbers], 0
            je .l0
            jmp .l1
            .l0:
                jmp .op_cell_loop_tail
            .l1:
                mov r8, rdi
                mov r9, rsi
                mov r10, rdi
                mov r11, rbx
                call try_span
                cmp rax, 1
                je .op_success

                mov r8, rdi
                mov r9, rsi
                mov r10, rdi
                lea r11, [rbx+1]
                cmp rsi, r11
                je .out_op_cell_loop
                call move_number
                jmp .op_success

            .op_success:
                mov rdx, 1
                jmp .row_loop_tail

        .op_cell_loop_tail:
            dec rbx
            cmp rbx, -1
            jne .op_cell_loop
        
        .out_op_cell_loop:
            cmp rbx, -1
            jne .row_loop_tail
            mov r8, rdi
            mov r9, rsi
            mov r10, rdi
            mov r11, 0
            call move_number
            mov rdx, 1
    .row_loop_tail:
        inc rdi
        cmp rdi, 4
        jne .row_loop
    inc rsi
    cmp rsi, 4
    jne .column_loop

    mov rax, rdx

    mov rsp, rbp
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret

op_right:
    push rbp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    mov rbp, rsp

    call init_flag
    xor rdx, rdx
    mov rsi, 2 ; column index
    xor rax, rax
.column_loop:
    mov rdi, 0 ; row index
    .row_loop:
        cmp byte [rdi*4+rsi+cellNumbers], 0
        je .row_loop_tail

        mov rbx, rsi
        inc rbx
        .op_cell_loop:
            cmp byte [rdi*4+rbx+cellNumbers], 0
            je .l0
            jmp .l1
            .l0:
                jmp .op_cell_loop_tail
            .l1:
                mov r8, rdi
                mov r9, rsi
                mov r10, rdi
                mov r11, rbx
                call try_span
                cmp rax, 1
                je .op_success

                mov r8, rdi
                mov r9, rsi
                mov r10, rdi
                lea r11, [rbx-1]
                cmp rsi, r11
                je .out_op_cell_loop
                call move_number
                jmp .op_success

            .op_success:
                mov rdx, 1
                jmp .row_loop_tail

        .op_cell_loop_tail:
            inc rbx
            cmp rbx, 4
            jne .op_cell_loop
        
        .out_op_cell_loop:
            cmp rbx, 4
            jne .row_loop_tail
            mov r8, rdi
            mov r9, rsi
            mov r10, rdi
            mov r11, 3
            call move_number
            mov rdx, 1
    .row_loop_tail:
        inc rdi
        cmp rdi, 4
        jne .row_loop
    dec rsi
    cmp rsi, -1
    jne .column_loop

    mov rax, rdx

    mov rsp, rbp
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret

