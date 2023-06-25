.section .data
	

.section .text
	.global total_occupied_array
	
total_occupied_array:

	pushq %rdx # position array capacity
	
	movl $0, %ecx # lets start the counter of filled positions at 0
	pushq %rcx # save the number of filled positions 
	
	movq %rsi, %rax # copy the position array to rax 
	
	jmp incrementation
	
incrementation:
	movl (%rax), %esi # x position to 2nd argument
	addq $4, %rax # iterates to the array next position
	movl (%rax), %edx # y position to 3rd argument
	addq $4, %rax # iterates to the array next position
	movl (%rax), %ecx # z position to 4th argument
	pushq %rax # saves the address of the array in the z position
	
	pushq %rdi # array with containers
	call check_position # if position is filled returns al=1, else al=0
	popq %rdi # restores array in its right position
	cmpb $1, %al
	je filled_position # if position is filled jumps, else continues
	
	popq %rax
	popq %rcx
	popq %rdx
	subl $1, %edx
	cmpl $0, %edx # if it is 0, the max capacity is 0
	je end # if we have reached the max capacity, we end the program
	
	addq $4, %rax #iterates to the next x position
	
	pushq %rdx
	pushq %rcx
	jmp incrementation # loop restart


filled_position:
	popq %rax
	popq %rcx
	popq %rdx
	
	addl $1, %ecx # if filled, we increment one to the counter
	
	subl $1, %edx # subtracts one to the max capacity
	cmpl $0, %edx # if it is 0, the max capacity is 0
	je end # if we have reached the max capacity, we end the program
	
	addq $4, %rax #iterates to the next x position
	
	pushq %rdx
	pushq %rcx
	
	jmp incrementation # loop restart
	
end:
	movq %rcx, %rax
	ret
	
	
