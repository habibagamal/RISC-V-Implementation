# reset handler
auipc  x5, 0;
addi   x5, x5, 0x180;
c.jr   x5;
c.nop;
c.nop;
c.nop;
# NMI handler
c.nop;
c.nop;
c.li    x31, 1;
c.nop;
mret;
c.nop;
c.nop;
# ecall handler
c.nop;
c.nop;
c.li    x31, 2;
c.nop;
mret;
c.nop;
c.nop;
# Ebreak handler
c.nop;
c.nop;
c.li    x31, 3;
c.nop;
mret;
c.nop;
c.nop;
# TMR handler
csrrwi  x31, 0xb03, 31;
mret; 
c.nop;
c.nop; 
c.nop;
c.nop; 

#@00000000
#00000297
#18028293
#00018282
#00010001
#00010001
#00014F85
#30200073
#00010001
#00010001
#00014F89
#30200073
#00010001
#00010001
#00014F8D
#30200073
#00010001
#B03FDFF3
#30200073
#00010001
#00010001


