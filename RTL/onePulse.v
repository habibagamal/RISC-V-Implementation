/*********************************************************
 *
 *  Module: onePulse.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Edge detector that outputs a signal that lasts for one clock cycle
 *
 *********************************************************/
`timescale 1ns/1ns

module onePulse(clk, in, out);
    input clk;
    input in;
    output out;
    
    reg delay;
    
    always @ (posedge clk) begin
        delay <= in;
    end
    
    assign out = in & ~delay;    
endmodule
