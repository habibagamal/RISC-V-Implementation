/*********************************************************
 *
 *  Module: forwardingUnit.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Forwarding Control Unit
 *
 *********************************************************/
 `timescale 1ns/1ns
 
module forwardingUnit(MEM_WB_RD, ID_EX_RS1, ID_EX_RS2, MEM_WB_WRITE, fwdA, fwdB);

    input       [4:0]   MEM_WB_RD;
    input       [4:0]   ID_EX_RS1;
    input       [4:0]   ID_EX_RS2;
    input               MEM_WB_WRITE; 
    output reg  [0:0]   fwdA;
    output reg  [0:0]   fwdB;
    
    always @ (*) begin
        if (MEM_WB_WRITE && (MEM_WB_RD != 5'd0) && (MEM_WB_RD == ID_EX_RS1))
            fwdA = 1'b1;
        else 
            fwdA = 1'b0;
        if (MEM_WB_WRITE && (MEM_WB_RD != 5'd0) && (MEM_WB_RD == ID_EX_RS2))
            fwdB = 1'b1;
        else
            fwdB = 1'b0;
    end
    
endmodule