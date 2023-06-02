; ---------------------------- DATA SEGMENT ---------------------------

                DATASEG                             ; Data segment IDEAL directive

correctLettersCount DW 0                            ; Correct word counter
input           DB              5 dup(?)            ; Input buffer + null-term
secretWord      DB              'MEALS','$',0       ; Temporary secret word
matchColor      DB 0Ah                              ; Green background color
mismatchColor   DB 08h                              ; Grey background color
inputPosition   DW 1026h                            ; Row 16, Column 38
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
                JNZ         inputLoop

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
                PUSH AX                             ; Preserve data of AX
                MOV AX, [correctLettersCount]       ; AX = correctLettersCount
                INC AX                              ; AX = AX + 1
                MOV [correctLettersCount], AX       ; Store updated correctLettersCount
                POP AX                              ; Restore previous value of AX
                RET
ENDP
