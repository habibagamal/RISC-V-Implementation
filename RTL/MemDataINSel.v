/*********************************************************
 *
 *  Module: MemDataINSel.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: The selection line of the Multiplexer that chooses the input to the memory banks
 *
 *********************************************************/
`include "defines/defines.v"
`timescale 1ns/1ns

module MemDataINSel (addr_LSB, sel0, sel1, sel2, sel3);

    input       [1:0] addr_LSB;
    output reg  [1:0] sel0;
    output reg  [1:0] sel1;
    output reg  [1:0] sel2;
    output reg  [1:0] sel3;
    
    always @ (*) begin
       
        case (addr_LSB)
            `ADDR_LSB_00: begin
                sel3 = 2'd0; //bank 0
                sel2 = 2'd1;
                sel1 = 2'd2;
                sel0 = 2'd3; //bank 3
            end
            `ADDR_LSB_01: begin
                sel3 = 2'd3;
                sel2 = 2'd0;
                sel1 = 2'd1;
                sel0 = 2'd2;
            end
            `ADDR_LSB_10: begin
                sel3 = 2'd2;
                sel2 = 2'd3;
                sel1 = 2'd0;
                sel0 = 2'd1;
            end
            `ADDR_LSB_11: begin
                sel3 = 2'd1;
                sel2 = 2'd2;
                sel1 = 2'd3;
                sel0 = 2'd0;
            end
            default: begin 
                sel3 = 2'd0; //bank 0
                sel2 = 2'd1;
                sel1 = 2'd2;
                sel0 = 2'd3; //bank 3
            end
        endcase

    end

endmodule



