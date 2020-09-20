
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 11,059200 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _data=R4
	.DEF _data_motor=R6
	.DEF _valOCR=R9
	.DEF _h=R8
	.DEF _m=R11
	.DEF _s=R10
	.DEF _dd=R13
	.DEF _mm=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x5F,0x46,0x41,0x48,0x4D,0x49,0x20,0x4D
	.DB  0x41,0x53,0x48,0x55,0x52,0x49,0x5F,0x5F
	.DB  0x0,0x5F,0x31,0x31,0x30,0x33,0x31,0x38
	.DB  0x31,0x30,0x30,0x31,0x20,0x7C,0x20,0x32
	.DB  0x44,0x33,0x45,0x41,0x5F,0x0,0x20,0x3E
	.DB  0x3E,0x20,0x3E,0x3E,0x20,0x3E,0x3E,0x20
	.DB  0x0,0x20,0x3C,0x3C,0x20,0x3C,0x3C,0x20
	.DB  0x3C,0x3C,0x20,0x0,0x3D,0x3D,0x4A,0x41
	.DB  0x4D,0x20,0x44,0x49,0x47,0x49,0x54,0x41
	.DB  0x4C,0x20,0x53,0x41,0x59,0x41,0x3D,0x3D
	.DB  0x0,0x53,0x45,0x54,0x54,0x49,0x4E,0x47
	.DB  0x20,0x41,0x4C,0x41,0x52,0x4D,0x20,0x30
	.DB  0x31,0x20,0x3A,0x20,0x34,0x35,0x0,0x57
	.DB  0x41,0x4B,0x54,0x55,0x20,0x20,0x20,0x20
	.DB  0x3A,0x25,0x30,0x32,0x75,0x3A,0x25,0x30
	.DB  0x32,0x75,0x3A,0x25,0x30,0x32,0x75,0x0
	.DB  0x54,0x41,0x4E,0x47,0x47,0x41,0x4C,0x20
	.DB  0x20,0x3A,0x25,0x64,0x3A,0x25,0x64,0x3A
	.DB  0x25,0x64,0x0,0x4A,0x41,0x4D,0x20,0x3D
	.DB  0x20,0x25,0x30,0x32,0x75,0x20,0x3A,0x20
	.DB  0x25,0x30,0x32,0x75,0x20,0x3A,0x20,0x25
	.DB  0x30,0x32,0x75,0x0,0xD,0x0,0x44,0x41
	.DB  0x54,0x45,0x20,0x3D,0x20,0x25,0x64,0x20
	.DB  0x2F,0x20,0x25,0x64,0x20,0x2F,0x20,0x25
	.DB  0x64,0x20,0x0,0x41,0x4C,0x41,0x52,0x4D
	.DB  0x20,0x41,0x4B,0x54,0x49,0x46,0x21,0x21
	.DB  0x21,0x0,0x3D,0x4D,0x4F,0x44,0x45,0x20
	.DB  0x43,0x4F,0x4E,0x54,0x52,0x4F,0x4C,0x20
	.DB  0x4D,0x4F,0x54,0x4F,0x52,0x3D,0x0,0x3E
	.DB  0x3E,0x3E,0x56,0x49,0x41,0x20,0x50,0x4F
	.DB  0x54,0x45,0x4E,0x53,0x49,0x4F,0x3C,0x3C
	.DB  0x3C,0x0,0x4E,0x69,0x6C,0x61,0x69,0x20
	.DB  0x52,0x50,0x4D,0x20,0x3D,0x20,0x25,0x64
	.DB  0x0,0x3C,0x3C,0x43,0x4F,0x55,0x4E,0x54
	.DB  0x45,0x52,0x20,0x43,0x4C,0x4F,0x43,0x4B
	.DB  0x20,0x57,0x49,0x53,0x45,0x0,0x43,0x4C
	.DB  0x4F,0x43,0x4B,0x20,0x57,0x49,0x53,0x45
	.DB  0x20,0x3E,0x3E,0x0,0x25,0x2E,0x32,0x66
	.DB  0x0,0xD,0xA,0x0,0x20,0x20,0x20,0x3E
	.DB  0x3E,0x3E,0x56,0x49,0x41,0x20,0x47,0x55
	.DB  0x49,0x3C,0x3C,0x3C,0x20,0x20,0x20,0x0
	.DB  0x20,0x43,0x4C,0x4F,0x43,0x4B,0x20,0x57
	.DB  0x49,0x53,0x45,0x20,0x3D,0x3E,0x3E,0x0
	.DB  0x4D,0x4F,0x54,0x4F,0x52,0x20,0x44,0x43
	.DB  0x20,0x53,0x55,0x44,0x41,0x48,0x20,0x43
	.DB  0x57,0x20,0x3D,0x3D,0x3E,0x3E,0xD,0x0
	.DB  0x3C,0x3C,0x3D,0x3D,0x20,0x4D,0x4F,0x54
	.DB  0x4F,0x52,0x20,0x44,0x43,0x20,0x53,0x55
	.DB  0x44,0x41,0x48,0x20,0x43,0x43,0x57,0xD
	.DB  0x0,0x3D,0x3E,0x4B,0x45,0x43,0x20,0x4D
	.DB  0x4F,0x54,0x4F,0x52,0x20,0x4C,0x41,0x4D
	.DB  0x42,0x41,0x4E,0x0,0x4B,0x45,0x43,0x45
	.DB  0x50,0x41,0x54,0x41,0x4E,0x20,0x4D,0x4F
	.DB  0x54,0x4F,0x52,0x20,0x4C,0x41,0x4D,0x42
	.DB  0x41,0x54,0xD,0x0,0x3D,0x3E,0x4B,0x45
	.DB  0x43,0x20,0x4D,0x4F,0x54,0x4F,0x52,0x20
	.DB  0x53,0x45,0x44,0x41,0x4E,0x47,0x20,0x0
	.DB  0x4B,0x45,0x43,0x45,0x50,0x41,0x54,0x41
	.DB  0x4E,0x20,0x4D,0x4F,0x54,0x4F,0x52,0x20
	.DB  0x53,0x45,0x44,0x41,0x4E,0x47,0xD,0x0
	.DB  0x3D,0x3E,0x4B,0x45,0x43,0x45,0x20,0x4D
	.DB  0x4F,0x54,0x4F,0x52,0x20,0x43,0x45,0x50
	.DB  0x41,0x54,0x0,0x4B,0x45,0x43,0x45,0x50
	.DB  0x41,0x54,0x41,0x4E,0x20,0x4D,0x4F,0x54
	.DB  0x4F,0x52,0x20,0x43,0x45,0x50,0x41,0x54
	.DB  0xD,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20E0060:
	.DB  0x1
