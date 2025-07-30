.PHONY: clean, .force-rebuild
all: IslandBoot.bin

IslandBoot.bin: src/map.asm .force-rebuild
	nasm -fbin src/map.asm -o map.bin

clean:
	rm *.bin
