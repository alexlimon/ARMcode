
 .global main
 .func main





main:
    BL  _numberinput        @ branch to get the first number
    MOV R4, R0              @ move return value R0 to argument register R4
    PUSH {R4}
    BL _operatorinput 
    MOV R5, R0
    PUSH {R5}
    BL  _numberinput
    MOV R6, R0
    POP {R5}
    POP {R4}
    MOV R2, R4
    MOV R1, R6
    CMP R5, #'+'
    BEQ _SUM 
    CMP R5, #'M'
    BEQ _MAX
    CMP R5, #'*'
    BEQ _PRODUCT
    CMP R5, #'-'
    BEQ _DIFFERENCE
    MOV R1, R0
    BL _printresult

    B   main              @ branch to exit procedure with no return
  
_numberinput:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string 
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {LR}
    MOV PC, LR              @ return

_operatorinput:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return


_printresult:
   PUSH {LR}
   LDR R0, =print_answer
   BL printf
   POP {PC}

_SUM:
   PUSH {LR}
   ADD R4, R2, R1
   MOV R0, R4
   POP {PC}

_MAX:
   PUSH {LR}
   CMP R2,R1
   MOVGE R0,R2
   POP {PC}

_PRODUCT:
   PUSH {LR}
   MUL R4, R2, R1
   MOV R0, R4
   POP {PC}

_DIFFERENCE:
   PUSH {LR}
   SUB R4, R2, R1
   MOV R0, R4
   POP {PC}
   
     
   
   
.data
format_str:     .asciz      "%d"
read_char:      .ascii      " "
print_answer:   .asciz      "%d"
