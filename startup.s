.syntax unified
.cpu cortex-m0plus
.fpu softvfp
.thumb

.global _start
.global Reset_Handler

/* Vector table */
.section .isr_vector, "a", %progbits
.word _estack
.word Reset_Handler
.word Default_Handler /* NMI */
.word Default_Handler /* HardFault */
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word Default_Handler /* SVC */
.word 0
.word 0
.word Default_Handler /* PendSV */
.word Default_Handler /* SysTick */

/* Weak handlers */
.weak Default_Handler
.type Default_Handler, %function
Default_Handler:
    b .

/* Reset handler */
.section .text.Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
        /* Copy data section */
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
1:
    cmp r1, r2
    bge 2f
    ldr r3, [r0]
    str r3, [r1]
    adds r0, #4
    adds r1, #4
    b 1b
2:

        /* Zero bss */
    ldr r1, =_sbss
    ldr r2, =_ebss
3:
    cmp r1, r2
    bge 4f
    movs r3, #0
    str r3, [r1]
    adds r1, #4
    b 3b
4:
    bl main
    b .
