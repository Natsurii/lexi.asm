; ---------------------------- DATA SEGMENT ---------------------------

                DATASEG                             ; Data segment IDEAL directive

correctLettersCount DW 0                            ; Correct word counter
input           DB              5 dup(?), '$'       ; Input buffer + null-term
inputBuffer     DB              6,?,6 dup ('$')     ; Buffer to store the user input; Buffer to store user input (max 4 digits + CR)
secretWord      DB              6 dup(?), '$'       ; Temporary secret word
matchColor      DB 0Ah                              ; Green background color
mismatchColor   DB 08h                              ; Grey background color
inputPosition   DW 1020h                            ; Row 16, Column 16
printPosRow     DB 07h          
printPosCol     DB 3Ch

attemptCount    DW 10
asciiBuffer     DB 3, 0, 3 DUP('$') ; Buffer for the ASCII string: max length, current length, string data


inputMessage    db 13,10,'Enter a level number (1-3100): $'
errorMessage    db 13,10,'Invalid input! Enter a decimal integer between 1 and 3100: $'
convertedNumber dw ?                                ; Variable to store the converted decimal number
printableLvl    DB 6,?,6 dup ('$')
prntUsrLvlPos   DW 0B26h  
attemptPos      DW 0C26h                         
; ---------------------------- CODE SEGMENT ---------------------------
 
                CODESEG


; -- gameLogic PROCEDURE --
; DESC:         This is where the game logic happens
; INPUT:        N/a
; RETURN:       N/a
PROC gameLogic
                CALL            userInputLoop       ; Start reading user input
                RET
ENDP

; -- userInputLoop PROCEDURE --
; DESC:         Set the cursor position and call readUserInput multiple times
; INPUT:        DH: The row of cursor
;               DL: The column
; RETURN:       N/a
PROC userInputLoop  
                CALL            getWordFromChoice
                CALL            printUserLevel
inputLoop:      
                CALL            print2DigitDecimal  ; Print number of attempts

                MOV             DX, [inputPosition] ; Set cursor to attempt POS
                MOV             CX, 5               ; Set the length blank horizontal line
                MOV             AL, ' '             ; Set the border character
                CALL            printHorizontalLine ; Print the horizontal line
                MOV             DX, [inputPosition] ; setCursor to (16,38)
                CALL            setCursor           ; move cursor
                CALL            readUserInput       ; Read the user input
                CALL            convertToUppercase  ; convert user input to uppercase

                MOV             DH, [printPosRow]
                MOV             DL, [printPosCol]
                CALL            compareLetters      ; compare user input to secret word

                INC             DH                  ; Increment the row
                MOV             [printPosRow], DH   ; save the row new val to the var 
                
                CALL            decrementAttempts
                MOV             AX, [attemptCount]
                CMP             AX, 0
                JZ              lose

                ; if all letters matched, exit loop
                MOV             AX, [correctLettersCount]; AX = correctLettersCount
                CMP             AX, 5                   ; AX == 5? exit loop: continue loop
                JNZ             inputLoop               ; Jump input loop if matched < 5

win:            

lose:

exitLoop:
                RET
ENDP

; -- compareLetters PROCEDURE --
; DESC:         Compare the user input and secretword
; INPUT:        input DB(5)
;               secretWord DB(5)
; RETURN:       NONE
PROC compareLetters
                MOV             CX, 5                   ; Number of letters to compare
                MOV             SI, OFFSET secretWord   ; Load secretWord index to SI
                MOV             DI, OFFSET input        ; Load input index to DI
                MOV             AX, 0                   ; Initialize correctLettersCount to 0
                MOV             [correctLettersCount],AX; Reset the correct letters count

compareLoop:
                MOV             AL, [SI]            ; Load letter from secret
                CMP             AL, [DI]            ; Compare with user input

                ; Set background color based on match or mismatch
                JE              matchedLetter       ; IF matched, jump to matchedLetter
                MOV             BL, [mismatchColor] ; Background color
                JMP             proceedPrint

matchedLetter:
                MOV             BL, [matchColor]    ; Background color
                CALL            incrementCorrectLetters ; Increment correctLettersCount

