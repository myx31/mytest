
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x9

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _number
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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
;#include <mega16a.h>
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
;#include <io.h>
;#include <delay.h>
;#include <stdio.h>
;// dinh nghia chan
;#define thuan PINC.0
;#define nguoc PINC.1
;#define tang PINC.2
;#define giam PINC.3
;#define dung PINC.4
;
;#define IN1 PORTD.0
;#define IN2 PORTD.1
;#define IN3 PORTD.2
;#define IN4 PORTD.3
;// dinh nghia hang so PID
;#define kp 300
;#define ki 100
;
;unsigned char number[10] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09};

	.DSEG
;
;
;void tangtoc(void);
;void giamtoc(void);
;void chaythuan(void);
;void chaynguoc(void);
;void dunglai(void);
;void dieukhien(void);
;
;// Declare your global variables here
;
;long int n=0; // bien nay dem so lan ngoai vi dc kich hoat , tinh toan toc do dc
;long int delta_v,toc_do,setpoint;// sai so toc do hien tai vs setpoint
;long int sum_e=0; // so lg tich luy cua sai so, (PID)
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void) // ngat nay dc kich hoat boi
; 0000 0026 //mot ngat ngoai vi tren INT 0
; 0000 0027 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0028     n++;// bien n tang len moi lan ngat say ra
	LDI  R26,LOW(_n)
	LDI  R27,HIGH(_n)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0029 } //  dem so xung tao ra boi ngoai vi
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)  // xu ly tran TImer0
; 0000 002C {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002D // Place your code here
; 0000 002E    // tinh toc do
; 0000 002F     toc_do = 75*n; //toc do = (n/8*N)*1000*60
	LDS  R30,_n
	LDS  R31,_n+1
	LDS  R22,_n+2
	LDS  R23,_n+3
	__GETD2N 0x4B
	CALL __MULD12
	CALL SUBOPT_0x0
; 0000 0030     sum_e += delta_v;  // tp tich phan
	CALL SUBOPT_0x1
	LDS  R26,_sum_e
	LDS  R27,_sum_e+1
	LDS  R24,_sum_e+2
	LDS  R25,_sum_e+3
	CALL __ADDD12
	STS  _sum_e,R30
	STS  _sum_e+1,R31
	STS  _sum_e+2,R22
	STS  _sum_e+3,R23
; 0000 0031    //reset n
; 0000 0032    n=0;
	LDI  R30,LOW(0)
	STS  _n,R30
	STS  _n+1,R30
	STS  _n+2,R30
	STS  _n+3,R30
; 0000 0033 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void hiemthi(unsigned int x)
; 0000 0036 {
_hiemthi:
; .FSTART _hiemthi
; 0000 0037      unsigned int temp;
; 0000 0038      //unsigned char a,b,c,d;
; 0000 0039      unsigned char m[4],i ;
; 0000 003A 
; 0000 003B   // tach so, luu vao 4 bien a b c d
; 0000 003C      temp=x;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
;	x -> Y+8
;	temp -> R16,R17
;	m -> Y+4
;	i -> R19
	__GETWRS 16,17,8
; 0000 003D      for(i=0;i<4;i++)
	LDI  R19,LOW(0)
_0x5:
	CPI  R19,4
	BRSH _0x6
; 0000 003E      {
; 0000 003F      m[3-i]=temp % 10;
	MOV  R30,R19
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOVW R26,R22
	ST   X,R30
; 0000 0040      temp =temp/10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R16,R30
; 0000 0041      }
	SUBI R19,-1
	RJMP _0x5
_0x6:
; 0000 0042 
; 0000 0043      // dieu khien cho LED1 sang, hiem thi chu so a
; 0000 0044      PORTA.0 =0;
	CBI  0x1B,0
; 0000 0045      PORTB = number[m[0]];
	LDD  R30,Y+4
	CALL SUBOPT_0x2
; 0000 0046      delay_ms(1);
; 0000 0047      PORTA.0 =1;
	SBI  0x1B,0
; 0000 0048      // dieu khien cho LED2 sang, hiem thi chu so b
; 0000 0049      PORTA.1 =0;
	CBI  0x1B,1
; 0000 004A      PORTB = number[m[1]];
	LDD  R30,Y+5
	CALL SUBOPT_0x2
; 0000 004B      delay_ms(1);
; 0000 004C      PORTA.1 =1;
	SBI  0x1B,1
; 0000 004D      // dieu khien cho LED3 sang, hiem thi chu so c
; 0000 004E      PORTA.2 =0;
	CBI  0x1B,2
; 0000 004F      PORTB = number[m[2]];
	LDD  R30,Y+6
	CALL SUBOPT_0x2
; 0000 0050      delay_ms(1);
; 0000 0051      PORTA.2 =1;
	SBI  0x1B,2
; 0000 0052      // dieu khien cho LED4 sang, hiem thi chu so d
; 0000 0053      PORTA.3 =0;
	CBI  0x1B,3
; 0000 0054      PORTB = number[m[3]];
	LDD  R30,Y+7
	CALL SUBOPT_0x2
; 0000 0055      delay_ms(1);
; 0000 0056      PORTA.3 =1;
	SBI  0x1B,3
; 0000 0057 
; 0000 0058 }
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; .FEND
;
;void main(void)
; 0000 005B {
_main:
; .FSTART _main
; 0000 005C //Cong D
; 0000 005D DDRD=0xff;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 005E PORTD.5=0;
	CBI  0x12,5
; 0000 005F 
; 0000 0060 //cau hinh timer
; 0000 0061 
; 0000 0062 // Timer/Counter 1 initialization
; 0000 0063 // Clock source: System Clock
; 0000 0064 // Clock value: 8000.000 kHz
; 0000 0065 // Mode: Fast PWM top=0x03FF
; 0000 0066 // OC1A output: Non-Inverted PWM
; 0000 0067 // OC1B output: Inverted PWM
; 0000 0068 // Noise Canceler: Off
; 0000 0069 // Input Capture on Falling Edge
; 0000 006A // Timer Period: 0.128 ms
; 0000 006B // Output Pulse(s):
; 0000 006C // OC1A Period: 0.128 ms Width: 0 us
; 0000 006D // OC1B Period: 0.128 ms Width: 0.128 ms
; 0000 006E // Timer1 Overflow Interrupt: Off
; 0000 006F // Input Capture Interrupt: Off
; 0000 0070 // Compare A Match Interrupt: Off
; 0000 0071 // Compare B Match Interrupt: Off
; 0000 0072 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (1<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(179)
	OUT  0x2F,R30
; 0000 0073 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 0074 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0075 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0076 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0077 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0078 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0079 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 007A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 007B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 007C 
; 0000 007D // TIMER0 init
; 0000 007E TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 007F TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0080 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0081 
; 0000 0082 // Timer(s)/Counter(s) Interrupt(s) initialization // thanh ghi mat na ngat bo dem Tg
; 0000 0083 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0084 
; 0000 0085 // External Interrupt(s) initialization
; 0000 0086 // INT0: On
; 0000 0087 // INT0 Mode: Falling Edge
; 0000 0088 // INT1: Off
; 0000 0089 // INT2: Off
; 0000 008A GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2); // dk ngat chung
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 008B MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);//  ko su dung TH nay
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 008C MCUCSR=(0<<ISC2);//dk co chung ( xoa co)
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 008D GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 008E 
; 0000 008F // cong
; 0000 0090 PORTC =0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0091 DDRB = 0xFF;
	OUT  0x17,R30
; 0000 0092 DDRA=0xFF;
	OUT  0x1A,R30
; 0000 0093 
; 0000 0094 while (1)
_0x19:
; 0000 0095 {
; 0000 0096       hiemthi(toc_do);
	CALL SUBOPT_0x3
; 0000 0097       dieukhien();
	RCALL _dieukhien
; 0000 0098       if(dung == 0)
	SBIS 0x13,4
; 0000 0099       {
; 0000 009A         dunglai();
	RCALL _dunglai
; 0000 009B       }
; 0000 009C }
	RJMP _0x19
; 0000 009D }
_0x1D:
	RJMP _0x1D
