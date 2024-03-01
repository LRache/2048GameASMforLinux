extern putchar

SECTION .bss
    inputBuffer resb 4
    termiosStruct resb 60
    originTermiosFlag resb 1

SECTION .text
    global getArrowInput
    global setTermios
    global resetTermios

setTermios:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rax, 16             ; 系统调用号: sys_ioctl
    mov rdi, 0              ; 文件描述符: stdin
    mov rsi, 21505          ; 请求码: TCGETS (获取termios结构)
    lea rdx, [termiosStruct] ; termios结构的地址
    syscall

    ; 设置终端为原始模式 (这里简化处理，实际需要更多设置)
    mov al, [termiosStruct+12]
    mov [originTermiosFlag], al
    mov byte [termiosStruct + 12], 0 ; c_lflag位置，关闭ECHO和ICANON

    ; 应用修改后的设置
    mov rax, 16             ; 系统调用号: sys_ioctl
    mov rdi, 0              ; 文件描述符: stdin
    mov rsi, 21506          ; 请求码: TCSETS (设置termios结构)
    lea rdx, [termiosStruct] ; termios结构的地址
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

resetTermios:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov al, [originTermiosFlag]
    mov [termiosStruct+12], al

    mov rax, 16             ; 系统调用号: sys_ioctl
    mov rdi, 0              ; 文件描述符: stdin
    mov rsi, 21506          ; 请求码: TCSETS (设置termios结构)
    lea rdx, [termiosStruct] ; termios结构的地址
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

getArrowInput:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rax, 0
    mov rdi, 0
    mov rsi, inputBuffer
    mov rdx, 3
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax

    ret