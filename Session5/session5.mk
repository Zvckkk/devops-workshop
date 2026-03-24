
CC=gcc
CFLAGS=-Wall -O2
TARGET=program
DIST_DIR=dist

all: build prepare_hex

build:
    $(CC) $(CFLAGS) main.c -o $(DIST_DIR)/$(TARGET).elf

prepare_hex:
    objcopy -O ihex $(DIST_DIR)/$(TARGET).elf $(DIST_DIR)/$(TARGET).hex

clean:
    rm -rf $(DIST_DIR)
    mkdir -p $(DIST_DIR)

.PHONY: all build clean prepare_hex
