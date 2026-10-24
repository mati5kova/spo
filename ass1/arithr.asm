arithr  START 0

first 	LDS     x    . S <- x
	    LDT	    y    . T <- y
	    RMO	    S, A . A <- x
        ADDR	T, A . A <- x + y
        STA     sum

        . A = x + y
        SUBR    T, A . A <- (x + y) - y = x
        SUBR    T, A . A <- x - y
        STA     diff

        . A = x - y
        ADDR    T, A . A <- (x - y) + y = x
        MULR    T, A . A <- x * y
        STA prod

        . A = x * y
        DIVR    T, A . A <- x * y / y = x
        DIVR    T, A . A <- x / y
        STA     quot

        . A = x / y
        MULR	T, A . A <- floor(x / y) * y
        COMPR	A, S . CC <- (A) : (S = x)
        JEQ	halt
        SUBR	A, S . S <- (S = x) - floor(x / y) * y
        STS     mod

halt	J	halt

. podatki
x       WORD 	32
y       WORD 	15
sum     RESW 	1
diff    RESW 	1
prod    RESW 	1
quot    RESW 	1
mod     WORD 	0
	END 	first
