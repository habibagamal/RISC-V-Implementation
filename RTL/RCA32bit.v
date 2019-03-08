/*********************************************************
 *
 *  Module: RCA32bit.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: 32 bit Ripple Carry Adder
 *
 *********************************************************/
`timescale 1ns/1ns

module RCA32bit(a, b, addsub, cout, vFlag, sum);
    parameter N = 32;   // size of operands and output
    input [N-1:0] a;    // operand 1
    input [N-1:0] b;    // operand 2
    input addsub;       // 0 for add 1 for sub
    output [N-1:0] sum; // output
    output cout;        // carry out flag
    output vFlag;       // overflow flag
    
    
    wire [N:0] c;
    assign c[0] = addsub;
    assign cout = c[N];
    assign vFlag = c[N] ^ c[N-1];
    genvar i;
    generate        // generate N Full Adders to calculate result
        for(i = 0; i < N; i = i+1) begin : RCA
            FA f(.a(a[i]), .b(b[i]^addsub), .cin(c[i]), .cout(c[i+1]), .sum(sum[i]));
        end 
    endgenerate
endmodule