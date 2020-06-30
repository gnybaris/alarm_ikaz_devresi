
_ayar:

;ikazdevresi.c,11 :: 		void ayar() {
;ikazdevresi.c,12 :: 		TRISB = 0X31; //harici kesme ve DIP switch baðlantýlarý giriþ yapýlýyor
	MOVLW      49
	MOVWF      TRISB+0
;ikazdevresi.c,13 :: 		PORTB = 0;
	CLRF       PORTB+0
;ikazdevresi.c,14 :: 		TRISA = 0X00;
	CLRF       TRISA+0
;ikazdevresi.c,15 :: 		PORTA = 0;
	CLRF       PORTA+0
;ikazdevresi.c,17 :: 		INTCON.GIE=1;   //Evrensel kesme aktif
	BSF        INTCON+0, 7
;ikazdevresi.c,18 :: 		INTCON.PEIE=1;  //Çevresel kesme aktif
	BSF        INTCON+0, 6
;ikazdevresi.c,19 :: 		INTCON.INTE=1;  //harici kesme aktif
	BSF        INTCON+0, 4
;ikazdevresi.c,20 :: 		PIE1.TMR1IE=1;  //Timer1 kesmesi aktif
	BSF        PIE1+0, 0
;ikazdevresi.c,22 :: 		CMCON=0X07;     //Analog karþýlaþtýrýcýlar kapatýldý
	MOVLW      7
	MOVWF      CMCON+0
;ikazdevresi.c,23 :: 		OPTION_REG = 0b01000111;    // Önölçekleyici WDT olarak 1:128
	MOVLW      71
	MOVWF      OPTION_REG+0
;ikazdevresi.c,24 :: 		TMR1H=0X00;  //Süre = Prescaler*(65635-0+1)*_____1_____ = 8*2 = 16sn
	CLRF       TMR1H+0
;ikazdevresi.c,25 :: 		TMR1L=0X00;  //                                32768
	CLRF       TMR1L+0
;ikazdevresi.c,26 :: 		Delay_us(10);
	MOVLW      3
	MOVWF      R13+0
L_ayar0:
	DECFSZ     R13+0, 1
	GOTO       L_ayar0
;ikazdevresi.c,28 :: 		T1CON.TMR1ON=0; //Timer1 önce kapalý
	BCF        T1CON+0, 0
;ikazdevresi.c,29 :: 		T1CON=0X3F;     //Ön ölçekleyici 1:8
	MOVLW      63
	MOVWF      T1CON+0
;ikazdevresi.c,30 :: 		Sound_Init(&PORTB, 3);  //Buzzer'ýn baðlý oluðu port
	MOVLW      PORTB+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      3
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;ikazdevresi.c,31 :: 		MAVI=0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;ikazdevresi.c,32 :: 		KIRMIZI=0;
	BCF        RB2_bit+0, BitPos(RB2_bit+0)
;ikazdevresi.c,33 :: 		SES=0;
	BCF        RB3_bit+0, BitPos(RB3_bit+0)
;ikazdevresi.c,34 :: 		ikaz_biti=0;
	CLRF       _ikaz_biti+0
;ikazdevresi.c,35 :: 		}
L_end_ayar:
	RETURN
; end of _ayar

_Alarm:

;ikazdevresi.c,36 :: 		void Alarm() {
;ikazdevresi.c,37 :: 		Sound_Play(1000, 50);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      50
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ikazdevresi.c,38 :: 		}
L_end_Alarm:
	RETURN
; end of _Alarm

_bitti:

;ikazdevresi.c,39 :: 		void bitti() {
;ikazdevresi.c,40 :: 		PORTB=0X00;
	CLRF       PORTB+0
;ikazdevresi.c,41 :: 		zaman=0;
	CLRF       _zaman+0
;ikazdevresi.c,42 :: 		ikaz_biti=0;
	CLRF       _ikaz_biti+0
;ikazdevresi.c,43 :: 		}
L_end_bitti:
	RETURN
; end of _bitti

_bir_dakika:

;ikazdevresi.c,44 :: 		void bir_dakika(){
;ikazdevresi.c,45 :: 		if(zaman<1){
	MOVLW      1
	SUBWF      _zaman+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_bir_dakika1
;ikazdevresi.c,46 :: 		Alarm();
	CALL       _Alarm+0
;ikazdevresi.c,47 :: 		KIRMIZI=~KIRMIZI;
	MOVLW
	XORWF      RB2_bit+0, 1
;ikazdevresi.c,48 :: 		}
L_bir_dakika1:
;ikazdevresi.c,49 :: 		if(zaman>=1){
	MOVLW      1
	SUBWF      _zaman+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_bir_dakika2
;ikazdevresi.c,50 :: 		bitti();
	CALL       _bitti+0
;ikazdevresi.c,51 :: 		}
L_bir_dakika2:
;ikazdevresi.c,52 :: 		}
L_end_bir_dakika:
	RETURN
