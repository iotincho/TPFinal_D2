list p=16f877a

INCLUDE <P16F877A.INC>

Time0 EQU 0X21 ;valores de tiempo 0-9/centesimas de segundo
Time1 EQU 0X22 ;decimas de segundos
Time2 EQU 0X23 ;segundos
Time3 EQU 0X24 ;decenas de segundo
Time4 EQU 0x25 ;centenas de segundo 
TimeAux EQU 0x26

Disp0 EQU 0X27 ; valores de los displays
Disp1 EQU 0x28
Disp2 EQU 0x29
Disp3 EQU 0x2A
MULT_PORT equ PORTA ;puerto de multiplexado
D0 equ 0x00
D1 equ 0x01
D2 equ 0x02
D3 equ 0x03

;;; Constantes de transmicion
tx_port equ	PORTC	; Puerto de tranmisión
tx_pin	equ	0x6		; Pin de transmisión
rx_port equ	PORTC 		; Puerto de recepción
rx_pin	equ	0x7		; Pin de recepción

data_tx	equ	0x30		; Datos a enviar
data_rx	equ	0x31	; Datos recibidos

count_d equ	0x32	; Contador para el retardo
count_p	equ	0x33	; Contador para el número de bits


W_TMP EQU 0X40
S_TMP EQU 0X41


ORG 00
	GOTO INICIO
ORG 04
	GOTO INTERRUPT
	
ORG 06
	INICIO: ; CONFIGURACOINES
		BSF STATUS,RP0;BANCO1
		BCF STATUS,RP1
		MOVLW 0x06 ; Configure all pins
		MOVWF ADCON1
		
		CLRF TRISA ; CONFIGURACION DE PUERTOS
		CLRF TRISD
		MOVLW 0X01
		MOVWF TRISB
		
		BSF PIE1,TMR1IE; HABILITO INTERRUPCION POR TIMER1
		
		BCF STATUS,RP0; BANCO 0
		
		BSF INTCON,PEIE ; HABILITO LAS INTERRUPCIONES POR PERIFERICOS
		
		BSF INTCON,INTE
		MOVLW 0x00; PRESCALER 1:1 , CON SYNC , CLOCK INTERNO, TMR1ON = 0
		MOVWF T1CON;
		
	MAIN:;INICIALIZO LAS VARIABLES
		CLRF Time0
		CLRF Time1
		CLRF Time2
		CLRF Time3
		CLRF Time4
		CLRF TimeAux
		
		MOVLW 0X01
		MOVWF MULT_PORT
		CLRF PORTD
		
		CLRW
		CALL TABLA
		MOVWF Disp0
		MOVWF Disp1
		MOVWF Disp2
		MOVWF Disp3
						;El timer 1 debe interrumpir cada 5ms, PRECARGA= EC77
		BCF T1CON,TMR1ON				
		MOVLW 0XEC
		MOVWF TMR1H
		MOVLW 0X77
		MOVWF TMR1L
		BSF T1CON,TMR1ON
		
		BSF INTCON,GIE
	A:	NOP
		GOTO A
		
			
			
INTERRUPT ;SALVO LOS REGISTROS
		MOVWF W_TMP
		SWAPF STATUS,W
		BCF STATUS,RP0
		BCF STATUS,RP1
		MOVWF S_TMP
		
		;VERIFICO LOS FLAGS
		BTFSC INTCON,INTF
		GOTO INT_EXT
		BTFSC PIR1,TMR1IF
		GOTO INT_TMR
		;SI FUE UN FALSO DISPARO RECUPERO LOS REG Y RETORNO 
		MOVF S_TMP,W
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE
		
		
		
INT_EXT:

		BCF INTCON,INTF;BAJO LA BANDERA Y RECUPERACOIN DE REGISTROS
		SWAPF S_TMP,W
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE

