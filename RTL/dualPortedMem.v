/*********************************************************
 *
 *  Module: dualPortedMem.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Dual Ported Memory
 *
 *********************************************************/
`timescale 1ns/1ns

module DualPortedMem (clk, rst, memWriteA, memWriteB, addrA, addrB, dataInA, dataInB, dataOutA, dataOutB);

    input           clk;
    input           rst;
    input           memWriteA;
    input           memWriteB;
    input   [4:0]   addrA;
    input   [4:0]   addrB;
    input   [31:0]  dataInA;
    input   [31:0]  dataInB;
    output  [31:0]  dataOutA;
    output  [31:0]  dataOutB;
    
    reg     [31:0]  mem [31:0];
    
    always @ (posedge clk or posedge rst) begin 
        
        mem[0] <= 32'd0;
        if (rst == 1'b1) begin
            mem[0] <= 32'd0;
        end
        else begin
            
            if (memWriteA) begin
                if (addrA == 5'd0) begin
                    mem[0] <= 32'd0;
                end
                else begin 
                    mem[addrA] <= dataInA;
                end
            end
            
            if (memWriteB) begin
                if (addrB == 5'd0) begin
                    mem[0] <= 32'd0;
                end
                else begin 
                    mem[addrB] <= dataInB;
                end
            end
              
        end
        
    end

    assign  dataOutA = memWriteA ? 0 : mem[addrA];
    assign  dataOutB = memWriteB ? 0 : mem[addrB];

endmodule