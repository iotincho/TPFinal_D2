list p=16f877a
;;; Configuración
;;;  Oscilador:	cristal de cuarzo
;;;  WatchDogTimer: apagado
;;;  CodeProtection: desactivado
;;;  PoWeR up Timer activado
__CONFIG _XT_OSC & _WDT_OFF & _CP_OFF & _PWRTE_ON
INCLUDE <P16F877A.INC>


;ESTE PROGRAMA RECIBE UN DATO POR EL PUERTO SERIE Y DEVUELVE EL MISMO DATO CUANDO SE GENERA LA INTERRUCION POR RECEPCION

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
			
		MOVLW 0X80
		MOVWF TRISC
						
		BCF STATUS,RP0; BANCO 0
		
		BSF INTCON,PEIE ; HABILITO LAS INTERRUPCIONES POR PERIFERICOS
				
	Main:
		; configuro los parametros de transmicion
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
		
		
		bsf INTCON,GIE
		
				
		MOVLW 0X30 ; envia un carxter de prueva
		MOVWF TXREG
		
		NOP
		GOTO $
		
INTERRUPT ;SALVO LOS REGISTROS
		MOVWF W_TMP
		SWAPF STATUS,W
		BCF STATUS,RP0
		BCF STATUS,RP1
		MOVWF S_TMP
		
		;VERIFICO LOS FLAGS
		BTFSC PIR1,RCIF
		GOTO INT_RC232
		
		
		;SI FUE UN FALSO DISPARO RECUPERO LOS REG Y RETORNO 
		MOVF S_TMP,W
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE
		
		
INT_RC232
		BCF PIR1,RCIF ; BAJO LA BANDERA
		MOVF RCREG,W
		MOVWF PORTB
		MOVWF TXREG
				 
		MOVF S_TMP,W ; RECUPERO REGISTROS
		MOVWF STATUS
		SWAPF W_TMP,F
		SWAPF W_TMP,W
		RETFIE
		


END