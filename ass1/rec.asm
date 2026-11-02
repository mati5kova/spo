. V zbirniku SIC/XE napišite program rec.asm, ki bere števila z naprave FA. 
. Za vsako število naj izračuna fakulteto ali Fibonaccijevo število (ali katero drugo rekurzivno funkcijo) in 
. rezultat izpiše na standardni izhod. Program se naj konča, ko prebere število 0.
.
. Vhodna datoteka je v zapisu ASCII, pri čemer je vsako število v svoji vrstici, torej npr.
.
. 1
. 9
. 42
. 0
. V istem formatu zapišite rezultate na standardni izhod, lahko pa namesto tega za izpis uporabite tekstovni zaslon. 
. Za računanje funkcije uporabite rekurzivno rutino, torej tako, ki »kliče« (z JSUB) samo sebe.

main	START   0
        EXTREF  stinit,push,pop,peek
	EXTREF	stdin,stdout,pchar,pnl,pstr,pnum

	+JSUB   stinit 

read_loop
	TD	#0xFA
	JEQ	read_loop

	CLEAR	A
	RD	#0xFA
	COMP	#0x0D	. CR
	JEQ	read_loop
	COMP	#0x0A	. LF
	JEQ	read_loop
	COMP	#0	. EOF
	JEQ	halt

	SUB	#48	. '0'
	RMO	A, T
	+JSUB	f

	+JSUB	pnum
	+JSUB	pnl

	J	read_loop

halt    J       halt
error   J       error

.-----fakulteta-------------
. v registru T je podana trenutni parameter
. rezultat se vraca v registru A
f
	RMO	L, A	. A <- (L)
	+JSUB	push	. [L]

	RMO	T, A	. A <- paramter
	COMP	#0	. if(n == 0) return 1
	JEQ	fret1

	+JSUB	push	. [L, n]

	. return n * f(n-1)

	SUB	#1	. A <- A - 1 	(n - 1)
	RMO	A, T	. T <- n-1
	JSUB	f

	. (A) = f(n-1)
	RMO	A, T	. T <- f(n-1)
	+JSUB	pop	. [L]; (A) = n
	MULR	A, T	. T <- n * f(n-1)

fret	
	+JSUB	pop	. []
	RMO	A, L
	RMO	T, A
	RSUB

fret1
	+JSUB	pop	. []
	RMO	A, L
	LDA	#1
	RSUB

        END     main