proceedPrint:
                PUSH            CX                  ; preserve CX
                INC             SI                  ; Move to next letter in secret word
                MOV             AL, [DI]            ; Load letter from user input into AL
                CALL            setCursor           ; change the cursor position

                ; Print the current character
                MOV             BH, 0               ; Display page
                MOV             CX, 1               ; Number of times to write character
                MOV             AH, 09h             ; DOS Function: write char w/ attrib
                INT             10h                 ; Call BIOS interrupt
                INC             DI                  ; Move to next letter in user input
                INC             DL                  ; Increment column
                POP             CX                  ; Restore compareLoop Count
                LOOP            compareLoop         ; Loop until all letters are compared
                RET                                 
ENDP

; -- incrementCorrectLetters PROCEDURE --
; DESC:         Compare the user input and secretword
; INPUT:        input DB(5)
;               secretWord DB(5)
; RETURN:       NONE
PROC incrementCorrectLetters
                PUSH            AX                      ; Preserve data of AX
                MOV             AX,[correctLettersCount]; AX = correctLettersCount
                INC             AX                      ; AX = AX + 1
                MOV             [correctLettersCount],AX; Store updated correctLettersCount
                POP             AX                      ; Restore previous value of AX
                RET
ENDP

; -- getWordFromChoice PROCEDURE -- 
; DESC:         Get the string from the ARRAY based on the userLvlChoice index 
; INPUT:        userLvlChoice DW (index) 
; OUTPUT:       secretWord DB(5) - The chosen string without the separator 
; RETURN:       NONE
PROC getWordFromChoice
                PUSH            SI                  ; Preserve SI,
                PUSH            DI                  ; DI,
                PUSH            AX                  ; AX,
                PUSH            CX                  ; CX values to STACk
                XOR             AX, AX              ; Flush the value of AX
                XOR             SI, SI              ; and SI
                LEA             SI, [ARRAY]         ; Load effective address offset
                MOV             AX,[convertedNumber]; Move user input to AX

                MOV             CX, 6               ; each string has 5char + 1sep
                IMUL            CX                  ; Offset = AX * 6
                ADD             SI, AX              ; Add SI to AX before addresaing
                LEA             DI, [secretWord]    ; init DI to point secretWord

; Copy the string from ARRAY to secretWord until the separator is encountered
CopyString:
                MOV             AL, [SI]            ; Move a character from ARRAY to AL
                CMP             AL, '$'             ; Compare AL with the separator character
                JE              EndOfString         ; If it's the separator, jump to EndOfString
                MOV             [DI], AL            ; Move the character from AL to secretWord
                INC             SI                  ; Increment SI to point to the next character in ARRAY
                INC             DI                  ; Increment DI to point to the next character location in secretWord
                JMP             CopyString          ; Jump back to CopyString to continue copying
EndOfString:
                MOV             [DI], 0             ; Add a null terminator to the secretWord

                POP             CX                  ; Retrieve CX,
                POP             AX                  ; AX,
                POP             DI                  ; DI,
                POP             SI                  ; SI values from STACK
                RET
ENDP

; -- getUserLvlInput PROCEDURE --
; DESC:         Reads user input, converts it to a decimal number and validates the range
; INPUT:        N/a
; RETURN:       Converted number stored in the 'convertedNumber' variable
PROC getUserLvlInput

startReading:
                ; Display input message
                LEA             DX, [inputMessage]
                MOV             AH, 09h
                INT             21h

                ; Read user input
                LEA             DX, [inputBuffer]
                MOV             AH, 0Ah
                INT             21h

                MOV AH, [inputBuffer]
                MOV [printableLvl], AH


                ; Convert user input to decimal number
                MOV             SI, offset inputBuffer + 2; Offset to read the user input after the length byte
                XOR             AX, AX              ; Clear AX register for conversion
                XOR             BX, BX              ; also BX
                XOR             CX, CX              ; CX
                XOR             DX, DX              ; and DX 

