. Napišite program cat.asm, ki kopira znake s standardnega vhoda na standardni izhod.

cat	START	0

rloop	TD	stdin	. poglej ali je naprava pripravljena na branje
	JEQ	rloop

	RD	stdin	. A[rightmost byte] <- 1 znak iz stdin

wloop	TD	stdout	. preveri ali je naprava pripravljena na pisanje
	JEQ	wloop

	WD	stdout	. stdout <- A[rightmost byte]
	J	rloop	. skok na ponovno branje

halt	J	halt

. data
stdin	BYTE	X'00'
stdout	BYTE	X'01'
buffer	RESB	1
	END	rloop