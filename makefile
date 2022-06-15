CC=gcc
ASMBIN=nasm
ASM_SRC=functions

all: assemble compile link

assemble: $(ASM_SRC).asm
	$(ASMBIN) -o $(ASM_SRC).o -f elf64 -g -l $(ASM_SRC).lst $(ASM_SRC).asm
compile: assemble main.c
	$(CC) -c -g -O0 main.c src/img_helpers.c src/coding_utils.c -std=c99

link: compile
	$(CC) -g -o program main.o img_helpers.o coding_utils.o $(ASM_SRC).o

clean:
	rm *.o
	rm program
	rm output.bmp
	rm $(ASM_SRC).lst

