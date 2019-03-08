/*********************************************************
 *
 *  Module: csrFwdUnit.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Forwarding unit for CSR instructions
 *
 *********************************************************/
`timescale 1ns / 1ns

module csrFwdUnit(csrAddr_EX, csrAddr_WB, fwdCSR);
    input [11:0] csrAddr_EX;
    input [11:0] csrAddr_WB;
    output reg   fwdCSR;
    
    always @ (*) begin
        if ((csrAddr_EX == csrAddr_WB) && (csrAddr_EX != 12'hb00) && (csrAddr_EX != 12'hb01) && (csrAddr_EX != 12'hb02))
            fwdCSR = 1'b1;
        else
            fwdCSR = 1'b0;
    end
    
endmodule


