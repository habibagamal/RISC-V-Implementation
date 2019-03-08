# IRQ0 handler
c.nop;
c.nop; 
c.li    x31, 4;
c.nop; 
mret;
c.nop;
c.nop; 
# IRQ1 handler
c.nop;
c.nop; 
c.li    x31, 5;
c.nop; 
mret;
c.nop;
c.nop; 
# IRQ2 handler
c.nop;
c.nop; 
c.li    x31, 6;
c.nop; 
mret;
c.nop;
c.nop; 
# IRQ3 handler
c.nop;
c.nop; 
c.li    x31, 7;
c.nop; 
mret;
c.nop;
c.nop; 
# IRQ4 handler
c.nop;
c.nop; 
c.li    x31, 9;
c.nop; 
mret;
c.nop;
c.nop; 
# IRQ5 handler
c.nop;
c.nop; 
c.li    x31, 10;
c.nop; 
mret;
c.nop;
c.nop; 
# IRQ6 handler
c.nop;
c.nop; 
c.li    x31, 11;
c.nop; 
mret;
c.nop;
c.nop; 
# IRQ7 handler
c.nop;
c.nop; 
c.li    x31, 12;
c.nop; 
mret;
c.nop;
c.nop; 
#program 
.text
main:
    li  x1, 1
    li  x2, 2
    li  x3, 3
    
    add x5, x1, x2      # 3
    sub x6, x5, x1      # 4
    slli x7, x3, 3       # 24
    or  x8, x7, x3      # 27
    
    li  x10, 0xFFFF
    li  x14, 800
    sw  x10, 0(x14)
    lbu x5, 0(x14)       # 0x000000A0
    lb  x6, 0(x14)       # 0xffffffe2
    srai x7, x5, 2       # 0x00000028
    srai x8, x6, 2       # 0xFFFFFFF8
    srli x9, x6, 2       # 0x3FFFFFF8
    
    slt x16, x8, x0
    sltu x17, x9, x0    # << fixed! 
    
    li x11, 804
    li x13, 0xffff
    sw  x13, 0(x11)
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
    ecall
    
exit:
    li  x31, 1
    li  a0, 10
    ecall
    


#@00000040
#00010001    
#00014F91    
#30200073    
#00010001    
      
#00010001    
#00014F95    
#30200073   
#00010001    
      
#00010001    
#00014F99    
#30200073   
#00010001    
      
#00010001    
#00014F9D    
#30200073    
#00010001    
      
#00010001    
#00014FA5    
#30200073    
#00010001    
      
#00010001    
#00014FA9   
#30200073    
#00010001    
      
#00010001    
#00014FAD   
#30200073    
#00010001    
      
#00010001    
#00014FB1    
#30200073    
#00010001    
      
#00100093    
#00200113    
#00300193    
#002082B3    
#40128333    
#00319393    
#0033E433   
#FFF00513    
#32000713    
#00A72023    
#00074283    
#00070303    
#4022D393    
#40235413    
#00235493    
#00042833    
#0004B8B3    
#32400593    
#FFF00693    
#00D5A023    
#0005A903    
#0125A223    
#0045A983    
#000F0CB7    
#00FF0D37    
#000F0D97    
#00FFFE17    
#00000463    
#0280006F    
#00100A13    
#00309463    
#01C0006F    
#00200A13    
#0011C463    
#0100006F    
#00400113    
#02000F93    
#0100006F    
#FFF00F93   
#00A00513    
#00000073    
#00100F93    
#00A00513   
#00000073   
