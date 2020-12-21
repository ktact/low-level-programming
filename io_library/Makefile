main: main.asm lib.asm
	nasm -felf64 main.asm -o main.o
	ld -g main.o -o main

test:
	./main

clean:
	rm -f main *.o *.~

.PHONY: test clean