_0x20E0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G107
	.DW  _0x20E0060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;Project : Test Final - Operasi Menu 1 dan Menu 2
;NAMA    : FAHMI MASHURI
;Comments: Menu 1 : Jam & Tanggal Digital LCD 20x4
;          Meny 2 : Kecepatan Motor DC -> CW dan CCW
;          Dengan Inteface Visual Basic
;*******************************************************/
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 000E #endasm
;#include <i2c.h>
;#include <ds1307.h>
;#include <alcd.h>
;#include <stdio.h>
;#define ADC_VREF_TYPE 0x20
;unsigned char read_adc(unsigned char adc_input)
; 0000 0015 {

	.CSEG
_read_adc:
; 0000 0016 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 0017 delay_us(10);
	__DELAY_USB 37
; 0000 0018 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0019 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 001A ADCSRA|=0x10;
	SBI  0x6,4
; 0000 001B return ADCH;
	IN   R30,0x5
	JMP  _0x2100007
; 0000 001C }
;
;/*--------DEKLARASI CHAR------------*/
;unsigned int data, data_motor;
;char temp[33],time[33],baris[16];
;unsigned char valOCR, h, m, s, dd, mm, yy,kol=0;
;float rpm;
;
;void main(void)
; 0000 0025 {
_main:
; 0000 0026     PORTC=0xFF; DDRC=0x0C;
	LDI  R30,LOW(255)
	OUT  0x15,R30
	LDI  R30,LOW(12)
	OUT  0x14,R30
; 0000 0027     PORTD=0xFC;DDRD=0xFF;
	LDI  R30,LOW(252)
	OUT  0x12,R30
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0028     //DDRD=0xFF; PORTD=0xCC;
; 0000 0029     DDRA.0=0;DDRA.1=0;
	CBI  0x1A,0
	CBI  0x1A,1
; 0000 002A     DDRA.2=0;DDRA.3=1;
	CBI  0x1A,2
	SBI  0x1A,3
; 0000 002B 
; 0000 002C     PORTA.0=1;PORTA.1=1;
	SBI  0x1B,0
	SBI  0x1B,1
; 0000 002D     PORTA.2=1;PORTA.3=1;
	SBI  0x1B,2
	SBI  0x1B,3
; 0000 002E 
; 0000 002F     ASSR=0x00;TCCR2=0x6F;
	LDI  R30,LOW(0)
	OUT  0x22,R30
	LDI  R30,LOW(111)
	OUT  0x25,R30
; 0000 0030     TCNT2=0x00;OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
	OUT  0x23,R30
; 0000 0031     TIMSK=0x00;
	OUT  0x39,R30
; 0000 0032 
; 0000 0033     UCSRA=0x00;UCSRB=0x18;
	OUT  0xB,R30
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0034     UCSRC=0x86;UBRRH=0x00;
	LDI  R30,LOW(134)
	OUT  0x20,R30
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0035     UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 0036 
; 0000 0037     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0038     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0039 
; 0000 003A     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 003B     ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 003C     SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 003D     TWCR=0x00;
	OUT  0x36,R30
; 0000 003E 
; 0000 003F     i2c_init();
	CALL _i2c_init
; 0000 0040     rtc_init(0,0,0);
	CALL SUBOPT_0x0
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _rtc_init
; 0000 0041     lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0042 
; 0000 0043     lcd_gotoxy(0,1); lcd_putsf("_FAHMI MASHURI__");
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x2
; 0000 0044     lcd_gotoxy(0,2); lcd_putsf("_1103181001 | 2D3EA_");
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x2
; 0000 0045     for (kol=0;kol<=10;kol++)
	STS  _kol,R30
_0x17:
	LDS  R26,_kol
	CPI  R26,LOW(0xB)
	BRSH _0x18
; 0000 0046     {
; 0000 0047         lcd_gotoxy(kol,0);
	CALL SUBOPT_0x4
; 0000 0048         lcd_putsf(" >> >> >> ");
	CALL SUBOPT_0x5
; 0000 0049         lcd_gotoxy(kol,3);
	CALL SUBOPT_0x6
; 0000 004A         lcd_putsf(" >> >> >> ");
	CALL SUBOPT_0x5
; 0000 004B         delay_ms(50);
	CALL SUBOPT_0x7
; 0000 004C     }
	LDS  R30,_kol
	SUBI R30,-LOW(1)
	STS  _kol,R30
	RJMP _0x17
_0x18:
; 0000 004D     for (kol=10;kol>=1;kol--)
	LDI  R30,LOW(10)
	STS  _kol,R30
_0x1A:
	LDS  R26,_kol
	CPI  R26,LOW(0x1)
	BRLO _0x1B
; 0000 004E     {
; 0000 004F         lcd_gotoxy(kol,0);
	CALL SUBOPT_0x4
; 0000 0050         lcd_putsf(" << << << ");
	CALL SUBOPT_0x8
; 0000 0051         lcd_gotoxy(kol,3);
	CALL SUBOPT_0x6
; 0000 0052         lcd_putsf(" << << << ");
	CALL SUBOPT_0x8
; 0000 0053         delay_ms(50);
	CALL SUBOPT_0x7
; 0000 0054     }
	LDS  R30,_kol
	SUBI R30,LOW(1)
	STS  _kol,R30
	RJMP _0x1A
_0x1B:
; 0000 0055     PORTA.3=0;PORTD.4=0; delay_ms(500);PORTD.4=1; PORTA.3=1;
	CBI  0x1B,3
	CBI  0x12,4
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x9
	SBI  0x12,4
	SBI  0x1B,3
; 0000 0056     lcd_clear();
	CALL _lcd_clear
; 0000 0057 
; 0000 0058 while (1)
_0x24:
; 0000 0059     {
; 0000 005A        if (PINA.2==0)
	SBIC 0x19,2
	RJMP _0x27
; 0000 005B        {
; 0000 005C        /*---------ambil data waktu--------*/
; 0000 005D         rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rtc_get_time
; 0000 005E         rtc_get_date(&dd,&mm,&yy);
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_yy)
	LDI  R31,HIGH(_yy)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rtc_get_date
; 0000 005F         //--------TAMPILAN LCD-------
; 0000 0060         lcd_gotoxy(0,0); lcd_putsf("==JAM DIGITAL SAYA==");
	CALL SUBOPT_0x0
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,60
	CALL SUBOPT_0xA
; 0000 0061         lcd_gotoxy(0,1);lcd_putsf("SETTING ALARM 01 : 45");
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,81
	CALL SUBOPT_0x2
; 0000 0062         lcd_gotoxy(0,2);sprintf(temp,"WAKTU    :%02u:%02u:%02u",h,m,s);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,103
	CALL SUBOPT_0xC
; 0000 0063         lcd_puts(temp);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 0064         lcd_gotoxy(0,3);sprintf(temp,"TANGGAL  :%d:%d:%d",dd,mm,yy);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,128
	CALL SUBOPT_0xE
; 0000 0065         lcd_puts(temp);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 0066         //-------SERIAL-----
; 0000 0067         sprintf(time,"JAM = %02u : %02u : %02u",h,m,s);puts(time);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,147
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0068         sprintf(time,"\r",s);puts(time);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
; 0000 0069 
; 0000 006A         sprintf(time,"DATE = %d / %d / %d ",dd,mm,yy);puts(time);
	__POINTW1FN _0x0,174
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 006B         sprintf(time,"\r",s);puts(time);
	CALL SUBOPT_0x11
	CALL _puts
; 0000 006C         delay_ms(1000);
	CALL SUBOPT_0x12
; 0000 006D 
; 0000 006E         //--------ALARM-----
; 0000 006F         if(h>=05 && m==46 )
	LDI  R30,LOW(5)
	CP   R8,R30
	BRLO _0x29
	LDI  R30,LOW(46)
	CP   R30,R11
	BREQ _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 0070         {
; 0000 0071         lcd_clear();
	CALL SUBOPT_0x13
; 0000 0072             lcd_gotoxy(0,2);lcd_putsf("ALARM AKTIF!!!")  ;
	__POINTW1FN _0x0,195
	CALL SUBOPT_0x2
; 0000 0073             lcd_gotoxy(0,3);lcd_putsf("ALARM AKTIF!!!")  ;
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	__POINTW1FN _0x0,195
	CALL SUBOPT_0xA
; 0000 0074             PORTA.3=0;
	CBI  0x1B,3
; 0000 0075             PORTD.4=0;
	CBI  0x12,4
; 0000 0076             delay_ms(1000);
	CALL SUBOPT_0x12
; 0000 0077         }
; 0000 0078         else{PORTD.4=1;}
	RJMP _0x2F
_0x28:
	SBI  0x12,4
_0x2F:
; 0000 0079 
; 0000 007A 
; 0000 007B       }
; 0000 007C       else
	RJMP _0x32
_0x27:
; 0000 007D       {
; 0000 007E         /*---------KENDALI MOTOR--------*/
; 0000 007F         data_motor = read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R6,R30
	CLR  R7
; 0000 0080         valOCR = ((float)data_motor*(2));
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x40000000
	CALL __MULF12
	CALL __CFD1U
	MOV  R9,R30
; 0000 0081         rpm=((float)data_motor*90);
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x42B40000
	CALL __MULF12
	STS  _rpm,R30
	STS  _rpm+1,R31
	STS  _rpm+2,R22
	STS  _rpm+3,R23
; 0000 0082         if (PINC.5==0)
	SBIC 0x13,5
	RJMP _0x33
; 0000 0083         {
; 0000 0084             /*-------- POTENSIOMETER -----*/
; 0000 0085             OCR2 = valOCR;
	OUT  0x23,R9
; 0000 0086             lcd_gotoxy(0,0); lcd_putsf("=MODE CONTROL MOTOR=");
	CALL SUBOPT_0x0
	CALL SUBOPT_0x14
; 0000 0087             lcd_gotoxy(0,1);lcd_putsf(">>>VIA POTENSIO<<<");
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,231
	CALL SUBOPT_0x2
; 0000 0088             lcd_gotoxy(0,3);sprintf(baris,"Nilai RPM = %d",data_motor);lcd_puts(baris);
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LDI  R30,LOW(_baris)
	LDI  R31,HIGH(_baris)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,250
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_baris)
	LDI  R31,HIGH(_baris)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
; 0000 0089             delay_ms(1000);
	CALL SUBOPT_0x12
; 0000 008A             if(PINC.7==1)
	SBIS 0x13,7
	RJMP _0x34
; 0000 008B             {
; 0000 008C                 PORTD.2 = 1;
	SBI  0x12,2
; 0000 008D                 PORTD.3 = 0;
	CBI  0x12,3
; 0000 008E                 lcd_clear();
	CALL SUBOPT_0x13
; 0000 008F                 lcd_gotoxy(0,2);lcd_putsf("<<COUNTER CLOCK WISE");
	__POINTW1FN _0x0,265
	RJMP _0x5E
; 0000 0090             }
; 0000 0091             else if(PINC.6==1)
_0x34:
	SBIS 0x13,6
	RJMP _0x3A
; 0000 0092             {
; 0000 0093                 PORTD.2 = 0;
	CBI  0x12,2
; 0000 0094                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 0095                 lcd_clear();
	CALL SUBOPT_0x13
; 0000 0096                 lcd_gotoxy(0,2);lcd_putsf("CLOCK WISE >>");
	__POINTW1FN _0x0,286
_0x5E:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_putsf
; 0000 0097             }
; 0000 0098             delay_ms(500);
_0x3A:
	RJMP _0x5F
; 0000 0099             printf("%.2f", rpm);
; 0000 009A             printf("\r\n");
; 0000 009B             delay_ms(10);
; 0000 009C         }
; 0000 009D         else
_0x33:
; 0000 009E         {
; 0000 009F             /*-------- GUI -----*/
; 0000 00A0             lcd_gotoxy(0,0); lcd_putsf("=MODE CONTROL MOTOR=");
	CALL SUBOPT_0x0
	CALL SUBOPT_0x14
; 0000 00A1             lcd_gotoxy(0,1);lcd_putsf ("   >>>VIA GUI<<<   ");
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,308
	CALL SUBOPT_0xA
; 0000 00A2             delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x9
; 0000 00A3             data=getchar();
	CALL _getchar
	MOV  R4,R30
	CLR  R5
; 0000 00A4             if (data=='A')
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x40
; 0000 00A5             {
; 0000 00A6                 PORTD.2 = 0;
	CBI  0x12,2
; 0000 00A7                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 00A8                 lcd_clear();
	CALL SUBOPT_0x13
; 0000 00A9                 lcd_gotoxy(0,2);lcd_putsf(" CLOCK WISE =>>");
	__POINTW1FN _0x0,328
	CALL SUBOPT_0xA
; 0000 00AA                 putsf("MOTOR DC SUDAH CW ==>>\r");
	__POINTW1FN _0x0,344
	CALL SUBOPT_0x15
; 0000 00AB             }
; 0000 00AC             else if(data=='B')
	RJMP _0x45
_0x40:
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x46
; 0000 00AD             {
; 0000 00AE                 PORTD.2 = 1;
	SBI  0x12,2
; 0000 00AF                 PORTD.3 = 0;
	CBI  0x12,3
; 0000 00B0                 lcd_clear();
	CALL SUBOPT_0x13
; 0000 00B1                 lcd_gotoxy(0,2);lcd_putsf("<<COUNTER CLOCK WISE");
	__POINTW1FN _0x0,265
	CALL SUBOPT_0xA
; 0000 00B2                 putsf("<<== MOTOR DC SUDAH CCW\r");
	__POINTW1FN _0x0,368
	CALL SUBOPT_0x15
; 0000 00B3             }
; 0000 00B4             else if (data=='C')
	RJMP _0x4B
_0x46:
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x4C
; 0000 00B5             {
; 0000 00B6                 OCR2 = 20;
	LDI  R30,LOW(20)
	OUT  0x23,R30
; 0000 00B7                 lcd_gotoxy(0,3);lcd_putsf("=>KEC MOTOR LAMBAN");
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,393
	CALL SUBOPT_0xA
; 0000 00B8                 putsf("KECEPATAN MOTOR LAMBAT\r");
	__POINTW1FN _0x0,412
	CALL SUBOPT_0x15
; 0000 00B9             }
; 0000 00BA             else if (data=='D')
	RJMP _0x4D
_0x4C:
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x4E
; 0000 00BB             {
; 0000 00BC                 OCR2 = 80;
	LDI  R30,LOW(80)
	OUT  0x23,R30
; 0000 00BD                 lcd_gotoxy(0,3);lcd_putsf("=>KEC MOTOR SEDANG ");
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,436
	CALL SUBOPT_0xA
; 0000 00BE                 putsf("KECEPATAN MOTOR SEDANG\r");
	__POINTW1FN _0x0,456
	CALL SUBOPT_0x15
; 0000 00BF             }
; 0000 00C0             else if (data=='E')
	RJMP _0x4F
_0x4E:
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x50
; 0000 00C1             {
; 0000 00C2                 OCR2 = 150;
	LDI  R30,LOW(150)
	OUT  0x23,R30
; 0000 00C3                 lcd_gotoxy(0,3);lcd_putsf("=>KECE MOTOR CEPAT");
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,480
	CALL SUBOPT_0xA
; 0000 00C4                 putsf("KECEPATAN MOTOR CEPAT\r");
	__POINTW1FN _0x0,499
	CALL SUBOPT_0x15
; 0000 00C5             }
; 0000 00C6             else if(data=='F')
	RJMP _0x51
_0x50:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x52
; 0000 00C7             {
; 0000 00C8                PORTD.5=1;
	SBI  0x12,5
; 0000 00C9             }
; 0000 00CA             else if(data=='G')
	RJMP _0x55
_0x52:
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x56
; 0000 00CB             {
; 0000 00CC                PORTD.6=1;
	SBI  0x12,6
; 0000 00CD             }
; 0000 00CE             else if(data=='H')
	RJMP _0x59
_0x56:
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x5A
; 0000 00CF             {
; 0000 00D0                PORTA.3=1;
	SBI  0x1B,3
; 0000 00D1             }
; 0000 00D2             delay_ms(500);
_0x5A:
_0x59:
_0x55:
_0x51:
_0x4F:
_0x4D:
_0x4B:
_0x45:
_0x5F:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x9
; 0000 00D3             printf("%.2f", rpm);
	__POINTW1FN _0x0,300
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_rpm
	LDS  R31,_rpm+1
	LDS  R22,_rpm+2
	LDS  R23,_rpm+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 00D4             printf("\r\n");
	__POINTW1FN _0x0,305
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 00D5             delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x9
; 0000 00D6         }
; 0000 00D7       }
_0x32:
; 0000 00D8     }
	RJMP _0x24
