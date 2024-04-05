.global _start             // Provide program starting address to linker
.p2align 3


_print: mov X0, #1     // 1 = StdOut
        mov X16, #4     // MacOS write system call
        svc 0     // Call linux to output the string
        ret

_start: adr X1, helloworld // string to print
        mov X2, #13     // length of our string
        bl _print

        adr X1, othermessage
        mov X2, #28
        bl _print

        adr X1, cake
        mov X2, #20
        bl _print

        mov     X0, #0
        mov     X16, #1
        svc     #0x80

helloworld:      .ascii  "Hello World!\n"
othermessage:   .ascii  "This is Apple Silicon ASM!\n"
cake:           .ascii  "The cake is a lie!\n"
