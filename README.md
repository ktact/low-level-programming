# low-level-programming

## x86-64レジスタ
### RFLAGS - フラグレジスタ

下位22ビットのみ使用する。
|7|6|5|4|3|2|1|0|7|6|5|4|3|2|1|0|7|6|5|4|3|2|1|0|
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|||ID|VIP|VIF|AC|VM|RF|0|NT|>|IOPL|OF|DF|IF|TF|SF|ZF|0|AF|0|PF|1|CF|

#### OF - オーバーフローフラグ
算術演算の結果が2の補数で表せない大きさの場合にセットされる

#### SF - 符号フラグ
演算結果の最上位ビットと同じ値にセットされる（2の補数の正負を表す）

#### ZF - ゼロフラグ
演算結果がゼロの場合にセットされる

#### AF
キャリーやボローが発生した場合にセットされる

#### PF - パリティフラグ
演算結果の下位8ビットのパリティ（偶奇）を表し、下位8ビットの1が偶数個なら1、奇数個なら0がセットされる

#### CF - キャリーフラグ
算術演算、シフト、ローテート命令で最上位ビットまたは再開ビットから桁溢れが発生した場合にセットされる

## x86-64命令
詳細は必ず[Intel® 64 and IA-32 Architectures Software Developer's Manual Combined Volumes 2A, 2B, 2C, and 2D: Instruction Set Reference, A-Z](https://software.intel.com/content/www/us/en/develop/download/intel-64-and-ia-32-architectures-sdm-combined-volumes-2a-2b-2c-and-2d-instruction-set-reference-a-z.html)を確認すること。  
※オペコード概要表のオペコード列の表記は`3.1.1.1 Opcode Column in the Instruction Summary Table(Instructions without VEX Prefix)`を参照  
※オペコード概要表の命令列の表記は`3.1.1.3 Instruction Column in the Opcode Summary Table`を参照

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
### `ja` - jump short if avove(CF=0 and ZR=0)

### `add` - 加算
#### 動作
  ```
  DEST = DEST + SRC
  ```
  |フラグ|OF|SF|ZF|AF|CF|PF|
  |---|---|---|---|---|---|---|
  |実行後|?|?|?|?|?|?|

  ※?は演算結果に従って値が設定されることを示す。

#### 実行例
  ```asm
  add rax, 0x100
  ```

### `sub` - 減算
#### 動作
  ```
  DEST = DEST - SRC
  ```
  |フラグ|OF|SF|ZF|AF|CF|PF|
  |---|---|---|---|---|---|---|
  |実行後|?|?|?|?|?|?|

※?は演算結果に従って値が設定されることを示す。

#### 実行例
  ```asm
  sub rax, 0x200
  ```

### `neg` - 2の補数
#### オペコード概要
  |オペコード|命令|説明|
  |---|---|---|
  |F6 /3|NEG r/m8|r/m8の2の補数を求め、結果をr/m8に代入|
  |REX + F6 /3|NEG r/m8*|r/m8の2の補数を求め、結果をr/m8に代入|
  |F7 /3|NEG r/m16|r/m16の2の補数を求め、結果をr/m16に代入|
  |F7 /3|NEG r/m32|r/m32の2の補数を求め、結果をr/m32に代入|
  |REX.W + F7 /3|NEG r/m64|r/m64の2の補数を求め、結果をr/m64に代入|

#### 動作
  ```
  IF DEST = 0
    THEN CF = 0
    ELSE CF = 1
  FI
  DEST = -DEST
  ```
  |フラグ|OF|SF|ZF|AF|CF|PF|
  |---|---|---|---|---|---|---|
  |実行後|?|?|?|?|?|?|

  ※?は演算結果に従って値が設定されることを示す。

#### 実行例
   ```asm
   mov rax, 1
   neg rax
   ```

### `cmp` - 2値比較
#### 動作
  ```
  temp = SRC1 - SignExtend(SRC2)
  ModifyStatusFlags // SRC1、SRC2を引数としてSUB命令を実行した場合と同様にステータスフラグを変更する
  ```
  |フラグ|OF|SF|ZF|AF|CF|PF|
  |---|---|---|---|---|---|---|
  |実行後|?|?|?|?|?|?|

  ※?は演算結果に従って値が設定されることを示す。

#### 実行例
  ```asm
  ; if (rax == 0) goto ZERO;
  cmp rax, 0
  je .ZERO
  ```

### `mov`
### `inc`
#### 動作
  ```
  DEST = DEST + 1
  ```
  |フラグ|OF|SF|ZF|AF|CF|PF|
  |---|---|---|---|---|---|---|
  |実行後|?|?|?|?|`not affected`|?|

  ※?は演算結果に従って値が設定されることを示す。

#### 実行例
  ```asm
  inc rax
  ```

### `dec`
#### 動作
  ```
  DEST = DEST - 1
  ```
  |フラグ|OF|SF|ZF|AF|CF|PF|
  |---|---|---|---|---|---|---|
  |実行後|?|?|?|?|`not affected`|?|

  ※?は演算結果に従って値が設定されることを示す。

#### 実行例
  ```asm
  dec rax
  ```



### `imul`
### `mul`
### `idiv`
### `div`
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
