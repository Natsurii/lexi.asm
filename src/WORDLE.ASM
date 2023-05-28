; ----------------------------------------------------------------------
%TITLE "Wordle: Guess the 5 letter word within 6 tries"
;AUTHOR:                Natsurii
;CREATION DATE:         2023/05/27
;LAST MODIFIED:         2023/05/28
;TODO:
;               [ ] Wordle data structure
;                       [ ] Word bank array
;                       [ ] current secret word
;                       [ ] correct letter array
;                       [ ] Incorrect position array
;                       [ ] number of guesses
;               [ ] Game logic
;                       [ ] Player guess comparator
;                       [ ] Letter position feedback
;               [ ] User input handler
;               [ ] Display game state
;                       [ ] User Terminal UI
;                       [ ] Word current guessed state (all 6 state)
;                       [ ] Word state colorizer
;                               [ ] Green for correct position
;                               [ ] Grey for correct letter, incorrect pos
;                       [ ] Letter State
;                       [/] User input prompt to input buffer
;                               [ ] Handle backspace and enter key
;               [ ] Game loop
;
; ---------------------------------------------------------------------

; ----------------------------- HEADER --------------------------------

                IDEAL                           ; Set IDEAL mode (strict type)
                MODEL           SMALL           ; Model = small (near, near)
                STACK           100h            ; Set stack to 100h

; ---------------------------- DATA SEGMENT ---------------------------

                DATASEG                         ; Data segment IDEAL directive

attempts        DB              6
input           DB              6 dup(?)        ; Input buffer + null-term
secretWord      DB              'MEALS'         ; Temporary secret word
guesses         DB              5 dup(?)
letterState     DB              26 dup(?)


; -------------------------- CODE SEGMENT -----------------------------

                CODESEG                         ; Code segment IDEAL directive

; --  MAIN PROCEDURE  --
; DESC:         Main entrypoint of the program
; INPUT:        NONE
; RETURN        NONE
PROC MAIN

                MOV             AX, @DATA       ; mov dataseg to ax
                MOV             DS, AX          ; mov the ax content to ds

                CALL            readUserInput   ; Call user input proc

                LEA             DX, [input]     ; Load input to DX
                MOV             AH, 9           ; DOS Function: display str
                INT             21h             ; Run DOS interrupt

exit:           MOV             AX, 4C00h       ; DOS Function: Terminate
                INT             21h             ; Run DOS interrupt
ENDP









; -- readUserInput Procedure --
; DESC:         Read the 5 characters inputed by the user
; INPUT:        DB input(0)
; OUTPUT:       DB input(5)
PROC readUserInput
                MOV             CX, 5           ; Set the loop counter = 5
                LEA             SI, [input]     ; pointer to input buffer
                MOV             DI, SI          ; Save initial pointer

readLoop:
                MOV             AH, 1           ; DOS Function: Read char
                INT             21h             ; Run DOS interrupt
                MOV             [SI], AL        ; input append character
                
                CMP             AL, 13          ; Check if Enter key (ASCII code 13)
                JE              saveInput       ; Jump to save input if true

                INC             SI              ; Increment the pointer
                DEC             CX              ; Decrement the counter
                JNZ             readLoop        ; JMP readLoop if CX != 0
                
saveInput:               
                MOV             [input+5], '$'       ; Add the null-term to buffer

                RET                             ; Return from procedure

ENDP


END MAIN


; ------------------------------- EOF ----------------------------------






