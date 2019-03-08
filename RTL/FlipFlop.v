/*********************************************************
 *
 *  Module: FlipFlop.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Flipflop
 *
 *********************************************************/
`timescale 1ns/1ns

module FlipFlop(
    input clk, 
    input rst, 
    input d, 
    output reg [0:0] q
);

    always @(posedge clk or posedge rst) begin
        if(rst == 1)
            q<=0;
        else
            q<=d;
    end

endmodule

