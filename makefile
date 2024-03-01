all: main

main: main.o out.o in.o gameArea.o utils.o
	ld main.o out.o in.o gameArea.o utils.o -o main

out.o: out.S
	nasm -f elf64 out.S -o out.o

in.o: in.S
	nasm -f elf64 in.S -o in.o

gameArea.o: gameArea.S
	nasm -f elf64 gameArea.S -o gameArea.o

utils.o: utils.S
	nasm -f elf64 utils.S -o utils.o

main.o: main.S
	nasm -f elf64 main.S -o main.o

test_out: test_out.o out.o
	ld test_out.o out.o -o test_out

test_out.o: test_out.s
	nasm -f elf64 test_out.s -o test_out.o