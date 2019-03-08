/*********************************************************
 *
 *  Module: InputToAdders.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Output is either 0 or 1 depending on whether data read or write is aligned or not
 *
 *********************************************************/
`timescale 1ns/1ns

module InputToAdders (mem_op, addr_LSB, out);
    
    input       [1:0]   mem_op; 
    input       [1:0]   addr_LSB; 
    output reg  [3:0]   out;
    
    always @ (*) begin
        
        case (mem_op) 
            2'b00: //lw
            begin
                case (addr_LSB)
                    2'b00:  out = 4'b0000; 	//the whole word will be stored in addr[31:2]
                    2'b01:  out = 4'b1000;	//The most significant byte will be stored in the following word (bank 0)
                    2'b10:  out = 4'b1100;	//the most significant half word will be stored in the following word (bank 0 & 1)
                    2'b11:  out = 4'b1110;	//The least significant word only will be stored in the given address (bank3)
                    default: out = 4'b0000;
                endcase
            end
            2'b01: //sh
            begin
                if (addr_LSB == 2'b11)
                    out = 4'b1000;		//The most significant byte will be stored in the following word (bank 0)
                else
                    out = 4'b0000;
            end
            2'b10: //sb
                out = 4'd0;
            default: 
            begin
                case (addr_LSB) //sw
                    2'b00:  out = 4'b0000;	//the whole word will be read from addr[31:2]
                    2'b01:  out = 4'b1000;	//The most significant byte will be read from the following word
                    2'b10:  out = 4'b1100;	//the most significant half word will be read from the following word
                    2'b11:  out = 4'b1110;	//The least significant word only will be read from the given address
                    default: out = 4'b0000;
                endcase
            end
        endcase
    end
        
endmodule