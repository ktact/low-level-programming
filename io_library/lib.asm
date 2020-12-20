section .text

; Call 'exit' systemcall.
;   rdi points to a exit code.
exit:
    mov rdi, rdi
    mov rax, 60
    syscall

; rdi points to a address
string_length:
    xor rax, rax
.string_length_loop:
    cmp byte [rdi + rax], 0
    je .string_length_end
    inc rax
    jmp .string_length_loop
.string_length_end:
    ret

print_string:
    xor rax, rax
    ret

print_char:
    xor rax, rax
    ret

print_newline:
    xor rax, rax
    ret

print_uint:
    xor rax, rax
    ret


print_int:
    xor rax, rax
    ret

string_equals:
    xor rax, rax
    ret

read_char:
    xor rax, rax
    ret

read_word:
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_uint:
    xor rax, rax
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_int:
    xor rax, rax
    ret

string_copy:
    ret
