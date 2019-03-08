/*********************************************************
 *
 *  Module: mux4by1.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: 4 by 1 Multiplexer
 *
 *********************************************************/
`timescale 1ns/1ns

module mux4by1 (in0, in1, in2, in3, sel, out);

    input   [7:0] in0;
    input   [7:0] in1;
    input   [7:0] in2;
    input   [7:0] in3;
    input   [1:0] sel;
    output  reg [7:0] out;
    
    always @ (*) begin
        
        case (sel)
            2'b00:  out = in0;
            2'b01:  out = in1;
            2'b10:  out = in2;
            2'b11:  out = in3;
        endcase
        
    end
    

endmodule