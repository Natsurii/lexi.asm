model small
stack 100h
IDEAL

dataseg
inputMessage db 13,10,'Enter a decimal integer (1-3100): $'
errorMessage db 13,10,'Invalid input! Enter a decimal integer between 1 and 3100: $'
inputBuffer db 5,?,5 dup ('$')  ; Buffer to store the user input
convertedNumber dw ?             ; Variable to store the converted decimal number

codeseg
proc main
    mov ax, @data
    mov ds, ax

    ; Display input message
    lea dx, inputMessage
    mov ah, 09h
    int 21h

    ; Read user input
    lea dx, inputBuffer
    mov ah, 0ah
    int 21h

    ; Convert user input to decimal number
    mov si, offset inputBuffer + 2   ; Offset to read the user input after the length byte
    xor ax, ax                       ; Clear AX register for conversion

convertDecLoop:
    mov bl, [si]                     ; Move the ASCII digit to BL
    cmp bl, 0Dh                      ; Check if the current character is carriage return
    je convertDecDone                ; If it is, jump to convertDone
    cmp bl, 30h                      ; Compare with ASCII '0'
    jl inputError                    ; Invalid input if less than '0'
    cmp bl, 39h                      ; Compare with ASCII '9'
    jg inputError                    ; Invalid input if greater than '9'
    sub bl, 30h                      ; Convert ASCII digit to numerical value
    mov cx, 10                       ; Multiplier for decimal conversion
    mul cx                           ; Multiply current number by 10
    add ax, bx                       ; Add current digit to the total
    inc si                           ; Move to next digit
    cmp [si], '$'           ; Check if reached the end of user input
    je convertDecDone                   ; Exit the loop if end marker is reached
    jmp convertDecLoop                  ; Continue the loop if not reached the end
              ; Continue the loop if not reached the end

convertDecDone:
    ; Check if the number is within the valid range
    cmp ax, 1
    jl inputError
    cmp ax, 3100
    jg inputError

    ; Save the number into the variable
    mov convertedNumber, ax

    ; Continue with your code here...

    jmp exitProgram

inputError:
    ; Display error message
    lea dx, errorMessage
    mov ah, 09h
    int 21h
    jmp main

exitProgram:
    mov ah, 4ch
    int 21h

endp
end main
