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
;                       [/] number of guesses
;               [ ] Game logic
;                       [ ] Player guess comparator
;                       [ ] Letter position feedback
;               [ ] User input handler
;                       [/] User input loop
;                       [/] Input to memory buffer
;               [ ] Display game state
;                       [/] User Terminal UI
;                       [ ] Word current guessed state (all 6 state)
;                       [ ] Word state colorizer
;                               [ ] Green for correct position
;                               [ ] Grey for correct letter, incorrect pos
;                       [ ] Letter State
;               [ ] Game loop
;
; ---------------------------------------------------------------------

; ----------------------------- HEADER --------------------------------

                IDEAL                           ; Set IDEAL mode (strict type)
                MODEL           COMPACT         ; CODE < 64k, DATA >= 64K
                STACK           100h            ; Set stack to 100h
; -------------------------- CODE SEGMENT -----------------------------

                CODESEG                         ; Code segment IDEAL directive

; --  MAIN PROCEDURE  --
; DESC:         Main entrypoint of the program
; INPUT:        NONE
; RETURN        NONE
PROC MAIN

                MOV             AX, @DATA       ; mov dataseg to ax
                MOV             DS, AX          ; mov the ax content to dsW

                ; CALL            drawUI
                CALL            gameLogic  

exit:           
                MOV             AX, 4C00h       ; DOS Function: Terminate
                INT             21h             ; Run DOS interrupt
ENDP

                INCLUDE "UI.ASM"
                INCLUDE "LOGIC.ASM"

END MAIN


; ------------------------------- EOF ----------------------------------






