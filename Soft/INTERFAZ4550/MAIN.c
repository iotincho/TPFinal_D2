#if defined(__PCH__)
#include <18f4550.h>
#Fuses HSPLL, NOWDT, NOPROTECT, NOLVP, NODEBUG, USBDIV, PLL6, CPUDIV1, VREGEN
#use delay(clock=24000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7, PARITY =N, bits = 8)
#include <usb_cdc2.h>
           
#endif

char recibido_RS232;
char Recibido_USB;

#INT_RDA
void PP_Reciver(){
   if (kbhit()){
      recibido_RS232 = getch();
      usb_cdc_putc(recibido_RS232);
      }
}


void main(){
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


usb_task();


}
}



