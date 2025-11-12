#
#   Copyright 2025 Trevor Calderwood
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#-------------------------------------------------------------------------------
#
#  Makefile: Compiles FreeRTOS and flashes the binary to an STM32F446RE.
#
#  File paths in this Makefile assume the same structure as the FreeRTOS github
#  repository. FreeRTOS/FreeRTOS/Source contains the FreeRTOS-Kernel repository.
#  The STM32CubeF4 github repository is also required.
#
#  FreeRTOS:           https://github.com/FreeRTOS/FreeRTOS
#  FreeRTOS-Kernel:    https://github.com/FreeRTOS/FreeRTOS-Kernel
#  STM32CubeF4:        https://github.com/STMicroelectronics/STM32CubeF4
#
#
#  Software Dependencies:
#    - arm-none-eabi-gcc
#    - st-link
#
#-------------------------------[ Build Config ]--------------------------------

#
# Following definitions should match directory structure and exact board
#

# Path to FreeRTOS root dir. Should have Demo/ and Source/ subdirs
FREERTOS_ROOT := ./FreeRTOS/FreeRTOS

# Path to STM32CubeF4 Drivers. Should have BSP/ and CMSIS/ subdirs
STM_DRIVERS := ./STM32CubeF4/Drivers

# Preprocessor definition for exact board
BOARD := -DSTM32F446xx

# Vendor supplied script for flashing to MCU
FLASH_SCRIPT := STM32F446RETX_FLASH.ld

#
#          !!! Config below here should not be meddled with !!!
#

# Path to FreeRTOS Common Demo files. Should have Minimal/ and include/ subdirs
DEMO_COMMON := $(FREERTOS_ROOT)/Demo/Common
# Path to FreeRTOS Kernel source. Should have portable/ and include/ subdirs
KERNEL_DIR := $(FREERTOS_ROOT)/Source

CC := arm-none-eabi-gcc
AS := arm-none-eabi-as
CP := arm-none-eabi-objcopy

# Not mentioned in datasheet: M4 FPU has 16 double percision fp registers (d16)
CFLAGS := -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16

CFLAGS += -O2 -g -std=c99
# Include dirs
CFLAGS += -I. \
          -Iinclude \
          -I$(DEMO_COMMON)/include \
          -I$(KERNEL_DIR)/include \
          -I$(KERNEL_DIR)/portable/GCC/ARM_CM4F \
          -I$(STM_DRIVERS)/CMSIS/Include \
          -I$(STM_DRIVERS)/CMSIS/Device/ST/STM32F4xx/Include \
          -I$(STM_DRIVERS)/BSP/STM32F4xx-Nucleo \
          -I$(STM_DRIVERS)/STM32F4xx_HAL_Driver/Inc

# Linker flags
LDFLAGS += -T $(FLASH_SCRIPT) -nostartfiles -Wl,--gc-sections

SRCS := src/main.c \
        src/partest.c \
        src/system_stm32f4xx.c \
        $(DEMO_COMMON)/Minimal/flash.c \
        $(DEMO_COMMON)/Minimal/flop.c \
        $(DEMO_COMMON)/Minimal/integer.c \
        $(DEMO_COMMON)/Minimal/PollQ.c \
        $(DEMO_COMMON)/Minimal/semtest.c \
        $(DEMO_COMMON)/Minimal/dynamic.c \
        $(DEMO_COMMON)/Minimal/BlockQ.c \
        $(DEMO_COMMON)/Minimal/blocktim.c \
        $(DEMO_COMMON)/Minimal/countsem.c \
        $(DEMO_COMMON)/Minimal/GenQTest.c \
        $(DEMO_COMMON)/Minimal/recmutex.c \
        $(DEMO_COMMON)/Minimal/death.c \
        $(KERNEL_DIR)/tasks.c \
        $(KERNEL_DIR)/queue.c \
        $(KERNEL_DIR)/list.c \
        $(KERNEL_DIR)/timers.c \
        $(KERNEL_DIR)/event_groups.c \
        $(KERNEL_DIR)/portable/MemMang/heap_4.c \
        $(KERNEL_DIR)/portable/GCC/ARM_CM4F/port.c \
        $(STM_DRIVERS)/BSP/STM32F4xx-Nucleo/stm32f4xx_nucleo.c \
        $(STM_DRIVERS)/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c \
        $(STM_DRIVERS)/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c \
        $(STM_DRIVERS)/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c \
        $(STM_DRIVERS)/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c \
        $(STM_DRIVERS)/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c

# ASM files not included in OBJS. Prevents 'make clean' from deleting .s files.
ASM_SRCS := src/startup_stm32f446xx.s \
            src/RegTest.s

OBJS := $(SRCS:.c=.o)

#----------------------------------[ Targets ]----------------------------------

all: main.elf

main.elf: $(OBJS) $(ASM_SRCS)
	$(CC) $(CFLAGS) $(BOARD) $(OBJS) $(ASM_SRCS) $(LDFLAGS) -o $@

flash: main.elf
	st-flash write main.elf 0x8000000

clean:
	rm -f $(OBJS) main.elf
