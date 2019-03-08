    .text
main:
    li  x1, 1
    li  x2, 2
    li  x3, 3
    
    la  x10, A
    la  x11, B
    la  x12, C
    la  x13, D
    la  x14, X
    
    add x5, x1, x2      # 3
    sub x6, x5, x1      # 4
    slli x7, x3, 3       # 24
    or  x8, x7, x3      # 27
    
    lbu x5, 0(x14)       # 0x000000A0
    lb  x6, 1(x14)       # 0xffffffe2
    srai x7, x5, 2       # 0x00000028
    srai x8, x6, 2       # 0xFFFFFFF8
    srli x9, x6, 2       # 0x3FFFFFF8
    
    slt x16, x8, x0
    sltu x17, x9, x0    # << fixed! 
    
    lw  x18, 0(x11)
    sw  x18, 4(x11)     # << fixed!
    lw  x19, 4(x11)     # << fixed!
    
    
    lui x25, 0xf0
    lui x26, 0xff0
    
    auipc   x27, 0xf0
    auipc   x28, 0xfff
    
    beq x0, x0, next_1
    jal x0, error
    
next_1:
    li  x20, 1
    bne x1, x3, next_2
    jal x0, error
    
next_2:
    li  x20, 2
    blt x3, x1, next_4
    jal x0, error
    
next_4:
    li x2, 4
    li  x31, 0x20
    jal x0, exit
    
error:
    li  x31, 0xfff
    li  a0, 10
    
exit:
    li  x31, 1
    li  a0, 10

    
    .data
A:  .word   1, 2, 3, 4
B:  .word   100, 200, 300, 400
C:  .half   10, 20, 30
D:  .byte   5, 6, 7
X:  .byte   0xA0, 0xE2
