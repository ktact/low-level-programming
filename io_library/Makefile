main: main.asm lib.asm
	nasm -felf64 main.asm -o main.o
	ld -g main.o -o main

test:
	python test.py

clean:
	rm -f main *.o *.~

.PHONY: test clean
