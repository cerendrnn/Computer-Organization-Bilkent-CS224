####################################################################################################################

#Author: Ayb�ke Ceren Duran
#Lab02 Preliminary question 1a
#Section: 03
#ID: 21302686

####################################################################################################################
.data
   myOctalNumber: .asciiz "20" # octal number 20 is declared
   tempArray: .space 80

   
.text
   la $a0, myOctalNumber
   la $a2, tempArray
   addi $a2, $a2, 1 #to overcome word align problem
   move $t9, $a2
   move $t0, $a0 # for further use, the address is copied into $t0                   
   move $t3, $a0 #it will be used for iteration later
   li $t6,1
   
   #in the base-8, the digits from 0 to 7 are used, so this condition will be checked.
   #in the ASCII table, the digit 7 is encoded as 0x37
   #in the ASCII table, the digit 0 is encoded as 0x30
   
   li $t5, 0x37 
   
   li $s1, 2 # the register $s1 is used for holding the size of the octal number    
   li $s2, 0 #decimal value in initialized as 0.           
   li $s3, 0   
   li $t4, 0#this will be used for holding the size of temporary array later.
   
   jal convertToDec
   
   li $v0,10
   syscall
  
  convertToDec:
   addi $sp, $sp, -16
   sw  $s3, 0($sp)#isValidOctal will use $s3 later :)
   sw  $s2, 4($sp)
   sw  $s1, 8($sp)
   sw  $ra, 12($sp)
  
   #now, check the condition whether if the given number is octal or not.
   jal isValidOctal
   lw  $s3, 0($sp)
   lw  $s2, 4($sp)
   lw  $s1, 8($sp)
   lw  $ra, 12($sp)
   addi $sp, $sp, 16  
   jr $ra
   
  
  isValidOctal:
   lb $s3, 0($t3) # in the function convertToDec, value of $s3 IS IN THE STACK
   beq $s3, 0x00, doCalculations#if the null character is encountered, go to lastStep
   #as mentioned above, $t5 holds 0x37 which is the digit 7 in ASCII table
   #we will check whether if the byte of the input number is greater that 7
   sgt $t7, $s3, $t5 # $t7 holds the result of the condition above
   bne $t7, 1, yesValid
   
  yesValid:
   addi $t3, $t3, 1
   subi $t7, $s3, 48# when we subtract 48, we get the actual number
   sw $t7, 0($t9)#I stored decimal ASCIIS in temporary array
   addi $t4, $t4, 1 #update the size of the temporary array as you put elements.
   add $t9, $t9, 4
   j isValidOctal  
   
  doCalculations: 
   subi $t4, $t4, 1
   beqz $t4, sum
   lw $t7, 0($a2) #get digits from the temporary array
   move $t8, $t4 # copied for further use
   bge $t8, 1, intCalc
   blt $t8, 1, continue
 
 intCalc:
   mul $t6, $t6, 8#$t6 will hold 8^N
   subi $t8, $t8, 1
   beq $t8, 0, continue
   j intCalc
 
 continue:
   mul $t5, $t6, $t7
   li $t6, 1
   add $s2, $s2, $t5
   add $a2, $a2, 4
   j doCalculations
   
 sum:
   lw $t7, 0($a2)
   add $s2, $s2, $t7
   j printNow
 
 printNow:
   move $a0, $s2
   li $v0,1
   syscall
   jr $ra   
  
  
      
  
   
  
   
 
   
   
   
   
   
   
   
   
  
  
