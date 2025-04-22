clear
rm -rf "./bin"
mkdir "./bin"

CC_FLAGS="-m32 -ffreestanding -fno-builtin -fno-stack-protector -nostdlib -nostartfiles \
-Wall -Wextra -Wpedantic -Wcast-align -Wcast-qual -Wmissing-declarations -Wmissing-prototypes \
-Wstrict-prototypes -Wold-style-definition -Wpointer-arith -Wundef -Wshadow -Wredundant-decls \
-Wdouble-promotion -Wformat=2 -Wconversion -Wsign-conversion -g"

nasm -f bin "./core/boot/1boot.s" -I "./core/boot/include" -o "./bin/1boot.bin"
nasm -f bin "./core/boot/2boot.s" -I "./core/boot/include" -o "./bin/2boot.bin"
nasm -f elf "./core/boot/3boot.s" -I "./core/boot/include" -o "./bin/3boot.o"

DISK_OBJ_FILES=""
for file in ./core/boot_manager/disk/*.c; do
    obj="./bin/$(basename "${file%.c}.o")"
    gcc -m32 -ffreestanding -c "$file" -I "./core/boot_manager/include" -o "$obj" ${CC_FLAGS}
    DISK_OBJ_FILES="$DISK_OBJ_FILES $obj"
done

PCI_OBJ_FILES=""
for file in ./core/boot_manager/pci/*.c; do
    obj="./bin/$(basename "${file%.c}.o")"
    gcc -m32 -ffreestanding -c "$file" -I "./core/boot_manager/include" -o "$obj" ${CC_FLAGS}
    PCI_OBJ_FILES="$PCI_OBJ_FILES $obj"
done

MEMORY_OBJ_FILES=""
for file in ./core/boot_manager/memory/*.c; do
    obj="./bin/$(basename "${file%.c}.o")"
    gcc -m32 -ffreestanding -c "$file" -I "./core/boot_manager/include" -o "$obj" ${CC_FLAGS}
    MEMORY_OBJ_FILES="$MEMORY_OBJ_FILES $obj"
done

DRAW_OBJ_FILES=""
for file in ./core/boot_manager/draw/*.c; do
    obj="./bin/$(basename "${file%.c}.o")"
    gcc -m32 -ffreestanding -c "$file" -I "./core/boot_manager/include" -o "$obj" ${CC_FLAGS}
    DRAW_OBJ_FILES="$DRAW_OBJ_FILES $obj"
done

PRINTF_OBJ_FILES=""
for file in ./core/boot_manager/printf/*.c; do
    obj="./bin/$(basename "${file%.c}.o")"
    gcc -m32 -ffreestanding -c "$file" -I "./core/boot_manager/include" -o "$obj" ${CC_FLAGS}
    PRINTF_OBJ_FILES="$PRINTF_OBJ_FILES $obj"
done

gcc -m32 -ffreestanding -c "./core/boot_manager/boot_manager.c" -I "./core/boot_manager/include" -o "./bin/boot_managerA.o" ${CC_FLAGS}

ld -T "./core/boot_manager/boot_manager.ld" -m elf_i386 -s -o "./bin/boot_manager.elf" ./bin/3boot.o ./bin/boot_managerA.o $MEMORY_OBJ_FILES $PCI_OBJ_FILES $DISK_OBJ_FILES $DRAW_OBJ_FILES $PRINTF_OBJ_FILES

objcopy -O binary "./bin/boot_manager.elf" "./bin/boot_manager.bin"

dd  if="./bin/1boot.bin"                    of="./bin/os.img"              bs=512
dd  if="./bin/2boot.bin"                    of="./bin/os.img"              bs=512          seek=1          # LBA 1 / Sector 2
dd  if="./bin/boot_manager.bin"             of="./bin/os.img"              bs=512          seek=5          # LBA 5 / Sector 6

qemu-img create -f raw disk.raw 64M

qemu-system-x86_64 \
  -drive format=raw,file=./bin/os.img,if=ide \
  -m 256M \
  -D error.log \
  -d int,cpu_reset \
  -device ahci,id=ahci0 \
  -drive id=disk0,file=disk.raw,format=raw,if=none \
  -device ide-hd,drive=disk0,bus=ahci0.0
