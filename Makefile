# Author: Trevor Calderwood
#
# This Makefile is for compiling FreeRTOS and flashing to an STM32F446RE.
#
# File paths in this Makefile assume the same structure as the FreeRTOS github
# repository. FreeRTOS/FreeRTOS/Source contains the FreeRTOS-Kernel repository.
#
# FreeRTOS:           https://github.com/FreeRTOS/FreeRTOS
# FreeRTOS-Kernel:    https://github.com/FreeRTOS/FreeRTOS-Kernel
#
# Dependencies:
#   - arm-none-eabi-gcc
#   - st-link


#-------------------------------[ Build Config ]--------------------------------

# File path macros should include trailing '/'.
# Path to common headers for FreeRTOS Demos: Demo/Common/include
DEMO  := ./FreeRTOS/FreeRTOS/Demo/Common/include/
# Path to FreeRTOS Kernel source code
KERNEL := ./FreeRTOS/FreeRTOS/Source/
# Path to STM32CubeF4 CMSIS Drivers
DRIVERS := ./STM32CubeF4/Drivers/

CC := arm-none-eabi-gcc
AS := arm-none-eabi-as
CP := arm-none-eabi-objcopy

# Not mentioned in datasheet: M4 FPU has 16 double percision fp registers (d16)
CFLAGS := -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -O2 -g -v

CFLAGS += -I./ \
          -I./include \
          -I$(DRIVERS)CMSIS/Include \
          -I$(DRIVERS)CMSIS/Device/ST/STM32F4xx/Include \
          -I$(DRIVERS)BSP/STM32F4xx-Nucleo \
          -I$(DRIVERS)STM32F4xx_HAL_Driver/Inc \
          -I$(DEMO) \
          -I$(KERNEL)include \
          -I$(KERNEL)portable/GCC/ARM_CM4F

# Preprocessor definitions
CFLAGS += -DSTM32F446xx

# Vendor supplied script for flashing to MCU
LDSCRIPT := STM32F446RETX_FLASH.ld

# Linker flags
CFLAGS += -T $(LDSCRIPT) -nostartfiles -Wl,--gc-sections

SRCS := main.c \
       $(KERNEL)tasks.c \
       $(KERNEL)queue.c \
       $(KERNEL)list.c \
       $(KERNEL)portable/MemMang/heap_4.c \
       $(KERNEL)portable/GCC/ARM_CM4F/port.c \
       $./startup/startup_stm32f4xx.s

OBJS := $(SRCS:.c=.o)


#----------------------------------[ Targets ]----------------------------------

all: main.elf

main.elf: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $@

flash: main.elf
	st-flash write main.elf 0x8000000

clean:
	rm -f $(OBJS) main.elf
