/*********************************************************
 *
 *  Module: memoryControl.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Memory Control Unit
 *
 *********************************************************/
`include "defines/defines.v"
`timescale 1ns/1ns

module memoryControl (memOp, addr_LSB, write);

    input [1:0] memOp, addr_LSB;
    output reg [3:0] write;
    
    always @ (*) begin
        case (memOp)
            `MEM_OP_00: begin //lw
                write = 4'b0000;
            end
            `MEM_OP_01: begin //sh
                case (addr_LSB)
                   `ADDR_LSB_00:  write = 4'b1100;
                   `ADDR_LSB_01:  write = 4'b0110; 	// assuming address wont end with 01 or 11
                   `ADDR_LSB_10:  write = 4'b0011;
                   `ADDR_LSB_11:  write = 4'b1001;	// assuming address wont end with 01 or 11
                endcase
            end
            `MEM_OP_10: begin //sb
                write = 4'b1000 >> addr_LSB;
            end
            default: begin  // sw
                write = 4'b1111;
            end
        endcase
    end
    
endmodule

