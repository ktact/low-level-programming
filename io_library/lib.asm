section .text

; Call 'exit' systemcall.
;   rdi points to a exit code.
exit:
    mov rdi, rdi
    mov rax, 60
    syscall

; rdi points to a string
string_length:
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

; rdi points to a string
print_string:
    push rdi            ; 文字列のアドレスを退避
    call string_length  ; raxに文字列長がセットされる
    pop rsi             ; 書き込むデータのアドレス
    mov rdx, rax        ; 書き込むバイト数
    mov rax, 1          ; 'write'システムコールのID
    mov rdi, 1          ; stdoutファイルのディスクリプタ
    syscall
    ret

; rdi points to an ASCII code
print_char:
    push rdi
    mov rdi, rsp
    call print_string
    pop rdi
    ret

print_newline:
    mov rdi, 10
    call print_char
    ret

print_uint:
    mov rax, rdi
    mov rdi, rsp        ; バッファ確保
    push 0              ; 終端記号を予めセットしておく
    sub rsp, 16
    dec rdi             ; 終端記号の1文字前にRDIをセット

    mov r8, 10

.loop:
    xor rdx, rdx        ; RDX=0
    div r8              ; RDX:RAX / 10 RAX=商, RDX=剰余
    or dl, 0x30         ; 剰余=10進数に変換した際のn桁目の数値をASCII化
    dec rdi
    mov [rdi], dl       ; 文字コードをバッファに格納
    test rax, rax
    jnz .loop           ; 商が0になるまでループ

    call print_string   ; 印字

    add rsp, 24         ; SP復帰

    ret


print_int:
    xor rax, rax
    ret

string_equals:
    xor rax, rax
    ret

read_char:
    push 0              ; 1バイト分のメモリ確保
    xor rax, rax        ; RAX='read'のID
    xor rdi, rdi        ; RDI=STDIN
    mov rsi, rsp        ; SPに読み込んだデータを格納する
    mov rdx, 1          ; 読み出すバイト数
    syscall
    pop rax             ; 読み込んだ値を戻り値にする
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
