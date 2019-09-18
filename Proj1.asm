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
#
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
sw $6, 0($16)
addi $16, $16, 4

addi $15, $15, -1
addi $7, $7, 1
bne $15, $0, loop_Outer
