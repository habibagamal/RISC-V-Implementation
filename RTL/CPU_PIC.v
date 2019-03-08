/*********************************************************
 *
 *  Module: CPU_PIC.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Priority Encoder for all interrupts 
 *
 *********************************************************/
`include "defines/defines.v"
`timescale 1ns/1ns

module CPU_PIC (ebreak, ecall, nmi, timer, INT, INT_NUM, enables, mret, interrupt, HA, pending, mip);

input [0:0] ebreak;
input [0:0] ecall;
input [0:0] nmi;
input [0:0] timer;
input [0:0] INT;
input [2:0] INT_NUM;
input [3:0] enables;
input mret;
output reg [0:0] interrupt;
output reg [31:0] HA;
output [0:0] pending;
output [2:0] mip;

wire timer_out;
wire external_out; 
wire ecall_out;

assign timer_out = (enables [3] & enables[0] & timer);
assign external_out = (enables [3] & enables[1] & INT);
assign ecall_out = (enables [3] & enables[2] & ecall);

assign mip = {ecall,INT,timer};
assign pending = (ecall|INT|timer);

always @ (*) begin
    if (mret) begin 
        interrupt = 1'b0;
        HA = 32'h00; //don/t care
    end
    else if (nmi) begin
        interrupt = 1'b1;
        HA = 32'h10;
    end
    else if (ebreak) begin
        interrupt = 1'b1;
        HA = 32'h30;
    end
    else if (timer_out) begin
        interrupt = 1'b1;
        HA = 32'h40;
    end
    else if (external_out) begin
        interrupt = 1'b1;
        case (INT_NUM)
            
            `NUM_ZERO: begin
                        HA = 32'h100;
                    end
            `NUM_ONE: begin
                        HA = 32'h110;
                    end
            `NUM_TWO: begin
                        HA = 32'h120;
                    end
            `NUM_THREE: begin
                        HA = 32'h130;
                    end
            `NUM_FOUR: begin
                        HA = 32'h140;
                    end
            `NUM_FIVE: begin
                        HA = 32'h150;
                    end
            `NUM_SIX: begin
                        HA = 32'h160;
                    end
            `NUM_SEVEN: begin
                        HA = 32'h170;
                    end
            default:
                    begin
                        HA = 32'h0;
                    end
            
            
        endcase
    end
    else if (ecall_out) begin
        interrupt = 1'b1;
        HA = 32'h20;
    end
    else begin
        interrupt =1'b0;
        HA = 32'h0;      //dont care
    end

end

endmodule