; .FEND
;void tangtoc(void)
; 0000 009F {
_tangtoc:
; .FSTART _tangtoc
; 0000 00A0 
; 0000 00A1       toc_do = toc_do + 1;
	CALL SUBOPT_0x4
	__ADDD1N 1
	CALL SUBOPT_0x5
; 0000 00A2       if (toc_do>10) { toc_do=10;}
	__CPD2N 0xB
	BRLT _0x1E
	__GETD1N 0xA
	CALL SUBOPT_0x0
; 0000 00A3       hiemthi(toc_do);
_0x1E:
	RJMP _0x2060001
; 0000 00A4 }
; .FEND
;void giamtoc(void)
; 0000 00A6 {
_giamtoc:
; .FSTART _giamtoc
; 0000 00A7 
; 0000 00A8       toc_do = toc_do - 1;
	CALL SUBOPT_0x4
	__SUBD1N 1
	CALL SUBOPT_0x5
; 0000 00A9       if (toc_do<1) {toc_do=1;}
	__CPD2N 0x1
	BRGE _0x1F
	__GETD1N 0x1
	CALL SUBOPT_0x0
; 0000 00AA       hiemthi(toc_do);
_0x1F:
_0x2060001:
	LDS  R26,_toc_do
	LDS  R27,_toc_do+1
	RCALL _hiemthi
; 0000 00AB }
	RET