; end of _bir_dakika

_iki_dakika:

;ikazdevresi.c,53 :: 		void iki_dakika(){
;ikazdevresi.c,54 :: 		if(zaman<8){
	MOVLW      8
	SUBWF      _zaman+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_iki_dakika3
;ikazdevresi.c,55 :: 		Alarm();
	CALL       _Alarm+0
;ikazdevresi.c,56 :: 		KIRMIZI=~KIRMIZI;
	MOVLW
	XORWF      RB2_bit+0, 1
;ikazdevresi.c,57 :: 		}
L_iki_dakika3:
;ikazdevresi.c,58 :: 		if(zaman>=8){
	MOVLW      8
	SUBWF      _zaman+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_iki_dakika4
;ikazdevresi.c,59 :: 		bitti();
	CALL       _bitti+0
;ikazdevresi.c,60 :: 		}
L_iki_dakika4:
;ikazdevresi.c,61 :: 		}
L_end_iki_dakika:
	RETURN
; end of _iki_dakika

_uc_dakika:

;ikazdevresi.c,62 :: 		void uc_dakika(){
;ikazdevresi.c,63 :: 		if(zaman<12){
	MOVLW      12
	SUBWF      _zaman+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_uc_dakika5
;ikazdevresi.c,64 :: 		Alarm();
	CALL       _Alarm+0
;ikazdevresi.c,65 :: 		KIRMIZI=~KIRMIZI;
	MOVLW
	XORWF      RB2_bit+0, 1
;ikazdevresi.c,66 :: 		}
L_uc_dakika5:
;ikazdevresi.c,67 :: 		if(zaman>=12){
	MOVLW      12
	SUBWF      _zaman+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_uc_dakika6
;ikazdevresi.c,68 :: 		bitti();
	CALL       _bitti+0
;ikazdevresi.c,69 :: 		}
L_uc_dakika6:
;ikazdevresi.c,70 :: 		}
L_end_uc_dakika:
	RETURN
; end of _uc_dakika

_bes_dakika:

;ikazdevresi.c,71 :: 		void bes_dakika(){
;ikazdevresi.c,72 :: 		if(zaman<20){
	MOVLW      20
	SUBWF      _zaman+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_bes_dakika7
;ikazdevresi.c,73 :: 		Alarm();
	CALL       _Alarm+0
;ikazdevresi.c,74 :: 		KIRMIZI=~KIRMIZI;
	MOVLW
	XORWF      RB2_bit+0, 1
;ikazdevresi.c,75 :: 		}
L_bes_dakika7:
;ikazdevresi.c,76 :: 		if(zaman>=20){
	MOVLW      20
	SUBWF      _zaman+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_bes_dakika8
;ikazdevresi.c,77 :: 		bitti();
	CALL       _bitti+0
;ikazdevresi.c,78 :: 		}
L_bes_dakika8:
;ikazdevresi.c,79 :: 		}
L_end_bes_dakika:
	RETURN
; end of _bes_dakika

_main:

