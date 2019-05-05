		;		ARM Programming Assignment #4: Encode in Hamming(15, 11)
		;
		;		Write a subroutine that encodes 11 bits of data into a 15-bit
		;       block, using 4 parity bits. Assume even parity, that is,
		;       the parity of the bits covered by a parity bit, including
		;       the parity bit, has to be an even number. Assume the bits are
		;       written in the following sequence: p1, p2, d1, p4, d2, d3, d4,
		;       p8, d5, d6, d7, d8, d9, d10, d11, p16, d12, d13, d14, d15.
		;       Call the subroutine `hencode`.
		;
		;       Write a subroutine that decodes a H(15, 11) block to extract
		;       the 11 data bits. Call it `hdecode`. It should:
		;       - calculate the correcting code
		;       - dentify the case: no error (noer), one-bit error (onee)
		;       - write the result in `case` using the encoding provided
		;       - if there is a one-bit error, write the number of the
		;         erroneous bit in `berr`
		;       - if there is a one-bit error, correct the data
		;       - write the result in `corr`
		;
		;       Now, write a main function which uses `hencode` and `decode`
		;       to encode `data` and then, after a simulated transmission,
		;       decode `recv`. Assume that `recv` contains what is received
		;       at the other end.

		;		Your code here

data	DCD		0b10100100101
recv    DCD     0b101111010100101

noer    DCD     0x00
onee    DCD     0x01

case    FILL    4
berr    FILL    4
corr    FILL    4
hencode
		adr		r1, data
		LDR		R1, [R1]
		
		AND		R2, R1, #0x1		; Clear all bits apart from d0 which will be the position of first parity bit
		MOV		R0, R2, LSL #2		; Align data bit d0
		
		AND		R2, R1, #0xE		; Clear all bits apart from d1, d2, & d3
		ORR		R0, R0, R2, LSL #3	; Align data bits d1, d2 & d3 and combine with d0
		
		AND		R2, R1, #0xF0		; Clear all bits apart from d3-d7
		ORR		R0, R0, R2, LSL #4	; Align data bits d4-d7 and combine with d0-d3
		
		
		
		EOR		R2, R0, R0, LSR #2	; Get p0 parity bit
		AND		R2, R2, #0x1		; Clear all but check bit p0
		ORR		R0, R0, R2		; Combine check bit c0 with number
		
		
		EOR		R2, R0, R0, LSR #1	; Generate p1 parity bit
		AND		R2, R2, #0x2		; Clear all but parity bit
		ORR		R0, R0, R2		; Combine parity bit with number
		
		
		
		EOR		R2, R0, R0, LSR #1  ; Gnerate p2 parity bit..
		AND		R2, R2, #0x8
		ORR		R0, R0, R2
		
		
		
		EOR		R2, R0, R0, LSR #1 ; Generate p3
		AND		R2, R2, #0x80
		ORR		R0, R0, R2
		
		
		
decode
		adr		r3, recv
		ldr		r3, [r3]
		
		AND		R3, R0, R3
		EOR		R2, R3, R3, LSR #2	; Generate p0 parity bit
		AND		R2, R2, #0x1		; Clear all but parity p0
		ORR		R3, R3, R2		; Combine with result
		
		EOR		R2, R3, R3, LSR #1	; Generate p1 parity bit
		AND		R2, R2, #0x2		; Clear all but parity bit p1
		ORR		R3, R3, R2		; Combine with result
		
		EOR		R2, R3, R3, LSR #1	; Generate p2 parity bit
		AND		R2, R2, #0x8		; Clear all but parity bit p2
		ORR		R3, R3, R2		; Combine with result
		
		EOR		R2, R3, R3, LSR #1	; Generate p3 parity bit
		AND		R2, R2, #0x80		; Clear all but parity bit
		ORR		R3, R3, R2		; Combine with result
		
		EOR		R1, R0, R3          ;Compare	recv and the hamming value
		LDR		R4, =0X80           ;Clearing and shifting positions right
		AND		R4, R4, R1
		MOV		R4, R4, LSR #4
		
		
		LDR		R5, =0X8    ;Clearing all bits apart from p3 and shifting the 3rd bit 1 position right
		AND		R5, R5, R1
		MOV		R5, R5, LSR #1
		
		LDR		R6, =0X3   ; Clear bit aside from p1 and p0
		AND		R6, R6, R1
		
		
		ADD		R1, R4, R5
		ADD		R1, R1, R6
		
		
		SUB		R1, R1, #1   ;Subtract 1 from R1 to determine the position of the error
		LDR		R7, =0XB
		MOV		R7, R7, LSL R1
		
		END
