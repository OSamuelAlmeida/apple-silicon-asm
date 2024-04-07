.global _start             // Provide program starting address to linker
.p2align 3


.text
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


_print: 
        // Store LR in stack
        stp X29, X30, [SP, #-16]!
        mov X29, SP
        bl _strlen

        mov X2, X0     // length of our string
        mov X0, #1     // 1 = StdOut
        mov X16, #4     // MacOS write system call
        svc #0x80    // Call linux to output the string
        cmp X0, #0     // Check the result
        blt _error 

        // Restore LR from stack
        ldp X29, X30, [SP], #16
        ret

_println:
        stp X29, X30, [SP, #-16]!
        mov X29, SP
        bl _print

        adr X1, newline
        mov X0, #1
        mov X2, #1
        mov X16, #4
        svc #0x80

        ldp X29, X30, [SP], #16
        ret

_readln:
        stp X29, X30, [SP, #-16]!
        mov X29, SP

        // Read user input into inputBuffer
        mov X0, #0
        adrp X1, inputBuffer@page
        add X1, X1, inputBuffer@pageoff
        mov X2, #63
        mov X16, #3
        svc #0x80

        // Replace newline with null terminator
        adrp X1, inputBuffer@page
        add X1, X1, inputBuffer@pageoff
        subs X2, X0, #1               // Subtract 1 from the number of bytes read to get the last byte's index
        add X3, X1, X2                // X3 = address of the last byte read
        strb wzr, [X3]               // Replace newline with null terminator

        ldp X29, X30, [SP], #16
        ret

_error:
        b _error

_start: 
        adr X1, helloworld // string to print
        bl _println

        adr X1, othermessage
        bl _print

        adr X1, cake
        bl _print

        adr X1, question
        bl _print
        bl _readln

        adr X1, helloyou
        bl _print

        adrp X1, inputBuffer@page
        add X1, X1, inputBuffer@pageoff
        bl _println

        mov     X0, #0
        mov     X16, #1
        svc     #0x80

helloworld:     .asciz  "Hello World!"
othermessage:   .asciz  "This is Apple Silicon ASM!\n"
cake:           .asciz  "The cake is a lie!\n"
newline:        .asciz  "\n"
question:       .asciz  "What is your name?: "
helloyou:       .asciz  "Hello, "

.data
inputBuffer:    .space  64