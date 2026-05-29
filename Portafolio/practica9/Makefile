build:
	gcc -m32 -c MAIN.c
	nasm -f elf p9.asm
	gcc -m32 p9.o MAIN.o -no-pie -z noexecstack -o ../../bin/practica9.exe

run:
	./../../bin/practica9.exe