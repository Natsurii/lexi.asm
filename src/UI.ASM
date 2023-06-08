; ---------------------------- DATA SEGMENT ---------------------------

                DATASEG
 
asciiArt        DB              "                 .---.                                        ", 10, 13
                DB              "                 |   |      __.....__                    .--. ", 10, 13
                DB              "                 |   |  .-''         '.                  |__| ", 10, 13
                DB              "                 |   | /     .------.  `.                .--. ", 10, 13
                DB              "                 |   |/     /________\   \ ____     _____|  | ", 10, 13
                DB              "                 |   ||                  |`.   \  .'    /|  | ", 10, 13
                DB              "                 |   |\    .-------------'  `.  `'    .' |  | ", 10, 13
                DB              "                 |   | \    '-.____...---.    '.    .'   |  | ", 10, 13
                DB              "                 |   |  `.             .'     .'     `.  |__| ", 10, 13
                DB              "                 '---'    `---...... -'     .'  .'`.   `.     ", 10, 13
                DB              "                                          .'   /    `.   `.   ", 10, 13
                DB              "                                         '----'       '----'  ", 10, 13
                DB              "$"

scrollArt       DB              "                     ______________________________", 10, 13
                DB              "                   / \                             \.", 10, 13
                DB              "                  |   |      __           _        |.    WORD HISTORY:", 10, 13
                DB              "                   \_ |     / /  _____  _(_)       |.", 10, 13
                DB              "                      |    / /  / _ \ \/ / |       |.", 10, 13
                DB              "                      |   / /__|  __/>  <| |       |.", 10, 13
                DB              "                      |   \____/\___/_/\_\_|       |.", 10, 13
                DB              "                      |                            |.", 10, 13
                DB              "                      |   Level #:                 |.", 10, 13
                DB              "                      |   Attempt #:               |.", 10, 13
                DB              "                      |                            |.", 10, 13
                DB              "                      |                            |.", 10, 13
                DB              "                      |                            |.", 10, 13
                DB              "                      |                            |.", 10, 13
                DB              "                      |                            |.", 10, 13
                DB              "                      |                            |.", 10, 13
                DB              "                      |   _________________________|___", 10, 13
                DB              "                      |  /                            /.", 10, 13
                DB              "                      \_/____________________________/.", 10, 13
                DB              "$"
               
anyKeyPrompt    DB              10, 13, 10, 13, "           Press any key to continue...",10 ,13, '$'

winASCII        DB              "                           .--------.", 10, 13
                DB              "                         .'          '.", 10, 13
                DB              "                        /   O      O   \", 10, 13
                DB              "                       :                :", 10, 13
                DB              "                       |                |          YOU WIN", 10, 13
                DB              "                       : ',          ,' :    press any key to exit.", 10, 13
                DB              "                        \  '-......-'  /", 10, 13
                DB              "                         '.          .'", 10, 13
                DB              "                           '-......-'", 10, 13
                DB              "$"


loseASCII       DB              "                           .--------.", 10, 13
                DB              "                         .'          '.", 10, 13
                DB              "                        /   O      O   \", 10, 13
                DB              "                       :           `    :", 10, 13
                DB              "                       |                |          YOU LOSE", 10, 13
                DB              "                       :    .------.    :    press any key to exit.", 10, 13
                DB              "                        \  (        )   /", 10, 13
                DB              "                         '.          .'", 10, 13
                DB              "                           '-......-'", 10, 13
                DB              "$"
; -------------------------- CODE SEGMENT -----------------------------

                CODESEG


; -- drawUI PROCEDURE --
; DESC:         Draw the user interface
; INPUT:        N/a
; RETURN        N/a
PROC drawUI
                CALL            clearScreen         ; Clear the screen

                CALL            displayASCII        ; Display ASCII art or logo
                CALL            drawBorder          ; Draw a border around the UI
                CALL            waitForKeypress     ; Wait for the user to press a key

                CALL            getUserLvlInput
                CALL            clearScreen         ; Clear the screen
                CALL            displayGameUI       ; Display the game user interface
                CALL            drawBorder          ; Draw a border around the game UI

                RET                                 ; Return from the procedure
