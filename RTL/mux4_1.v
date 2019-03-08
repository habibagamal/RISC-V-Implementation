/*********************************************************
 *
 *  Module: mux4_1.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: 4 by 1 Multiplexer
 *
 *********************************************************/
`timescale 1ns/1ns

module mux4_1 (
    sel,
    in1,
    in2,
    in3,
    in4,
    out
);
    parameter N=1;
    input [1:0] sel;
    input [N-1:0] in1;
    input [N-1:0] in2;
    input [N-1:0] in3;
    input [N-1:0] in4;
    output reg [N-1:0] out;
    
    always @(*) begin
        case(sel)
            2'b00: out = in1;
            2'b01: out = in2;
            2'b10: out = in3;
            2'b11: out = in4;
        endcase
    end
    
endmodule