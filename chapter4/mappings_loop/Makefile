main: main.o
	ld -o main main.o

main.o: mappings_loop.asm
	nasm -felf64 -o main.o mappings_loop.asm
