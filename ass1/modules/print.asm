printm	START	0	. printm <=> print module
	EXTDEF	stdin,stdout,pchar,pnl,pstr,pnum

. data
stdin	BYTE	X'00'
stdout	BYTE	X'01'

.-------subrutine-------------

. izpis znaka, podanega v registru A
pchar	
        TD	stdout
	JEQ	pchar	. naprava se ni pripravljena za pisanje
	WD	stdout
	RSUB

. izpis znaka za skok v novo vrstico
pnl	
        STX	nlx       . shrani prejsnjo vrednost v registru X
        STL	nll       . shrani prejsnji return address ker se kasneje klice druga subrutina (pchar)
        LDX	#0        . X <- 0 (index)
nlwlop  
        LDCH	nlchar, X . A[rightmost byte] <- (nlchar + X)
        JSUB	pchar
        TIX	#2        . (X) < 2 ? print : konec;
        JLT	nlwlop

        LDX	nlx       . restore X
        LDL	nll       . restore L
        RSUB

nlx     RESW    1
nll     RESW    1
nlchar	BYTE	X'0D'
	BYTE	X'0A'

. izpis niza, ki se nahaja na naslovu, podanem v registru A. Podprite C-jevske nize (konca se z \0)
pstr  
        STX	strx
        STL	strl
        LDX	#0
        STA	strpos  . shrani kazalec na zacetek stringa
strlop
        LDA	strpos  . A <- addrof(pstr)
        ADDR	X, A    . A <- (A) + (X)  (na katerem znaku niza smo)
        STA	strptr  . shranimo v strptr

        CLEAR	A       . pocisti (zgornjih 16b) A
        +LDCH	@strptr . A[righmost byte] <- (strptr)

        COMP    #0
        JEQ	strext  . A[rightmost byte] == 0 ? konec niza : nadaljuj;

        JSUB	pchar    . skok na subrutino za izpis znaka shranjenega v A[rightmost byte]
        TIX	#0
        J	strlop

strext
        LDX	strx
        LDL	strl
        LDA	strptr
        SUB	strpos
        RSUB

strx    RESW    1
strl    RESW    1
strpos  RESW    1
strptr  RESW    1

. desetiški izpis števila, podanega v registru A
pnum
        STL	numl    . shrani return addr
        STA	numa
        STA	number  . (number) <- (A)

        LDA     #0
        STA     strted  . bool started = false

        . 10mio (2^24 najvecji delitelj da pridemo do najbolj leve stevke)
        +LDA     #1000000
        STA     div
numlop  
        LDA	div     . A <- (div)
        COMP    #0
        JEQ	numext  . div == 0 ? exit : continue; . while (div > 0){
                        . div > 0
        LDA	number
        DIV	div     . A <- number / div
        STA	curdgt  . current_digit (gremo od leve proti desni)

        LDA	curdgt  . reduntant - je pa bolj jasno
        COMP	#0
        JGT	nmprnt
        JLT	nmprnt  . curr_digit != 0 ? print digit : nadaljuj check;

        LDA	strted
        COMP	#1
        JEQ	nmprnt  . started ? print digit : nadaljuj check;

        LDA	div
        COMP	#1
        JEQ	nmprnt  . div == 1 ? print digit : adjust;

        J	adjust

nmprnt                  . # pnum print
        LDA	#1
        STA	strted  . started = 1

        LDA	curdgt
        ADD	#48     . A <- current_digit + '0'

        JSUB	pchar

adjust    
        . number = number % div
        . formula: ostanek = stevilo - (div * floor(stevilo / div))
        LDA     number
        DIV     div
        MUL     div
        STA     curdgt
        LDA     number
        SUB     curdgt
        STA     number

        . div /= 10
        LDA	div
        DIV	#10
        STA	div

        J       numlop

numext
        LDL	numl
        LDA	numa
        RSUB

numl    RESW    1
numa    RESW    1
number  RESW    1
div     RESW    1
strted  WORD    0       . true/false
curdgt  WORD    0

	END	printm	. end print module