	LIST P=16F877A
	#INCLUDE <P16F877A.INC>
	__CONFIG H'3F31'
	SAYICI EQU 0X19
	SAYICI_TIMER EQU 0X20
	BIRLERBSM EQU 0X21
	ONLARBSM EQU 0X22
	DEGER1 EQU 0X23
	DEGER2 EQU 0X24
	ORG 0X000
	GOTO ANA_METOT
	ORG 0X004

KESME_METOT
	BTFSS PIR1,TMR1IF
	RETFIE
	BCF PIR1,TMR1IF
	
	MOVLW H'3C'
	MOVWF TMR1H
	MOVLW H'B0'
	MOVWF TMR1L
	
	DECFSZ SAYICI_TIMER,F
	RETFIE

	MOVLW D'15'
	MOVWF SAYICI_TIMER

	INCF DEGER1,F
	MOVLW D'10'
	SUBWF DEGER1,W
	BTFSS STATUS,Z
	GOTO BIRLERBSM_GOSTER
	GOTO ONLARBSM_GOSTER

BIRLERBSM_GOSTER
	MOVF DEGER1,W
	CALL LOOKUP_TABLE
	MOVWF BIRLERBSM
	RETFIE

ONLARBSM_GOSTER
	CLRF DEGER1
	MOVLW D'63'
	MOVWF BIRLERBSM
	BCF STATUS,Z
	INCF DEGER2,F
	MOVLW D'6'
	SUBWF DEGER2,W
	BTFSC STATUS,Z
	GOTO ANA_METOT

	MOVF DEGER2,W
	CALL LOOKUP_TABLE
	MOVWF ONLARBSM

	RETFIE
	
ANA_METOT
	BANKSEL ADCON1
	MOVLW 0X06
	MOVWF ADCON1

	BANKSEL TRISB
	CLRF TRISB
	CLRF TRISA
	BANKSEL PORTB
	CLRF PORTB
	CLRF PORTA
	
	BANKSEL INTCON
	MOVLW B'11000000'
	MOVWF INTCON
	BANKSEL INTCON
	
	BANKSEL PIE1
	BSF PIE1,TMR1IE
	BANKSEL PIE1
	
	BANKSEL PIR1
	BCF PIR1,TMR1IF
	BANKSEL PIR1
	
	BANKSEL T1CON
	MOVLW B'00010001'
	MOVWF T1CON
	BANKSEL T1CON
	
	BANKSEL TMR1H
	MOVLW 0X3C
	MOVWF TMR1H
	MOVLW 0XB0
	MOVWF TMR1L
	CLRF SAYICI_TIMER
	MOVLW D'15'
	MOVWF SAYICI_TIMER
	MOVLW D'63'
	MOVWF BIRLERBSM
	MOVLW D'63'
	MOVWF ONLARBSM
	BANKSEL TMR1H	
	
	CLRF DEGER1
	CLRF DEGER2

KONTROL
	MOVLW H'01'
	MOVWF PORTA
	MOVF BIRLERBSM,W
	MOVWF PORTB
	CALL GECIKME
	MOVLW H'02'
	MOVWF PORTA
	MOVLW D'6'
	SUBWF DEGER2,W
	BTFSC STATUS,Z
	CLRF DEGER2
	MOVF ONLARBSM,W
	MOVWF PORTB
	CALL GECIKME
	GOTO KONTROL

LOOKUP_TABLE
	ADDWF PCL,F
	RETLW B'00111111'	;0
	RETLW B'00000110'	;1
	RETLW B'01011011'	;2
	RETLW B'01001111'	;3
	RETLW B'01100110'	;4
	RETLW B'01101101'	;5
	RETLW B'01111101'	;6
	RETLW B'00000111'	;7
	RETLW B'01111111'	;8
	RETLW B'01101111'	;9

GECIKME
	MOVLW 0XAA
	MOVWF SAYICI

TEKRAR
	DECFSZ SAYICI,F
	GOTO TEKRAR
	RETURN

END