convertDecInpLoop:
                MOV             BL, [SI]            ; Move the ASCII digit to BL
                CMP             BL, 0Dh             ; Check if the current character is carriage return
                JE              convertDecDone      ; If it is, jump to convertDone
                CMP             BL, 30h             ; Compare with ASCII '0'
                JL              inputError          ; Invalid input if less than '0'
                CMP             BL, 39h             ; Compare with ASCII '9'
                JG              inputError          ; Invalid input if greater than '9'
                SUB             BL, 30h             ; Convert ASCII digit to numerical value
                MOV             CX, 10              ; Multiplier for decimal conversion
                MUL             CX                  ; Multiply current number by 10
                ADD             AX, BX              ; Add current digit to the total
                INC             SI                  ; Move to next digit
                CMP             [SI], '$'           ; Check if reached the end of user input
                JE              convertDecDone      ; Exit the loop if end marker is reached
                JMP             convertDecInpLoop   ; Continue the loop if not reached the end

convertDecDone:
                ; Check if the number is within the valid range
                CMP             AX, 1
                JL              inputError
                CMP             AX, 3100
                JG              inputError

                ; Save the number into the variable
                SUB             AX, 1               ; Make it 0-based array index
                MOV             [convertedNumber],AX; save the value to the variablee
                JMP             exitProgram         ; Jump to exit

inputError:
                ; Display error message
                LEA             DX, errorMessage    ; Load address of errorMessage string
                MOV             AH, 09h             ; DOS Function: Print string
                INT             21h                 ; Run DOS interrupt
                JMP             startReading        ; Jump again to start

exitProgram:
                RET                                 ; Return from procedure
ENDP

PROC printUserLevel
                PUSH            DX                  ; Preserve DX
                MOV             DX, [prntUsrLvlPos] ; Get user lvl print position
                CALL            setCursor           ; run getCursor interrupt
                MOV             DX, OFFSET inputBuffer + 2; get the address of input
                MOV             AH, 09h             ; DOS function: Print string
                INT             21h                 ; Run DOS interrupt
                POP             DX                  ; Restore the value of DX
                RET                                 ; Return from procedure
ENDP

; -- print2DigitDecimal PROCEDURE --
; DESC:         Converts a 2-digit decimal number in AX to a printable ASCII string and prints it
; INPUT:        AX - 2-digit decimal number to be printed
; RETURN:       N/a
PROC print2DigitDecimal
                ; Prepare the buffer for the ASCII string
                PUSH            AX
                PUSH            DX
                PUSH            CX

                MOV             AX, [attemptCount]
                LEA             DI, [asciiBuffer]   ; Load the address of asciiBuffer into DI
                MOV             [DI], 2             ; Store the maximum string length at the beginning of the buffer
                MOV             [DI+1], 0           ; Set the current string length to 0
                ADD             DI, 2                        ; Move DI to the start of the string data

                ; Convert the 2-digit decimal number to ASCII string
                MOV             CX, 10              ; Set the divisor for the conversion
                XOR             DX, DX              ; Clear DX for division
                DIV             CX                  ; Divide AX by 10: quotient in AX, remainder in DX
                ADD             DX, 30h             ; Convert the remainder to ASCII
                MOV             [DI+1], DL          ; Store the ASCII digit in the buffer (second digit)
                ADD             AX, 30h             ; Convert the quotient to ASCII
                MOV             [DI], AL            ; Store the ASCII digit in the buffer (first digit)

                MOV             DX, [attemptPos]    ; Set cursor to attempt POS
                MOV             CX, 2               ; Set the length blank horizontal line
                MOV             AL, ' '             ; Set the border character
                CALL            printHorizontalLine ; Print the horizontal line
                MOV             DX, [attemptPos]
                CALL            setCursor

                ; Print the ASCII string
                MOV             DX,OFFSET asciiBuffer+2 ; Load the address of asciiBuffer into DX
                MOV             AH, 09h             ; Set AH to 09h for DOS function: print string
                INT             21h                 ; Run DOS interrupt 21h to print the string

                POP             CX
                POP             DX
                POP             AX
                RET                                 ; Return from the procedure
ENDP

PROC decrementAttempts
                PUSH            AX
                MOV             AX, [attemptCount]
                DEC             AX
                MOV             [attemptCount], AX
                POP             AX
                RET
ENDP
; ------------------------------- EOF ----------------------------------
