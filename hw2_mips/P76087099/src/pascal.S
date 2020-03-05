main:
    addi $a0, $zero, 10 # n = 10
    addi $a1, $zero, 5  # m = 5
    jal pascal          # call pascal(10, 5)
    j exit

pascal:
    beq $a0,$a1,return  # m == n
    beq $a1,$zero,return # m == 0
    # Save $ra register into stack
    addi $sp, $sp, -8
    sw $ra, 0x4($sp)    
    #call pascal (m-1,n-1)
    addi $a0,$a0,-1
    addi $a1,$a1,-1
    jal pascal 
    sw $v0,0x0($sp)
    #call pascal(m-1,n)
    addi $a1,$a1,1 
    jal pascal 
    #get result
    lw $t0,0x0($sp)
    add $v0,$v0,$t0
    #restore parameter
    addi $a0,$a0,1 
    # Load $ra register from stack
    lw $ra, 0x4($sp)    
    addi $sp, $sp, 8
    jr $ra
return:
    addi $v0,$zero,1
    jr $ra

exit:
