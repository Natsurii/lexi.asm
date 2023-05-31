; ---------------------------- DATA SEGMENT ---------------------------

                DATASEG
 
asciiArt        DB              "                                               dP dP", 10, 13
                DB              "                                               88 88   ", 10, 13
                DB              "            dP  dP  dP .d8888b. 88d888b. .d888b88 88 .d8888b.", 10, 13
                DB              "            88  88  88 88'  `88 88'  `88 88'  `88 88 88ooood8", 10, 13
                DB              "            88.88b.88' 88.  .88 88       88.  .88 88 88.  ...", 10, 13
                DB              "            8888P Y8P  `88888P' dP       `88888P8 dP `88888P'", 10, 13
                DB              "$"


anyKeyPrompt    DB              10, 13, 10, 13, "           Press any key to continue...",10 ,13, '$'

equalSign       DB              "=", "$"

attemptLabel    DB              'Attempts Left: ', '$'
usedLetLabel    DB              'Used letters:', '$'

; -------------------------- CODE SEGMENT -----------------------------

                CODESEG


PROC drawUI     
                CALL            clearScreen          
                               
                CALL            displayASCII
                CALL            drawBorder

                CALL            waitForKeypress

                CALL            clearScreen
                CALL            drawBorder
                CALL            displayGameArea

                CALL            waitForKeypress
                
                
                RET
ENDP

PROC drawBorder
                MOV             DX, 0100h           ; Set cursor to upper left                
                MOV             CX, 80
                MOV             AL, '=' 
                CALL            printHorizontalLine

                MOV             DX, 1700h           ; setCursor to Lower left
                MOV             CX, 80
                MOV             AL, '='                        
                CALL            printHorizontalLine

                MOV             DX, 0100h
                MOV             CX, 23
                MOV             BH, '='
                CALL            printVerticalLine

                MOV             DX, 014Fh
                MOV             CX, 23
                MOV             BH, '='
                CALL            printVerticalLine

                RET

ENDP

PROC displayASCII

                MOV             DX, 0800h           ; Move down the cursor
                CALL            setCursor
                
                LEA             DX, [asciiArt]      ; DX <- address of asciiArt
                MOV             AH, 09h             ; DOS function: print string
                INT             21h             

                LEA             DX, [anyKeyPrompt]  ; DX <- address of anyKeyPrompt
                MOV             AH, 09h             ; DOS Function: print string
                INT             21h

                RET
ENDP

; -- drawGameArea PROCEDURE  --
; DESC:         Draw the (9x10) game area
; INPUT:        N/a
; RETURN        N/a
PROC displayGameArea
                MOV             DX, 031Dh           ; Set cursor to (5,6)
                CALL            setCursor
                MOV             CX, 20
                MOV             AL, '.' 
                CALL            printHorizontalLine

                MOV             DX, 0D1Dh           ; setCursor to (15,6)
                CALL            setCursor
                MOV             CX, 20
                MOV             AL, '.'                        
                CALL            printHorizontalLine

                MOV             DX,031Dh           ; setCursor to (5,6)
                CALL            setCursor
                MOV             CX, 10
                MOV             BH, '.'
                CALL            printVerticalLine

                MOV             DX, 0331h           ; setCursor to (5,26)
                CALL            setCursor
                MOV             CX, 10
                MOV             BH, '.'
                CALL            printVerticalLine
                RET
ENDP

                INCLUDE "UTILS/CONSOLE.ASM"
                INCLUDE "UTILS/INPUT.ASM"