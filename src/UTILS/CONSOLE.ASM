; -------------------------- CODE SEGMENT -----------------------------
                CODESEG

; -- clearScreen PROCEDURE --
; DESC:         Clear the screen and reset the cursor position
; INPUT:        N/a
; RETURN:       N/a
PROC clearScreen
                MOV             AH, 06h             ; AH=06h Scroll up window
                MOV             AL, 00h             ; Clear the whole window
                MOV             BH, 07h             ; Set BH to 07h for text attribute: white on black
                MOV             CX, 0000h           ; Set CX to 0000h for cursor position: top-left corner
                MOV             DX, 184Fh           ; Set DX to 184Fh for screen dimensions: 25 rows x 80 columns
                INT             10h                 ; Call BIOS interrupt 10h to clear the screen and reset cursor position
                RET                                 ; Return from the procedure
ENDP


; --  setCursor PROCEDURE  --
; DESC:         Set the cursor to the program
; INPUT:        DH: The row of cursor
;               DL: the column
; RETURN        NONE
PROC setCursor
                PUSH            AX                  ; Preserve AX
                PUSH            BX                  ; Save the value of BX register
                MOV             BH, 00h             ; Set page to 0
                MOV             AH, 02h             ; DOS Function: set cursor pos
                INT             10h                 ; Run DOS interrupt
                POP             BX                  ; Restore the value of BX register
                POP             AX                  ; Restore AX from stack
                RET                                 ; Return from the procedure
ENDP


; -- printHorizontalLine PROCEDURE  --
; DESC:         Populate '=' in the given row
; INPUT:        AL: The character you want to print
;               CX: How many times you want to print
;               DX: cursor Location
; RETURN        N/a
PROC printHorizontalLine
                CALL            setCursor           ; Set the cursor from input
                MOV             AH, 09h             ; DOS Function: print char
                MOV             BH, 0               ; on page 0
                MOV             BL, 07h             ; White text on black
                INT             10h                 ; Run DOS interrupt
                RET                                 ; Return form procedure
ENDP


; -- printVerticalLine PROCEDURE  --
; DESC:         Populate '=' in the given column
; INPUT:        BH: The character you want to print
;               CX: How many times you want to print
; RETURN        N/a
PROC printVerticalLine
PRINT_LOOP:
                CALL            setCursor           ; Reposition cursor based on DX
                PUSH            DX                  ; Push DX Coz INT21/AH=02 will use it
                MOV             AH, 02h             ; DOS Function: display character
                MOV             DL, BH              ; Mov character to DL
                INT             21h                 ; Run DOS interrupt
                POP             DX                  ; Restore cursor position
                INC             DH                  ; Increment row
                LOOP            PRINT_LOOP          ; Loop until CX = 0
                RET                                 ; Return form procedure

ENDP


; -- printCharAttrib PROCEDURE  --
; DESC:         print the character with the attribute
; INPUT:        AL: The character you want to print
;               BL: The color attribute
; RETURN        N/a
PROC printCharAttrib
                CALL            setCursor           ; Set the cursor from input
                MOV             AH, 09h             ; DOS Function: print char
                MOV             CX, 1               ; Print only 1 time
                MOV             BH, 0               ; on page 0
                INT             10h                 ; Run DOS interrupt
                RET                                 ; Return form procedure
ENDP

; ------------------------------- EOF ----------------------------------
