# loop 100 x sw into memory: 1,2,3...100

#$8: loopCounter
#$9: n
#$10: address

addi $8, $0, 100
addi $9, $0, 1
ori $10, $0, 0x2000

loop_100:

sw $9, 0($10)

addi $9, $9, 1
addi $10, $10, 4
addi $8, $8, -1

bne $8, $0, loop_100
