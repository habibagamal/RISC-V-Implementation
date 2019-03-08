/*********************************************************
 *
 *  Module: PIC.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Priority Encoder for external interrupts 
 *
 *********************************************************/

`timescale 1ns/1ns

module PIC (IRQ, INT, INT_NUM);

input [7:0] IRQ;
output reg [0:0] INT;
output reg [2:0] INT_NUM;

always @ (*) begin 

    if (IRQ[0] == 1'b1) begin
        INT = 1'b1;
        INT_NUM = 3'd0;
    end
    else if (IRQ[1] == 1'b1) begin
        INT = 1'b1;
        INT_NUM = 3'd1;
    end
    else if (IRQ[2] == 1'b1) begin
        INT = 1'b1;
        INT_NUM = 3'd2;
    end
    else if (IRQ[3] == 1'b1) begin
        INT = 1'b1;
        INT_NUM = 3'd3;
    end
    else if (IRQ[4] == 1'b1) begin
        INT = 1'b1;
        INT_NUM = 3'd4;
    end
    else if (IRQ[5] == 1'b1) begin
        INT = 1'b1;
        INT_NUM = 3'd5;
    end
    else if (IRQ[6] == 1'b1) begin
        INT = 1'b1;
        INT_NUM = 3'd6;
    end
    else if (IRQ[7] == 1'b1) begin
        INT = 1'b1;
        INT_NUM = 3'd7;
    end
    else begin
        INT = 1'b0;
        INT_NUM = 3'b000; //if there is no interrupt INT_NUM is a dont care.
    end

end

endmodule