; 0000 00D9 }
_0x5D:
	RJMP _0x5D

	.CSEG
_rtc_init:
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	CALL SUBOPT_0x16
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _i2c_write
	CALL _i2c_stop
	JMP  _0x2100006
_rtc_get_time:
	CALL SUBOPT_0x16
	LDI  R30,LOW(0)
	CALL SUBOPT_0x17
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x18
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RJMP _0x2100008
_rtc_get_date:
	CALL SUBOPT_0x16
	LDI  R30,LOW(4)
	CALL SUBOPT_0x17
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x18
	LD   R26,Y
	LDD  R27,Y+1
_0x2100008:
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x18,4
	RJMP _0x2020005
_0x2020004:
	CBI  0x18,4
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x18,5
	RJMP _0x2020007
_0x2020006:
	CBI  0x18,5
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x18,6
	RJMP _0x2020009
_0x2020008:
	CBI  0x18,6
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x18,7
	RJMP _0x202000B
_0x202000A:
	CBI  0x18,7
_0x202000B:
	__DELAY_USB 7
	SBI  0x18,2
	__DELAY_USB 18
	CBI  0x18,2
	__DELAY_USB 18
	JMP  _0x2100007
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 184
	JMP  _0x2100007
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x19
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x19
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	JMP  _0x2100007
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x18,0
	JMP  _0x2100007
