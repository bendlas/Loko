/**
  ******************************************************************************
  * @file      startup_stm32wle5xx.s
  * @author    MCD Application Team
  * @brief     STM32WLE5xx devices vector table for GCC toolchain.
  *            This module performs:
  *                - Set the initial SP
  *                - Set the initial PC == Reset_Handler,
  *                - Set the vector table entries with the exceptions ISR address,
  *                - Branches to main in the C library (which eventually
  *                  calls main()).
  *            After Reset the Cortex-M4 processor is in Thread mode,
  *            priority is Privileged, and the Stack is set to Main.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2020-2021 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */

.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

/**
 * @brief  This is the code that gets called when the processor first
 *          starts execution following a reset event. Only the absolutely
 *          necessary set is performed, after which the application
 *          supplied main() routine is called.
 * @param  None
 * @retval : None
*/

  .section .text.Reset_Handler
  .weak Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */

/* Call the clock system initialization function.*/
  bl  SystemInit

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit

/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call static constructors */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever

  .size Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 *
 * @param  None
 * @retval : None
*/
  .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler

/******************************************************************************
*
* The STM32WLE5xx vector table.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
******************************************************************************/
  .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
  .word _estack
  .word Reset_Handler
  .word NMI_Handler
  .word HardFault_Handler
  .word	MemManage_Handler
  .word	BusFault_Handler
  .word	UsageFault_Handler
  .word	0
  .word	0
  .word	0
  .word	0
  .word	SVC_Handler
  .word	DebugMon_Handler
  .word	0
  .word	PendSV_Handler
  .word	SysTick_Handler
  .word	WWDG_IRQHandler                      			/* Window Watchdog interrupt                          */
  .word	PVD_PVM_IRQHandler                   			/* PVD and PVM interrupt through EXTI                 */
  .word	TAMP_STAMP_LSECSS_SSRU_IRQHandler    			/* RTC Tamper, RTC TimeStamp, LSECSS and RTC SSRU int.*/
  .word	RTC_WKUP_IRQHandler                  			/* RTC wakeup interrupt through EXTI[19]              */
  .word	FLASH_IRQHandler                     			/* Flash memory global interrupt and Flash memory ECC */
  .word	RCC_IRQHandler                       			/* RCC global interrupt                               */
  .word	EXTI0_IRQHandler                     			/* EXTI line 0 interrupt                              */
  .word	EXTI1_IRQHandler                     			/* EXTI line 1 interrupt                              */
  .word	EXTI2_IRQHandler                     			/* EXTI line 2 interrupt                              */
  .word	EXTI3_IRQHandler                     			/* EXTI line 3 interrupt                              */
  .word	EXTI4_IRQHandler                     			/* EXTI line 4 interrupt                              */
  .word	DMA1_Channel1_IRQHandler             			/* DMA1 channel 1 interrupt                           */
  .word	DMA1_Channel2_IRQHandler             			/* DMA1 channel 2 interrupt                           */
  .word	DMA1_Channel3_IRQHandler             			/* DMA1 channel 3 interrupt                           */
  .word	DMA1_Channel4_IRQHandler             			/* DMA1 channel 4 interrupt                           */
  .word	DMA1_Channel5_IRQHandler             			/* DMA1 channel 5 interrupt                           */
  .word	DMA1_Channel6_IRQHandler             			/* DMA1 channel 6 interrupt                           */
  .word	DMA1_Channel7_IRQHandler             			/* DMA1 channel 7 interrupt                           */
  .word	ADC_IRQHandler                       			/* ADC interrupt                                      */
  .word	DAC_IRQHandler                       			/* DAC interrupt                                      */
  .word	0                                    			/* Reserved                                           */
  .word	COMP_IRQHandler                      			/* COMP1 and COMP2 interrupt through EXTI             */
  .word	EXTI9_5_IRQHandler                   			/* EXTI line 9_5 interrupt                            */
  .word	TIM1_BRK_IRQHandler                  			/* Timer 1 break interrupt                            */
  .word	TIM1_UP_IRQHandler                   			/* Timer 1 Update                                     */
  .word	TIM1_TRG_COM_IRQHandler              			/* Timer 1 trigger and communication                  */
  .word	TIM1_CC_IRQHandler                   			/* Timer 1 capture compare interrupt                  */
  .word	TIM2_IRQHandler                      			/* TIM2 global interrupt                              */
  .word	TIM16_IRQHandler                     			/* Timer 16 global interrupt                          */
  .word	TIM17_IRQHandler                     			/* Timer 17 global interrupt                          */
  .word	I2C1_EV_IRQHandler                   			/* I2C1 event interrupt                               */
  .word	I2C1_ER_IRQHandler                   			/* I2C1 event interrupt                               */
  .word	I2C2_EV_IRQHandler                   			/* I2C2 error interrupt                               */
  .word	I2C2_ER_IRQHandler                   			/* I2C2 error interrupt                               */
  .word	SPI1_IRQHandler                      			/* SPI1 global interrupt                              */
  .word	SPI2_IRQHandler                      			/* SPI2 global interrupt                              */
  .word	USART1_IRQHandler                    			/* USART1 global interrupt                            */
  .word	USART2_IRQHandler                    			/* USART2 global interrupt                            */
  .word	LPUART1_IRQHandler                   			/* LPUART1 global interrupt                           */
  .word	LPTIM1_IRQHandler                    			/* LPtimer 1 global interrupt                         */
  .word	LPTIM2_IRQHandler                    			/* LPtimer 2 global interrupt                         */
  .word	EXTI15_10_IRQHandler                 			/* EXTI line 15_10] interrupt through EXTI            */
  .word	RTC_Alarm_IRQHandler                 			/* RTC Alarms A & B interrupt                         */
  .word	LPTIM3_IRQHandler                    			/* LPtimer 3 global interrupt                         */
  .word	SUBGHZSPI_IRQHandler                 			/* SUBGHZSPI global interrupt                         */
  .word	0                                    			/* Reserved                                           */
  .word	0                                    			/* Reserved                                           */
  .word	HSEM_IRQHandler                      			/* Semaphore interrupt 0 to CPU1                      */
  .word	I2C3_EV_IRQHandler                   			/* I2C3 event interrupt                               */
  .word	I2C3_ER_IRQHandler                   			/* I2C3 error interrupt                               */
  .word	SUBGHZ_Radio_IRQHandler              			/* Radio IRQs RFBUSY interrupt through EXTI           */
  .word	AES_IRQHandler                       			/* AES global interrupt                               */
  .word	RNG_IRQHandler                       			/* RNG interrupt                                      */
  .word	PKA_IRQHandler                       			/* PKA interrupt                                      */
  .word	DMA2_Channel1_IRQHandler             			/* DMA2 channel 1 interrupt                           */
  .word	DMA2_Channel2_IRQHandler             			/* DMA2 channel 2 interrupt                           */
  .word	DMA2_Channel3_IRQHandler             			/* DMA2 channel 3 interrupt                           */
  .word	DMA2_Channel4_IRQHandler             			/* DMA2 channel 4 interrupt                           */
  .word	DMA2_Channel5_IRQHandler             			/* DMA2 channel 5 interrupt                           */
  .word	DMA2_Channel6_IRQHandler             			/* DMA2 channel 6 interrupt                           */
  .word	DMA2_Channel7_IRQHandler             			/* DMA2 channel 7 interrupt                           */
  .word	DMAMUX1_OVR_IRQHandler               			/* DMAMUX overrun interrupt                           */
