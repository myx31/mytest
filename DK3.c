#include <mega16.h>
#include <delay.h>
#include <io.h>
#include <delay.h>
#include <stdio.h>

#define thuan PINC.0
#define nguoc PINC.1
#define tang PINC.2
#define giam PINC.3
#define dung PINC.4

#define IN1 PORTD.0
#define IN2 PORTD.1
#define IN3 PORTD.2
#define IN4 PORTD.3
    
unsigned char number[10] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09};

int tocdo =5;

void tangtoc(void);
void giamtoc(void);
void chaythuan(void);
void chaynguoc(void);
void dunglai(void);
void dieukhien(void);
     
// Declare your global variables here


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
DDRD = 0xFF;
PORTC =0xFF;
DDRB = 0xFF;
DDRA=0xFF;
while (1)
{ 
      hiemthi(tocdo);
      dieukhien();
      if(dung == 0)
      {   
        dunglai();
      }
}
}
void tangtoc(void)
{      
     
      tocdo = tocdo - 1;
      if (tocdo<1) { tocdo=1;}
      hiemthi(tocdo);
}
void giamtoc(void)
{     
      
      tocdo = tocdo + 1; 
      if (tocdo>10) {tocdo=10;}
      hiemthi(tocdo);
}

void chaythuan(void)
{

   while ( dung!=0)
   {
    hiemthi(tocdo);                           
    IN1 = 1;
    IN2 = 0;

   } 

   
}

void chaynguoc(void)
{
  
   while (dung!=0)
   {
    hiemthi(tocdo);   
    IN1 = 0;
    IN2 = 1;

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
