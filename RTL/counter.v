/*********************************************************
 *
 *  Module: counter.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Counter with enable and load
 *
 *********************************************************/
`timescale 1ns/1ns

module counter_32
(
    input clk,
    input rst, 
    input en,
    input ld,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    always @ (posedge clk or posedge rst) begin
        if (rst)
            data_out <= 32'd0;
        else if (en)
                if (ld)
                    data_out <= data_in;
                else 
                    data_out <= data_out + 32'b1;
        else
            data_out <= data_out; 
    end
    
endmodule

