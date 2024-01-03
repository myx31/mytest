#include <mega32a.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>

void keypad(void);
int numGet(void);
int a=0 , b=0 , key=20, flag=0, flag2=0 , num;
unsigned char c[16];

void main(void){
DDRB=0xF0;
DDRA=0xFF;
lcd_init(16);

a= numGet();
delay_ms(50);
flag2=flag;
b=numGet();
delay_ms(50);


while(flag==5){
    lcd_gotoxy(1,1);
    if(flag2==4)
        sprintf(c,"%d",a+b);
    else if(flag2==3)
        sprintf(c,"%d",a-b); 
    else if(flag2==2)
        sprintf(c,"%d",a*b); 
    else if(flag2==1)
        sprintf(c,"%d",(float)a-b); 
    lcd_puts(c);
    delay_ms(30);
}
}
void keypad(void)
{
key=20;
PORTB=0xFF;
//---- ROW1 ----
PORTB.4=0;
delay_ms(2);
if(PINB.0==0) key=7;
if(PINB.1==0) key=4;
if(PINB.2==0) key=1;
if(PINB.3==0) {lcd_clear(); flag = 0;}  
PORTB.4=1;
//---- ROW2 ----
PORTB.5=0;
delay_ms(2);
if(PINB.0==0) key=8;
if(PINB.1==0) key=5;
if(PINB.2==0) key=2;
if(PINB.3==0) key=0;
PORTB.5=1;
//---- ROW3 ----
PORTB.6=0;
delay_ms(2);
if(PINB.0==0) key=9;
if(PINB.1==0) key=6;
if(PINB.2==0) key=3;
if(PINB.3==0) { lcd_putchar('='); flag=5; delay_ms(30); }
PORTB.6=1;
//---- ROW4 ----
PORTB.7=0;
delay_ms(2);
if(PINB.0==0) { lcd_putchar('/'); flag2=1; delay_ms(30); }
if(PINB.1==0) { lcd_putchar('*'); flag2=2;delay_ms(30); }
if(PINB.2==0) { lcd_putchar('-'); flag2=3; delay_ms(30); }
if(PINB.3==0) { lcd_putchar('+'); flag2=4; delay_ms(30); }
PORTB.7=1;
}

int numGet(void)
{          
    flag=0;
    num=0;
    while(flag<1){
        keypad();
        if(key!=20){
            sprintf(c,"%d",key);
            lcd_puts(c);
            delay_ms(30);
            num+=key;
            num*=10;
        }
    }
    return num/10;
}
