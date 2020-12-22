%include "lib.asm"

section .data

test_string: db "abcdef", 0

section .text

global _start

_start:
    mov rdi, test_string
    call print_string
    call print_newline
    call read_char
    mov rdi, rax
    call print_uint
    call print_newline
    xor rdi, rdi        ; rdx = 0
    call exit
