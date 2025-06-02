/******************************************************************************
  * @file    startup_MDR32F1QI.S
  * @author  Milandr Application Team
  * @version V2.0
  * @date    22/07/2024
  * @brief   CMSIS core device startup file for MDR32F1QI.
  ******************************************************************************
  * <br><br>
  *
  * THE PRESENT FIRMWARE IS FOR GUIDANCE ONLY. IT AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING MILANDR'S PRODUCTS IN ORDER TO FACILITATE
  * THE USE AND SAVE TIME. MILANDR SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES RESULTING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR A USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN THEIR PRODUCTS.
  *
  * <h2><center>&copy; COPYRIGHT 2024 Milandr</center></h2>
  ******************************************************************************
  */

@--------- <<< Use Configuration Wizard in Context Menu >>> ------------------

@<h> Stack Configuration
@  <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
@</h>

.equ    Stack_Size, 0x00001000

.section .stack, "aw", %nobits
.align  3
__stack_limit:
Stack_Mem:
    .space  Stack_Size
    .size   Stack_Mem, Stack_Size
__initial_sp:
    .size   __initial_sp, . - __initial_sp


@<h> Heap Configuration
@  <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
@</h>

.equ    Heap_Size, 0x00001000

.section .heap, "aw", %nobits
.align  3
__heap_base:
Heap_Mem:
    .space  Heap_Size
    .size   Heap_Mem, Heap_Size
__heap_limit:
    .size   __heap_limit, . - __heap_limit

.syntax unified
.thumb

@ Vector Table Mapped to Address 0 at Reset
.section .isr_vector, "a", %progbits
.global  __Vectors
.global  __Vectors_End
.global  __Vectors_Size

@ Attention for NMI_Handler:
@ Called by software only (bit [31] of the ICSR register). Used for mission critical applications
__Vectors:
    .word     __initial_sp                @     Top of Stack
    .word     Reset_Handler               @     Reset Handler
    .word     NMI_Handler                 @ -14 NMI Handler
    .word     HardFault_Handler           @ -13 Hard Fault Handler
    .word     0                           @     Reserved
    .word     0                           @     Reserved
    .word     0                           @     Reserved
    .word     0                           @     Reserved
    .word     0                           @     Reserved
    .word     0                           @     Reserved
    .word     0                           @     Reserved
    .word     SVC_Handler                 @  -5 SVCall Handler
    .word     0                           @     Reserved
    .word     0                           @     Reserved
    .word     PendSV_Handler              @  -2 PendSV Handler
    .word     SysTick_Handler             @  -1 SysTick Handler

    @ External Interrupts
    .word     MIL_STD_1553B2_IRQHandler   @   0 MIL_STD_1553B2 Handler
    .word     MIL_STD_1553B1_IRQHandler   @   1 MIL_STD_1553B1 Handler
    .word     USB_IRQHandler              @   2 USB Host Handler
    .word     CAN1_IRQHandler             @   3 CAN1 Handler
    .word     CAN2_IRQHandler             @   4 CAN2 Handler
    .word     DMA_IRQHandler              @   5 DMA Handler
    .word     UART1_IRQHandler            @   6 UART1 Handler
    .word     UART2_IRQHandler            @   7 UART2 Handler
    .word     SSP1_IRQHandler             @   8 SSP1 Handler
    .word     BUSY_IRQHandler             @   9 NAND Flash Handler
    .word     ARINC429R_IRQHandler        @  10 ARINC429R1-ARINC429R8 Handler
    .word     POWER_IRQHandler            @  11 POWER Handler
    .word     WWDG_IRQHandler             @  12 WWDG Handler
    .word     TIMER4_IRQHandler           @  13 Timer4 Handler
    .word     TIMER1_IRQHandler           @  14 Timer1 Handler
    .word     TIMER2_IRQHandler           @  15 Timer2 Handler
    .word     TIMER3_IRQHandler           @  16 Timer3 Handler
    .word     ADC_IRQHandler              @  17 ADC Handler
    .word     ETHERNET_IRQHandler         @  18 Ethernet Handler
    .word     SSP3_IRQHandler             @  19 SSP3 Handler
    .word     SSP2_IRQHandler             @  20 SSP2 Handler
    .word     ARINC429T1_IRQHandler       @  21 ARINC429T1 Handler
    .word     ARINC429T2_IRQHandler       @  22 ARINC429T2 Handler
    .word     ARINC429T3_IRQHandler       @  23 ARINC429T3 Handler
    .word     ARINC429T4_IRQHandler       @  24 ARINC429T4 Handler
    .word     0                           @     Reserved
    .word     0                           @     Reserved
    .word     BKP_IRQHandler              @  27 BKP Handler
    .word     EXT_INT1_IRQHandler         @  28 EXT_INT1 Handler
    .word     EXT_INT2_IRQHandler         @  29 EXT_INT2 Handler
    .word     EXT_INT3_IRQHandler         @  30 EXT_INT3 Handler
    .word     EXT_INT4_IRQHandler         @  31 EXT_INT4 Handler
