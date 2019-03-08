/*********************************************************
 *
 *  Module: handlerEndHandler.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Outputs signal that stays on while handling some interrupt and lowers the signal when handling is done
 *
 *********************************************************/
`timescale 1ns/1ns


module handlerEndHandler(clk, rst, mret, ecall, ebreak, timer, pc, ecallSit, ebreakStay, timerFetch);
    input clk;
    input rst;
    input mret;
    input ecall;
    input ebreak;
    input timer;
    input [31:0] pc;
    output ecallSit;
    output ebreakStay;
    output timerFetch;
    
    reg [1:0] ecallState, ecallNxtState;
    reg [1:0] ebreakState, ebreakNxtState;
    reg [1:0] tmrState, tmrNxtState;
    parameter [1:0] ecallA = 2'b00, ecallB = 2'b01, ecallC = 2'b10;
    parameter [1:0] ebreakA = 2'b00, ebreakB = 2'b01, ebreakC = 2'b10;
    parameter [1:0] tmrA = 2'b00, tmrB = 2'b01, tmrC = 2'b10;
    
    assign ecallSit = (ecallState == ecallB) || (ecallState == ecallC);
    assign ebreakStay = (ebreakState == ebreakB) || (ebreakState == ebreakC);
    assign timerFetch = (tmrState == tmrB) || (tmrState == tmrC);
    
    always @(*) begin
    
        case(ecallNxtState)
            ecallA:
                if(ecall) 
                    ecallState <= ecallB;
                else
                    ecallState <= ecallA;
                    
            ecallB:
                if(pc == 32'h20) 
                    ecallState <= ecallC;
                else
                    ecallState <= ecallB;
            
            ecallC: 
                if (mret)
                    ecallState <= ecallA;
                else 
                    ecallState <= ecallC;
            default: 
                ecallState <= ecallA;
        endcase
         
        case(ebreakNxtState)
            ebreakA:
                if(ebreak) 
                    ebreakState <= ebreakB;
                else
                    ebreakState <= ebreakA;
                    
            ebreakB:
                if(pc == 32'h30) 
                    ebreakState <= ebreakC;
                else
                    ebreakState <= ebreakB;
            
            ebreakC: 
                if (mret)
                    ebreakState <= ebreakA;
                else 
                    ebreakState <= ebreakC;
            default: 
                ebreakState <= ebreakA;
        endcase
         
        case(tmrNxtState)
            tmrA:
                if(timer) 
                    tmrState <= tmrB;
                else
                    tmrState <= tmrA;
                    
            tmrB:
                if(pc == 32'h40) 
                    tmrState <= tmrC;
                else
                    tmrState <= tmrB;
            
            tmrC: 
                if (mret)
                    tmrState <= tmrA;
                else 
                    tmrState <= tmrC;
            default: 
                tmrState <= tmrA;
        endcase
         
      
    end
    
    always @ (posedge clk or posedge rst) begin 
        if(rst) begin
            ecallNxtState <= ecallA;
            ebreakNxtState <= ebreakA;
            tmrNxtState <= tmrA;
        end
        else begin
            ecallNxtState <= ecallState;
            ebreakNxtState <= ebreakState;
            tmrNxtState <= tmrState;
        end
    end
endmodule


