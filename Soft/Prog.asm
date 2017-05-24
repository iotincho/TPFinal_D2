list p=16f877a
;;; Configuración
;;;  Oscilador:	cristal de cuarzo
;;;  WatchDogTimer: apagado
;;;  CodeProtection: desactivado
;;;  PoWeR up Timer activado
__CONFIG _XT_OSC & _WDT_OFF & _CP_OFF & _PWRTE_ON
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
Disp_Aux equ 0x2B


W_TMP EQU 0X30
S_TMP EQU 0X31
cont_flag equ 0x32 ; es una bandera que ademas cuenta el tiempo de retencion de muestra del intervalo recibido desde la pc


ORG 00
	GOTO INICIO
ORG 04
	GOTO INTERRUPT
	
ORG 06
	INICIO ; CONFIGURACOINES
		BSF STATUS,RP0;BANCO1
		BCF STATUS,RP1
		MOVLW 0x06 ; Configure all pins
		MOVWF ADCON1
		
		CLRF TRISA ; CONFIGURACION DE PUERTOS
		CLRF TRISD
		MOVLW 0X01
		MOVWF TRISB
		MOVLW 0X80
		MOVWF TRISC
		
		BSF PIE1,TMR1IE; HABILITO INTERRUPCION POR TIMER1
		
		BCF STATUS,RP0; BANCO 0
		
		BSF INTCON,PEIE ; HABILITO LAS INTERRUPCIONES POR PERIFERICOS
		
		BSF INTCON,INTE
		MOVLW 0x00; PRESCALER 1:1 , CON SYNC , CLOCK INTERNO, TMR1ON = 0
		MOVWF T1CON;
		
;;;;;;;;; CONFIGURO LOS PARAMETROS DE TRANSMICION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		BSF STATUS,RP0;BANCO1
		BCF STATUS,RP1
		
		movlw D'25' ;9600 baud CRISTAL DE 4MHZ
		movwf SPBRG
		
		bcf TXSTA,CSRC ;7(ignorado por estar en modo asincrono)
		bcf TXSTA,TX9 ;6 transmicion de 8 bits
		bsf TXSTA,TXEN;5 transmicion habilitada
		bcf TXSTA,SYNC;4 modo asincrono
					  ;bit 3 no implementado
		bsf TXSTA,BRGH;2 high speed baudrate
		
		bsf PIE1,RCIE
		BCF STATUS,RP0; BANCO 0
		
		bsf RCSTA,SPEN;7 serial port habilitado
		bcf RCSTA,RX9;6 se reciben 8 bits
		  			  ;bit 5 ignorado en modo asincrono
		bsf RCSTA,CREN ;4 activa la recepcion continua
		bsf RCSTA,ADDEN ;3 activo la interrupcion por recepcion
		bcf RCSTA,FERR; 2 no framming error
		bcf RCSTA,OERR;1 no overrun error
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	MAIN ;INICIALIZO LAS VARIABLES
		CLRF Time0
		CLRF Time1
		CLRF Time2
		CLRF Time3
		CLRF Time4
		CLRF TimeAux
		CLRF cont_flag
		CLRF Disp_Aux
		
		MOVLW 0XFF
		MOVWF MULT_PORT
		MOVWF PORTD
		
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
		
		
		;btfsc PORTB,0
		;goto $-1
		
		BSF T1CON,TMR1ON		
		BSF INTCON,GIE
		
		NOP
		GOTO $-1
		
			
			
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
		BTFSC PIR1,RCIF
		GOTO INT_RC232
		;SI FUE UN FALSO DISPARO RECUPERO LOS REG Y RETORNO 
		MOVF S_TMP,W
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE
		
		
		
INT_EXT
		BCF PIR1,TXIF
		MOVF Time4,W ; ENVIO LOS VALORES DE TIEMPO
		;IORLW 0X30 ; CODIFICO EN ASCII
		MOVWF TXREG
		BTFSS PIR1,TXIF ; SI EL BUFFER DE ENVIO ESTA VACIO ENVIO EL PROXIMO
		GOTO $-1
		
		BCF PIR1,TXIF
		MOVF Time3,W ; ENVIO LOS VALORES DE TIEMPO
		;IORLW 0X30 ; CODIFICO EN ASCII
		MOVWF TXREG
		BTFSS PIR1,TXIF ; SI EL BUFFER DE ENVIO ESTA VACIO ENVIO EL PROXIMO
		GOTO $-1
		
	        BCF PIR1,TXIF
		MOVF Time2,W ; ENVIO LOS VALORES DE TIEMPO
		;IORLW 0X30 ; CODIFICO EN ASCII
		MOVWF TXREG
		BTFSS PIR1,TXIF ; SI EL BUFFER DE ENVIO ESTA VACIO ENVIO EL PROXIMO
		GOTO $-1
		
		BCF PIR1,TXIF
		MOVF Time1,W ; ENVIO LOS VALORES DE TIEMPO
		;IORLW 0X30 ; CODIFICO EN ASCII
		MOVWF TXREG
		BTFSS PIR1,TXIF ; SI EL BUFFER DE ENVIO ESTA VACIO ENVIO EL PROXIMO
		GOTO $-1
		
		MOVF Time0,W ; ENVIO LOS VALORES DE TIEMPO
		;IORLW 0X30 ; CODIFICO EN ASCII
		MOVWF TXREG
		
		
		BCF INTCON,INTF;BAJO LA BANDERA Y RECUPERACOIN DE REGISTROS
		SWAPF S_TMP,W
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE
		

