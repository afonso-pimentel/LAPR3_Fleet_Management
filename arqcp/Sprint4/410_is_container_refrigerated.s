.section .data 

.equ STRUCT_SIZE, 48 #total size of Container struct
.equ X_OFFSET, 44 #OFFSET for X of struct
.equ Y_OFFSET, 45 #OFFSET for Y of struct
.equ Z_OFFSET, 46 #OFFSET for Z of struct
.equ TEMPERATURE_OFFSET, 47 #OFFSET for the temperature that the container must be refrigerated to

.section .text

.global is_container_refrigerated # unsigned char is_container_refrigerated(Container *ptrArrayContainers, int size_of_array, unsigned char x, unsigned char y, unsigned char z)

# %rdi = ptrArrayContainers
# %rsi = size_of_array
# %rdx = x
# %rcx = y
# %r8 = z

is_container_refrigerated:
	pushq %r9 # save r9
	pushq %r10 # save r10
	pushq %r11 # save r11
	
	movq %rdi, %r9 # save initial vector address on r9
	andq $0, %r10 # initialize counter
	andq $0, %rax # initialize return register at 0
	andq $0, %r11 # initialize %r11 at 0
	
is_container_refrigerated_loop:
	cmpl %r10d, %esi #compare counter with array size
	je is_container_refrigerated_end #if true it means the end of the vector has been reached

	movb X_OFFSET(%r9), %r11b #move X position to %r11b
	cmpb %dl, %r11b #compare expected X position with X position of current container
	jne failed_comparison #if comparison fails it means this is not the container at the expected position X,Y,Z
	
	movb Y_OFFSET(%r9), %r11b #move Y position to %r11b
	cmpb %cl, %r11b #compare expected Y position with Y position of current container
	jne failed_comparison #if comparison fails it means this is not the container at the expected position X,Y,Z
	
	movb Z_OFFSET(%r9), %r11b #move Z position to %r11b
	cmpb %r8b, %r11b #compare expected Z position with Z position of current container
	jne failed_comparison #if comparison fails it means this is not the container at the expected position X,Y,Z
	
	movb TEMPERATURE_OFFSET(%r9), %r11b #move TEMPERATURE value of the current container to %r11b
	cmpb $0, %r11b #compare the value of TEMPERATURE variable for the current container with 0
	je container_is_not_refrigerated #if condition verifies it means that the current container is not refrigerated
	jmp container_is_refrigerated #if the previous condition was false it means that the container is indeed refrigerated		

failed_comparison: #conditional branching for a failed comparison
	incl %r10d # increment counter
	addq $STRUCT_SIZE, %r9 # increment array address by one position
	jmp is_container_refrigerated_loop # jump to the start of the loop
		

container_is_refrigerated: #conditional branching to set container is refrigerated flag to 1
	movb $1, %al # move 1 to return value
	jmp is_container_refrigerated_end #jump to the end

container_is_not_refrigerated: #conditional branching to set container is refrigerated flag to 0
	movb $0, %al # move 0 to return value
	jmp is_container_refrigerated_end # jump to the end

is_container_refrigerated_end: #end of method
	popq %r11 #restore r11
	popq %r10 #restore r10
	popq %r9 #restore r9
	ret
