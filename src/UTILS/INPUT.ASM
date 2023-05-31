PROC waitForKeypress
            PUSH            AX
            MOV             AH, 00h             ; DOS Function: wait keypress
            INT             16h                 ; Run Keyboard interrupt
            POP             AX
            RET
ENDP