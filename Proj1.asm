#project stuff
#
# $7  A
# $8  B:0xFA19E366
# $10 multiply fold variable
# $11 loopCounter
# $12 hi
# $13 lo
# $14 n
#
#
lui $8, 0xFA19        # Initialize B
ori $8, $8, 0xE366
addi $7, $0, 1

addi $11, $0, 5
multu $7, $8        # [hi,lo] = A * B

loop_5fold:
mfhi $12
mflo $13
xor $14, $12, $13
multu $14, $8
addi $11, $11, -1
bne $11, $0, loop_5fold

