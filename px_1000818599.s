.global main
.func main
   
main:
    MOV R0, #0              

writeloop:
    CMP R0, #10             
    BEQ writedone           
    LDR R1, =array_a       
    LSL R2, R0, #2          
    ADD R2, R1, R2
    PUSH {R0}
    PUSH {R1}
    PUSH {R2}
    BL _numberinput
    MOV R4, R0
    POP {R2}
    POP {R1}
    POP {R0}
    STR R4, [R2]
    ADD R0, R0, #1  
    B   writeloop           
writedone:
    MOV R0, #0   

printarray:
    CMP R0, #10             
    BEQ findmin          
    LDR R1, =array_a       
    LSL R2, R0, #2          
    ADD R2, R1, R2
    LDR R6, [R2] 
    PUSH {R0}
    PUSH {R1}
    PUSH {R2}
    MOV R1, R0
    MOV R2, R6
    BL _printi
    POP {R2}
    POP {R1}
    POP {R0}
    ADD R0, R0, #1  
    B   printarray 

findmin:
    LDR R5, = 0x55555555
    @MOV R5, #0x000000FF
    MOV R0, #0
    loop:
	CMP R0, #10             
    	BEQ mindone           
    	LDR R1, =array_a       
    	LSL R2, R0, #2          
    	ADD R2, R1, R2
    	LDR R6, [R2]
        CMP R6, R5
        MOVLT R5, R6
	ADD R0, R0, #1  
    	B   loop 
mindone: 
   MOV R1, R5
   BL _printmin
   MOV R5, #0
   MOV R0, #0

findmax:
   CMP R0, #10             
   BEQ maxdone           
   LDR R1, =array_a       
   LSL R2, R0, #2          
   ADD R2, R1, R2
   LDR R6, [R2]
   CMP R6, R5
   MOVGT R5, R6
   ADD R0, R0, #1  
   B   findmax

maxdone:
   MOV R1, R5
   BL _printmax
   MOV R5, #0
   MOV R0, #0

findsum:
   CMP R0, #10             
   BEQ sumdone           
   LDR R1, =array_a       
   LSL R2, R0, #2          
   ADD R2, R1, R2
   LDR R6, [R2]
   ADD R5, R5, R6
   ADD R0, R0, #1  
   B   findsum

sumdone:
   MOV R1, R5
   BL _printsum
   MOV R5, #0
   MOV R0, #0
   B _exit


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


_printi:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_i     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC} 

_printmin:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_min     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC} 

_printmax:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_max     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC} 

_printsum:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_sum     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC} 

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


.data

.balign 4
array_a:        .skip       40

printf_i:       .asciz      "array_a[%d]= %d\n" 
printf_min:     .asciz      "minimum = %d\n"
printf_max:     .asciz      "maximum = %d\n"
printf_sum:     .asciz      "sum = %d\n"
format_str:     .asciz      "%d"
exit_str:       .ascii      "Terminating program.\n"
