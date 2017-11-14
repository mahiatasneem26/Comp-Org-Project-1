	.data				#mark beginning of data segment

	user_input: .space 9		#allocate 9 bytes of storage for 8 charecters in global variable user_input
	askInput: 			#store charectar sequence of initial output string
		.asciiz "\n Input a string: \n"
	invalid_input:			#store charectar sequence to prompt if user_input is invalid
		.asciiz "\n Your input is invalid \n"
	valid_input:			#store charectar sequence to prompt if user_input is valid
		.asciiz "\n Your input is valid \n"

	.text				#mark beginning of text segment

main:
	li $v0, 4			#call code to print string in askInput
	la $a0, askInput		#load address of askInput in argument $a0
	syscall				#syscall to print askInput
	
	li $v0, 8			#call code to read string
	la $t0, user_input		#load address of user_input in register $t0
	la $a0, ($t0)			#load address of user_input in $t0 to argument register $a0
	la $a1, 9			#gets length of space in myWord to avoid exceeding memory limit
	syscall				#syscall to read user_input and store the string in memory
	
	addi $t7, $t0, 8		#add the value of the 9th byte of user_input to the register $t7

iterate_string:				#iterate through user_input to check if all the charectars are valid	
	lb $t1, 0($t0)			#load first byte of memory into register $t1
	blt $t1, 48, if_invalid		#branch to if_invalid label if value in $t1 is less than 48 (ASCII dec for number 0)		
	blt $t1, 58, if_valid		#branch to if_invalid label if value in $t1 is less than 58 (next ASCII dec for number 9)		
	blt $t1, 65, if_invalid		# 65 = ASCII dec for 'A'
	blt $t1, 71, if_valid		# 71 = ASCII dec for 'G' , user_input is valid up to 'F'
	blt $t1, 97, if_invalid		# 97 = ASCII dec for 'a'
	blt $t1, 103, if_valid	
	bgt $t1, 102, if_invalid	#branch to if_invalid if value in $t1 is greater than 102 (ASCII dec for 'f')

if_invalid:				#label to call invalid_input and exit program
	li $v0, 4
	la $a0, invalid_input
	syscall
	li $v0, 10			#call code to exit program
	syscall
if_valid:				#label to call valid_input and exit program
	addi $t0, $t0, 1		#increment offset of $t0 by 1
	bne $t0, $t7, iterate_string	#if offset of $t0 is not equal to $t7, branch to iterate_string to continue looping
	li $v0, 4
	la $a0, valid_input
	syscall
	li $v0, 10			#call code to exit program
	syscall
