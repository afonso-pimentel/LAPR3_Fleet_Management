.section .data
	

.section .text
	.global slot_status
	
slot_status:
	movl %esi, %edx # our function should be slot_status(pointer_to_the_matrix, ship_capacity)
	movl $0, %ecx # lets start the counter of filled positions at 0
	jmp incrementation
	
incrementation:
	subl $1, %edx	#subtracts 1 to the max capacity
	cmpl $0, (%rdi)	#checks if current position in the matrix is empty
	jne filled_position # if not, it jumps to filled_position
	cmpl $0, %edx # if it is 0, the max capacity is 0
	je end # if we have reached the max capacity, we end the program
	addq $4, %rdi # we increment one position in the matrix
	jmp incrementation # loop restart

filled_position:
	addl $1, %ecx # if filled, we increment one
	cmpl $0, %edx # if it is 0, the max capacity is 0
	je end # if we have reached the max capacity, we end the program
	addq $4, %rdi # we increment one position in the matrix
	jmp incrementation # loop restart
	
end:
	subl %ecx, %esi # we subtract the number of filled positions to the total
	movl %esi, %eax # copies the number of free positions to %eax
	rolq $8, %rax # rotates the number to the most significant bytes
	addl %ecx, %eax # adds the filled positions to the least significant bytes

	ret
	
	
