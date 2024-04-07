.include "io.asm"

.global _start             // Provide program starting address to linker
.p2align 3

.text
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

        // Exit with return code 0
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