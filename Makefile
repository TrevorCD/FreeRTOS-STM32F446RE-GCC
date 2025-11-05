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

CC := arm-none-eabi-gcc
AS := arm-none-eabi-as
CP := arm-none-eabi-objcopy

# File path macros should include trailing '/'.
# Path to demo for STM32F4xx
DEMO   := ./FreeRTOS/FreeRTOS/Demo/CORTEX_M4F_STM32F407ZG-SK/
# Path to Demo/Common/include/
DEMOI  := ./FreeRTOS/FreeRTOS/Demo/Common/include/
# Path to FreeRTOS Kernel source code
KERNEL := ./FreeRTOS/FreeRTOS/Source/

# Not mentioned in datasheet: M4 FPU has 16 double percision fp registers (d16)
CFLAGS := -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -O2 -g -v

CFLAGS += -I./include \
          -I./CMSIS \
          -I./Libraries \
          -I./Libraries/STM32F4xx_StdPeriph_Driver/inc \
          -I$(DEMO) \
          -I$(DEMO)Libraries/CMSIS \
          -I$(DEMO)Libraries/CMSIS/Device/ST/STM32F4xx/Include \
          -I$(DEMO)board \
          -I$(DEMOI) \
          -I$(KERNEL)include \
          -I$(KERNEL)portable/GCC/ARM_CM4F \
#          -I./FreeRTOS/FreeRTOS/Demo/CORTEX_M4F_CEC1302_Keil_GCC/CMSIS

CFLAGS += -DSTM32F4xx

# Vendor supplied script for flashing to MCU
LDSCRIPT := STM32F446RE_FLASH.ld
# Linker flags
CFLAGS += -T $(LDSCRIPT) -nostartfiles -Wl,--gc-sections

SRCS := main.c \
       $(KERNEL)tasks.c \
       $(KERNEL)queue.c \
       $(KERNEL)list.c \
       $(KERNEL)portable/MemMang/heap_4.c \
       $(KERNEL)portable/GCC/ARM_CM4F/port.c \
       $(DEMO)startup/startup_stm32f4xx.s

OBJS := $(SRCS:.c=.o)


#----------------------------------[ Targets ]----------------------------------

all: main.elf

main.elf: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $@

flash: main.elf
	st-flash write main.elf 0x8000000

clean:
	rm -f $(OBJS) main.elf
