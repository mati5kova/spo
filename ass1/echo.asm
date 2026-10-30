. Napišite program echo.asm za izpis besedila na standardni izhod. Program naj bo sestavljen iz rutin in glavnega dela, 
. ki jih testira. Pazite, da rutine ne popackajo registrov. Napišite naslednje rutine:
.
. char - izpis znaka, podanega v registru A.
. nl  - izpis znaka za skok v novo vrstico.
. string - izpis niza, ki se nahaja na naslovu, podanem v registru A. Podprite C-jevske nize,
. 	t.j. nizi se končajo z znakom s kodo 0. Namig: potrebovali boste posredno naslavljanje.
. num - desetiški izpis števila, podanega v registru A. 
. 	Ta rutina je malce bolj zapletena, zato je pametno malce vnaprej razmisliti. Kako pridemo do števk števila? 
. 	V kakšnem vrstnem redu jih dobimo?

echo	START	0
first	
        LDCH	#83     . 'S'
        JSUB	char
        LDCH	#80     . 'P'
        JSUB	char
        LDCH	#79     . 'O'
        JSUB	char

        +LDA	#buffer . A <- naslov kjer se zacne buffer
        JSUB	string

        JSUB	nl

        LDA	#10
        JSUB	num
        LDA	#47     . '/'
        JSUB	char
        LDA	#10
        JSUB	num

halt	J	halt

. data
stdin	BYTE	X'00'
stdout	BYTE	X'01'
buffer  BYTE    C' '
        BYTE    C'j'
        BYTE    C'e'
        BYTE    C' '
        BYTE    C'k'
        BYTE    C'u'
        BYTE    C'l'
        BYTE    0
	END 	first

.-------subrutine-------------

. izpis znaka, podanega v registru A
char	
        TD	stdout
	JEQ	char	. naprava se ni pripravljena za pisanje
	WD	stdout
	RSUB

. izpis znaka za skok v novo vrstico
nl	
        STX	nlx       . shrani prejsnjo vrednost v registru X
        STL	nll       . shrani prejsnji return address ker se kasneje klice druga subrutina (char)
        LDX	#0        . X <- 0 (index)
nlwlop  
        LDCH	nlchar, X . A[rightmost byte] <- (nlchar + X)
        JSUB	char
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
string  
        STX	strx
        STL	strl
        LDX	#0
        STA	strpos  . shrani kazalec na zacetek stringa
strlop
        LDA	strpos  . A <- addrof(string)
        ADDR	X, A    . A <- (A) + (X)  (na katerem znaku niza smo)
        STA	strptr  . shranimo v strptr

        CLEAR	A       . pocisti (zgornjih 16b) A
        +LDCH	@strptr . A[righmost byte] <- (strptr)

        COMP    #0
        JEQ	strext  . A[rightmost byte] == 0 ? konec niza : nadaljuj;

        JSUB	char    . skok na subrutino za izpis znaka shranjenega v A[rightmost byte]
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
num
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

nmprnt                  . # num print
        LDA	#1
        STA	strted  . started = 1

        LDA	curdgt
        ADD	#48     . A <- current_digit + '0'

        JSUB	char

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