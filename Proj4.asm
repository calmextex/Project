TITLE Project4   (Proj4.asm)

; Author: Abraham Zamora
; Last Modified: 2/25/2023
; OSU email address: zamoraab@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project Number 4               Due Date: 2/26/2023
; Description: 

INCLUDE Irvine32.inc


MAX_PRIME = 200
MIN_PRIME = 1


.data

; String variables

greeting	BYTE	"PRIME NUMBERS PROGRAMMED by Abraham", 0
intro		BYTE	"Enter the number offset prime numbers you would like to see.",0
introTwo	BYTE	"I'll accept orders up to 200 primes", 0

instruct	BYTE	"Enter the number offset primes to display [1 ... 200]: ", 0
error		BYTE	"No primes for you! Number out of range. Try again.", 0

outro		BYTE	"Results certified byte Abraham. Goodbye!", 0

; program variables



.code
main PROC

call introduction

call getUserData

call showPrimes

call farewell

main ENDP

;---------------------------------
; Procedure that introduces user to the program.
;
;---------------------------------

introduction PROC

	mov		EDX, OFFSET greeting	
	call	WriteString
	CALL	CrLf
	CALL	CrLf

	mov		edx, OFFSET intro
	CALL	WriteString
	call	CrLf

	mov		EDX, OFFSET introTwo
	call	WriteString
	call	CrLf
	call	CrLf


introduction ENDP

; Get User data

getUserData PROC

getUserData endp

; Show Primes numbers

showPrimes PROC

showPrimes ENDP

;--------------------------
; Procedure that provides a farewell
;	to the user
;
;--------------------------

farewell PROC
	mov		EDX, OFFSET outro
	call	WriteString
	call	CrLf

farewell ENDP



END main
