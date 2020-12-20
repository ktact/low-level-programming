test: test.asm lib.asm
	nasm -felf64 test.asm -o test.o
	ld test.o -o test
	./test

clean:
	rm -f test *.o *.~

.PHONY: test clean
