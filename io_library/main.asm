%include "lib.asm"

section .data

test_string: db "abcdef", 0
test_number: db "123456", 0

section .text

global _start

_start:
    mov rdi, test_string
    call print_string
    call print_newline
    mov rdi, -1
    call print_int
    call print_newline
    mov rdi, 1
    call print_int
    call print_newline
    mov rdi, test_number
    call parse_uint
    mov rdi, rax
    call print_int
    call print_newline
    call read_char
    mov rdi, rax
    call print_int
    call print_newline
    xor rdi, rdi        ; rdx = 0
    call exit
