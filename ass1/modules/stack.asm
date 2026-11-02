stmod	START	0		. stmod <=> stack module
	EXTDEF	stinit,push,pop,peek
. inicializacija stacka; ohrani vsebino registra A
stinit
	STA	stacktmpa
	+LDA	#stack		. A <- addr_of(stack)
	STA	stackptr
	LDA	stacktmpa
	RSUB

. push reg A na sklad; overflow check; ohrani vsebino registra A
push
	STA	stacktmpa

	. overflow check
	LDA	stackptr
	+COMP	#stacklast
	JGT	overflow

	LDA	stacktmpa
	STA	@stackptr
	LDA	stackptr
	ADD	#3
	STA	stackptr
	LDA	stacktmpa
	RSUB

. pop vrh sklada in ga shrani v A; stackptr -= 3; underflow check
pop
	LDA	stackptr

	. underflow check
	+COMP	#stack
	JEQ	underflow

	SUB	#3
	STA	stackptr
	LDA	@stackptr
	RSUB

. peek na vrh sklada in shrani v A; underflow check 
peek
	LDA     stackptr
	+COMP   #stack
	JEQ     underflow

	SUB     #3
	STA     stacktmpa
	LDA     @stacktmpa
	RSUB

overflow	J	overflow
underflow	J	underflow

. stack
stackptr	RESW	1
stacktmpa	RESW	1
stack		RESB	1024		. 1kB
stackend	EQU	*
stacklast	EQU	stackend - 3	. zadnji NASLOV v katerega lahko pisemo (ne stevilo elementov)

		END	stmod
