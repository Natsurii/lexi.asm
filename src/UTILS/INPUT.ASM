PROC waitForKeypress
            PUSH            AX
            MOV             AH, 00h             ; DOS Function: wait keypress
            INT             16h                 ; Run Keyboard interrupt
            POP             AX
            RET
ENDP

; -- convertToUppercase Procedure --
; DESC:         Convert all lowercase characters in the input string to uppercase
; INPUT:        DB input(6)
; OUTPUT:       DB input(6) with all lowercase characters converted to uppercase
PROC convertToUppercase

            PUSH            AX
            PUSH            CX
            PUSH            SI

            MOV             CX, 6               ; Set the loop counter = 6
            LEA             SI, [input]         ; Pointer to input buffer

convertLoop:
            MOV             AL, [SI]            ; Load the character into AL
            CMP             AL, 'a'             ; Check if it's a lowercase letter
            JB              nextChar
            CMP             AL, 'z'
            JA              nextChar

            ; Convert to uppercase:
            AND             AL, 11011111b       ; Clear the third bit
            MOV             [SI], AL            ; Store the uppercase character back to the buffer

nextChar:
            INC             SI                  ; Increment the pointer
            DEC             CX                  ; Decrement the counter
            JNZ             convertLoop         ; JMP convertLoop if CX != 0

            POP             SI
            POP             CX
            POP             AX
            RET                                 ; Return from procedure
        ENDP


; -- readUserInput Procedure --
; DESC:         Read the 5 characters inputted by the user
; INPUT:        DB input(0)
; OUTPUT:       DB input(5)
PROC readUserInput
            PUSH            AX
            PUSH            CX                  
            PUSH            DI
            PUSH            SI

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

