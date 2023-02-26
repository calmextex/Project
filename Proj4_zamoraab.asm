TITLE Project4_zamoraab   (Proj4_zamoraab.asm)

; Author: Abraham Zamora
; Last Modified: 2/26/2023
; OSU email address: zamoraab@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project Number 4               Due Date: 2/26/2023
; Description: Program asks a user to pick how many prime numbers they wish to be
;	displayed on the screen, starting from 1 until 4000 (see extra credit note).
;	Program will loop all numbers starting at 2 until total number of primes that user wishes to see
;	is displayed on the screen.
; ** EC: DESCRIPTION - Program aligns the output columns so that the first digit of each number matches the row above
; ** EC: DESCRIPTION - Program extends the range of primes to display up to 4000

INCLUDE Irvine32.inc


MAX_PRIME = 4000	; set to 4000 for EC Part 2
MIN_PRIME = 1
MAX_COLUMN = 15		; set to get 15 columns per row
MAX_ROW = 20		; 20 rows max before the waitmsg appears for EC Part 2


.data

; String variables

greeting	BYTE	"PRIME NUMBERS PROGRAMMED by Abraham", 0
intro		BYTE	"Enter the number offset prime numbers you would like to see.",0
introTwo	BYTE	"I'll accept orders up to 4000 primes", 0

instruct	BYTE	"Enter the number offset primes to display [1 ... 4000]: ", 0
error		BYTE	"No primes for you! Number out of range. Try again.", 0

outro		BYTE	"Results certified byte Abraham. Goodbye!", 0
strSpace	BYTE	"	", 0	; adds a tab to after a prime number is printed to enhance readability and to align the columns for EC Part 1

; program variables

userPrimes	DWORD	?	; users input for total number of primes
startNumber	DWORD	2	; since 1 is not a prime number, we start at 2 and increase until total number of primes is satisfied
compNumber	DWORD	2	; for every number, we start by dividing by 2 and increase
colCounter	DWORD	0	; counter for number of columns
rowCounter	DWORD	0	; counter for number of rows


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

; reads user input and compares to see if the number is within the parameters of the program before returning

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


; if number is either below 1 or above 4000 (for EC part 2), then user gets notified of the error and is asked to try again
_wrongNumber:

	mov		EDX, OFFSET error
	call	WriteString
	CALL	CrLf
	jmp		_validate

getUserData endp

;------------------------------------------
; showPrimes procedure will enter a loop to check if a number is prime.
;	startNumber starts at 2, and will continue to increase until a total number of primes "n"
;	set by the user is printed to the screen. startNumber will be divided by all number k where k > 1 (compNumber)
;	until k == startNumber as long as there is a remainder in the division. If at any point no remainder exists
;	before k == startNunmber, then the number is not prime and startNumber gets increased and compNumber gets 
;	reset to 2.
;
;
;------------------------------------------

showPrimes PROC

	mov		EAX, startNumber	; move start number to EAX register
	mov		EBX, compNumber		; move comp number to EBX
	mov		ECX, userPrimes		; userPrimes moved to ECX as it will be used as a counter

; Main loop compares contents of EAX and EBX (startNumber and compNumber) until a prime number is found
_primeLoop:
	cmp		EAX, EBX
	JE		_isPrime			; if EAX and EBX are the same number, the number is prime and jumps to _isPrime
	CDQ
	div		EBX
	cmp		EDX, 0				; when divinding by any number, if the remainder is zero, number is not prime
	JE		_notPrime
	inc		EBX					; EBX increases
	mov		EAX, startNumber	
	jmp		_primeLoop			; jumps back to beginning of loop, but DOES NOT decrease userNumber counter in ECX


; If a number is not prime, startNumber is increased and program returns to _PrimeLoop
_notPrime:
	inc		startNumber	
	mov		EAX, startNumber
	mov		EBX, compNumber
	jmp		_primeLoop

; If a current number is a prime number, write prime number to the screen
_isPrime:

	CALL	WriteDec
	mov		EDX, OFFSET	strSpace	; For EC1, strspace is set to a tab so that columns are aligned.
	call	WriteString
	inc		colCounter				; since a new number was written, increase the column counter			
	mov		EBX, colCounter
	cmp		EBX, MAX_COLUMN
	JE		_newRow					; if the column counter reaches max_columns, jump to create a new row
	jmp		_resetStatus

; Increases startNumber, reset compNumber to 2, and decrease userNumber counter in ECX by 1
_resetStatus:
	inc		startNumber
	mov		EAX, startNumber
	mov		compNumber, 2
	mov		EBX, compNumber
	LOOP	_primeLoop			; LOOP through _primeLoop, decreases userNumber by 1
	ret							; return to main procedure after ECX counter reaches 0

; After 15 numbers in a column, jump to new row and reset column counter
_newRow:
	call	CrLf
	mov		colCounter, 0
	inc		rowCounter			; as new row is created, increase row counter
	mov		EBX, rowCounter	
	cmp		ebx, MAX_ROW		; for extrac credit, will check to see if row counter reached 20 total rows
	JE		_newPage
	jmp		_resetStatus		; jump back to reset status in order to decrease ECX counter

; for EC, if 20 rows are reached, print out a wait message and reset row counter to zero
_newPage:
	call	WaitMsg
	call	CrLf
	mov		rowCounter, 0
	jmp		_resetStatus		; jump back to reset status to decrease ECX counter


showPrimes ENDP

;--------------------------
; Procedure that provides a farewell
;	to the user
;
;--------------------------

farewell PROC
	call	CrLf
	mov		EDX, OFFSET outro
	call	WriteString
	call	CrLf

farewell ENDP


	Invoke ExitProcess,0			; exit to OS
END main