__Vectors_End:

.equ  __Vectors_Size, __Vectors_End - __Vectors

.text
.thumb

@ Reset Handler
.thumb_func
.global Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    .extern  SystemInit
    .extern  __main
    LDR     R0, =SystemInit
    BLX     R0
    LDR     R0,=__main
    BX      R0
    .size Reset_Handler, . - Reset_Handler

@ Dummy Exception Handlers (infinite loops which can be modified)
.thumb_func
.weak NMI_Handler
.type NMI_Handler, %function
NMI_Handler:
    B       .
    .size NMI_Handler, . - NMI_Handler

.thumb_func
.weak HardFault_Handler
.type HardFault_Handler, %function
HardFault_Handler:
    B       .
    .size HardFault_Handler, . - HardFault_Handler

.thumb_func
.weak SVC_Handler
.type SVC_Handler, %function
SVC_Handler:
    B       .
    .size SVC_Handler, . - SVC_Handler

.thumb_func
.weak PendSV_Handler
.type PendSV_Handler, %function
PendSV_Handler:
    B       .
    .size PendSV_Handler, . - PendSV_Handler

.thumb_func
.weak SysTick_Handler
.type SysTick_Handler, %function
SysTick_Handler:
    B       .
    .size SysTick_Handler, . - SysTick_Handler

@ External Interrupts
.thumb_func
.weak MIL_STD_1553B2_IRQHandler
.type MIL_STD_1553B2_IRQHandler, %function
MIL_STD_1553B2_IRQHandler:
    B       .
    .size MIL_STD_1553B2_IRQHandler, . - MIL_STD_1553B2_IRQHandler

.thumb_func
.weak MIL_STD_1553B1_IRQHandler
.type MIL_STD_1553B1_IRQHandler, %function
MIL_STD_1553B1_IRQHandler:
    B       .
    .size MIL_STD_1553B1_IRQHandler, . - MIL_STD_1553B1_IRQHandler

.thumb_func
.weak USB_IRQHandler
.type USB_IRQHandler, %function
USB_IRQHandler:
    B       .
    .size USB_IRQHandler, . - USB_IRQHandler

.thumb_func
.weak CAN1_IRQHandler
.type CAN1_IRQHandler, %function
CAN1_IRQHandler:
    B       .
    .size CAN1_IRQHandler, . - CAN1_IRQHandler

.thumb_func
.weak CAN2_IRQHandler
.type CAN2_IRQHandler, %function
CAN2_IRQHandler:
    B       .
    .size CAN2_IRQHandler, . - CAN2_IRQHandler

.thumb_func
.weak DMA_IRQHandler
.type DMA_IRQHandler, %function
DMA_IRQHandler:
    B       .
    .size DMA_IRQHandler, . - DMA_IRQHandler

.thumb_func
.weak UART1_IRQHandler
.type UART1_IRQHandler, %function
UART1_IRQHandler:
    B       .
    .size UART1_IRQHandler, . - UART1_IRQHandler

.thumb_func
.weak UART2_IRQHandler
.type UART2_IRQHandler, %function
UART2_IRQHandler:
    B       .
    .size UART2_IRQHandler, . - UART2_IRQHandler

.thumb_func
.weak SSP1_IRQHandler
.type SSP1_IRQHandler, %function
SSP1_IRQHandler:
    B       .
    .size SSP1_IRQHandler, . - SSP1_IRQHandler

.thumb_func
.weak BUSY_IRQHandler
.type BUSY_IRQHandler, %function
BUSY_IRQHandler:
    B       .
    .size BUSY_IRQHandler, . - BUSY_IRQHandler

.thumb_func
.weak ARINC429R_IRQHandler
.type ARINC429R_IRQHandler, %function
ARINC429R_IRQHandler:
    B       .
    .size ARINC429R_IRQHandler, . - ARINC429R_IRQHandler

.thumb_func
.weak POWER_IRQHandler
.type POWER_IRQHandler, %function
POWER_IRQHandler:
    B       .
    .size POWER_IRQHandler, . - POWER_IRQHandler

.thumb_func
.weak WWDG_IRQHandler
.type WWDG_IRQHandler, %function
WWDG_IRQHandler:
    B       .
    .size WWDG_IRQHandler, . - WWDG_IRQHandler

