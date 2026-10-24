. polinom: x⁴+2x³+3x²+4x+5 v točki x=2
.
.	 1 	 2	     3	              4	                       5
.      |---------------------------------------------------------------------------
.      |
.      |        1*x      (1*x+2)*x     ((1*x+2)*x+3)*x      (((1*x+2)*x+3)*x+4)*x
.      |---------------------------------------------------------------------------
.    x | 1     1*x+2    (1*x+2)*x+3   ((1*x+2)*x+3)*x+4    (((1*x+2)*x+3)*x+4)*x+5
.
. pri x=2 je rezultat 57
horner	START	0
first	LDT 	x
	RMO	T, A
	MUL	a4
	ADD	a3
	MULR	T, A
	ADD	a2
	MULR	T, A
	ADD	a1
	MULR	T, A
	ADD	a0

	STA	rez

halt	J	halt

.data
x	WORD	2
a0	WORD	5
a1	WORD	4
a2	WORD	3
a3	WORD	2
a4	WORD	1
rez	RESW	1
	END 	first