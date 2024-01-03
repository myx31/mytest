#include <mega16a.h>
#include <delay.h>
#include <io.h>
#include <delay.h>
#include <stdio.h>
// dinh nghia chan 
#define thuan PINC.0
#define nguoc PINC.1
#define tang PINC.2
#define giam PINC.3
#define dung PINC.4

#define IN1 PORTD.0
#define IN2 PORTD.1
#define IN3 PORTD.2
#define IN4 PORTD.3
// dinh nghia hang so PID
#define kp 300
#define ki 100
  
unsigned char number[10] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09};


void tangtoc(void);
void giamtoc(void);
void chaythuan(void);
void chaynguoc(void);
void dunglai(void);
void dieukhien(void);
     
// Declare your global variables here

long int n=0; // bien nay dem so lan ngoai vi dc kich hoat , tinh toan toc do dc
long int delta_v,toc_do,setpoint;// sai so toc do hien tai vs setpoint
long int sum_e=0; // so lg tich luy cua sai so, (PID)
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void) // ngat nay dc kich hoat boi 
//mot ngat ngoai vi tren INT 0 
{
    n++;// bien n tang len moi lan ngat say ra 
} //  dem so xung tao ra boi ngoai vi 

interrupt [TIM0_OVF] void timer0_ovf_isr(void)  // xu ly tran TImer0
{
// Place your code here
   // tinh toc do
    toc_do = 75*n; //toc do = (n/8*N)*1000*60
    sum_e += delta_v;  // tp tich phan
   //reset n 
   n=0;
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
     PORTA.0 =0;
     PORTB = number[m[0]];
     delay_ms(1);
     PORTA.0 =1;
     // dieu khien cho LED2 sang, hiem thi chu so b 
     PORTA.1 =0;
     PORTB = number[m[1]];
     delay_ms(1);
     PORTA.1 =1;
     // dieu khien cho LED3 sang, hiem thi chu so c 
     PORTA.2 =0;
     PORTB = number[m[2]];
     delay_ms(1);
     PORTA.2 =1;    
     // dieu khien cho LED4 sang, hiem thi chu so d 
     PORTA.3 =0;
     PORTB = number[m[3]];
     delay_ms(1);
     PORTA.3 =1; 
       
}

void main(void)
{
//Cong D
DDRD=0xff;
PORTD.5=0;

//cau hinh timer
    
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Fast PWM top=0x03FF
// OC1A output: Non-Inverted PWM
// OC1B output: Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0.128 ms
// Output Pulse(s):
// OC1A Period: 0.128 ms Width: 0 us
// OC1B Period: 0.128 ms Width: 0.128 ms
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (1<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// TIMER0 init
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization // thanh ghi mat na ngat bo dem Tg 
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2); // dk ngat chung 
MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);//  ko su dung TH nay
MCUCSR=(0<<ISC2);//dk co chung ( xoa co) 
GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);

// cong
PORTC =0xFF;
DDRB = 0xFF;
DDRA=0xFF;

while (1)
{ 
      hiemthi(toc_do);         
      dieukhien();                  
      if(dung == 0)
      {   
        dunglai();
      }
}
}
void tangtoc(void)
{      
                                                
      toc_do = toc_do + 1;
      if (toc_do>10) { toc_do=10;}
      hiemthi(toc_do);
}
void giamtoc(void)
{     
      
      toc_do = toc_do - 1; 
      if (toc_do<1) {toc_do=1;}
      hiemthi(toc_do);
}

void chaythuan(void)
{

   while (dung!=0)
   {
    hiemthi(toc_do);                           
    IN1 = 0;
    IN2 = 1; 
    setpoint=50;
    PORTD.5=1; 
    delay_ms(50);
    
    //TinhtoanPWM
      delta_v = setpoint - toc_do;
      if(delta_v<0)
      {
        OCR1A=0;
      }
      else 
      {
        if((kp*delta_v+ki*sum_e)>0x3ff) OCR1A = 0x3ff;
        else OCR1A = kp*delta_v+ki*sum_e;
      }
   } 

   
}

void chaynguoc(void)
{
  
   while (dung!=0)
   {
    hiemthi(toc_do);   
    IN1 = 1;
    IN2 = 0; 
    setpoint=5;
    PORTD.5=1;
    delay_ms(50); 
    
    //TinhtoanPWM
      delta_v = setpoint - toc_do;// hieu so chenh lech 
      if(delta_v<0)
      {
        OCR1A=0; // neu am chu ky nhiem =0
      }
      else 
      {  //neu ko am tinh PWM moi dua tren cong thuc kiem soat PID
        if((kp*delta_v+ki*sum_e)>0x3ff) OCR1A = 0x3ff; // neu gia tri vuot 0x3FF dat ve toi da
        else OCR1A = kp*delta_v+ki*sum_e;// dat gia tri PWM dua tren cong thuc kiem soat Pwm
      }
   }  
   
   
}   
void dunglai(void)
{   
    hiemthi(0000);
    IN1 = 0;
    IN2 = 0;

} 

void dieukhien(void)
{   
  if (thuan==0)
  {  
   {
   chaythuan();
   }
  }
  if (nguoc==0)
  {
     chaynguoc();
   }  
   if (tang==0)  
   {  
    while (tang==0);
    tangtoc();  
    if (thuan==0)
    {
    chaythuan();
    } 
    if (nguoc==0)
    {
    chaynguoc();
    }
   }
   if (giam==0) 
   {  
    while (giam==0);
    giamtoc();
    if (thuan==0)
    {
    chaythuan();
    }
    if (nguoc==0)
    {
    chaynguoc();
    }
   }  
  
}