.thumb_func
.weak TIMER4_IRQHandler
.type TIMER4_IRQHandler, %function
TIMER4_IRQHandler:
    B       .
    .size TIMER4_IRQHandler, . - TIMER4_IRQHandler

.thumb_func
.weak TIMER1_IRQHandler
.type TIMER1_IRQHandler, %function
TIMER1_IRQHandler:
    B       .
    .size TIMER1_IRQHandler, . - TIMER1_IRQHandler

.thumb_func
.weak TIMER2_IRQHandler
.type TIMER2_IRQHandler, %function
TIMER2_IRQHandler:
    B       .
    .size TIMER2_IRQHandler, . - TIMER2_IRQHandler

.thumb_func
.weak TIMER3_IRQHandler
.type TIMER3_IRQHandler, %function
TIMER3_IRQHandler:
    B       .
    .size TIMER3_IRQHandler, . - TIMER3_IRQHandler

.thumb_func
.weak ADC_IRQHandler
.type ADC_IRQHandler, %function
ADC_IRQHandler:
    B       .
    .size ADC_IRQHandler, . - ADC_IRQHandler

.thumb_func
.weak ETHERNET_IRQHandler
.type ETHERNET_IRQHandler, %function
ETHERNET_IRQHandler:
    B       .
    .size ETHERNET_IRQHandler, . - ETHERNET_IRQHandler

.thumb_func
.weak SSP3_IRQHandler
.type SSP3_IRQHandler, %function
SSP3_IRQHandler:
    B       .
    .size SSP3_IRQHandler, . - SSP3_IRQHandler

.thumb_func
.weak SSP2_IRQHandler
.type SSP2_IRQHandler, %function
SSP2_IRQHandler:
    B       .
    .size SSP2_IRQHandler, . - SSP2_IRQHandler

.thumb_func
.weak ARINC429T1_IRQHandler
.type ARINC429T1_IRQHandler, %function
ARINC429T1_IRQHandler:
    B       .
    .size ARINC429T1_IRQHandler, . - ARINC429T1_IRQHandler

.thumb_func
.weak ARINC429T2_IRQHandler
.type ARINC429T2_IRQHandler, %function
ARINC429T2_IRQHandler:
    B       .
    .size ARINC429T2_IRQHandler, . - ARINC429T2_IRQHandler

.thumb_func
.weak ARINC429T3_IRQHandler
.type ARINC429T3_IRQHandler, %function
ARINC429T3_IRQHandler:
    B       .
    .size ARINC429T3_IRQHandler, . - ARINC429T3_IRQHandler

.thumb_func
.weak ARINC429T4_IRQHandler
.type ARINC429T4_IRQHandler, %function
ARINC429T4_IRQHandler:
    B       .
    .size ARINC429T4_IRQHandler, . - ARINC429T4_IRQHandler

.thumb_func
.weak BKP_IRQHandler
.type BKP_IRQHandler, %function
BKP_IRQHandler:
    B       .
    .size BKP_IRQHandler, . - BKP_IRQHandler

.thumb_func
.weak EXT_INT1_IRQHandler
.type EXT_INT1_IRQHandler, %function
EXT_INT1_IRQHandler:
    B       .
    .size EXT_INT1_IRQHandler, . - EXT_INT1_IRQHandler

.thumb_func
.weak EXT_INT2_IRQHandler
.type EXT_INT2_IRQHandler, %function
EXT_INT2_IRQHandler:
    B       .
    .size EXT_INT2_IRQHandler, . - EXT_INT2_IRQHandler

.thumb_func
.weak EXT_INT3_IRQHandler
.type EXT_INT3_IRQHandler, %function
EXT_INT3_IRQHandler:
    B       .
    .size EXT_INT3_IRQHandler, . - EXT_INT3_IRQHandler

.thumb_func
.weak EXT_INT4_IRQHandler
.type EXT_INT4_IRQHandler, %function
EXT_INT4_IRQHandler:
    B       .
    .size EXT_INT4_IRQHandler, . - EXT_INT4_IRQHandler

.align

@ User Initial Stack & Heap
.ifdef __MICROLIB
    .global __initial_sp
    .global __stack_limit
    .global __heap_base
    .global __heap_limit
.else
    .extern __use_two_region_memory
    .global __user_initial_stackheap
    .thumb_func
__user_initial_stackheap:
    LDR     R0, = Heap_Mem
    LDR     R1, = (Stack_Mem + Stack_Size)
    LDR     R2, = (Heap_Mem +  Heap_Size)
    LDR     R3, = Stack_Mem
    BX      LR
    .align
.endif

.end