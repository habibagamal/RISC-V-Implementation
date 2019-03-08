/*********************************************************
 *
 *  Module: mux2_1.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: 2 by 1 Multiplexer
 *
 *********************************************************/
`timescale 1ns/1ns

module mux2_1 (
    sel,
    in1,
    in2,
    out
);
    parameter N=1;
    output [N-1:0] out;
    input [N-1:0] in1;
    input [N-1:0] in2;
    input sel;
    
    assign out = (sel)?in2:in1;
endmodule