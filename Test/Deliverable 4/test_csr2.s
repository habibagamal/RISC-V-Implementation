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
# Instructions and Data
c.li    x1, 20;
csrrwi  x0, 0xb03,  3;
c.li    x2, 30;
csrrw   x3, 0xb00, x2;
csrrw   x3, 0xb01, x2;
csrrci 	x0, 0x304, 1;
c.li    x9,9;
c.li 	x10, 10;
ebreak;
c.slli x10, 2;
c.li    x4, 4;
c.li    x5, 5;
c.li    x6, 6;
ecall;
add     x7, x2, x6; #X7 = 36
sub     x7, x4, x5; #X7 = -1
c.ebreak;
c.li    x8, 8; #X8 = 8
c.srai  x8, 2; #X8 = 2

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

#D07340D1
#4179B031
#B00111F3
#B01111F3

#452944A5
#050A0902
#42954211
#00734319
#03B30000
#03B30061
#90024052
#84094421
