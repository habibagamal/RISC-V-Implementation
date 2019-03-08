/*********************************************************
 *
 *  Module: branchControlUnit.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Branch Control Unit
 *
 *********************************************************/
`include "defines/defines.v"
`timescale 1ns/1ns

module branchControlUnit(Zflag, OVF, ALU_MSB, ALU_COUT, func3, branch);
    
    input Zflag;
    input OVF;
    input ALU_MSB;
    input ALU_COUT;
    input [2:0] func3;
    output reg branch;
    
    always @ (*) begin
        case (func3)
            `BR_BEQ:     branch <= Zflag;             //BEQ
            `BR_BNE:     branch <= !Zflag;            //BNE
            `BR_BLT:     branch <= ALU_MSB != OVF;    //BLT
            `BR_BGE:     branch <= ALU_MSB == OVF;    //BLT
            `BR_BLTU:    branch <= !ALU_COUT;         //BLTU
            `BR_BGEU:    branch <= ALU_COUT;          //BGEU
            default:     branch <= 1'd0;              
        endcase
    end

endmodule

