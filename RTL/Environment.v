/*********************************************************
 *
 *  Module: Environment.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Environment including CPU and PIC
 *
 *********************************************************/
`timescale 1ns / 1ns

module Environment(clk, rst, NMI, IRQ, hunterOut);
    
    input clk;
    input rst;
    input NMI;
    input [7:0] IRQ;
    output [31:0] hunterOut;
    
    wire INT;
    wire [2:0] INT_NUM;
    wire [1:0] memOp;
    wire [31:0] memOut, memIn;
    wire [9:0] memAddr;
    
    hunter_RV32 CPU (.clk(clk), .rst(rst), .NMI(NMI), .INT(INT), .INT_NUM(INT_NUM),
                     .memOut(memOut), .memInOUT(memIn), .memOpOUT(memOp), .memAddrOUT(memAddr), .hunterOut(hunterOut));
    
    memory mem (.clk(clk), .rst(rst), .mem_op(memOp), .dataIn(memIn), .addr(memAddr), .dataOut(memOut));
    
    PIC pic (.IRQ(IRQ), .INT(INT), .INT_NUM(INT_NUM));
    
endmodule 

 

