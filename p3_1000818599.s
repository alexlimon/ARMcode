.global main
.func main
   
main:
    BL _numberinput
    MOV R7, R0
    MOV R0, #0              





writeloop:
    CMP R0, #20             
    BEQ writedone           
    LDR R1, =array_a       
    LSL R2, R0, #2          
    ADD R2, R1, R2
    ADD R8, R7, R0
    STR R8, [R2]
    ADD R2, R2, #4
    ADD R8, R8, #1
    NEG R8, R8
    STR R8, [R2]
    ADD R0, R0, #2  
    B   writeloop           
writedone:
    MOV R0, #0              @ initialze index variable

sort:
    
    
    outerloop:
            CMP R0, #20
            BEQ sortdone
            MOV R5, #2000
            MOV R1, #0
            CMP R0, #1
            LDRGE R6, [R10]
            NEGLT R6, R5
            LDR R10, =array_b
            LSL R2, R0, #2
            ADD R10, R10, R2
            innerloop:
                    CMP R1, #20
                    ADDEQ R0, R0, #1
                    STREQ R5, [R10]
                    BEQ outerloop
                    LDR R9, =array_a
                    LSL R2, R1, #2
                    ADD R9, R9, R2
                    LDR R11, [R9]
                    CMP R11, R5
                    ADDGT R1, R1,#1
                    BGT innerloop
                    CMPLT R11, R6
                    MOVGT R5, R11
                    ADD R1, R1, #1
                    B innerloop
sortdone:
    MOV R0, #0

readloop:
    CMP R0, #20          @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =array_a        @ get address of a
    LDR R4, =array_b
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]
    LSL R5, R0, #2
    ADD R5, R5, R4
    LDR R3, [R5]
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}
    PUSH {R3}
    
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf 
    POP {R3}
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
    B _exit                 @ exit if done
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


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
    POP {PC}                @ restore the stack pointer and return
   
.data

.balign 4
array_a:        .skip       80
array_b:        .skip       80


printf_str:     .asciz      "array_a[%d]= %d, array_b= %d\n" 
format_str:     .asciz      "%d"
exit_str:       .ascii      "Terminating program.\n"
