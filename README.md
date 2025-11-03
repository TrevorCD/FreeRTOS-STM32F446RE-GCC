# FreeRTOS STM32F446RE GCC

Author: Trevor Calderwood


## Usage

Clone the [FreeRTOS](https://github.com/FreeRTOS/FreeRTOS) and
[FreeRTOS-Kernel](https://github.com/FreeRTOS/FreeRTOS-Kernel) repositories
into the project, following the [Directory Structure](#directory-structure).

Copy the FreeRTOS 'stdint.h' into the demo directory. This file can be found in
FreeRTOS/FreeRTOS/Demo/PIC18_MPLAB/.

## Directory Structure

* FreeRTOS-STM32F446RE-GCC/
  * Makefile  
  * main.c  
  * [FreeRTOS/](https://github.com/FreeRTOS/FreeRTOS)
    * FreeRTOS/  
      * [Source/](https://github.com/FreeRTOS/FreeRTOS-Kernel)
