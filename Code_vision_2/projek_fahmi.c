/*******************************************************
Project : Test Final - Operasi Menu 1 dan Menu 2
NAMA    : FAHMI MASHURI
Comments: Menu 1 : Jam & Tanggal Digital LCD 20x4
          Meny 2 : Kecepatan Motor DC -> CW dan CCW
          Dengan Inteface Visual Basic
*******************************************************/
#include <mega16.h>
#include <delay.h>
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>
#include <ds1307.h>
#include <alcd.h>
#include <stdio.h>
#define ADC_VREF_TYPE 0x20
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
delay_us(10);
ADCSRA|=0x40;
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

/*--------DEKLARASI CHAR------------*/
unsigned int data, data_motor;
char temp[33],time[33],baris[16];
unsigned char valOCR, h, m, s, dd, mm, yy,kol=0;
float rpm;
 
void main(void)
{
    PORTC=0xFF; DDRC=0x0C;
    PORTD=0xFC;DDRD=0xFF;
    //DDRD=0xFF; PORTD=0xCC;
    DDRA.0=0;DDRA.1=0;
    DDRA.2=0;DDRA.3=1;

    PORTA.0=1;PORTA.1=1;
    PORTA.2=1;PORTA.3=1;

    ASSR=0x00;TCCR2=0x6F;
    TCNT2=0x00;OCR2=0x00;
    TIMSK=0x00;

    UCSRA=0x00;UCSRB=0x18;
    UCSRC=0x86;UBRRH=0x00;
    UBRRL=0x47;

    ACSR=0x80;
    SFIOR=0x00;

    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x87;
    SPCR=0x00;
    TWCR=0x00; 
    
    i2c_init();
    rtc_init(0,0,0);
    lcd_init(20);

    lcd_gotoxy(0,1); lcd_putsf("_FAHMI MASHURI__");
    lcd_gotoxy(0,2); lcd_putsf("_1103181001 | 2D3EA_");
    for (kol=0;kol<=10;kol++)                    
    {                                                      
        lcd_gotoxy(kol,0);
        lcd_putsf(" >> >> >> ");
        lcd_gotoxy(kol,3);
        lcd_putsf(" >> >> >> ");
        delay_ms(50);
    }
    for (kol=10;kol>=1;kol--)
    {
        lcd_gotoxy(kol,0);
        lcd_putsf(" << << << ");
        lcd_gotoxy(kol,3);
        lcd_putsf(" << << << ");
        delay_ms(50);
    }
    PORTA.3=0;PORTD.4=0; delay_ms(500);PORTD.4=1; PORTA.3=1; 
    lcd_clear();

while (1)
    { 
       if (PINA.2==0)
       {
       /*---------ambil data waktu--------*/ 
        rtc_get_time(&h,&m,&s);
        rtc_get_date(&dd,&mm,&yy);
        //--------TAMPILAN LCD-------
        lcd_gotoxy(0,0); lcd_putsf("==JAM DIGITAL SAYA==");
        lcd_gotoxy(0,1);lcd_putsf("SETTING ALARM 01 : 45");   
        lcd_gotoxy(0,2);sprintf(temp,"WAKTU    :%02u:%02u:%02u",h,m,s);
        lcd_puts(temp); 
        lcd_gotoxy(0,3);sprintf(temp,"TANGGAL  :%d:%d:%d",dd,mm,yy);
        lcd_puts(temp); 
        //-------SERIAL-----
        sprintf(time,"JAM = %02u : %02u : %02u",h,m,s);puts(time);
        sprintf(time,"\r",s);puts(time);

        sprintf(time,"DATE = %d / %d / %d ",dd,mm,yy);puts(time);
        sprintf(time,"\r",s);puts(time);
        delay_ms(1000); 
        
        //--------ALARM-----
        if(h>=05 && m==46 )
        {         
        lcd_clear();
            lcd_gotoxy(0,2);lcd_putsf("ALARM AKTIF!!!")  ; 
            lcd_gotoxy(0,3);lcd_putsf("ALARM AKTIF!!!")  ;
            PORTA.3=0;
            PORTD.4=0;
            delay_ms(1000);
        }
        else{PORTD.4=1;}
        
  
      }
      else
      {
        /*---------KENDALI MOTOR--------*/
        data_motor = read_adc(6);
        valOCR = ((float)data_motor*(2));
        rpm=((float)data_motor*90);
        if (PINC.5==0)
        {   
            /*-------- POTENSIOMETER -----*/  
            OCR2 = valOCR;
            lcd_gotoxy(0,0); lcd_putsf("=MODE CONTROL MOTOR=");
            lcd_gotoxy(0,1);lcd_putsf(">>>VIA POTENSIO<<<");                       
            lcd_gotoxy(0,3);sprintf(baris,"Nilai RPM = %d",data_motor);lcd_puts(baris);
            delay_ms(1000);
            if(PINC.7==1)
            {
                PORTD.2 = 1; 
                PORTD.3 = 0;
                lcd_clear();        
                lcd_gotoxy(0,2);lcd_putsf("<<COUNTER CLOCK WISE");               
            }
            else if(PINC.6==1)
            {
                PORTD.2 = 0; 
                PORTD.3 = 1;
                lcd_clear();        
                lcd_gotoxy(0,2);lcd_putsf("CLOCK WISE >>");
            }
            delay_ms(500);
            printf("%.2f", rpm);
            printf("\r\n");
            delay_ms(10);                        
        }
        else 
        {   
            /*-------- GUI -----*/ 
            lcd_gotoxy(0,0); lcd_putsf("=MODE CONTROL MOTOR=");
            lcd_gotoxy(0,1);lcd_putsf ("   >>>VIA GUI<<<   "); 
            delay_ms(100);           
            data=getchar();
            if (data=='A')
            {   
                PORTD.2 = 0; 
                PORTD.3 = 1;
                lcd_clear();
                lcd_gotoxy(0,2);lcd_putsf(" CLOCK WISE =>>");               
                putsf("MOTOR DC SUDAH CW ==>>\r");
            }
            else if(data=='B')
            { 
                PORTD.2 = 1; 
                PORTD.3 = 0;
                lcd_clear();        
                lcd_gotoxy(0,2);lcd_putsf("<<COUNTER CLOCK WISE");               
                putsf("<<== MOTOR DC SUDAH CCW\r");        
            }  
            else if (data=='C')
            {
                OCR2 = 20;             
                lcd_gotoxy(0,3);lcd_putsf("=>KEC MOTOR LAMBAN");            
                putsf("KECEPATAN MOTOR LAMBAT\r");       
            }
            else if (data=='D')
            {
                OCR2 = 80;            
                lcd_gotoxy(0,3);lcd_putsf("=>KEC MOTOR SEDANG ");               
                putsf("KECEPATAN MOTOR SEDANG\r");
            }
            else if (data=='E')
            {
                OCR2 = 150;            
                lcd_gotoxy(0,3);lcd_putsf("=>KECE MOTOR CEPAT");               
                putsf("KECEPATAN MOTOR CEPAT\r");
            } 
            else if(data=='F')
            {
               PORTD.5=1;
            }
            else if(data=='G')
            {
               PORTD.6=1;
            }
            else if(data=='H')
            {
               PORTA.3=1;
            }
            delay_ms(500);
            printf("%.2f", rpm);
            printf("\r\n");
            delay_ms(10);      
        }
      }
    }
}