INT_TMR: 
		BCF PIR1,TMR1IF;BAJO LA BANDERA  
		
		BCF T1CON,TMR1ON	; precarga de timer			
		MOVLW 0XEC
		ADDWF TMR1H ; uso add para mas precicion
		MOVLW 0X77
		ADDWF TMR1L
		BSF T1CON,TMR1ON
		
		INCF  TimeAux,F ;incremento la cuenta de tiempo
		MOVF  TimeAux,W
		XORLW 0x02
		BTFSS STATUS,Z
		GOTO SIG		; SI NO ES NECESARIO ACTUALIZAR LOS OTROS CONTADORES PASA DIRECGTO AL SIGUIENTE PASO
		CLRF TimeAux		
		
		INCF  Time0,F ; si el aux es 2 incremento las centesimas de segundo
		MOVF  Time0,W
		XORLW 0x0A
		BTFSS STATUS,Z
		GOTO SIG
		CLRF Time0
		
		INCF  Time1,F ; si es necesario incremento las decimas de segundo
		MOVF  Time1,W
		XORLW 0x0A
		BTFSS STATUS,Z
		GOTO SIG
		CLRF Time1
		
		INCF  Time2,F; si es necesario incremento los segundos
		MOVF  Time2,W
		XORLW 0x0A
		BTFSS STATUS,Z
		GOTO SIG
		CLRF Time2
		
		INCF  Time3,F; si es necesario incremento las decenas de segundo
		MOVF  Time3,W
		XORLW 0x0A
		BTFSS STATUS,Z
		GOTO SIG
		CLRF Time3
		
		; carga de datos de displays
	SIG:	
		MOVF Time4,F ; si las centenas son cero no se muestran en los displays
		BTFSS STATUS,Z
		GOTO  MUESTRA_CENTENA
		
	NO_MUESTRA_CENTENA: ; carga los valores de los displays para luego imprimir
		MOVF Time0,W
		CALL TABLA
		MOVWF Disp0
		
		MOVF Time1,W
		CALL TABLA
		MOVWF Disp1
		
		MOVF Time2,W
		CALL TABLA
		MOVWF Disp2
		BSF Disp2 , 7 ; agrego el punto decimal luego de los segundos
		
		MOVF Time3,W
		CALL TABLA
		MOVWF Disp3
		GOTO IMPR
		
	MUESTRA_CENTENA:
		MOVF Time1,W
		CALL TABLA
		MOVWF Disp0
		
		MOVF Time2,W
		CALL TABLA
		MOVWF Disp1
		BSF Disp1 , 7 ; agrego el punto decimal luego de los segundos
		
		MOVF Time3,W
		CALL TABLA
		MOVWF Disp2
		
		MOVF Time4,W
		CALL TABLA
		MOVWF Disp3
		GOTO IMPR
		;IMPRESION CON MULTIPLEXADO EN LOS DISPLAYS
	IMPR:	
		CLRF PORTD ; 
		BCF STATUS,C ; ASEGURO EL CARRY EN 0 PARA Q NO INTERFIERA EN LA ROTACION
		RLF MULT_PORT,F ;ROTACION DE BITS PARA MULTIPLEXAR
	DIS3:
		BTFSS MULT_PORT,3
		GOTO DIS2
		MOVF Disp3,W
		MOVWF PORTD
		GOTO RET ; PASO AL RETORNO DE INTERRUPCION
	DIS2:	
		BTFSS MULT_PORT,2
		GOTO DIS1
		MOVF Disp2,W
		MOVWF PORTD
		GOTO RET ; PASO AL RETORNO DE INTERRUPCION
	DIS1:
		BTFSS MULT_PORT,1
		GOTO DIS0
		MOVF Disp1,W
		MOVWF PORTD
		GOTO RET ; PASO AL RETORNO DE INTERRUPCION
	DIS0: ; SI LLEGO HASTA AQUI ES PORQUE TODOS ESTAN EN 0, OSEA , MULT_PORT = 0001 0000
		BSF PORTA,0
		MOVF Disp0,W
		MOVWF PORTD
		
		
	RET:
		;RECUPERACOIN DE REGISTROS
		SWAPF S_TMP,W
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE
		
TABLA:
		ADDWF PCL,F
		RETLW 0x3F ;0
		RETLW 0x06 ;1
		RETLW 0x5B ;2
		RETLW 0x4F ;3
		RETLW 0x66 ;4
		RETLW 0x6D ;5
		RETLW 0x7D ;6
		RETLW 0x07 ;7
		RETLW 0x7F ;8
		RETLW 0x6F ;9
	
END

