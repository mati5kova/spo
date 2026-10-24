arith START 0

first   LDA 	x
        ADD	y
        STA	sum

        LDA 	x
        SUB 	y
        STA 	diff

        LDA 	x
        MUL 	y
        STA 	prod

        LDA 	x
        DIV	y
        STA 	quot

        . v A je floor(x/y)
        MUL	y
        . v A je floor(x/y)*y
        COMP 	x
        . ce floor(x/y)*y == x potem je mod = 0
        JEQ	halt
        STA 	mod
        LDA 	x
        SUB 	mod
        STA 	mod

halt    J	halt

. podatki
x 	WORD 	32
y 	WORD 	15
sum  	RESW 	1
diff 	RESW 	1
prod 	RESW 	1
quot 	RESW 	1
mod 	WORD 	0
    	END 	first