INT_TMR 
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
	SIG	
		MOVF cont_flag,f ; SI LOS VALORES DE LOS DISPLAYS ESTAN BAJO RETENCION PARA MOSTRAR EL INTERVALO NO SE DEBEN ACTUALIZAR
		BTFSC STATUS,Z ; CUNADO EL FLAG ESTA EN CERO NO HAY RETENCION. TAMBIEN HACE LA CUENTA DE LA RETENCION
		GOTO  ACTUALIZAR
		INCF  cont_flag ; incremente el contador de tiempo de retencion
		goto  IMPR
	ACTUALIZAR	
		MOVF Time4,F ; si las centenas son cero no se muestran en los displays
		BTFSS STATUS,Z
		GOTO  MUESTRA_CENTENA
		
	NO_MUESTRA_CENTENA ; carga los valores de los displays para luego imprimir
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
		
	MUESTRA_CENTENA
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
		
		
		
	IMPR	
		MOVLW 0XFF
		MOVWF PORTD ; 
		MOVF Disp_Aux,W
		ADDWF PCL,F
		GOTO DIS3
		GOTO DIS2
		GOTO DIS1
		GOTO DIS0
		
	DIS3
		MOVLW B'11110111'
		MOVWF MULT_PORT
		MOVF Disp3,W
		MOVWF PORTD
		INCF Disp_Aux,F
		GOTO RET ; PASO AL RETORNO DE INTERRUPCION
	DIS2	
		MOVLW B'11111011'
		MOVWF MULT_PORT
		MOVF Disp2,W
		MOVWF PORTD
		INCF Disp_Aux,F
		GOTO RET ; PASO AL RETORNO DE INTERRUPCION
	DIS1
		MOVLW B'11111101'
		MOVWF MULT_PORT
		MOVF Disp1,W
		MOVWF PORTD
		INCF Disp_Aux,F
		GOTO RET ; PASO AL RETORNO DE INTERRUPCION
		
	DIS0	
		MOVLW B'11110111'
		MOVWF MULT_PORT
		BSF PORTA,0
		MOVF Disp0,W
		CLRF Disp_Aux
		MOVWF PORTD
		goto RET
		
	RET
		;RECUPERACOIN DE REGISTROS
		SWAPF S_TMP,W
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE
		
		
TABLA
		ADDWF PCL,F
		RETLW 0xC0 ;0
		RETLW 0xF9 ;1
		RETLW 0xA4 ;2
		RETLW 0xB0 ;3
		RETLW 0x99 ;4
		RETLW 0x92 ;5
		RETLW 0x82 ;6
		RETLW 0xF8 ;7
		RETLW 0x80 ;8
		RETLW 0x90 ;9
	
	
INT_RC232
		BCF PIR1,RCIF
		MOVF RCREG,W ; RECIBO LOS VALORES DE TIEMPO
		ANDLW 0X0F ; CONVERSION ASCII -> DECIMAL
		CALL TABLA
		MOVWF Disp3	
		
		BTFSS PIR1,RCIF ; Cuando llegue el proximo digito lo recibo
		GOTO $-1
		
		BCF PIR1,RCIF
		MOVF RCREG,W ; RECIBO LOS VALORES DE TIEMPO
		ANDLW 0X0F ; CONVERSION ASCII -> DECIMAL
		CALL TABLA
		MOVWF Disp2
		BSF Disp2,7 ; agrego el punto decimal
		
		BTFSS PIR1,RCIF ; Cuando llegue el proximo digito lo recibo
		GOTO $-1
		
	        BCF PIR1,RCIF
		MOVF RCREG,W ; RECIBO LOS VALORES DE TIEMPO
		ANDLW 0X0F ; CONVERSION ASCII -> DECIMAL
		CALL TABLA
		MOVWF Disp1	
		
		BTFSS PIR1,RCIF ; Cuando llegue el proximo digito lo recibo
		GOTO $-1
		
		BCF PIR1,RCIF
		MOVF RCREG,W ; RECIBO LOS VALORES DE TIEMPO
		ANDLW 0X0F ; CONVERSION ASCII -> DECIMAL
		CALL TABLA
		MOVWF Disp0	
		
		MOVLW 0X01
		MOVWF cont_flag ; seteo la bandera de tiempo
		
		
		BCF INTCON,INTF;BAJO LA BANDERA Y RECUPERACOIN DE REGISTROS
		SWAPF S_TMP,W
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE
	
	
	
END

