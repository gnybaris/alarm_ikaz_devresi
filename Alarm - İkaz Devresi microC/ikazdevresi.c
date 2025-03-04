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
     TRISB = 0X31; //harici kesme ve DIP switch ba�lant�lar� giri� yap�l�yor
     PORTB = 0;
     TRISA = 0X00;
     PORTA = 0;

     INTCON.GIE=1;   //Evrensel kesme aktif
     INTCON.PEIE=1;  //�evresel kesme aktif
     INTCON.INTE=1;  //harici kesme aktif
     PIE1.TMR1IE=1;  //Timer1 kesmesi aktif

     CMCON=0X07;     //Analog kar��la�t�r�c�lar kapat�ld�
     OPTION_REG = 0b01000111;    // �n�l�ekleyici WDT olarak 1:128
     TMR1H=0X00;  //S�re = Prescaler*(65635-0+1)*_____1_____ = 8*2 = 16sn
     TMR1L=0X00;  //                                32768
     Delay_us(10);

     T1CON.TMR1ON=0; //Timer1 �nce kapal�
     T1CON=0X3F;     //�n �l�ekleyici 1:8
     Sound_Init(&PORTB, 3);  //Buzzer'�n ba�l� olu�u port
     MAVI=0;
     KIRMIZI=0;
     SES=0;
     ikaz_biti=0;
}
void Alarm() {
     Sound_Play(1000, 50);   // 1kHz-50ms fas�l� sinyal
}
void bitti() {
     PORTB=0X00;
     zaman=0;
     ikaz_biti=0;
}
void bir_dakika(){
      if(zaman<4){
     Alarm();
     KIRMIZI=~KIRMIZI;
}
      if(zaman>=4){
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
              if(!BIR && !IKI){  // 0-0
              bir_dakika();
              }
              if(!BIR && IKI){   // 0-1
              iki_dakika();
              }
              if(BIR && !IKI){   // 1-0
              uc_dakika();
              }
              if(BIR && IKI){    // 1-1
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
         BTFSC TMR1L, 0 //TMR1L 0 olana kadar d�ner
         GOTO $-1
         }
 T1CON.TMR1CS = 0; // Timer1 i�in dahili osilat�r se�iliyor
 TMR1H=0X00; //Timer1 y�ksek bayt� y�kleniyor
 T1CON.TMR1ON=0; // Timer1 kapat�l�yor
 T1CON=0x3F; // S�re = Prescaler*(65536-0)*___1___=8*2=16sn
             //                             32768
 PIR1.TMR1IF=0;
 }
 }