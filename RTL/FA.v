/*********************************************************
 *
 *  Module: FA.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Full Adder
 *
 *********************************************************/
`timescale 1ns/1ns

module FA (
    input a, 
    input b, 
    input cin,
    output sum, 
    output cout 
);

  assign sum = a ^ b ^ cin;
  assign cout = ((a ^ b) & cin) | (a & b);
  
endmodule

