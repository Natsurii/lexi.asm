PROC gameLogic
            MOV             DX, 0624h           ;setCursor to (6,36)
            CALL            userInputLoop        
            RET
ENDP

; -- userInputLoop PROCEDURE --
; DESC:         Set the cursor position and call readUserInput multiple times
; INPUT:        DH: The row of cursor
;               DL: The column
; RETURN:       NONE
PROC userInputLoop
    PUSH    CX              ; Push CX to stack segment
    CALL    setCursor
    MOV     CX, 6           ; Set the loop counter = 6
inputLoop:
    CALL    setCursor       ; Set the cursor position
    CALL    readUserInput   
    CALL    convertToUppercase

    INC     DH              ; Increment the row
    LOOP    inputLoop       ; Loop back for the next input

    POP     CX              ; Restore CX from stack
    RET
ENDP