scrstr	START	0
first	
	LDA     #0xFF
        +STCH   screen	 . pobarvaj prvi pixel belo
	
	JSUB	scrclear . cel screen rdece

	LDA	#0x0C
	JSUB	scrfill	 . cel screen zeleno

	JSUB	scrclear . ce screen rdece

halt	J	halt

.-------subrutine----------

. screen fill
. vrednost je v A[rightmost byte]
scrfill
	STCH	clrclr
. screen clear
. clear color je 0xF0 (rdeca)
scrclear
	STX	clrx
	STA	clra

	LDX	#0	. index na 0
	CLEAR	A
	LDCH	clrclr	. A[rightmost byte] <- barva

clrlop	+STCH	screen, X
	+TIX	#scrlen
	JLT	clrlop

	LDA	#0xF0	. ponastavi clear color (v primeru da je bila vstopna tocka scrfill)
	STCH	clrclr
	LDX	clrx
	LDA	clra
	RSUB

clrclr	BYTE	0xF0	. clear color
clrx	RESW	1
clra	RESW	1

. data
screen	EQU	0x0A000 . to ni na dejanski pomnilniski lokaciji ampak je konstanta znana ob compile time-u
scrcols	EQU	64
scrrows	EQU	64
scrlen	EQU	4096	. (scrcols * scrrows)
	END	scrstr