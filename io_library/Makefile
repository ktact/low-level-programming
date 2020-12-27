main: main.asm lib.asm
	nasm -felf64 main.asm -o main.o
	ld -g main.o -o main

test:
	python test.py

clean:
	rm -f main \
		parse_int parse_int.asm \
		parse_uint parse_uint.asm \
		print_char print_char.asm \
		print_int print_int.asm \
		print_string print_string.asm \
		print_uint print_uint.asm \
		read_char read_char.asm \
		read_word read_word.asm \
		read_word_length read_word_length.asm \
		read_word_too_long read_word_too_long.asm \
		string_copy string_copy.asm \
		string_copy_too_long string_copy_too_long.asm \
		string_equals string_equals.asm \
		'string_equals not equals' 'string_equals not equlas.asm' \
		string_length string_length.asm \
		*.o *.~

.PHONY: test clean
