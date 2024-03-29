#project stuff
# $6  C
# $7  A
# $8  B:0xFA19E366
# $10 multiply fold variable
# $11 LC
# $15 LC OuterLoop
# $12 hi
# $13 lo
# $14 n
# $16 address 
# $17 MAXv
# $18 MaxAddr
# $4
# $23 flag
# $20 MaxC value addr flag
# $19 MaxC address addr flag
# $9
# $21
lui $8, 0xFA19        # Initialize B
ori $8, $8, 0xE366
addi $7, $0, 1	      # Initialize A
addi $16, $0, 0x2020

addi $15, $0, 100
loop_Outer:
     



addi $11, $0, 5
multu $7, $8        # [hi,lo] = A * B
##############################
# Loop_5fold is meant to save on registers and automate the hash fold function
# Loop_5fold C code equivalent:
# for(i=0;i<5;i++)
# { mult(A,B);  (result is stored in 'n')
#   hi = x;
#   lo = y;
#   xor(n,x,y);
#   mult(n,B);
# }
#############################
loop_5fold:
mfhi $12
mflo $13
xor $14, $12, $13
multu $14, $8
addi $11, $11, -1
bne $11, $0, loop_5fold

andi $12, $14, 0xffff               # C = A5[31:16] XOR A5[15:0]
srl $14, $14, 16
andi $13, $14, 0xffff

xor $6, $12, $13                    #endof C = A5[31:16] XOR A5[15:0]

andi $12, $6, 0xff                  # C = C[15:8] XOR C[7:0]
srl $6, $6, 8
andi $13, $6, 0xff

xor $6, $12, $13		    #endof C = C[15:8] XOR C[7:0]

slt $4, $17, $6                     #if (MaxV<C){ MaxV = C}
beq $4, $0, Endif

add $17, $0, $6                     # MaxV = C;
addi $20, $0, 0x2000
sw $17, 0($20)

add $18, $0, $16                   # MaxAddr = Current Address;
addi $19, $0, 0x2004
sw $18, 0($19) 		    

Endif:
sb $6, 0($16)                       #Store C in Current Address
addi $16, $16, 1                    # Move current address to next address

addi $22, $0, 4
loop_bleh:
addi $4, $0, 4
addi $9, $0, 0x0000001f

andi $21, $6, 0xfffff
bne $21, $9, jump
addi $23, $23, 1

jump:
srl $6,$6, 4
addi $22, $22, -1
bne $22, $0, loop_bleh

addi $15, $15, -1                   #decrement outlerloop Counter
addi $7, $7, 1                      #increment A value
bne $15, $0, loop_Outer	
