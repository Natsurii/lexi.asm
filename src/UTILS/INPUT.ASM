; -------------------------- CODE SEGMENT -----------------------------

                CODESEG
; -- waitForKeypress PROCEDURE --
; DESC:         Wait for a keypress from the user
; INPUT:        N/a
; RETURN:       N/a
PROC waitForKeypress
                PUSH            AX                  ; Save AX register content on the stack
                MOV             AH, 00h             ; Set AH to 00h for DOS function: wait for keypress
                INT             16h                 ; Run keyboard interrupt 16h to wait for a keypress
                POP             AX                  ; Restore the original content of AX register from the stack
                RET                                 ; Return from the procedure
ENDP


; -- convertToUppercase Procedure --
; DESC:         Convert all lowercase characters in the input string to uppercase
; INPUT:        DB input(6)
; OUTPUT:       DB input(6) with all lowercase characters converted to uppercase
PROC convertToUppercase

                PUSH            AX                  ; Push AX
                PUSH            CX                  ; CX
                PUSH            SI                  ; SI values to stack to preserve

                MOV             CX, 6               ; Set the loop counter = 6
                LEA             SI, [input]         ; Pointer to input buffer

convertLoop:
                MOV             AL, [SI]            ; Load the character from memory location pointed by SI into AL
                CMP             AL, 'a'             ; Compare the character with 'a' (lowercase)
                JB              nextChar            ; If the character is smaller than 'a', jump to nextChar
                CMP             AL, 'z'             ; Compare the character with 'z' (lowercase)
                JA              nextChar            ; If the character is larger than 'z', jump to nextChar

                ; Convert to uppercase:
                AND             AL, 11011111b       ; Clear the third bit
                MOV             [SI], AL            ; Store the uppercase character back to the buffer

nextChar:
                INC             SI                  ; Increment the pointer
                DEC             CX                  ; Decrement the counter
                JNZ             convertLoop         ; JMP convertLoop if CX != 0

                POP             SI                  ; Restore SI
                POP             CX                  ; CX
                POP             AX                  ; AX values from stack
                RET                                 ; Return from procedure
ENDP


; -- readUserInput Procedure --
; DESC:         Read the 5 characters inputted by the user
; INPUT:        DB input(0)
; OUTPUT:       DB input(5)
PROC readUserInput
                PUSH            AX                  ; Preserve AX
                PUSH            CX                  ; CX
                PUSH            DI                  ; DI
                PUSH            SI                  ; SI values to stack

                MOV             CX, 5               ; Set the loop counter = 5
                LEA             SI, [input]         ; Pointer to input buffer
                MOV             DI, SI              ; Save initial pointer

readLoop:
                MOV             AH, 1               ; DOS Function: Read char
                INT             21h                 ; Run DOS interrupt
                MOV             [SI], AL            ; Input append character

                CMP             AL, 13              ; Check if Enter key (ASCII code 13)
                JE              saveInput           ; Jump to save input if true

                INC             SI                  ; Increment the pointer
                DEC             CX                  ; Decrement the counter
                JNZ             readLoop            ; JMP readLoop if CX != 0

saveInput:
                MOV             [input+5], '$'      ; Add the null-term to buffer
                
                POP             SI                  ; Restore SI
                POP             DI                  ; Restore DI
                POP             CX                  ; Restore CX 
                POP             AX                  ; Restore AX after it ran
                RET                                 ; Return from procedure
ENDP

; ------------------------------- EOF ----------------------------------
