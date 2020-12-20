%include "lib.asm"

section .data

test_string: db "abcdef", 0

section .text

global _start

_start:
    mov rdi, test_string
    call exit
