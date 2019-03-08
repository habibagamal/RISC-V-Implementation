/*********************************************************
 *
 *  Module: edgeDet.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Edge detector that outputs a pulse for 2 clock cycles
 *
 *********************************************************/
 `timescale 1ns/1ns

module edgeDet (clk, rst, in , out);
    input clk;
    input rst;
    input in;
    output out;
    
    reg[1:0] state, nxtState;
    parameter [1:0] Zero= 2'b00 , One = 2'b01, Two=2'b10, Three = 2'b11;
    
    always @(*) begin
    
    case(nxtState)
        Zero:
            if(in) 
                state <= One;
            else
                state <= Zero;
        
        One: 
            if (in)
                state <= Two;
            else 
                state <= Zero;
        Two:
            if(in)
                state <= Three;
            else
                state <= Zero;
        Three:
            if(in)
                state <= Three;
            else 
                state <= Zero;
        default: 
            state <= Zero;
        endcase 
    end
    
    always @(posedge clk or posedge rst)begin 
        if(rst) 
            nxtState <= Zero;
        else begin
            nxtState <= state;
        end
    end
    
    assign out = (state == One) | (state == Two);
endmodule