;ikazdevresi.c,80 :: 		void main(){
;ikazdevresi.c,81 :: 		ayar();
	CALL       _ayar+0
;ikazdevresi.c,82 :: 		while(1){
L_main9:
;ikazdevresi.c,83 :: 		if(!ikaz_biti){
	MOVF       _ikaz_biti+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;ikazdevresi.c,84 :: 		SES=0;
	BCF        RB3_bit+0, BitPos(RB3_bit+0)
;ikazdevresi.c,85 :: 		KIRMIZI=0;
	BCF        RB2_bit+0, BitPos(RB2_bit+0)
;ikazdevresi.c,86 :: 		if(zaman>=1){
	MOVLW      1
	SUBWF      _zaman+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main12
;ikazdevresi.c,87 :: 		zaman=0;
	CLRF       _zaman+0
;ikazdevresi.c,88 :: 		for(i=0;i<5;i++){
	CLRF       _i+0
L_main13:
	MOVLW      5
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main14
;ikazdevresi.c,89 :: 		MAVI=~MAVI;
	MOVLW
	XORWF      RB1_bit+0, 1
;ikazdevresi.c,90 :: 		delay_ms(50);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_main16:
	DECFSZ     R13+0, 1
	GOTO       L_main16
	DECFSZ     R12+0, 1
	GOTO       L_main16
	NOP
;ikazdevresi.c,88 :: 		for(i=0;i<5;i++){
	INCF       _i+0, 1
;ikazdevresi.c,91 :: 		}
	GOTO       L_main13
L_main14:
;ikazdevresi.c,92 :: 		delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	NOP
	NOP
;ikazdevresi.c,93 :: 		MAVI=0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;ikazdevresi.c,94 :: 		}
L_main12:
;ikazdevresi.c,95 :: 		Delay_us(20);
	MOVLW      6
	MOVWF      R13+0
L_main18:
	DECFSZ     R13+0, 1
	GOTO       L_main18
	NOP
;ikazdevresi.c,96 :: 		asm{ sleep }
	SLEEP
;ikazdevresi.c,97 :: 		}
L_main11:
;ikazdevresi.c,98 :: 		if(ikaz_biti){
	MOVF       _ikaz_biti+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main19
;ikazdevresi.c,99 :: 		if(!BIR && !IKI){  // 0-0
	BTFSC      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_main22
	BTFSC      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_main22
L__main37:
;ikazdevresi.c,100 :: 		bir_dakika();
	CALL       _bir_dakika+0
;ikazdevresi.c,101 :: 		}
L_main22:
;ikazdevresi.c,102 :: 		if(!BIR && IKI){   // 0-1
	BTFSC      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_main25
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_main25
L__main36:
;ikazdevresi.c,103 :: 		iki_dakika();
	CALL       _iki_dakika+0
;ikazdevresi.c,104 :: 		}
L_main25:
;ikazdevresi.c,105 :: 		if(BIR && !IKI){   // 1-0
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_main28
	BTFSC      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_main28
L__main35:
;ikazdevresi.c,106 :: 		uc_dakika();
	CALL       _uc_dakika+0
;ikazdevresi.c,107 :: 		}
L_main28:
;ikazdevresi.c,108 :: 		if(BIR && IKI){    // 1-1
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_main31
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_main31
L__main34:
;ikazdevresi.c,109 :: 		bes_dakika();
	CALL       _bes_dakika+0
;ikazdevresi.c,110 :: 		}
L_main31:
;ikazdevresi.c,111 :: 		}
L_main19:
;ikazdevresi.c,112 :: 		}
	GOTO       L_main9
;ikazdevresi.c,113 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ikazdevresi.c,114 :: 		void interrupt(){
;ikazdevresi.c,115 :: 		if(INTCON.INTF){
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt32
;ikazdevresi.c,116 :: 		zaman=0;
	CLRF       _zaman+0
;ikazdevresi.c,117 :: 		ikaz_biti=1;
	MOVLW      1
	MOVWF      _ikaz_biti+0
;ikazdevresi.c,118 :: 		INTCON.INTF=0;
	BCF        INTCON+0, 1
;ikazdevresi.c,119 :: 		}
L_interrupt32:
;ikazdevresi.c,120 :: 		if(PIR1.TMR1IF){
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt33
;ikazdevresi.c,121 :: 		zaman++;
	INCF       _zaman+0, 1
;ikazdevresi.c,123 :: 		BTFSC TMR1L, 0 //TMR1L 0 olana kadar döner
	BTFSC      TMR1L+0, 0
;ikazdevresi.c,124 :: 		GOTO $-1
	GOTO       $-1
;ikazdevresi.c,126 :: 		T1CON.TMR1CS = 0; // Timer1 için dahili osilatör seçiliyor
	BCF        T1CON+0, 1
;ikazdevresi.c,127 :: 		TMR1H=0X00; //Timer1 yüksek baytý yükleniyor
	CLRF       TMR1H+0
;ikazdevresi.c,128 :: 		T1CON.TMR1ON=0; // Timer1 kapatýlýyor
	BCF        T1CON+0, 0
;ikazdevresi.c,129 :: 		T1CON=0x3F; // Süre = Prescaler*(65536-0)*___1___=8*2=16sn
	MOVLW      63
	MOVWF      T1CON+0
;ikazdevresi.c,131 :: 		PIR1.TMR1IF=0;
	BCF        PIR1+0, 0
;ikazdevresi.c,132 :: 		}
L_interrupt33:
;ikazdevresi.c,133 :: 		}
L_end_interrupt:
L__interrupt47:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt
