; ---------------------------- DATA SEGMENT ---------------------------

                DATASEG                             ; Data segment IDEAL directive

correctLettersCount DW 0                            ; Correct word counter
input           DB              5 dup(?), '$'       ; Input buffer + null-term
secretWord      DB              6 dup(?), '$',      ; Temporary secret word
matchColor      DB 0Ah                              ; Green background color
mismatchColor   DB 08h                              ; Grey background color
inputPosition   DW 1020h                            ; Row 16, Column 16
userLvlChoice   DW 2002         
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
                CALL        getWordFromChoice
inputLoop:
                MOV         DX, [inputPosition]     ; setCursor to (16,38)
                CALL        setCursor               ; move cursor
                CALL        readUserInput           ; Read the user input
                CALL        convertToUppercase      ; convert user input to uppercase

                MOV         DX, [inputPosition]     ; setCursor to (16,38)
                CALL        compareLetters          ; compare user input to secret word

                ; if all letters matched, exit loop
                MOV         AX, [correctLettersCount]; AX = correctLettersCount
                CMP         AX, 5                   ; AX == 5? exit loop: continue loop
                JNZ         inputLoop               ; Jump input loop if matched < 5

    RET
ENDP

; -- compareLetters PROCEDURE --
; DESC:         Compare the user input and secretword
; INPUT:        input DB(5)
;               secretWord DB(5)
; RETURN:       NONE
PROC compareLetters
                MOV         CX, 5                   ; Number of letters to compare
                MOV         SI, OFFSET secretWord   ; Load secretWord index to SI
                MOV         DI, OFFSET input        ; Load input index to DI
                MOV         AX, 0                   ; Initialize correctLettersCount to 0
                MOV         [correctLettersCount],AX; Reset the correct letters count

compareLoop:
                MOV         AL, [SI]                ; Load letter from secret
                CMP         AL, [DI]                ; Compare with user input

                ; Set background color based on match or mismatch
                JE          matchedLetter           ; IF matched, jump to matchedLetter
                MOV         BL, [mismatchColor]     ; Background color
                JMP         proceedPrint

matchedLetter:
                MOV         BL, [matchColor]        ; Background color
                CALL        incrementCorrectLetters ; Increment correctLettersCount

proceedPrint:
                PUSH        CX                      ; preserve CX
                INC         SI                      ; Move to next letter in secret word
                MOV         AL, [DI]                ; Load letter from user input into AL
                CALL        setCursor               ; change the cursor position

                ; Print the current character
                MOV         BH, 0                   ; Display page
                MOV         CX, 1                   ; Number of times to write character
                MOV         AH, 09h                 ; DOS Function: write char w/ attrib
                INT         10h                     ; Call BIOS interrupt
                INC         DI                      ; Move to next letter in user input
                INC         DL                      ; Increment column
                POP         CX                      ; Restore compareLoop Count
                LOOP        compareLoop             ; Loop until all letters are compared
                RET                                 
ENDP

; -- incrementCorrectLetters PROCEDURE --
; DESC:         Compare the user input and secretword
; INPUT:        input DB(5)
;               secretWord DB(5)
; RETURN:       NONE
PROC incrementCorrectLetters
                PUSH        AX                      ; Preserve data of AX
                MOV         AX,[correctLettersCount]; AX = correctLettersCount
                INC         AX                      ; AX = AX + 1
                MOV         [correctLettersCount],AX; Store updated correctLettersCount
                POP         AX                      ; Restore previous value of AX
                RET
ENDP

; -- getWordFromChoice PROCEDURE -- 
; DESC:         Get the string from the ARRAY based on the userLvlChoice index 
; INPUT:        userLvlChoice DW (index) 
; OUTPUT:       secretWord DB(5) - The chosen string without the separator 
; RETURN:       NONE
PROC getWordFromChoice
                PUSH        SI                      ; Preserve SI,
                PUSH        DI                      ; DI,
                PUSH        AX                      ; AX,
                PUSH        CX                      ; CX values to STACk
                XOR         AX, AX                  ; Flush the value of AX
                XOR         SI, SI                  ; and SI
                LEA         SI, [ARRAY]             ; Load effective address offset
                MOV         AX, [userLvlChoice]     ; Move user input to AX

                MOV         CX, 6                   ; each string has 5char + 1sep
                IMUL        CX                      ; Offset = AX * 6
                ADD         SI, AX                  ; Add SI to AX before addresaing
                LEA         DI, [secretWord]        ; init DI to point secretWord

; Copy the string from ARRAY to secretWord until the separator is encountered
CopyString:
                MOV         AL, [SI]                ; Move a character from ARRAY to AL
                CMP         AL, '$'                 ; Compare AL with the separator character
                JE          EndOfString             ; If it's the separator, jump to EndOfString
                MOV         [DI], AL                ; Move the character from AL to secretWord
                INC         SI                      ; Increment SI to point to the next character in ARRAY
                INC         DI                      ; Increment DI to point to the next character location in secretWord
                JMP         CopyString              ; Jump back to CopyString to continue copying
EndOfString:
                MOV         [DI], 0                 ; Add a null terminator to the secretWord

                POP         CX                      ; Retrieve CX,
                POP         AX                      ; AX,
                POP         DI                      ; DI,
                POP         SI                      ; SI values from STACK
                RET
ENDP

; ------------------------------- EOF ----------------------------------
