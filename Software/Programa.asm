
Time0 EQU 0X21 ;valores de tiempo 0-9
Time1 EQU 0X22
Time2 EQU 0X23
Time3 EQU 0X24

Disp0 EQU 0X25 ; valores de los displays
Disp1 EQU 0x26
Disp2 EQU 0x27
Disp3 EQU 0x28

;;; Constantes de transmicion
tx_port equ	PORTC 		; Puerto de tranmisión
tx_pin	equ	0x6		; Pin de transmisión
rx_port equ	PORTC 		; Puerto de recepción
rx_pin	equ	0x7		; Pin de recepción

data_tx	equ	0xd		; Datos a enviar
data_rx	equ	0xf		; Datos recibidos

count_d equ	0xc		; Contador para el retardo
count_p	equ	0x10		; Contador para el número de bits

TimeAux EQU 0x29


ORG 00
	GOTO INICIO
ORG 04
	GOTO INTERRUPT
	
ORG 06
	INICIO:
		BSF STATUS,RP0;BANCO1
		BCF STATUS,RP1
		
		CLRF TRISA ; CONFIGURACION DE PUERTOS
		CLRF TRISD
		MOVLW 0X01
		MOVWF TRISB
		
		BCF STATUS,RP0; BANCO 0
		
	MAIN:
		
			