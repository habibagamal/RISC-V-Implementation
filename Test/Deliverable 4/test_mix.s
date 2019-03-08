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
# Program
c.li x8, 1
c.li x9, 1
c.li x10, 1
c.li x11, 0
c.li x12, 0
c.li x13, 1
c.add x10, x9 #x10 = 2
c.and x10, x9 #x10 = 0
c.or x11, x9 #x11 = 1
c.xor x8, x9 #x8 = 0
add x8,x8,x9 #x8 = 1
c.andi x12, 1 #x12 = 0
sub x11, x10,x10 #x11 = 0
c.slli x13, 3 #x13 = 8
c.srli x13, 3 #x13 = 1
c.j 4
c.li x8, 0
c.li x8, 1
c.jal 4
c.li x8, 2
c.li x8, 3
c.jr x1 #infinite loop
c.li x8, 4 

# @00000040

# 00010001    
# 00014F91    
# 30200073    
# 00010001    
      
# 00010001    
# 00014F95    
# 30200073   
# 00010001    
      
# 00010001    
# 00014F99    
# 30200073   
# 00010001    
      
# 00010001    
# 00014F9D    
# 30200073    
# 00010001    
      
# 00010001    
# 00014FA5    
# 30200073    
# 00010001    
      
# 00010001    
# 00014FA9   
# 30200073    
# 00010001    
      
# 00010001    
# 00014FAD   
# 30200073    
# 00010001    
      
# 00010001    
# 00014FB1    
# 30200073    
# 00010001    
      
# 44854405    
# 45814505    
# 46854601    
# 8D659526   
# 8C258DC5    
# 8A059426    
# 40A505B3   
# 828D068E  

# 4401a011
# 20114405
# 440d4409
# 44118082

