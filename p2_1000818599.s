
    .global main
    .func main


main:
    BL  _scanf              @ branch to scan procedure with return
    MOV R4, R0              @ store n in R4
    PUSH {R4}
    BL  _scanf   
    MOV R5, R0              @ store m in R5
    PUSH {R5}
    MOV R1, R4              @ move n and m in argument registers
    MOV R2, R5
    BL  _countpart          @ branch to count partition procedure with return
    MOV R1, R0              @ pass result to printf procedure
    POP {R5}
    POP {R4}
    MOV R2, R4              @ pass n to printf procedure
    MOV R3, R5              @ pass m to printf procedure
    
    BL  _printf             @ branch to print procedure with return
    B main
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    @MOV R1, R1             @ R1 contains printf argument 1 (redundant line)
    @MOV R2, R2             @ R2 contains printf argument 2 (redundant line)
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
_scanf:
    PUSH {LR}               @ store the return address
    PUSH {R1}               @ backup regsiter value
    LDR R0, =format_str     @ R0 contains address of format string
    SUB SP, SP, #4          @ make room on stack
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {R1}                @ restore register value
    POP {PC}                @ restore the stack pointer and return


_countpart:
    PUSH {LR}
    
    CMP R1, #0 @ first base case if N equals 0
    MOVEQ R0, #1 @ returns 1 
    POPEQ {PC}
    
    MOVLT R0, #0 @ second base case if N is less than 0, returns 0
    POPLT {PC}
    
    CMP R2, #0 @ third base case if M equals 0
    MOVEQ R0, #0 @ returns 0
    POPEQ {PC}
  
    PUSH {R1}
    SUB R1, R1, R2  @ computing N - M
    PUSH {R2} 
    BL _countpart  @ parameters R1 is N-M and R2 is just M itself
    
    MOV R4, R0 @ grabbing the first calls return value and putting it into R4
    POP {R2}
    POP {R1}
    SUB R2, R2, #1 @ computing M -1
    PUSH {R4}
    BL _countpart @ parameters R1 is just the old N and R2 is M-1
    
    MOV R5, R0   @ grabbing the second calls return value and putting it into R5 
    POP {R4}
    ADD R0, R4, R5  @ adding the previous calls return values and returning that itself
    POP {PC}

    



.data
number:         .word       0
format_str:     .asciz      "%d"
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d\n"


 