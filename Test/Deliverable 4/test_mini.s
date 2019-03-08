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
c.li x8, 5
c.sub x8, x8
c.beqz x8, 4
c.li x8, 2
c.li x8, 3
c.bnez x8, 4
c.li x8, 5
c.li x8, 0
li x8, 400
c.sw x8, 0(x8)
c.lw x9, 0(x8)

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

# 8c014415
# 4409c011
# e011440d
# 44014415
# 0c800413
# 4004c000