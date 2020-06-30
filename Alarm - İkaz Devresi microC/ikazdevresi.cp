#line 1 "C:/Users/GUNAY/Desktop/Alarm - Ýkaz Devresi/ikazdevresi.c"
unsigned short ikaz_biti=0;
unsigned short zaman=0;
unsigned short i, yukselen=0;
unsigned short ilk=0;
sbit BIR at RB4_bit;
sbit IKI at RB5_bit;
sbit SES at RB3_bit;
sbit KIRMIZI at RB2_bit;
sbit MAVI at RB1_bit;

void ayar() {
 TRISB = 0X31;
 PORTB = 0;
 TRISA = 0X00;
 PORTA = 0;

 INTCON.GIE=1;
 INTCON.PEIE=1;
 INTCON.INTE=1;
 PIE1.TMR1IE=1;

 CMCON=0X07;
 OPTION_REG = 0b01000111;
 TMR1H=0X00;
 TMR1L=0X00;
 Delay_us(10);

 T1CON.TMR1ON=0;
 T1CON=0X3F;
 Sound_Init(&PORTB, 3);
 MAVI=0;
 KIRMIZI=0;
 SES=0;
 ikaz_biti=0;
}
void Alarm() {
 Sound_Play(1000, 50);
}
void bitti() {
 PORTB=0X00;
 zaman=0;
 ikaz_biti=0;
}
void bir_dakika(){
 if(zaman<1){
 Alarm();
 KIRMIZI=~KIRMIZI;
}
 if(zaman>=1){
 bitti();
}
}
void iki_dakika(){
 if(zaman<8){
 Alarm();
 KIRMIZI=~KIRMIZI;
}
 if(zaman>=8){
 bitti();
}
}
void uc_dakika(){
 if(zaman<12){
 Alarm();
 KIRMIZI=~KIRMIZI;
}
 if(zaman>=12){
 bitti();
}
}
void bes_dakika(){
 if(zaman<20){
 Alarm();
 KIRMIZI=~KIRMIZI;
}
 if(zaman>=20){
 bitti();
}
}
void main(){
ayar();
while(1){
if(!ikaz_biti){
SES=0;
KIRMIZI=0;
if(zaman>=1){
zaman=0;
for(i=0;i<5;i++){
MAVI=~MAVI;
delay_ms(50);
}
delay_ms(10);
MAVI=0;
}
Delay_us(20);
asm{ sleep }
}
if(ikaz_biti){
 if(!BIR && !IKI){
 bir_dakika();
 }
 if(!BIR && IKI){
 iki_dakika();
 }
 if(BIR && !IKI){
 uc_dakika();
 }
 if(BIR && IKI){
 bes_dakika();
 }
 }
 }
 }
void interrupt(){
 if(INTCON.INTF){
 zaman=0;
 ikaz_biti=1;
 INTCON.INTF=0;
}
 if(PIR1.TMR1IF){
 zaman++;
 asm{
 BTFSC TMR1L, 0
 GOTO $-1
 }
 T1CON.TMR1CS = 0;
 TMR1H=0X00;
 T1CON.TMR1ON=0;
 T1CON=0x3F;

 PIR1.TMR1IF=0;
 }
 }
