/*********************************************************
 *
 *  Module: alu.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Arithmatic and Logic Unit
 *
 *********************************************************/
`include "defines/defines.v"
`timescale 1ns/1ns

module ALU(a, b, op, out, zFlag, cFlag, vFlag);
    
    input [31:0] a;
    input [31:0] b;
    input [3:0] op;
    output reg [31:0] out;
    output reg [0:0] zFlag;
    output cFlag;
    output vFlag;
    wire [31:0] rcaOut;
    
    RCA32bit rca(.a(a), .b(b), .addsub(op[0]), .cout(cFlag), .vFlag(vFlag), .sum(rcaOut));
    
    always @ (*) begin

        case(op)
            `ALU_0P_ADD    : out = rcaOut;
            `ALU_0P_SUB    : out = rcaOut;
            `ALU_0P_AND    : out = a & b;
            `ALU_0P_OR     : out = a | b;
            `ALU_0P_XOR    : out = a ^ b;
            `ALU_0P_SLL    : out = a << b; // TODO: shifters
            `ALU_0P_SRL    : out = a >> b;
            `ALU_0P_SRA    : out = $signed(a) >>> b;
            `ALU_0P_LUI    : out = b;
            `ALU_0P_SRAI   : out = $signed(a) >>> b[4:0];
            default : out = 32'd0;
        endcase
        
        if (out == 0)
            zFlag = 1;
        else 
            zFlag = 0;
        
        //if (a[31] ^ b[31] ^ op[0] ^ cFlag ^ )    // TODO: check condition for overflow
        //    vFlag = 1;
        //else
        //    vFlag = 0;
    end
    
endmodule