ENDP


; -- displayASCII PROCEDURE --
; DESC:         Display ASCII art and a prompt message
; INPUT:        N/a
; RETURN:       N/a
PROC displayASCII
                MOV             DX, 0500h           ; Move down the cursor
                CALL            setCursor           ; run set cursor
                
                LEA             DX, [asciiArt]      ; DX <- address of asciiArt
                MOV             AH, 09h             ; DOS function: print string
                INT             21h                 ; Run DOS interrupt

                LEA             DX, [anyKeyPrompt]  ; DX <- address of anyKeyPrompt
                MOV             AH, 09h             ; DOS Function: print string
                INT             21h                 ; Run DOS interrupt

                RET                                 ; Return from the procedure
ENDP

; -- displayGameUI PROCEDURE --
; DESC:         Display the game user interface
; INPUT:        N/a
; RETURN:       N/a
PROC displayGameUI

                MOV             DX, 0300h           ; Move down the cursor
                CALL            setCursor           ; call cursor interupt
                LEA             DX, [scrollArt]     ; DX <- address of scrollArt
                MOV             AH, 09h             ; DOS function: print string
                INT             21h                 ; Run DOS interrupt

                MOV             DX, [inputPosition] ; Move the cursor again
                CALL            displayGameArea     ; Display the game area

                RET                                 ; Return from the procedure
ENDP


; -- displayGameArea PROCEDURE  --
; DESC:         Draw the (9x10) game area
; INPUT:        N/a
; RETURN        N/a
PROC displayGameArea
                DEC             DH                  ; Decrement DH to move the cursor up
                DEC             DL                  ; Decrement DL to move the cursor left
                CALL            setCursor           ; Set the cursor position

                MOV             CX, 7               ; Set the length of the horizontal line
                MOV             AL, '-'             ; Set the horizontal line character
                CALL            printHorizontalLine ; Print the horizontal line

                INC             DH                  ; Increment DH to move the cursor down
                CALL            setCursor           ; Set the cursor position

                MOV             CX, 1               ; Set the length of the vertical line
                MOV             BH, '|'             ; Set the vertical line character
                CALL            printVerticalLine   ; Print the vertical line

                CALL            setCursor           ; Set the cursor position

                MOV             CX, 7               ; Set the length of the horizontal line
                MOV             AL, '-'             ; Set the horizontal line character
                CALL            printHorizontalLine ; Print the horizontal line

                DEC             DH                  ; Decrement DH to move the cursor up
                ADD             DL, 6               ; Add 6 to DL to move the cursor right
                CALL            setCursor           ; Set the cursor position

                MOV             CX, 1               ; Set the length of the vertical line
                MOV             BH, '|'             ; Set the vertical line character
                CALL            printVerticalLine   ; Print the vertical line

                RET                                 ; Return from the procedure
ENDP

; -- drawBorder PROCEDURE --
; DESC:         Draw a border around the screen
; INPUT:        N/a
; RETURN:       N/a
PROC drawBorder
                MOV             DX, 0100h           ; Set cursor to upper left corner
                MOV             CX, 80              ; Set the length of the horizontal line
                MOV             AL, '#'             ; Set the border character
                CALL            printHorizontalLine ; Print the horizontal line

                MOV             DX, 1700h           ; Set cursor to lower left corner
                MOV             CX, 80              ; Set the length of the horizontal line
                MOV             AL, '#'             ; Set the border character
                CALL            printHorizontalLine ; Print the horizontal line

                MOV             DX, 0100h           ; Set cursor to upper left corner
                MOV             CX, 23              ; Set the length of the vertical line
                MOV             BH, '#'             ; Set the border character
                CALL            printVerticalLine   ; Print the vertical line

                MOV             DX, 014Fh           ; Set cursor to upper right corner
                MOV             CX, 23              ; Set the length of the vertical line
                MOV             BH, '#'             ; Set the border character
                CALL            printVerticalLine   ; Print the vertical line

                RET                                 ; Return from the procedure
ENDP

PROC winGameOver

    RET
ENDP


PROC loseGameOver

    RET
ENDP
; ------------------------------- EOF ----------------------------------