_lcd_puts:
	ST   -Y,R17
_0x2020014:
	CALL SUBOPT_0x1A
	BREQ _0x2020016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	JMP  _0x2100006
_lcd_putsf:
	ST   -Y,R17
_0x2020017:
	CALL SUBOPT_0x1B
	BREQ _0x2020019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
	LDD  R17,Y+0
	JMP  _0x2100006
_lcd_init:
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	SBI  0x17,7
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 276
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
	JMP  _0x2100007
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2100007:
	ADIW R28,1
	RET
_puts:
	ST   -Y,R17
_0x2040003:
	CALL SUBOPT_0x1A
	BREQ _0x2040005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2040003
_0x2040005:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
	RJMP _0x2100006
_putsf:
	ST   -Y,R17
_0x2040006:
	CALL SUBOPT_0x1B
	BREQ _0x2040008
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2040006
_0x2040008:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
	RJMP _0x2100006
_put_usart_G102:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x1D
_0x2100006:
	ADIW R28,3
	RET
_put_buff_G102:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x1D
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x1D
_0x2040014:
_0x2040013:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G102:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2040019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2040000,0
	CALL SUBOPT_0x1E
	RJMP _0x2100005
_0x2040019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2040018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2040000,1
	CALL SUBOPT_0x1E
	RJMP _0x2100005
