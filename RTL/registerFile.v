/*********************************************************
 *
 *  Module: registerFile.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Register File
 *
 *********************************************************/

`timescale 1ns/1ns

module RegisterFile(clk, rst, rs1_addr, rs2_addr, rd_addr, rfWrite, altSignal, rfIN, rs1_data, rs2_data);

    input clk;
    input rst;
    input rfWrite;
    input altSignal;
    input [4:0] rs1_addr;
    input [4:0] rs2_addr;
    input [4:0] rd_addr;
    input [31:0] rfIN;
    output [31:0] rs1_data;
    output [31:0] rs2_data;
    
    wire [4:0] addrB;
    
    assign addrB = (altSignal) ? rs2_addr : rd_addr;
    
    DualPortedMem RFmem (.clk(clk), .rst(rst), .memWriteA(1'b0), .memWriteB(rfWrite && ~altSignal), 
                    .addrA(rs1_addr), .addrB(addrB), .dataInA(32'd0), .dataInB(rfIN), 
                    .dataOutA(rs1_data), .dataOutB(rs2_data));
    
endmodule