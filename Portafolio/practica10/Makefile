build:
	gcc -m32 -c Main.c
	nasm -f elf p10.asm
	gcc -m32 p10.o Main.o -no-pie -z noexecstack -o ../../bin/practica10.exe

run:
	./../../bin/practica10.exe