		;		ARM Programming Assignment #4: Count the ones in a binary number
		;
		;		Write a program that counts the number of ones in a binary number,
		;       stored in a word (4 bytes). Its loop should run no more times than there
		;       are ones in the number. Write the count in `numones`. For the example
		;       number given below, the loop should only run 8 times, counting 8 ones.
		;
		;       Hint:
		;       The first significant instruction in the loop is SUB r1, r1, 1, which
		;       decrements the number, assuming it's stored in register r1. Now,
		;       remember your logical operations.
		;
		;       Bonus:
		;       1. (20 extra points) For the shortest program (by instruction count),
		;          because this operation has to be FAST.
		;       2. (30 extra points) For extending the program to counting the ones
		;          in any word-aligned contiguous region of memory.

		;		Your code here

example	DCD		0x0010070f
numones FILL    4

		adr		r2, example   ; get start address for number
		LDR		r2, [r2]	    ; load number into r0
		
loop		MOVS		r2, r2, LSR #1  ; shift right by one so rightmost bit is in carry flag
		ADC		r1,r1, #0		 ; increment when 1 is encountered
		CMP		r2, #0		 ; check if finsihed with number
		BNE		loop            ; keep shifting and checking rightmost bit until finsihed
		end
