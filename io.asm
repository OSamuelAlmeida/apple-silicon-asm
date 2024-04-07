.include "string.asm"

_error:
    b _error

_print: 
    stp X29, X30, [SP, #-16]!
    mov X29, SP
    bl _strlen

    mov X2, X0     // length of our string
    mov X0, #1     // 1 = StdOut
    mov X16, #4     // MacOS write system call
    svc #0x80       // syscall

    cmp X0, #0     
    blt _error 

    ldp X29, X30, [SP], #16
    ret

_println:
    stp X29, X30, [SP, #-16]!
    mov X29, SP
    bl _print

    adr X1, newline
    bl _print

    ldp X29, X30, [SP], #16
    ret

_readln:
    stp X29, X30, [SP, #-16]!
    mov X29, SP

    // Read user input into inputBuffer
    mov X0, #0                   // 0 = StdIn
    adrp X1, inputBuffer@page       
    add X1, X1, inputBuffer@pageoff
    mov X2, #63                  // 64 bytes max
    mov X16, #3                  // MacOS read system call
    svc #0x80                    // syscall

    // Check for errors
    cmp X0, #0
    blt _error

    // Replace newline with null terminator
    adrp X1, inputBuffer@page
    add X1, X1, inputBuffer@pageoff
    subs X2, X0, #1               // Subtract 1 from the number of bytes read to get the last byte's index
    add X3, X1, X2                // X3 = address of the last byte read
    strb wzr, [X3]               // Replace newline with null terminator

    ldp X29, X30, [SP], #16
    ret

newline: .asciz "\n"