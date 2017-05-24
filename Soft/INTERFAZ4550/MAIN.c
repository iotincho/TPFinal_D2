#if defined(__PCH__)
#include <18f4550.h>
#Fuses HSPLL, NOWDT, NOPROTECT, NOLVP, NODEBUG, USBDIV, PLL6, CPUDIV1, VREGEN
#use delay(clock=24000000)
#use rs232(BAUD=9600, XMIT=PIN_C6, RCV=PIN_C7, PARITY =N, BITS = 8,STOP = 1,UART1)
#include <usb_cdc2.h>
           
#endif

char recibido_RS232;
char Recibido_USB;

#INT_RDA
void PP_Reciver(){
  do{
      recibido_RS232 = getch();
      usb_cdc_putc(recibido_RS232);
  }while(kbhit());
}

#INT_TIMER0
void refreshUSB(){
usb_task();
}


void main(){
setup_timer_0(RTCC_INTERNAL|RTCC_DIV_128|RTCC_8_BIT);
enable_interrupts(INT_TIMER0);
enable_interrupts(INT_USB);
enable_interrupts(INT_RDA);
enable_interrupts(GLOBAL);

usb_cdc_init();
   usb_init();  
   usb_task();
  
while(true){

   if(usb_cdc_kbhit()){
            Recibido_USB = usb_cdc_getc();
            putc(Recibido_USB);         
      }


}
}



