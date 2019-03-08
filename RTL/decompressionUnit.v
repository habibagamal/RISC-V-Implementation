/*********************************************************
 *
 *  Module: decompressionUnit.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Decompression Unit. Converts the compressed instruction into its equivalent uncompressed instruction. 
 *
 *********************************************************/
`include "defines/defines.v"
`timescale 1ns / 1ns
module decompressionUnit(   
    input       [15:0] cinst,
    output reg  [31:0] inst
);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    always @(*) begin
        case (cinst[1:0])
            `C_OP_00: begin
                if (cinst[15:13] == 3'd0) //C.ADDI4SPN --> addi rd, x2, nzuimm[9:2]
                    inst = {    2'd0, cinst[10:7], cinst[12:11], cinst[5], cinst[6], 
                                2'd0,5'd2,3'd0, ({2'b0, cinst[4:2]} + 5'd8) , 7'b0010011 };
                else if (cinst[15:13] == 3'b010) //C.LW 
                    inst = {    6'd0, cinst[5], cinst[12:10], cinst[6], 2'd0, ({2'b0, cinst[9:7]} + 5'd8), 
                                3'b010, ({2'b0, cinst[4:2]} + 5'd8), 7'b0000011 };  
                else if (cinst[15:13] == 3'b110) //C.SW
                    inst = {    5'd0, cinst[5], cinst[12], ({2'b0, cinst[4:2]} + 5'd8), 
                                ({2'b0, cinst[9:7]} + 5'd8), 3'b010, cinst[11:10], cinst[6], 2'd0, 
                                7'b0100011};
                else //unreachable
                    inst = { 25'd0, 7'b0110011 };              
            end
            `C_OP_01:begin
                case (cinst[15:13])
                    `C_funct3_000: begin
                        if (cinst[11:7] != 5'd0) //c.addi
                            inst = {    6'd0, cinst[12], cinst[6:2], cinst[11:7], 
                                        3'b000, cinst[11:7], 7'b0010011};
                        else //c.nop --> add x0, x0, x0
                            inst = {    25'd0, 7'b0110011};
                    end
                    `C_funct3_001: begin //c.jal --> jal x1, offset[11:1]
                            inst = {    1'b0, cinst[8], cinst[10:9], cinst[6], cinst[7], cinst[2], 
                                        cinst[11], cinst[5:3], cinst[12], 8'd0, 5'd1, 7'b1101111};
                    end
                    `C_funct3_010: begin //c.li --> addi rd, x0, imm[5:0]
                        inst = {    6'd0, cinst[12], cinst[6:2], 8'b0, cinst[11:7], 7'b0010011};
                    end
                    `C_funct3_011: begin 
                        if (cinst[11:7] == 5'd2)//c.addi16sp --> addi x2, x2, nzimm[9:4]
                            inst = {    2'd0, cinst[12], cinst[4:3], cinst[5], 
                                    cinst[2], cinst[6], 4'd0, 5'd2, 3'b0, 5'd2, 7'b0010011};
                        else //c.lui
                            inst = {    14'd0, cinst[12], cinst[6:2], cinst[11:7], 7'b0110111}; 
                    end
                    `C_funct3_100: begin
                        case (cinst[11:10])
                            2'b00: begin //c.srli --> srli rd, rd, shamt[5:0]
                                //inst = {    7'b0, cinst[12], cinst[6:2], ({2'b0, cinst[9:7]} + 5'd8), 
                                inst = {    7'b0, cinst[6:2], ({2'b0, cinst[9:7]} + 5'd8), 
                                            3'b101, ({ 2'b0, cinst[9:7]} + 5'd8), 7'b0010011}; 
                            end
                            2'b01: begin //c.srai --> srai rd, rd, shamt[5:0]
                                //inst = {    7'b010000, cinst[12], cinst[6:2], 
                                inst = {    7'b0100000,  cinst[6:2],
                                            ({2'b0, cinst[9:7]} + 5'd8), 3'b101,
                                            ({2'b0, cinst[9:7]} + 5'd8), 7'b0010011}; 
                            end
                            2'b10: begin //c.andi
                                inst = {    6'd0, cinst[12], cinst[6:2], ({2'b0, cinst[9:7]} + 5'd8), 
                                            3'b111, ({2'b0, cinst[9:7]} + 5'd8) , 7'b0010011};
                            end
                            2'b11: begin 
                                case (cinst[6:5])
                                    2'b00: begin //c.sub
                                        inst = {    7'b0100000, ({2'd0, cinst[4:2]} + 5'd8), ({2'd0, cinst[9:7]} + 5'd8),
                                                    3'b0, ({2'd0, cinst[9:7]} + 5'd8), 7'b0110011};
                                    end
                                    2'b01: begin //c.xor
                                        inst = {    7'd0, ({2'd0, cinst[4:2]} + 5'd8), ({2'd0, cinst[9:7]} + 5'd8),
                                                    3'b100, ({2'd0, cinst[9:7]} + 5'd8), 7'b0110011};
                                    end
                                    2'b10: begin //c.or
                                        inst = {    7'd0, ({2'd0, cinst[4:2]} + 5'd8), ({2'd0, cinst[9:7]} + 5'd8),
                                                    3'b110, ({2'd0, cinst[9:7]} + 5'd8), 7'b0110011};
                                    end
                                    2'b11: begin //c.and
                                        inst = {    7'd0, ({2'd0, cinst[4:2]} + 5'd8), ({2'd0, cinst[9:7]} + 5'd8),
                                                    3'b111, ({2'd0, cinst[9:7]} + 5'd8), 7'b0110011};
                                    end
                                    default: //unreachable
                                        inst = {    25'd0, 7'b0110011};
                                    endcase
                            end
                            default: //unreachable
                                inst = {    25'd0, 7'b0110011};
                        endcase
                    end
                    `C_funct3_101: begin//C.J  
                            inst = {    1'b0,cinst[8],cinst[10:9],cinst[6],cinst[7],cinst[2],
                                        cinst[11],cinst[5:3],cinst[12],8'd0,5'd0,7'b1101111};
                    end
                    `C_funct3_110: begin//C.beqz
                            inst = {    4'd0, cinst[12], cinst[6:5], cinst[2], 5'd0, 
                                        ({2'b0, cinst[9:7]} + 5'd8), 3'b0, cinst[11:10], 
                                        cinst[4:3], 1'b0, 7'b1100011};
                    end
                    `C_funct3_111: begin//C.BNEZ
                        inst = {    4'd0, cinst[12], cinst[6:5] ,cinst[2], 5'd0,
                                    ({2'b00 , cinst[9:7]} + 5'd8), 3'b001, cinst[11:10],
                                    cinst[4:3], 1'b0, 7'b1100011};
                    end
                    default: //unreachable
                        inst = {    25'd0, 7'b0110011};
                endcase
            end
            `C_OP_10: begin
                 if (cinst[15:13]== `C_funct3_000 & cinst[11:7] != 5'b00000 & {cinst[12],cinst[6:2]} != 6'd0 )
                     begin//C.SLLI
                         inst = {   7'b0000000,cinst[6:2],( {2'b00,cinst[9:7]} + 5'b01000),
                                    3'b001, ({2'b0, cinst[9:7]} + 5'd8), 7'b0010011}; 
                     end
                 else if (cinst[15:13]== `C_funct3_010 & cinst[11:7] != 5'b00000)
                     begin//C.LWSP
                         inst = {{  4'b0000,cinst[3:2],cinst[12],cinst[6:4],2'b00},5'b00010,
                                    3'b010,cinst[11:7],7'b0000011};
                     end
                 else if (  cinst[15:13] == `C_funct3_100 & cinst[6:2] == 5'b00000 & cinst[12] == 1'b0)
                     begin//C.JR
                         inst = {12'b000000000000,cinst[11:7],3'b000,5'b00000,7'b1100111};
                     end
                 else if (  cinst[15:13] == `C_funct3_100 & cinst[6:2] != 5'b00000 
                            & cinst[11:7] != 5'b00000 & cinst[12] == 0)
                     begin//C.MV
                         inst = {7'b0000000, cinst[6:2], 5'b00000, 3'b000, cinst[11:7], 7'b0110011};
                     end
                 else if (cinst[15:13] == `C_funct3_100 & cinst[12] == 1'b1 & cinst[11:2] == 10'd0)
                     begin//C.EBREAK
                         inst = 32'b00000000000100000000000001110011;
                     end
                 else if (  cinst[15:13] == `C_funct3_100 & cinst[6:2] == 5'b00000 & 
                            cinst[11:7] != 5'b00000 & cinst[12] == 1'b1)
                     begin//C.JALR
                         inst = {12'd0 , cinst[11:7], 3'b000, 5'd1, 7'b1100111};    
                     end
                 else if ( cinst[15:13] == `C_funct3_100 & cinst[12] == 1'b1 & cinst[11:7] 
                            != 5'b00000 & cinst[6:2] != 5'b00000)
                     begin//C.ADD
                         inst = {7'b0000000,cinst[6:2], cinst[11:7], 3'b000, cinst[11:7], 7'b0110011};
                     end
                 else if ( cinst[15:13] == `C_funct3_110)
                     begin//C.SWSP --> 
                         inst = {{4'b0, cinst[8:7], cinst[12]}, cinst[6:2], 5'b00010, 3'b010,
                                    {cinst[11:9],2'b00},7'b0100011};
                     end
                 else //unreachable
                     inst ={25'b0,7'b0110011};
             end
             default: begin //unreachable
                inst = { 25'd0, 7'b0110011 };
             end
        endcase
    end
endmodule


