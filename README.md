# FreeRTOS STM32F446RE GCC

The FreeRTOS STM32F4xx Demo ported to GCC from IAR Workbench.
The files main.c, ParTest.s, FreeRTOSConfig.h, and stm32f4xx_conf.h are
sourced from the CORTEX_M4F_STM32F407ZG-SK demo. 
Additionally, standard peripheral drivers are updated to HAL CMSIS drivers.
This port is a work in progress.

## Dependencies

* FreeRTOS
* make
* arm-none-eabi-gcc
  * arm-none-eabi-newlib
* st-link
* STM32CubeF4

## Usage

Clone the [FreeRTOS](https://github.com/FreeRTOS/FreeRTOS) and
[STM32CubeF4](https://github.com/STMicroelectronics/STM32CubeF4) repositories
into the project, using the --recursive flag.

```
git clone --recursive https://github.com/FreeRTOS/FreeRTOS
```
```
git clone --recursive https://github.com/STMicroelectronics/STM32CubeF4
```
### Config

If you use a different STM32F4xx board with this port, you need to change the
following:

* ./Makefile
  * In Build Config, change `-DSTM32F446xx` to the appropriate definition for your board. This sets the appropriate board specific includes in stm32f4xx.h. To check which definition matches your board, find this file in `./STM32CubeF4/Drivers/CMSIS/Device/ST/STM32F4xx/Include`.
  * In Build Config, change `LDSCRIPT` to match your board. Also, move the appropriate script to `./`. The flash script can be found in `./STM32CubeF4/Projects/[BOARD NAME]/Templates/STM32CubeIDE/`.

You may need to change the FREERTOS_ROOT and STM_DRIVERS macros in the Makefile
if the paths do not match the [directory structure](#directory-structure).

### Make

The Makefile includes these targets:
* all: compiles the FreeRTOS image (main.elf)
* flash: flashes main.elf to the STM32F446RE using st-link
* clean
* debug: starts an openocd server to communicate with the st-link and attaches gdb
* gdb: starts gdb and attaches (if the server is already running)

## Directory Structure

* FreeRTOS-STM32F446RE-GCC/
  * [STM32CubeF4/](https://github.com/STMicroelectronics/STM32CubeF4)
  * [FreeRTOS/](https://github.com/FreeRTOS/FreeRTOS)
    * FreeRTOS/  
      * [Source/](https://github.com/FreeRTOS/FreeRTOS-Kernel)

> [!NOTE]
> If using the `--recursive` flag when cloning the above directories, you don't need to separately clone the FreeRTOS-Kernel repository (FreeRTOS/FreeRTOS/Source).
