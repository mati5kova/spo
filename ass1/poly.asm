. polinom: x⁴+2x³+3x²+4x+5 v točki x=2
poly	START 	0
first 	LDT	x    . T <- x
	RMO	T, A . A <- (T = x)
	MULR	T, A
	MULR	T, A
	MULR	T, A
	RMO	A, S

	RMO	T, A
	MULR	T, A
	MULR	T, A
	MUL	#2
	ADDR	A, S

	RMO	T, A
	MULR	T, A
	MUL	#3
	ADDR	A, S

	RMO	T, A
	MUL	#4   . A = 4x
	ADD 	#5   . A = 4x + 5
	ADDR	A, S . S <- (S = x^4 + 2x^3 + 3x^2) + (A = 4x + 5)

	STS	rez

halt	J	halt


. data
x	WORD	2
rez	WORD	0
	END 	first