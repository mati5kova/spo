main    START   0
        EXTREF  pchar,pnl

        CLEAR   X
        STX     index

read_loop
        TD      input
        JEQ     read_loop

        CLEAR   A
        RD      input
        RMO     A, T

. ascii stdout output	-> output only even rows so that aspect ratio is preserved
        LDA     index
        AND     #128
        COMP    #0
        JGT     graphical_output

        JSUB    point2symbol
        +JSUB   pchar

. graphical screen output
graphical_output
        LDX     index
        JSUB    point2color
        +STCH   screen,X

. increment index
        LDA     index
        ADD     #1
        STA     index

. newline after 128 pixels / chars
        . AND     #127	. nice trick i found -> when trying to get result of: num % 128 == 127
	. 		 . you just have to check the low 7 bits and if they are all set then the
	. 		 . remainder when dividing with 128 is 127
	. COMP	#0
        . JLT     skip_nl
	. JGT     skip_nl
        . +JSUB   pnl
. newline only after printed rows -> printed (even) rows finish on indexes 128, 3*128=384, 5*128=640, ...
. 128, 385, 640 all have lower 8 bits set
	AND     #255
        COMP    #128
        JLT     skip_nl
	JGT     skip_nl
        +JSUB   pnl

skip_nl
        LDA     index
        +COMP   #screen_len
        JLT     read_loop

halt    J       halt

.----subrutine------------

. convert grayness of pixel into ascii character
.
. T = grayscale pixel (0-255)
. A = ascii character
point2symbol
	. " .:-=+*#%@"[p * 9 / 255]
        RMO     T, A
        MUL     #9
        DIV     #255
        RMO     A, X
        CLEAR   A
        LDCH    symbols, X

        RSUB

. convert grayness into a color
.
. T = grayscale pixel (0-255)
. A = IRGB color
point2color
        RMO     X, S

        RMO     T, A
        DIV     #64	. A <- grayness / 64     (split grayness scale into 4 intervals and select appropriate one)
        RMO     A, X
        CLEAR   A
        LDCH    colors, X

        RMO     S, X
        RSUB

.----data-----------------
input       BYTE    X'CA'
index       RESW    1

symbols     BYTE    C' .:-=+*#%@'
colors      BYTE    X'0055AAFF'		. black -> dark gray -> light gray -> white

.----screen---------------
screen      EQU     0x0A000
screen_cols EQU     128
screen_rows EQU     128
screen_len  EQU     128 * 128
	    END     main
