TITLE Proj3_zamoraab     (Proj3_zamoraab.asm)

; Author: Abraham Zamora
; Last Modified: 2/6/2023
; OSU email address: zamoraab@oregonstate.edu
; Course number/section:   CS271 Section 271/400
; Project Number: Project Number 3                Due Date: 2/12/2023
; Description: Program asks user to pick a value between [-200,-100] and [-50,-1].
;	If user enters a negative number not within that range, program will keep prompting user.
;	If user enters a number greater than -1, program will then calculate sum of all user numbers, average, min, and max.

INCLUDE Irvine32.inc

LOWEST_LIMIT = -200
HIGHEST_LIMIT = -1
MID_LIMIT_ONE =	-100
MID_LIMIT_TWO =	-50

.data
; String variables	
	progIntro		byte	"Welcome to the Integer Accumulator by Abraham Zamora.", 0
	progDescr		byte	"We will be accumulating user-input negative integers between the specified bounds,",13,10
					byte	"then displaying statistics of the input values including minimum, maximum, and average values values,",13,10
					byte	"total sum, and total number of valid inputs.", 0
	greeting		byte	"What is your name? ", 0
	greetCont		byte	"Hello there, ", 0
	userName		byte	25 DUP(0)
	
	instrucVar		byte	"Please enter numbers in [-200,100] or [-50,-1].", 0
	instrucVar2		byte	"Enter a non-negative number when you are finished, and input stats will be shown.", 0
	numInput		byte	"Enter number: ", 0
	invalInput		byte	"This is not a number we're looking for (Invalid Input)!", 0
	confirmOne		byte	"You entered ", 0
	confirmTwo		byte	" valid numbers", 0
	maxNum			byte	"The maximum number is ", 0
	minNum			byte	"The minimum number is ", 0
	sumNum			byte	"The sum of your valid numbers is ", 0
	avgNum			byte	"The rounded average is ", 0
	outroMess		byte	"We have to stop meeting like this. Farewell, ", 0
	noNumbers		byte	"No valid numbers entered. Try again.", 0
; Integer variables and user inputs

	userNum1		SDWORD	?		; user will input this number
	validNumber		DWORD	0		; will increment with each valid number
	sumNumbers		SDWORD	0		; the sum of all valid numbers
	maxNumbers		SDWORD	-201	; max number entered. default is less than lowest limit	
	minNumbers		SDWORD	-1		; min number entered. default is set to zero
	averageNums		SDWORD	?		; calculating average

.code

main PROC

;-------------------------
; Program Intro that asks user for name, stores name in variable, and
;	lets user know the instructions of the program. 
;
;
;--------------------------
	mov		EDX, OFFSET	progIntro
	call	WriteString
	call	CrLf

	mov		EDX,	OFFSET	progDescr	
	call	WriteString
	call	CrLf

	mov		EDX, OFFSET	greeting
	call	WriteString
	mov		EDX, OFFSET	userName	; ask for the username
	mov		ECX, 24
	CALL	ReadString

	mov		EDX, OFFSET	greetCont
	call	WriteString
	mov		EDX, OFFSET	userName
	call	WriteString
	call	CrLf
	

	mov		EDX, OFFSET	instrucVar
	CALL	WriteString
	CALL	CrLf
	mov		EDX, OFFSET	instrucVar2
	call	WriteString
	call	CrLf
	jmp		_userPrompt


;--------------------------
; Asks the user to give a number between the ranges of [-200,-100] and [-50,-1].
;	If the user inputs a number greater than -1, moves to check valid numbers
;	If the number is less than 0, program checks if the number is between the defined ranges.
;	If the number is within the ranges, program jumps to _validNum.
;	If not within the range, will jump to _notValid
;-------------------------
_userPrompt:
	mov		EDX, OFFSET numInput	; asks user for number
	call	WriteString
	call	ReadInt
	mov		userNum1, EAX
	mov		EBX, 0
	cmp		userNum1, EBX			
	JNS		_totalValid				; if input number is not negative, jump to check total valid numbers

	mov		eax, userNum1
	cmp		eax, LOWEST_LIMIT		; compare to LOWEST_LIMIT for a valid number
	jl		_notValid
	cmp		eax, HIGHEST_LIMIT		; compare to HIGHEST_LIMIT for a valid number
	jg		_notValid
	cmp		eax, MID_LIMIT_ONE		; compare to MID_LIMIT_ONE for a valid number
	jle		_validNum
	cmp		eax, MID_LIMIT_TWO		; compare to MID_LIMIT_TWO for a valid number
	jl		_notValid
	jmp		_validNum
	jmp		_tryAgain

