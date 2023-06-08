; ----------------------------------------------------------------------
%TITLE "LEXI: Guess the 5 letter word within 10 tries"
;AUTHOR:                Natsurii
;CREATION DATE:         2023/05/27
;LAST MODIFIED:         2023/06/06
;TODO:
;               [ ] Lexi data structure
;                       [/] Word bank array
;                       [/] current secret word
;                       [/] correct letter count
;                       [ ] number of guesses
;               [/] Game logic
;                       [/] Player guess comparator
;                       [/] Letter position feedback
;               [ ] User input handler
;                       [/] User input loop
;                       [/] Input to memory buffer
;                       [ ] User level picker
;               [ ] Display game state
;                       [/] User Terminal UI
;                       [/] Word current guessed state (all 6 state)
;                       [/] Word state colorizer
;                               [/] Green for correct position
;                               [/] Grey for correct letter, incorrect pos
;               [/] Game loop
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

                MOV             AH, 00H         ; Video function: set video mode
                MOV             AL, 03H         ; 80x25 text mode
                INT             10h             ; Run video interrupt

                CALL            drawUI          ; Draw the UI
                CALL            gameLogic       ; Initialize the game logic

exit:           
                MOV             AX, 4C00h       ; DOS Function: Terminate
                INT             21h             ; Run DOS interrupt
ENDP


                INCLUDE "UTILS/CONSOLE.ASM"
                INCLUDE "UTILS/INPUT.ASM"
                INCLUDE "WORDLIST.ASM"
                INCLUDE "UI.ASM"
                INCLUDE "LOGIC.ASM"

END MAIN


; ------------------------------- EOF ----------------------------------