/**************************************************************************//**
 * @file     startup_ARMCM3.S
 * @brief    CMSIS-Core(M) Device Startup File for Cortex-M3 Device
 * @version  V2.2.0
 * @date     26. May 2021
 ******************************************************************************/
/*
 * Copyright (c) 2009-2021 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the License); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

                .syntax  unified
                .arch    armv7-m

                .section .vectors
                .align   2
                .globl   __Vectors
                .globl   __Vectors_End
                .globl   __Vectors_Size
__Vectors:
                .long    __StackTop                         /*     Top of Stack */
                .long    Reset_Handler                      /*     Reset Handler */
                .long    NMI_Handler                        /* -14 NMI Handler */
                .long    HardFault_Handler                  /* -13 Hard Fault Handler */
                .long    MemManage_Handler                  /* -12 MPU Fault Handler */
                .long    BusFault_Handler                   /* -11 Bus Fault Handler */
                .long    UsageFault_Handler                 /* -10 Usage Fault Handler */
                .long    0                                  /*     Reserved */
                .long    0                                  /*     Reserved */
                .long    0                                  /*     Reserved */
                .long    0                                  /*     Reserved */
                .long    SVC_Handler                        /*  -5 SVC Handler */
                .long    DebugMon_Handler                   /*  -4 Debug Monitor Handler */
                .long    0                                  /*     Reserved */
                .long    PendSV_Handler                     /*  -2 PendSV Handler */
                .long    SysTick_Handler                    /*  -1 SysTick Handler */

                /* External Interrupts */
                .long    CAN1_IRQHandler
                .long    CAN2_IRQHandler
                .long    USB_IRQHandler
                .long    0

                .long    0
                .long    DMA_IRQHandler
                .long    UART1_IRQHandler
                .long    UART2_IRQHandler
                .long    SSP1_IRQHandler
                .long    0
                .long    I2C_IRQHandler
                .long    POWER_IRQHandler
                .long    WWDG_IRQHandler
                .long    0
                .long    Timer1_IRQHandler
                .long    Timer2_IRQHandler
                .long    Timer3_IRQHandler
                .long    ADC_IRQHandler
                .long    0
                .long    COMPARATOR_IRQHandler
                .long    SSP2_IRQHandler
                .long    0
                .long    0
                .long    0
                .long    0
                .long    0
                .long    0
                .long    BACKUP_IRQHandler
                .long    EXT_INT1_IRQHandler
                .long    EXT_INT2_IRQHandler
                .long    EXT_INT3_IRQHandler
                .long    EXT_INT4_IRQHandler

                .space   (192 * 4)                          /* Interrupts 32 .. 224 are left out */
__Vectors_End:
                .equ     __Vectors_Size, __Vectors_End - __Vectors
                .size    __Vectors, . - __Vectors


                .thumb
                .section .text
                .align   2

                .thumb_func
                .type    Reset_Handler, %function
                .globl   Reset_Handler
                .fnstart
Reset_Handler:
                bl       SystemInit

                ldr      r4, =__copy_table_start__
                ldr      r5, =__copy_table_end__

.L_loop0:
                cmp      r4, r5
                bge      .L_loop0_done
                ldr      r1, [r4]                /* source address */
                ldr      r2, [r4, #4]            /* destination address */
                ldr      r3, [r4, #8]            /* word count */
                lsls     r3, r3, #2              /* byte count */

.L_loop0_0:
                subs     r3, #4                  /* decrement byte count */
                ittt     ge
                ldrge    r0, [r1, r3]
                strge    r0, [r2, r3]
                bge      .L_loop0_0

                adds     r4, #12
                b        .L_loop0
.L_loop0_done:

                ldr      r3, =__zero_table_start__
                ldr      r4, =__zero_table_end__

.L_loop2:
                cmp      r3, r4
                bge      .L_loop2_done
                ldr      r1, [r3]                /* destination address */
                ldr      r2, [r3, #4]            /* word count */
                lsls     r2, r2, #2              /* byte count */
                movs     r0, 0

.L_loop2_0:
                subs     r2, #4                  /* decrement byte count */
                itt      ge
                strge    r0, [r1, r2]
                bge      .L_loop2_0

                adds     r3, #8
                b        .L_loop2
.L_loop2_done:

                bl       _start

                .fnend
                .size    Reset_Handler, . - Reset_Handler
/* The default macro is not used for HardFault_Handler
 * because this results in a poor debug illusion.
 */
                .thumb_func
                .type    HardFault_Handler, %function
                .weak    HardFault_Handler
                .fnstart
HardFault_Handler:
                b        .
                .fnend
                .size    HardFault_Handler, . - HardFault_Handler

                .thumb_func
                .type    Default_Handler, %function
                .weak    Default_Handler
                .fnstart
Default_Handler:
                b        .
                .fnend
                .size    Default_Handler, . - Default_Handler

/* Macro to define default exception/interrupt handlers.
 * Default handler are weak symbols with an endless loop.
 * They can be overwritten by real handlers.
 */
                .macro   Set_Default_Handler  Handler_Name
                .weak    \Handler_Name
                .set     \Handler_Name, Default_Handler
                .endm


/* Default exception/interrupt handler */

                Set_Default_Handler  NMI_Handler
                Set_Default_Handler  MemManage_Handler
                Set_Default_Handler  BusFault_Handler
                Set_Default_Handler  UsageFault_Handler
                Set_Default_Handler  SVC_Handler
                Set_Default_Handler  DebugMon_Handler
                Set_Default_Handler  PendSV_Handler
                Set_Default_Handler  SysTick_Handler
                Set_Default_Handler  CAN1_IRQHandler
                Set_Default_Handler  CAN2_IRQHandler
                Set_Default_Handler  USB_IRQHandler
                Set_Default_Handler  DMA_IRQHandler
                Set_Default_Handler  UART1_IRQHandler
                Set_Default_Handler  UART2_IRQHandler
                Set_Default_Handler  SSP1_IRQHandler
                Set_Default_Handler  I2C_IRQHandler
                Set_Default_Handler  POWER_IRQHandler
                Set_Default_Handler  WWDG_IRQHandler
                Set_Default_Handler  Timer1_IRQHandler
                Set_Default_Handler  Timer2_IRQHandler
                Set_Default_Handler  Timer3_IRQHandler
                Set_Default_Handler  ADC_IRQHandler
                Set_Default_Handler  COMPARATOR_IRQHandler
                Set_Default_Handler  SSP2_IRQHandler
                Set_Default_Handler  BACKUP_IRQHandler
                Set_Default_Handler  EXT_INT1_IRQHandler
                Set_Default_Handler  EXT_INT2_IRQHandler
                Set_Default_Handler  EXT_INT3_IRQHandler
                Set_Default_Handler  EXT_INT4_IRQHandler


                .end