; .FEND
;
;void chaythuan(void)
; 0000 00AE {
_chaythuan:
; .FSTART _chaythuan
; 0000 00AF 
; 0000 00B0    while (dung!=0)
_0x20:
	SBIS 0x13,4
	RJMP _0x22
; 0000 00B1    {
; 0000 00B2     hiemthi(toc_do);
	CALL SUBOPT_0x3
; 0000 00B3     IN1 = 0;
	CBI  0x12,0
; 0000 00B4     IN2 = 1;
	SBI  0x12,1
; 0000 00B5     setpoint=50;
	__GETD1N 0x32
	CALL SUBOPT_0x6
; 0000 00B6     PORTD.5=1;
; 0000 00B7     delay_ms(50);
; 0000 00B8 
; 0000 00B9     //TinhtoanPWM
; 0000 00BA       delta_v = setpoint - toc_do;
; 0000 00BB       if(delta_v<0)
	BRPL _0x29
; 0000 00BC       {
; 0000 00BD         OCR1A=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4C
; 0000 00BE       }
; 0000 00BF       else
_0x29:
; 0000 00C0       {
; 0000 00C1         if((kp*delta_v+ki*sum_e)>0x3ff) OCR1A = 0x3ff;
	CALL SUBOPT_0x7
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x9
	BRLT _0x2B
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	RJMP _0x4C
; 0000 00C2         else OCR1A = kp*delta_v+ki*sum_e;
_0x2B:
	CALL SUBOPT_0xA
_0x4C:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00C3       }
; 0000 00C4    }
	RJMP _0x20
_0x22:
; 0000 00C5 
; 0000 00C6 
; 0000 00C7 }
	RET
; .FEND
;
;void chaynguoc(void)
; 0000 00CA {
_chaynguoc:
; .FSTART _chaynguoc
; 0000 00CB 
; 0000 00CC    while (dung!=0)
_0x2D:
	SBIS 0x13,4
	RJMP _0x2F
; 0000 00CD    {
; 0000 00CE     hiemthi(toc_do);
	CALL SUBOPT_0x3
; 0000 00CF     IN1 = 1;
	SBI  0x12,0
; 0000 00D0     IN2 = 0;
	CBI  0x12,1
; 0000 00D1     setpoint=5;
	__GETD1N 0x5
	CALL SUBOPT_0x6
; 0000 00D2     PORTD.5=1;
; 0000 00D3     delay_ms(50);
; 0000 00D4 
; 0000 00D5     //TinhtoanPWM
; 0000 00D6       delta_v = setpoint - toc_do;// hieu so chenh lech
; 0000 00D7       if(delta_v<0)
	BRPL _0x36
; 0000 00D8       {
; 0000 00D9         OCR1A=0; // neu am chu ky nhiem =0
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4D
; 0000 00DA       }
; 0000 00DB       else
_0x36:
; 0000 00DC       {  //neu ko am tinh PWM moi dua tren cong thuc kiem soat PID
; 0000 00DD         if((kp*delta_v+ki*sum_e)>0x3ff) OCR1A = 0x3ff; // neu gia tri vuot 0x3FF dat ve toi da
	CALL SUBOPT_0x7
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x9
	BRLT _0x38
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	RJMP _0x4D
; 0000 00DE         else OCR1A = kp*delta_v+ki*sum_e;// dat gia tri PWM dua tren cong thuc kiem soat Pwm
_0x38:
	CALL SUBOPT_0xA
_0x4D:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00DF       }
; 0000 00E0    }
	RJMP _0x2D
_0x2F:
; 0000 00E1 
; 0000 00E2 
; 0000 00E3 }
	RET
; .FEND
;void dunglai(void)
; 0000 00E5 {
_dunglai:
; .FSTART _dunglai
; 0000 00E6     hiemthi(0000);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _hiemthi
; 0000 00E7     IN1 = 0;
	CBI  0x12,0
; 0000 00E8     IN2 = 0;
	CBI  0x12,1
; 0000 00E9 
; 0000 00EA }
	RET
