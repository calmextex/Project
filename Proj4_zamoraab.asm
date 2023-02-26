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
MAX_COLUMN = 15


.data

; String variables

greeting	BYTE	"PRIME NUMBERS PROGRAMMED by Abraham", 0
intro		BYTE	"Enter the number offset prime numbers you would like to see.",0
introTwo	BYTE	"I'll accept orders up to 200 primes", 0

instruct	BYTE	"Enter the number offset primes to display [1 ... 200]: ", 0
error		BYTE	"No primes for you! Number out of range. Try again.", 0

outro		BYTE	"Results certified byte Abraham. Goodbye!", 0
strSpace	BYTE	"	", 0	; adds three spaces to prime numbers for readability

; program variables

userPrimes	DWORD	?	; users input for total number of primes
startNumber	DWORD	2	; since 1 is not a prime number, we start at 2 and increase until total number of primes is satisfied
compNumber	DWORD	2	; for every number, we start by dividing by 2 and increase
colCounter	DWORD	0	; counter for number of columns




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
	ret


introduction ENDP

;--------------------------
; getUserData procedure collects the number of prime numbers
;	the user wants to consider.  The procedure checks to see
;	if the number is within the min and max prime constants.
;	If not within the min and max, the user will be given an
;	error and asked to try again.
;
;--------------------------

getUserData PROC

_validate:

	mov		EDX, OFFSET instruct
	call	WriteString
	call	ReadDec
	mov		userPrimes, EAX
	cmp		userPrimes, MAX_PRIME
	jg		_wrongNumber
	cmp		userPrimes, MIN_PRIME
	jl		_wrongNumber
	ret



_wrongNumber:

	mov		EDX, OFFSET error
	call	WriteString
	CALL	CrLf
	jmp		_validate

getUserData endp

; Show Primes numbers

showPrimes PROC
	mov		EAX, startNumber
	mov		EBX, compNumber
	mov		ECX, userPrimes

_primeLoop:
	cmp		EAX, EBX
	JE		_isPrime
	CDQ
	div		EBX
	cmp		EDX, 0
	JE		_notPrime
	inc		EBX
	mov		EAX, startNumber
	jmp		_primeLoop

_notPrime:
	inc		startNumber	
	mov		EAX, startNumber
	mov		EBX, compNumber
	jmp		_primeLoop




_isPrime:

	CALL	WriteDec
	mov		EDX, OFFSET	strSpace
	call	WriteString
	inc		colCounter
	mov		EBX, colCounter
	cmp		EBX, MAX_COLUMN
	JE		_newRow
	jmp		_resetStatus

_resetStatus:


	inc		startNumber
	mov		EAX, startNumber
	mov		compNumber, 2
	mov		EBX, compNumber
	LOOP	_primeLoop
	ret

_newRow:
	call	CrLf
	mov		colCounter, 0
	jmp		_resetStatus





	

	

showPrimes ENDP

;--------------------------
; Procedure that provides a farewell
;	to the user
;
;--------------------------

farewell PROC
	call CrLf
	mov		EDX, OFFSET outro
	call	WriteString
	call	CrLf
	ret

farewell ENDP



END main
