;*******************************************************************************
;@file				 hanoi.s
;@project		     Microprocessor Systems Homework 2 Question 2
;@date
;
;@Student Name: Ahmet Fatih Akcan
;@Student Number: 150210707
;*******************************************************************************
;*******************************************************************************
;@section 		INPUT_PARAMETERS
;*******************************************************************************
DISC_NUMBER EQU 3
START   	EQU  'A'
TARGET  	EQU  'C'
TEMP    	EQU  'B'

;*******************************************************************************
;@endsection 	INPUT_PARAMETERS
;*******************************************************************************

;*******************************************************************************
;@section 		OUTPUT_MEMORY_DECLARATION
;*******************************************************************************
		AREA result_data, DATA, READWRITE
result 		SPACE 	1000
end_result	
;*******************************************************************************
;@endsection 		OUTPUT_MEMORY_DECLARATION
;*******************************************************************************


;*******************************************************************************
;@section 		MAIN_FUNCTION
;*******************************************************************************
	AREA hanoi, CODE, READONLY
		ENTRY
		THUMB
		ALIGN 
__main	FUNCTION
		EXPORT __main	
		LDR R0, =result
		MOVS R1, #DISC_NUMBER
		MOVS R2, #START
		MOVS R3, #TARGET
		MOVS R4, #TEMP
		MOVS R5, #0 ; pointer for the records array
		BL   HANOI
		LDR R0, =result
STOP    B    STOP
		ENDFUNC
;*******************************************************************************
;@endsection 		MAIN_FUNCTION
;*******************************************************************************		
	
;*******************************************************************************
;@section 		HANOI_FUNCTION
;*******************************************************************************
HANOI   FUNCTION
;//-------- <<< USER CODE BEGIN Hanoi_Function >>> ----------------------															
		PUSH{LR};first push LR
		POP{R6};after pop R6, so R6=LR now
		CMP R1, #1 ; compare if r1==1
		BEQ RET;if equal go to RET subroutine
		PUSH{R6,R1,R2,R3,R4}; save current status to the stack before calling the next recursive function 
		B SWAP_1; swap 'temp' and 'to' (as a preprocessing to call Hanoi(from, temp, to, disc_number-1))
CONT_S1	SUBS R1, R1, #1; disc_number--
		BL HANOI ; Hanoi(from, temp, to, disc_number-1)
		POP{R6,R1,R2,R3,R4} ; save current status to the stack before calling the next recursive function 
		B RECORD ; save the step record 
CONT_M	PUSH{R6,R1,R2,R3,R4};save current status to the stack before calling the next recursive function
		B SWAP_2 ;swap 'temp' and 'from' (as a preprocessing to call Hanoi(temp, to, from, disc_number-1))
CONT_S2	SUBS R1, R1, #1
		BL HANOI ;Hanoi(temp, to, from, disc_number-1)
		POP{R6,R1,R2,R3,R4};save current status to the stack before calling the next recursive function
		BX R6; return
		
;*****************************subroutines*****************************

;*************save the step record*************
RECORD 	STR R1, [R0, R5] ; records[i]=disc number
		ADDS R5, R5, #4 ; i++
		STR R2, [R0, R5] ; records[i]=from
		ADDS R5, R5, #4 ; i++
		STR R3, [R0, R5];records[i]=to
		ADDS R5, R5, #4 ; i++
		B CONT_M ;continue
;**********************************************

;*************swap 'temp' and 'to'*************
SWAP_1	EORS R3, R3, R4 ;r3 = r3 xor r4
		EORS R4, R3, R4 ;r4 = r3 xor r4
		EORS R3, R3, R4 ;r3 = r3 xor r4 ; now r3_new=r4_old and r4_new = r3_old
		B CONT_S1 ; continue
;**********************************************

;************swap 'temp' and 'from'************
SWAP_2 	EORS R2, R2, R4 ;r2 = r2 xor r4
		EORS R4, R2, R4 ;r4 = r2 xor r4
		EORS R2, R2, R4 ;r2 = r2 xor r4 ; now r2_new=r4_old and r4_new = r2_old
		B CONT_S2 ; continue
;**********************************************

;********save the step record and return********
RET		STR R1, [R0, R5] ; records[i]=disc number	
		ADDS R5, R5, #4 ; i++
		STR R2, [R0, R5] ; records[i]=from
		ADDS R5, R5, #4; i++
		STR R3, [R0, R5] ;records[i]=to
		ADDS R5, R5, #4;i++
		BX R6 ;return
;***********************************************		
		
;//-------- <<< USER CODE END Hanoi_Function >>> ------------------------		
		ALIGN
		ENDFUNC
		END
			
;*******************************************************************************
;@endsection 		HANOI_FUNCTION
;*******************************************************************************