; .FEND
;
;void dieukhien(void)
; 0000 00ED {
_dieukhien:
; .FSTART _dieukhien
; 0000 00EE   if (thuan==0)
	SBIS 0x13,0
; 0000 00EF   {
; 0000 00F0    {
; 0000 00F1    chaythuan();
	RCALL _chaythuan
; 0000 00F2    }
; 0000 00F3   }
; 0000 00F4   if (nguoc==0)
	SBIS 0x13,1
; 0000 00F5   {
; 0000 00F6      chaynguoc();
	RCALL _chaynguoc
; 0000 00F7    }
; 0000 00F8    if (tang==0)
	SBIC 0x13,2
	RJMP _0x40
; 0000 00F9    {
; 0000 00FA     while (tang==0);
_0x41:
	SBIS 0x13,2
	RJMP _0x41
; 0000 00FB     tangtoc();
	RCALL _tangtoc
; 0000 00FC     if (thuan==0)
	SBIS 0x13,0
; 0000 00FD     {
; 0000 00FE     chaythuan();
	RCALL _chaythuan
; 0000 00FF     }
; 0000 0100     if (nguoc==0)
	SBIS 0x13,1
; 0000 0101     {
; 0000 0102     chaynguoc();
	RCALL _chaynguoc
; 0000 0103     }
; 0000 0104    }
; 0000 0105    if (giam==0)
_0x40:
	SBIC 0x13,3
	RJMP _0x46
; 0000 0106    {
; 0000 0107     while (giam==0);
_0x47:
	SBIS 0x13,3
	RJMP _0x47
; 0000 0108     giamtoc();
	RCALL _giamtoc
; 0000 0109     if (thuan==0)
	SBIS 0x13,0
; 0000 010A     {
; 0000 010B     chaythuan();
	RCALL _chaythuan
; 0000 010C     }
; 0000 010D     if (nguoc==0)
	SBIS 0x13,1
; 0000 010E     {
; 0000 010F     chaynguoc();
	RCALL _chaynguoc
; 0000 0110     }
; 0000 0111    }
; 0000 0112 
; 0000 0113 }
_0x46:
	RET
; .FEND
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

	.CSEG

	.CSEG

	.DSEG
_number:
	.BYTE 0xA
_n:
	.BYTE 0x4
_delta_v:
	.BYTE 0x4
_toc_do:
	.BYTE 0x4
_setpoint:
	.BYTE 0x4
_sum_e:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x0:
	STS  _toc_do,R30
	STS  _toc_do+1,R31
	STS  _toc_do+2,R22
	STS  _toc_do+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDS  R30,_delta_v
	LDS  R31,_delta_v+1
	LDS  R22,_delta_v+2
	LDS  R23,_delta_v+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2:
	LDI  R31,0
	SUBI R30,LOW(-_number)
	SBCI R31,HIGH(-_number)
	LD   R30,Z
	OUT  0x18,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDS  R26,_toc_do
	LDS  R27,_toc_do+1
	JMP  _hiemthi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R30,_toc_do
	LDS  R31,_toc_do+1
	LDS  R22,_toc_do+2
	LDS  R23,_toc_do+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	RCALL SUBOPT_0x0
	LDS  R26,_toc_do
	LDS  R27,_toc_do+1
	LDS  R24,_toc_do+2
	LDS  R25,_toc_do+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x6:
	STS  _setpoint,R30
	STS  _setpoint+1,R31
	STS  _setpoint+2,R22
	STS  _setpoint+3,R23
	SBI  0x12,5
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
	LDS  R26,_toc_do
	LDS  R27,_toc_do+1
	LDS  R24,_toc_do+2
	LDS  R25,_toc_do+3
	LDS  R30,_setpoint
	LDS  R31,_setpoint+1
	LDS  R22,_setpoint+2
	LDS  R23,_setpoint+3
	CALL __SUBD12
	STS  _delta_v,R30
	STS  _delta_v+1,R31
	STS  _delta_v+2,R22
	STS  _delta_v+3,R23
	LDS  R26,_delta_v+3
	TST  R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x1
	__GETD2N 0x12C
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDS  R30,_sum_e
	LDS  R31,_sum_e+1
	LDS  R22,_sum_e+2
	LDS  R23,_sum_e+3
	__GETD2N 0x64
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	CALL __ADDD21
	__CPD2N 0x400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xA:
	LDS  R30,_delta_v
	LDS  R31,_delta_v+1
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL __MULW12
	MOVW R22,R30
	LDS  R30,_sum_e
	LDS  R31,_sum_e+1
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