_0x2040018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x204001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x204001B:
	LDD  R17,Y+11
_0x204001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001E
	CALL SUBOPT_0x1F
	RJMP _0x204001C
_0x204001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x204001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x1F
	RJMP _0x2040020
_0x204001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x20
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x1F
_0x2040022:
	CALL SUBOPT_0x20
	BRLO _0x2040024
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	RJMP _0x2040022
_0x2040024:
	RJMP _0x2040025
_0x2040021:
_0x2040026:
	CALL SUBOPT_0x20
	BRSH _0x2040028
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	SUBI R19,LOW(1)
	RJMP _0x2040026
_0x2040028:
	CALL SUBOPT_0x1F
_0x2040025:
	__GETD1S 12
	CALL SUBOPT_0x25
	CALL SUBOPT_0x24
	CALL SUBOPT_0x20
	BRLO _0x2040029
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
_0x2040029:
_0x2040020:
	LDI  R17,LOW(0)
_0x204002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x204002C
	__GETD2S 4
	CALL SUBOPT_0x26
	CALL SUBOPT_0x25
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x21
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x21
	CALL SUBOPT_0x29
	CALL SUBOPT_0x24
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x204002A
	CALL SUBOPT_0x27
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x204002A
_0x204002C:
	CALL SUBOPT_0x2A
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x204002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x204010E
_0x204002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x204010E:
	ST   X,R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2A
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x2A
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G102:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x1D
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2040032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040036
	CPI  R18,37
	BRNE _0x2040037
	LDI  R17,LOW(1)
	RJMP _0x2040038
