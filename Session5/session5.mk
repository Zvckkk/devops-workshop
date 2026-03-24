# Define variables
CC := gcc
CFLAGS := -Wall -O2
TARGET := program
DIST_DIR := dist

# Default target
all: build prepare_hex

# Build the ELF file
build:
	$(CC) $(CFLAGS) main.c -o $(DIST_DIR)/$(TARGET).elf

# Convert ELF to HEX
prepare_hex:
	objcopy -O ihex $(DIST_DIR)/$(TARGET).elf $(DIST_DIR)/$(TARGET).hex

# Clean the build directory
clean:
	rm -rf $(DIST_DIR)
	mkdir -p $(DIST_DIR)

# Declare phony targets
.PHONY: all build clean prepare_hex
