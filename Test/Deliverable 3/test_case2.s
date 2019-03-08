        .text
        
        li  x1, 10
        li  x2, 20
        li  x3, 30
        li  x4, 40
        li  x5, 50
    test_R:
        add x6, x1, x2
        sub x7, x5, x1
        and x8, x5, x3
        or  x9, x4, x2
        xor x10, x5, x2
    test_I:
        addi    x11, x5, 121
        andi    x12, x5, 0xff
        ori     x13, x5, 0x121
        slli    x14, x5, 3
        srli    x15, x5, 3
    test_branch:
        beq     x1, x2, error
        bne     x3, x3, error
        blt     x2, x5, next
        jal     x0, error
    next:
        li      x31, 1
        jal     x30, subroutine
        li      x31, 2
    
        jal     x0, stop
        
    subroutine:
        li      x29, 5
        jalr    x0, x30, 0
        
    error:
        li      x31, 0xffffffff
        
    stop:
        li      a0, 10