_0x2040037:
	CALL SUBOPT_0x2B
_0x2040038:
	RJMP _0x2040035
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040039
	CPI  R18,37
	BRNE _0x204003A
	CALL SUBOPT_0x2B
	RJMP _0x204010F
_0x204003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x204003B
	LDI  R16,LOW(1)
	RJMP _0x2040035
_0x204003B:
	CPI  R18,43
	BRNE _0x204003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003C:
	CPI  R18,32
	BRNE _0x204003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003D:
	RJMP _0x204003E
_0x2040039:
	CPI  R30,LOW(0x2)
	BRNE _0x204003F
_0x204003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040040
	ORI  R16,LOW(128)
	RJMP _0x2040035
_0x2040040:
	RJMP _0x2040041
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
_0x2040041:
	CPI  R18,48
	BRLO _0x2040044
	CPI  R18,58
	BRLO _0x2040045
_0x2040044:
	RJMP _0x2040043
_0x2040045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040035
_0x2040043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2040046
	LDI  R17,LOW(4)
	RJMP _0x2040035
_0x2040046:
	RJMP _0x2040047
_0x2040042:
	CPI  R30,LOW(0x4)
	BRNE _0x2040049
	CPI  R18,48
	BRLO _0x204004B
	CPI  R18,58
	BRLO _0x204004C
_0x204004B:
	RJMP _0x204004A
_0x204004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2040035
_0x204004A:
_0x2040047:
	CPI  R18,108
	BRNE _0x204004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2040035
