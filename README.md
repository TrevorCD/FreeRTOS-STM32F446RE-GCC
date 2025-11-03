# FreeRTOS STM32F446RE GCC

Author: Trevor Calderwood

The FreeRTOS STM32F4xx Demo ported to GCC from IAR Workbench.
This port is a work in progress

## Dependencies

* FreeRTOS
* make
* arm-none-eabi-gcc
* st-link

## Usage

Clone the [FreeRTOS](https://github.com/FreeRTOS/FreeRTOS) and
[FreeRTOS-Kernel](https://github.com/FreeRTOS/FreeRTOS-Kernel) repositories
into the project, following the [Directory Structure](#directory-structure).

Copy the FreeRTOS 'stdint.h' into the demo directory. This file can be found in
FreeRTOS/FreeRTOS/Demo/PIC18_MPLAB/.

### Make

The Makefile includes three targets:
* all (main.elf): the FreeRTOS binary
* flash: flashes main.elf to the STM32F446RE using st-link
* clean

## Directory Structure

* FreeRTOS-STM32F446RE-GCC/
  * Makefile  
  * main.c  
  * [FreeRTOS/](https://github.com/FreeRTOS/FreeRTOS)
    * FreeRTOS/  
      * [Source/](https://github.com/FreeRTOS/FreeRTOS-Kernel)
