_strlen:
    mov X0, #0
_strlen_loop:
    ldrb W2, [X1, X0]
    cmp W2, #0
    beq _strlen_done
    add X0, X0, #1
    b _strlen_loop
_strlen_done:
    ret 

