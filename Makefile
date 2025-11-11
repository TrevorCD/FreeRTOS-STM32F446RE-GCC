# Author: Trevor Calderwood
#
# This Makefile is for compiling FreeRTOS and flashing to an STM32F446RE.
#
# File paths in this Makefile assume the same structure as the FreeRTOS github
# repository. FreeRTOS/FreeRTOS/Source contains the FreeRTOS-Kernel repository.
# The STM32CubeF4 github repository is also referenced by DRIVERS.
#
# FreeRTOS:           https://github.com/FreeRTOS/FreeRTOS
# FreeRTOS-Kernel:    https://github.com/FreeRTOS/FreeRTOS-Kernel
# STM32CubeF4:        https://github.com/STMicroelectronics/STM32CubeF4
#
# Dependencies:
#   - arm-none-eabi-gcc
#   - st-link


#-------------------------------[ Build Config ]--------------------------------

# File path macros must include trailing '/'
# Path to FreeRTOS Common Demo files. Should have Minimal/ and include/ subdirs
DEMO  := ./FreeRTOS/FreeRTOS/Demo/Common/
# Path to FreeRTOS Kernel source. Should have portable/ and include/ subdirs
KERNEL := ./FreeRTOS/FreeRTOS/Source/
# Path to STM32CubeF4 Drivers. Should have BSP/ and CMSIS/ subdirs
DRIVERS := ./STM32CubeF4/Drivers/

CC := arm-none-eabi-gcc
AS := arm-none-eabi-as
CP := arm-none-eabi-objcopy

# Not mentioned in datasheet: M4 FPU has 16 double percision fp registers (d16)
CFLAGS := -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -O2 -g

CFLAGS += -I. \
          -Iinclude \
          -I$(DRIVERS)CMSIS/Include \
          -I$(DRIVERS)CMSIS/Device/ST/STM32F4xx/Include \
          -I$(DRIVERS)BSP/STM32F4xx-Nucleo \
          -I$(DRIVERS)STM32F4xx_HAL_Driver/Inc \
          -I$(DEMO)include \
          -I$(KERNEL)include \
          -I$(KERNEL)portable/GCC/ARM_CM4F

# Preprocessor definitions
CFLAGS += -DSTM32F446xx

# Vendor supplied script for flashing to MCU
LDSCRIPT := STM32F446RETX_FLASH.ld

# Linker flags
LDFLAGS += -T $(LDSCRIPT) -nostartfiles -Wl,--gc-sections

SRCS := src/main.c \
        src/partest.c \
        src/system_stm32f4xx.c \
        $(KERNEL)tasks.c \
        $(KERNEL)queue.c \
        $(KERNEL)list.c \
        $(KERNEL)portable/MemMang/heap_4.c \
        $(KERNEL)portable/GCC/ARM_CM4F/port.c \
        $(DRIVERS)BSP/STM32F4xx-Nucleo/stm32f4xx_nucleo.c \
        $(DEMO)Minimal/flash.c \
        $(DEMO)Minimal/flop.c \
        $(DEMO)Minimal/integer.c \
        $(DEMO)Minimal/PollQ.c \
        $(DEMO)Minimal/semtest.c \
        $(DEMO)Minimal/dynamic.c \
        $(DEMO)Minimal/BlockQ.c \
        $(DEMO)Minimal/blocktim.c \
        $(DEMO)Minimal/countsem.c \
        $(DEMO)Minimal/GenQTest.c \
        $(DEMO)Minimal/recmutex.c \
        $(DEMO)Minimal/death.c

# ASM files not included in OBJS. Prevents 'make clean' from deleting .s files.
ASRCS := src/startup_stm32f446xx.s

OBJS := $(SRCS:.c=.o)

#----------------------------------[ Targets ]----------------------------------

all: main.elf

main.elf: $(OBJS) $(ASRCS)
	$(CC) $(CFLAGS) $(OBJS) $(ASRCS) $(LDFLAGS) -o $@

flash: main.elf
	st-flash write main.elf 0x8000000

clean:
	rm -f $(OBJS) main.elf
