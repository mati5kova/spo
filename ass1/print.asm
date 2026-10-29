. Vhodno/izhodne naprave so v SIC/XE oštevilčene z 0–255, pri čemer naprave 0, 1 in 2 
. predstavljajo standardni vhod, izhod in napako (angl. stdin, stdout in stderr). 
. Ostale naprave simulator predstavi z datoteko XX.dev, kjer je XX šestnajstiški zapis številke naprave.
.
. Napišite program print.asm, ki na napravo z oznako AA zapiše niz SIC/XE in znak za skok v novo vrstico.

print	START	0
first	LDX	#0	. X <- 0
wloop	TD	device	. poglej ali je device AA pripravljen na sprejemanje
	JEQ	wloop	. device ni pripravljen -> ponovi

	LDCH	buff, X	. A [rightmost byte] <- (buff + x)
	WD	device	. zapisi znak

	TIX	len	. X <- (X) + 1; (X) : len
	JLT	wloop	. (X) < len ? pisi naprej : halt

halt	J	halt

. data
device	BYTE	X'AA'
len	WORD	8
buff	BYTE	C'S'
	BYTE	C'I'
	BYTE	C'C'
	BYTE	C'/'
	BYTE	C'X'
	BYTE 	C'E'
	BYTE	X'0D'
	BYTE	X'0A'
	END 	first