_0x204004D:
	RJMP _0x204004E
_0x2040049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2040035
_0x204004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040053
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2C
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2E
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x45)
	BREQ _0x2040057
	CPI  R30,LOW(0x65)
	BRNE _0x2040058
_0x2040057:
	RJMP _0x2040059
_0x2040058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x204005A
_0x2040059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x2F
	CALL __GETD1P
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	LDD  R26,Y+13
	TST  R26
	BRMI _0x204005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x204005D
	RJMP _0x204005E
_0x204005B:
	CALL SUBOPT_0x32
	CALL __ANEGF1
	CALL SUBOPT_0x30
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x204005D:
	SBRS R16,7
	RJMP _0x204005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x2E
	RJMP _0x2040060
_0x204005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2040060:
_0x204005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2040062
	CALL SUBOPT_0x32
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2040063
_0x2040062:
	CALL SUBOPT_0x32
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G102
_0x2040063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x33
	RJMP _0x2040064
_0x204005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2040066
	CALL SUBOPT_0x31
	CALL SUBOPT_0x34
	CALL SUBOPT_0x33
	RJMP _0x2040067
_0x2040066:
	CPI  R30,LOW(0x70)
	BRNE _0x2040069
	CALL SUBOPT_0x31
	CALL SUBOPT_0x34
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x204006B
	CP   R20,R17
	BRLO _0x204006C
_0x204006B:
	RJMP _0x204006A
_0x204006C:
	MOV  R17,R20
_0x204006A:
_0x2040064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x204006D
_0x2040069:
	CPI  R30,LOW(0x64)
	BREQ _0x2040070
	CPI  R30,LOW(0x69)
	BRNE _0x2040071
_0x2040070:
	ORI  R16,LOW(4)
	RJMP _0x2040072
_0x2040071:
	CPI  R30,LOW(0x75)
	BRNE _0x2040073
_0x2040072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2040074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x35
	LDI  R17,LOW(10)
	RJMP _0x2040075
_0x2040074:
	__GETD1N 0x2710
	CALL SUBOPT_0x35
	LDI  R17,LOW(5)
	RJMP _0x2040075
_0x2040073:
	CPI  R30,LOW(0x58)
	BRNE _0x2040077
	ORI  R16,LOW(8)
	RJMP _0x2040078
_0x2040077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20400B6
_0x2040078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x204007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x35
	LDI  R17,LOW(8)
	RJMP _0x2040075
_0x204007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x35
	LDI  R17,LOW(4)
_0x2040075:
	CPI  R20,0
	BREQ _0x204007B
	ANDI R16,LOW(127)
	RJMP _0x204007C
_0x204007B:
	LDI  R20,LOW(1)
_0x204007C:
	SBRS R16,1
	RJMP _0x204007D
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2F
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2040110
_0x204007D:
	SBRS R16,2
	RJMP _0x204007F
	CALL SUBOPT_0x31
	CALL SUBOPT_0x34
	CALL __CWD1
	RJMP _0x2040110
_0x204007F:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x34
	CLR  R22
	CLR  R23
_0x2040110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2040081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2040082
	CALL SUBOPT_0x32
	CALL __ANEGD1
	CALL SUBOPT_0x30
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2040082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2040083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2040084
_0x2040083:
	ANDI R16,LOW(251)
_0x2040084:
_0x2040081:
	MOV  R19,R20
_0x204006D:
	SBRC R16,0
	RJMP _0x2040085
_0x2040086:
	CP   R17,R21
	BRSH _0x2040089
	CP   R19,R21
	BRLO _0x204008A
_0x2040089:
	RJMP _0x2040088
_0x204008A:
	SBRS R16,7
	RJMP _0x204008B
	SBRS R16,2
	RJMP _0x204008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x204008D
_0x204008C:
	LDI  R18,LOW(48)
_0x204008D:
	RJMP _0x204008E
_0x204008B:
	LDI  R18,LOW(32)
_0x204008E:
	CALL SUBOPT_0x2B
	SUBI R21,LOW(1)
	RJMP _0x2040086
_0x2040088:
_0x2040085:
_0x204008F:
	CP   R17,R20
	BRSH _0x2040091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040092
	CALL SUBOPT_0x36
	BREQ _0x2040093
	SUBI R21,LOW(1)
_0x2040093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x2E
	CPI  R21,0
	BREQ _0x2040094
	SUBI R21,LOW(1)
_0x2040094:
	SUBI R20,LOW(1)
	RJMP _0x204008F
_0x2040091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2040095
_0x2040096:
	CPI  R19,0
	BREQ _0x2040098
	SBRS R16,3
	RJMP _0x2040099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x204009A
_0x2040099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x204009A:
	CALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x204009B
	SUBI R21,LOW(1)
_0x204009B:
	SUBI R19,LOW(1)
	RJMP _0x2040096
_0x2040098:
	RJMP _0x204009C
