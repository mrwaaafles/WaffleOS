export PATH=$PATH:/usr/local/i386elfgcc/bin

nasm "boot/boot.asm" -f bin -o "Binaries/boot.bin"
nasm "boot/kernel_entry.asm" -f elf -o "Binaries/kernel_entry.o"
i386-elf-gcc -ffreestanding -m32 -g -c "kernel/kernel.cpp" -o "Binaries/kernel.o"
nasm "zeroes.asm" -f bin -o "Binaries/zeroes.bin"

i386-elf-ld -o "Binaries/full_kernel.bin" -Ttext 0x1000 "Binaries/kernel_entry.o" "Binaries/kernel.o" --oformat binary

cat "Binaries/boot.bin" "Binaries/full_kernel.bin" "Binaries/zeroes.bin"  > "Binaries/WaffleOS.bin"

qemu-system-x86_64 -drive format=raw,file="Binaries/WaffleOS.bin",index=0,if=floppy,  -m 128M
