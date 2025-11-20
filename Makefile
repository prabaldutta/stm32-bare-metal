TARGET=firmware
CC=arm-none-eabi-gcc
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy
CFLAGS=-mcpu=cortex-m0plus -mthumb -O2 -Wall -nostdlib


all: $(TARGET).bin


startup.o: startup.s
	$(AS) -mcpu=cortex-m0plus -mthumb startup.s -o startup.o


main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o


$(TARGET).elf: main.o startup.o linker.ld
	$(CC) $(CFLAGS) main.o startup.o -T linker.ld -o $(TARGET).elf


$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

jlink: $(TARGET).bin
	JLinkExe -device STM32C011J4 -if SWD -speed 4000 -autoconnect 1

jlinkscr: $(TARGET).bin
	JLinkExe -commandfile script.jlink

clean:
	rm -f *.o *.elf *.bin