;------------------------------
; If a number is valid, program will increase the total valid numbers,
;	adds up the user number to other user numbers that have been deemed as valid.
;	Program will then check to see if the number is less than or greater than the
;	mininum and maximum values entered already.
;	If so, program jumps to set either a new minimum or maximum
;	Otherwise, return to user prompt for a new input number
;------------------------------

_validNum:
	inc		validNumber				; increase the validNumber variable for each valid number
	add		sumNumbers,	eax			; add valid number to the total sum
	mov		eax, userNum1
	cmp		eax, maxNumbers			; compare user number to max number
	jg		_setMax
	cmp		eax, minNumbers			; compare user number to min number
	jl		_setMin
	jmp		_userPrompt

;---------------------------------
; Program will set a new maximum number before returning to
;	prompt user for new number
;
;----------------------------------
_setMax:
	mov		eax, userNum1
	mov		maxNumbers, eax			; set a new Maximum number
	jmp		_userPrompt

;------------------------------
; Program will set a new minimum number before returning to
;	prompt user for a new number
;
;-------------------------------
_setMin:
	mov		eax, userNum1
	mov		minNumbers,	eax			;set a new Minimum number
	jmp		_userPrompt

;-------------------------------------
; If a user input a number that is not within the indicated range,
;	user will be prompted of the mistake and return to user prompt
;
;-----------------------------------
_notValid:
	mov		EDX, OFFSET	invalInput
	call	WriteString
	call	CrLf
	jmp		_userPrompt

;----------------------------------
; Checks to see how many total valid numbers exists.
;	If one, jumps to sets min number to equal max number
;	If less than 1 or invalid input like a char or string,
;	user is prompted to try again
;	If more than 1, jump to calculate average
;
;----------------------------------

_totalValid:
	mov		EAX, validNumber	
	mov		EBX, 1
	cmp		EAX, EBX			; compares if valid numbers equals 1
	je		_oneValid
	cmp		eax, EBX			; checks if valid numbers is 0 or an invalid input
	jl		_tryAgain
	jmp		_calcNumbers

;----------------------------------
; If only one valid input, set min number to
;	equal maximum number before moving to calculate average
;
;----------------------------------

_oneValid:
	mov		eax, maxNumbers
	mov		minNumbers, eax			; set minimum number to maximum number
	jmp		_calcNumbers
	
;-------------------------------------
; Calculate the average after a user
;	input a number greater than -1	
;
;-------------------------------------
_calcNumbers:
	mov		EAX, sumNumbers
	mov		ebx, validNumber
	cdq
	IDIV	validNumber				; divide the sum of all numbers by total valid numbers
	mov		averageNums, EAX		
	jmp		_outroStatement
	
;----------------------------------
; Program will return the total valid numbers,
;	sum of all numbers, average of the numbers,
;	maximum value and minimum value before closing.
;
;----------------------------------

_outroStatement:

	mov		EDX, OFFSET	confirmOne
	call	WriteString
	mov		EAX, validNumber		; return total of valid numbers
	call	WriteDec
	mov		EDX, OFFSET	confirmTwo
	call	WriteString
	call	CrLf

	mov		EDX, OFFSET	sumNum
	call	WriteString
	mov		EAX, sumNumbers			; return the sum of all numbers
	call	WriteInt
	call	CrLF

	mov		EDX, OFFSET	maxNum
	call	WriteString
	mov		EAX, maxNumbers			; return the maximum number
	call	WriteInt
	call	CrLf

	mov		EDX, OFFSET	minNum
	call	WriteString
	mov		EAX, minNumbers			; return the minimum number
	call	WriteInt
	call	CrLf

	mov		EDX, OFFSET	avgNum
	call	WriteString
	mov		EAX,	averageNums		; return the rounded average
	call	WriteInt
	call	CrLf

	mov		EDX, OFFSET	outroMess
	call	WriteString
	mov		EDX, OFFSET	userName
	call	WriteString
	call	CrLf
	JMP		_Exit					; jumps to exit

;-------------------------------------
; If no valid numbers are available
;	or a user input a char or string,
;	prompt user to try again
;
;-------------------------------------
_tryAgain:
	mov		EDX, OFFSET	noNumbers
	call	WriteString
	call	CrLf
	jmp		_userPrompt				; return to _userPrompt to try again

;------------------------------
; Exits the program
;
;------------------------------

_Exit:

	Invoke ExitProcess,0			; exit to operating system


main ENDP



END main
