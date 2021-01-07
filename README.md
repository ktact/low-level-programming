# low-level-programming

## x86-64アセンブリ

## x86-64命令
詳細は必ず[Intel® 64 and IA-32 Architectures Software Developer's Manual Combined Volumes 2A, 2B, 2C, and 2D: Instruction Set Reference, A-Z](https://software.intel.com/content/www/us/en/develop/download/intel-64-and-ia-32-architectures-sdm-combined-volumes-2a-2b-2c-and-2d-instruction-set-reference-a-z.html)を確認すること。

### `xor` - 排他的論理和
#### 動作
  ```
  DEST = DEST XOR SRC
  ```
  |フラグ|OF|SF|ZF|AF|CF|PF|
  |---|---|---|---|---|---|---|
  |実行後|0|?|?|`undefined`|0|?|
  
  ※?は演算結果に従って値が設定されることを示す。

#### 実行例
  ```asm
  xor rax, rax ; rax=0
  ```

### `jmp`
### `ja`
### `cmp`
### `mov`
### `inc`
### `dec`
### `add`
### `imul`
### `mul`
### `sub`
### `idiv`
### `div`
### `neg`
### `call`
### `ret`
### `push`
### `pop`

## x86-64Linuxシステムコール
### 1. 呼び出し方法
`rax`にシステムコール番号を設定し、
* 必要であれば第1引数を`rdi`に設定し
* 必要であれば第2引数を`rsi`に設定し
* 必要であれば第3引数を`rdx`に設定し
* 必要であれば第4引数を`r10`に設定し
* 必要であれば第5引数を`r8`に設定し
* 必要であれば第6引数を`r9`に設定し  

`systemcall`命令を実行する。

### 2. 呼び出し例

下記のように`exit`システムコールを呼び出す。

```asm
section .text

global _start

exit:
    mov rdi, rdi    ; 第1引数（exit code）に0を設定
    mov rax, 60     ; raxにシステムコール番号60を設定
    syscall

_start:
    call exit
```

※サンプルコードは下記手順に従って実際に動作確認を行うことができる。
  ```bash
  $ nasm -felf64 exit.asm -o exit.o
  $ ld exit.o -o exit
  $ ./exit
  $ echo $? # exit codeを確認する
  0
  ```

### 3. システムコール番号
|システムコール名|番号|
|---|---|
|exit|60|
