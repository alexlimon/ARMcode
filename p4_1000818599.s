.global main
.func main
   
main:
    BL _numberinput
    MOV R4, R0
    BL _numberinput
    MOV R5, R0
    MOV R1, R4
    MOV R2, R5
    BL _printf
    
    VMOV S0, R4
    VMOV S1, R5


    VCVT.F32.U32 S0, S0
    VCVT.F32.U32 S1, S1
    VDIV.F32 S2, S0, S1   
    VCVT.F64.F32 D4, S2
    VMOV R1, R2, D4
    BL _printf2
    B main



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

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}  

_printf2:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str1     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}  

.data

printf_str:     .asciz      "%d / %d "
printf_str1:    .asciz      "= %.02f\n" 
format_str:     .asciz      "%d"
