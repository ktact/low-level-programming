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
    test rdi, rdi
    jns print_uint
    push rdi
    mov rdi, '-'
    call print_char
    pop rdi
    neg rdi
    jmp print_uint
    ret

; rdi points to a string1
; rsi points to a string2
; returns rax: number(0: STR1!=STR2, 1: STR1=STR2)
string_equals:
    mov al, byte [rdi]
    cmp al, byte [rsi]
    jne .no
    inc rdi
    inc rsi
    test al, al
    jnz string_equals
    mov rax, 1
    ret
    .no:
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

; rdi : buffer address
; rsi : buffer length
; returns rax : buffer address, rdx : length of word
read_word:
    push r14
    push r15
    xor r14, r14
    mov r15, rsi
    dec r15                         ; 終端文字を除いた長さにしておく

.first_char_is_whitespace:
    push rdi
    call read_char
    pop rdi
    ; 1文字目が空白文字の場合
    cmp al, ' '
    je .first_char_is_whitespace
    cmp al, 9
    je .first_char_is_whitespace
    cmp al, 10
    je .first_char_is_whitespace
    cmp al, 13
    je .first_char_is_whitespace
    test al, al
    jz .reaches_end_of_string

.read_next_char:
    mov byte[rdi + r14], al         ; 読み込んだ文字をバッファに格納する
    inc r14                         ; ポインタを次の文字に移動する

    push rdi
    call read_char
    pop rdi
    cmp al, ' '
    je .reaches_end_of_string
    cmp al, 9
    cmp al, 10
    je .reaches_end_of_string
    cmp al, 13
    je .reaches_end_of_string
    test al, al
    je .reaches_end_of_string
    cmp r14, r15                    ; バッファ長超過したか確認
    je .reaches_end_of_buffer
    jmp .read_next_char

.reaches_end_of_string:
    mov byte[rdi + r14], 0          ; ヌルで終わらせる
    mov rax, rdi                    ; returns rax : buffer address
    mov rdx, r14                    ; returns rdx : length of word
    pop r15
    pop r14
    ret

.reaches_end_of_buffer:
    xor rax, rax
    pop r15
    pop r14
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_uint:
    mov r8, 10
    xor rax, rax            ; RAX=0
    xor rcx, rcx            ; RCX=0
.loop:
    movzx r9, byte[rdi+rcx]

    ; '0'〜'9'以外の文字が出現した場合には処理を終了する
    cmp r9b, '0'
    jb  .end
    cmp r9b, '9'
    ja  .end

    xor rdx, rdx            ; RDX=0
    mul r8                  ; RAX * 10
    and r9b, 0x0f
    add rax, r9
    inc rcx
    jmp .loop
.end:
    mov rdx, rcx
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_int:
    mov al, byte[rdi]
    cmp al, '-'
    je .signed
    jmp parse_uint

.signed:
    inc rdi
    call parse_uint
    neg rax
    test rdx, rdx
    jz .error
    ret

.error:
    xor rax, rax
    ret

; rdi = src
; rsi = dst
; rdx = dst length
string_copy:
    push rdi
    push rsi
    push rdx
    call string_length  ; RAX = src length
    pop rdx
    pop rsi
    pop rdi

    cmp rax, rdx
    jae .too_long

.loop:
    ; byte[RDX] = byte[RDI]
    mov dl, byte[rdi]
    mov byte[rsi], dl
    inc rdi
    inc rsi
    test dl, dl
    jnz .loop
    ret

    pop rax
    ret

.too_long:
    xor rax, rax
    ret
