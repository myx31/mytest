/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/26/2023
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>
#include <delay.h>
#define up PINA.0
#define dw PINA.1
#define start_stop PINA.2
#define enable PIND.7
unsigned int value, captocdo;// set_PWM1_duty(value) thay doi DC
int ttdc; // trang thai dc TTDC=0: DC dung, TTDC=1 DC chay
unsigned char number[10] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09};

// Khai b?o bi?n
unsigned char duty = 128; // Gi? tr? duty cycle m?c d?nh

void kt_start_stop()
{
     if(start_stop==0)
     {   
          delay_ms(20);
          if(start_stop==0)
          {    
               while(start_stop==0){}
               ttdc=~ttdc;
               if(ttdc==1) {captocdo=1;}
               else (captocdo=0);
          }
     }
}


void kt_up()
{
     if(up==0)
     {   
          delay_ms(20);
          if(up==0)
          {    
          while(up==0)
          captocdo++;
          if(captocdo>10)
          captocdo=10;
          }
     }
    }  
    

void kt_dw()
{
     if(dw==0)
     {   
          delay_ms(20);
          if(dw==0)
          {    
          while(dw==0)
          captocdo--;
          if(captocdo<1)
          captocdo=1;
          }
     }
    }

void hiemthi(unsigned int x)
{
     unsigned int temp;
     //unsigned char a,b,c,d;
     unsigned char m[4],i ;
     
  // tach so, luu vao 4 bien a b c d   
     temp=x;   
     for(i=0;i<4;i++)
     {
     m[3-i]=temp % 10;
     temp =temp/10;
     } 
     
     // dieu khien cho LED1 sang, hiem thi chu so a 
     PORTC.4 =0;
     PORTB = number[m[0]];
     delay_ms(1);
     PORTC.4 =1;
     // dieu khien cho LED2 sang, hiem thi chu so b 
     PORTC.5 =0;
     PORTB = number[m[1]];
     delay_ms(1);
     PORTC.5 =1;
     // dieu khien cho LED3 sang, hiem thi chu so c 
     PORTC.6 =0;
     PORTB = number[m[2]];
     delay_ms(1);
     PORTC.6 =1;     
     // dieu khien cho LED4 sang, hiem thi chu so d 
     PORTC.7 =0;
     PORTB = number[m[3]];
     delay_ms(1);
     PORTC.7 =1;   
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
DDRA=0XFF;
PORTA=0XFF;
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
DDRB=0xFF;
PORTB=0xFF;
// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
DDRC=0xFF;
PORTC=0x0F;
// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Fast PWM top=0xFF
// OC0 output: Disconnected
// Timer Period: 0.032 ms
TCCR0=(1<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Fast PWM top=OCR1A
// OC1A output: Disconnected
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 1 ms
// Output Pulse(s):
// OC1B Period: 1 ms Width: 0.50006 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x1F;
OCR1AL=0x3F;
OCR1BH=0x00;
OCR1BL=0x04;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 250.000 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Disconnected
// Timer Period: 1.024 ms
ASSR=0<<AS2;
TCCR2=(1<<PWM2) | (0<<COM21) | (0<<COM20) | (1<<CTC2) | (0<<CS22) | (1<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

while (1)
      {
      // Place your code here
      hiemthi(1234); 
      if(ttdc==1)
         {
           kt_up();
           kt_dw();
         }
      kt_start_stop();
      value= captocdo*100;
      OCR0 = duty;
      delay_ms(1000);
      
        duty += 10;
        if (duty > 255) {
            duty = 0; 
            }
      }
}
