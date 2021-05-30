```bash
$ cat mappings_loop.asm
section .data
correct: dq -1
section .text

global _start
_start:
  jmp _start
$ make
nasm -felf64 -o main.o mappings_loop.asm
ld -o main main.o
$ ./main &
[1] 28869
$ cat /proc/28869/maps
00400000-00402000 r-xp 00000000 103:02 1708332                           /home/tact/low-level-programming/chapter4/mappings_loop/main
00402000-00403000 rwxp 00002000 103:02 1708332                           /home/tact/low-level-programming/chapter4/mappings_loop/main
7ffcd60e1000-7ffcd6103000 rwxp 00000000 00:00 0                          [stack]
7ffcd619f000-7ffcd61a2000 r--p 00000000 00:00 0                          [vvar]
7ffcd61a2000-7ffcd61a3000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]
```

## /proc/[pid]/maps
### addressカラム
マッピングが締めているプロセスのアドレス空間
### permsカラム
パーミッションのセット
### offsetカラム
ファイル中でのオフセット
### devカラム
デバイス(メジャーデバイス番号:マイナーデバイス番号)
### inodeカラム
デバイスのiノード番号  
0はBSSのようにメモリ領域がどのiノードとも関連付けられていないことを意味する
