PROC clearScreen
                MOV             AX, 0600h
                MOV             BH, 07h
                MOV             CX, 0000h
                MOV             DX, 184Fh
                INT             10h

                RET
ENDP


; --  setCursor PROCEDURE  --
; DESC:         Set the cursor to the program
; INPUT:        DH: The row of cursor
;               DL: the column
; RETURN        NONE
PROC setCursor
                PUSH            AX
                PUSH            BX         ; Save the value of BX register
                MOV             BH, 00h
                MOV             AH, 02h
                INT             10h
                POP             BX         ; Restore the value of BX register
                POP             AX

                RET
ENDP


; -- printHorizontalLine PROCEDURE  --
; DESC:         Populate '=' in the given row
; INPUT:        AL: The character you want to print
;               CX: How many times you want to print
; RETURN        N/a
PROC printHorizontalLine
                MOV             AH, 09h             ; DOS Function: print char
                MOV             BH, 0               ; on page 0
                MOV             BL, 07h             ; White text on black
                INT             10h                 ; Run DOS interrupt

                RET
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
                LOOP            PRINT_LOOP

                RET
ENDP