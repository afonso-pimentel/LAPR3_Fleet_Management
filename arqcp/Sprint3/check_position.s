.section .data
	

.section .text
	.global check_position

check_position:
	imull $36, %esi # multiplies number of bytes needed to change the x position on the matrix
	movl %esi, %eax # copies it to eax
	imull $12, %edx # multiplies number of bytes needed to change the y position on the matrix
	addl %edx, %eax # adds it to eax
	imull $4, %ecx	# multiplies number of bytes needed to change the z position on the matrix
	adcl %ecx, %eax # adds it to eax 
	
	addq %rax, %rdi  # sends the pointer to the position wanted
	movl (%rdi), %eax # for debug purposes
	cmpl $0, (%rdi) # if the position has a 0, it is empty
	jne is_occupied
	movb $0, %al # 0 is sent to the return register
	jmp end


is_occupied:
	movb $1, %al # 1 is sent to the return register
	jmp end
	
end:
	ret
	
	
