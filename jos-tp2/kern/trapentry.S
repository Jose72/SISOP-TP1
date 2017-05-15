/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

TRAPHANDLER_NOEC(handl0, 0)
TRAPHANDLER_NOEC(handl1, 1)
TRAPHANDLER_NOEC(handl2, 2)
TRAPHANDLER_NOEC(handl3, 3)
TRAPHANDLER_NOEC(handl4, 4)
TRAPHANDLER_NOEC(handl5, 5)
TRAPHANDLER_NOEC(handl6, 6)
TRAPHANDLER_NOEC(handl7, 7)
TRAPHANDLER(handl8, 8)
TRAPHANDLER_NOEC(handl9, 9)
TRAPHANDLER(handl10, 10)
TRAPHANDLER(handl11, 11)
TRAPHANDLER(handl12, 12)
TRAPHANDLER(handl13, 13)
TRAPHANDLER(handl14, 14)
TRAPHANDLER_NOEC(handl15, 15)
TRAPHANDLER_NOEC(handl16, 16)
TRAPHANDLER(handl17, 17)
TRAPHANDLER_NOEC(handl18, 18)
TRAPHANDLER_NOEC(handl19, 19)

TRAPHANDLER_NOEC(handl48, 48)

/*
 * Lab 3: Your code here for _alltraps
 */

.globl _alltraps
_alltraps:
        pushl %ds
        pushl %es
	pushal

	movl $GD_KD, %eax
	movw %ax, %ds
	movw %ax, %es 

        pushl %esp  //trap frame
        call trap

.data
.globl handlers
handlers:
	.long handl0
        .long handl1
	.long handl2
	.long handl3
	.long handl4
	.long handl5
	.long handl6
	.long handl7
	.long handl8
	.long handl9
	.long handl10
	.long handl11
	.long handl12
	.long handl13
	.long handl14
	.long handl15
	.long handl16
	.long handl17
	.long handl18
	.long handl19
	.long handl48

