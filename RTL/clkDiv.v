/*********************************************************
 *
 *  Module: clkDiv.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Clock Divider
 *
 *********************************************************/
`timescale 1ns / 1ns

module clkDiv(clock_in, clock_out, rst);

    input clock_in;
    output clock_out;
    input rst;
    
    reg[27:0] counter = 28'd0;
    parameter DIVISOR = 28'd2;

    always @(posedge clock_in or posedge rst) begin
        if (rst == 1'b1) begin
            counter <= (DIVISOR-1);
        end
        else begin
            counter <= counter + 28'd1;
            if(counter >= (DIVISOR-1))
                counter <= 28'd0;
        end
    end
    
    assign clock_out = (counter < DIVISOR/2) ? 1'b0 : 1'b1;
    
endmodule