_0x2040095:
_0x204009E:
	CALL SUBOPT_0x37
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20400A0
	SBRS R16,3
	RJMP _0x20400A1
	SUBI R18,-LOW(55)
	RJMP _0x20400A2
_0x20400A1:
	SUBI R18,-LOW(87)
_0x20400A2:
	RJMP _0x20400A3
_0x20400A0:
	SUBI R18,-LOW(48)
_0x20400A3:
	SBRC R16,4
	RJMP _0x20400A5
	CPI  R18,49
	BRSH _0x20400A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20400A6
_0x20400A7:
	RJMP _0x20400A9
_0x20400A6:
	CP   R20,R19
	BRSH _0x2040111
	CP   R21,R19
	BRLO _0x20400AC
	SBRS R16,0
	RJMP _0x20400AD
_0x20400AC:
	RJMP _0x20400AB
_0x20400AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20400AE
_0x2040111:
	LDI  R18,LOW(48)
_0x20400A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20400AF
	CALL SUBOPT_0x36
	BREQ _0x20400B0
	SUBI R21,LOW(1)
_0x20400B0:
_0x20400AF:
_0x20400AE:
_0x20400A5:
	CALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x20400B1
	SUBI R21,LOW(1)
_0x20400B1:
_0x20400AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x37
	CALL __MODD21U
	CALL SUBOPT_0x30
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x35
	__GETD1S 16
	CALL __CPD10
	BREQ _0x204009F
	RJMP _0x204009E
_0x204009F:
_0x204009C:
	SBRS R16,0
	RJMP _0x20400B2
_0x20400B3:
	CPI  R21,0
	BREQ _0x20400B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2E
	RJMP _0x20400B3
_0x20400B5:
_0x20400B2:
_0x20400B6:
_0x2040054:
_0x204010F:
	LDI  R17,LOW(0)
_0x2040035:
	RJMP _0x2040030
_0x2040032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x38
	SBIW R30,0
	BRNE _0x20400B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2100004
_0x20400B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x38
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x39
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2100004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x39
	LDI  R30,LOW(_put_usart_G102)
	LDI  R31,HIGH(_put_usart_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G102
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret

	.CSEG

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x3A
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x3A
	RJMP _0x2100003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x3A
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x2100003:
	ADIW R28,4
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20E000D
	RCALL SUBOPT_0x3B
	__POINTW1FN _0x20E0000,0
	RCALL SUBOPT_0x1E
	RJMP _0x2100002
_0x20E000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20E000C
	RCALL SUBOPT_0x3B
	__POINTW1FN _0x20E0000,1
	RCALL SUBOPT_0x1E
	RJMP _0x2100002
_0x20E000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20E000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(45)
	ST   X,R30
_0x20E000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20E0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20E0010:
	LDD  R17,Y+8
_0x20E0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20E0013
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x3F
	RJMP _0x20E0011
_0x20E0013:
	RCALL SUBOPT_0x40
	CALL __ADDF12
	RCALL SUBOPT_0x3C
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x3F
_0x20E0014:
	RCALL SUBOPT_0x40
	CALL __CMPF12
	BRLO _0x20E0016
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x3F
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20E0017
	RCALL SUBOPT_0x3B
	__POINTW1FN _0x20E0000,5
	RCALL SUBOPT_0x1E
	RJMP _0x2100002
_0x20E0017:
	RJMP _0x20E0014
_0x20E0016:
	CPI  R17,0
	BRNE _0x20E0018
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20E0019
_0x20E0018:
_0x20E001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20E001C
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x25
	CALL __PUTPARD1
	CALL _floor
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x28
	LDI  R31,0
	RCALL SUBOPT_0x3E
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x3C
	RJMP _0x20E001A
_0x20E001C:
_0x20E0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2100001
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(46)
	ST   X,R30
_0x20E001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20E0020
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x3C
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x28
	LDI  R31,0
	RCALL SUBOPT_0x41
	CALL __CWD1
	CALL __CDF1
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x3C
	RJMP _0x20E001E
_0x20E0020:
_0x2100001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.DSEG
_temp:
	.BYTE 0x21
_time:
	.BYTE 0x21
_baris:
	.BYTE 0x10
_yy:
	.BYTE 0x1
_kol:
	.BYTE 0x1
_rpm:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G107:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDS  R30,_kol
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__POINTW1FN _0x0,38
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDS  R30,_kol
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__POINTW1FN _0x0,49
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R10
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R13
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R12
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_yy
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(_time)
	LDI  R31,HIGH(_time)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL _puts
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x11:
	__POINTW1FN _0x0,172
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R10
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,210
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	CALL _i2c_write
	CALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x18:
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G101
	__DELAY_USW 276
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1F:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x20:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2B:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2C:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2D:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2F:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x2C
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x34:
	RCALL SUBOPT_0x2F
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x36:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x40:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	__GETD2S 9
	RET


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,18
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,37
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
