# FreeRTOS STM32F446RE GCC

Author: Trevor Calderwood

The FreeRTOS STM32F4xx Demo ported to GCC from IAR Workbench.
Additionally, standard peripheral drivers are updated to the new HAL CMSIS
drivers.
This port is a work in progress.

## Dependencies

* FreeRTOS
* make
* arm-none-eabi-gcc
* st-link
* STM32CubeF4

## Usage

Clone the [FreeRTOS](https://github.com/FreeRTOS/FreeRTOS) and
[STM32CubeF4](https://github.com/STMicroelectronics/STM32CubeF4) repositories
into the project, using the --recursive flag.

`git clone --recursive https://github.com/FreeRTOS/FreeRTOS`

`git clone --recursive https://github.com/STMicroelectronics/STM32CubeF4`

### Make

The Makefile includes three targets:
* all (main.elf): the FreeRTOS binary
* flash: flashes main.elf to the STM32F446RE using st-link
* clean

## Directory Structure

* FreeRTOS-STM32F446RE-GCC/
  * [STM32CubeF4/](https://github.com/STMicroelectronics/STM32CubeF4)
  * [FreeRTOS/](https://github.com/FreeRTOS/FreeRTOS)
    * FreeRTOS/  
      * [Source/](https://github.com/FreeRTOS/FreeRTOS-Kernel)

> [!NOTE]
> If using the `--recursive` flag when cloning the above directories, you don't need to separately clone the FreeRTOS-Kernel repository (FreeRTOS/FreeRTOS/Source).