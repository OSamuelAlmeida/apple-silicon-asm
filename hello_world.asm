.global _start             // Provide program starting address to linker
.p2align 3

_strlen:
        mov X0, #0
loop:
        ldrb W2, [X1, X0]
        cmp W2, #0
        beq done
        add X0, X0, #1
        b loop
done:
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
        mov X16, #4
        svc #0x80

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

        mov     X0, #0
        mov     X16, #1
        svc     #0x80

helloworld:     .asciz  "Hello World!"
othermessage:   .asciz  "This is Apple Silicon ASM!\n"
cake:           .asciz  "The cake is a lie!\n"
newline:        .asciz  "\n"
