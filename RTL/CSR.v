/*********************************************************
 *
 *  Module: CSR.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Control and Status registers
 *
 *********************************************************/
`timescale 1ns/1ns

module CSR 
( 
    input clk,
    input altSignal,
    input rst, 
    input interrupt,        //1 if interrupt 
    input interrupt_EX,
    input [31:0] pc,        //input pc to store in mepc
    input pending,          //1 if an instruction is pending
    input [2:0] mip_in,     //input to mip
    input retire,
    input [11:0] addr,      //address of CSR to write to
    input [31:0] CSR_new,   //value to write in CSR
    input write,            //1 if CSRRW,   CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
    input notServiced,
    input mie_in,           //global bit of mie
    input mret,                 //1 if mret
    output reg [31:0] CSR,      //to be written in rd
    output [2:0] mip_out,
    output [3:0] mie_out,
    output reg timer_int,
    output [31:0] mepc_out
);
    
    wire [31:0] mepc_datain,  mcycle_out, mtime_out, minstret_out, mtimecmp_out, compCount;
    wire [2:0] mip_datain;
    wire [3:0] mie_datain;
    wire mip_load, mepc_load, mie_load, clkDiv, writePulse, write2;
    reg mepc_ld, mip_ld, mtimecmp_ld, mie_ld;
    reg [31:0] timeCounter; 
    
    assign mepc_datain = interrupt ? pc : CSR_new;  //if interrupt is 1, mepc will be loaded with pc
    assign mepc_load = interrupt || mepc_ld; //controls load of mepc
    
    assign mip_datain = pending ? mip_in : CSR_new[2:0]; //is pending is 1, take mip input
    assign mip_load = pending || mip_ld; //controls load of mip
    
    assign mie_load = interrupt_EX || mret || mie_ld;
    assign mie_datain = (interrupt_EX || mret) ? {mie_in, mie_out[2:0]} : CSR_new[3:0];
    
    clkDiv #(4) div (.clock_in(clk), .clock_out(clkDiv), .rst(rst));
    //read only.. Counter of time in cycles since reset
    counter_32 mcycle ( .clk(clk), .rst(rst), .en(1'b1), .ld(1'b0), .data_in(32'd0), .data_out(mcycle_out));  
    //read only.. Counter of time in some unit
    counter_32 mtime ( .clk(clkDiv), .rst(rst), .en(1'b1), .ld(1'd0), .data_in(32'd0), .data_out(mtime_out));  
    //read only.. Counter of retired instructions
    counter_32 minstret( .clk(altSignal), .rst(rst), .en(retire), .ld(1'b0), .data_in(32'd0), .data_out(minstret_out));
    //data_in is CSR_new
    mTimeCmp mtc (.clk(clk), .rst(rst), .load(mtimecmp_ld), .data_in(CSR_new), .data_out(mtimecmp_out));
    //data_in is CSR_new
    MIE mie (.clk(clk), .rst(rst), .load(mie_load), .data_in(mie_datain), .data_out(mie_out));   
    //data_in is CSR_new or mip_in
    register #(3)  mip      (.clk(clk), .rst(rst), .load(mip_load), .data_in(mip_datain), .data_out(mip_out));  
    //data_in is CSR_new or pc
    register #(32) mepc     (.clk(clk), .rst(rst), .load(mepc_load), .data_in(mepc_datain), .data_out(mepc_out)); 
    
    
    
    counter_32 compCounter ( .clk(clk), .rst(rst | mtimecmp_ld), .en(1'b1), .ld(timer_int), .data_in(32'd0), .data_out(compCount));
    always @ (*) begin  //controlling the timer
        if (rst)
            timer_int = 1'b0;
        else if ((compCount >= (mtimecmp_out - 32'b1)) | notServiced) 
            timer_int = 1'b1;
        else
            timer_int = 1'b0;
    end
    
    assign writePulse = altSignal ? write: 1'b0;
    //onePulse op (.clk(clk), .in(write2), .out(writePulse));
    always @ (*) begin  //contolling the loads
        if (rst) begin
            mie_ld = 1'b0;
            mip_ld = 1'b0;
            mepc_ld = 1'b0;
            mtimecmp_ld = 1'b0;
        end 
        else
        if (writePulse)
            case (addr)
                12'h341: begin //mepc
                    mie_ld = 1'b0;
                    mip_ld = 1'b0;
                    mepc_ld = 1'b1;
                    mtimecmp_ld = 1'b0;
                end
                12'h304: begin //mie
                    mie_ld = 1'b1;
                    mip_ld = 1'b0;
                    mepc_ld = 1'b0;
                    mtimecmp_ld = 1'b0;
                end
                12'h344: begin //mip
                    mie_ld = 1'b0;
                    mip_ld = 1'b1;
                    mepc_ld = 1'b0;
                    mtimecmp_ld = 1'b0;
                end
                12'hB00: begin //mcycle (read only)
                    mie_ld = 1'b0;
                    mip_ld = 1'b0;
                    mepc_ld = 1'b0;
                    mtimecmp_ld = 1'b0;
                end
                12'hB01: begin //mtime (read only)
                    mie_ld = 1'b0;
                    mip_ld = 1'b0;
                    mepc_ld = 1'b0;
                    mtimecmp_ld = 1'b0;
                end
                12'hB03: begin //mtimecmp
                    mie_ld = 1'b0;
                    mip_ld = 1'b0;
                    mepc_ld = 1'b0;
                    mtimecmp_ld = 1'b1;
                end
                12'hB02: begin //minstret (read only)
                    mie_ld = 1'b0;
                    mip_ld = 1'b0;
                    mepc_ld = 1'b0;
                    mtimecmp_ld = 1'b0;
                end
                default: begin 
                    mie_ld = 1'b0;
                    mip_ld = 1'b0;
                    mepc_ld = 1'b0;
                    mtimecmp_ld = 1'b0;
                end
            endcase
        else begin 
            mie_ld = 1'b0;
            mip_ld = 1'b0;
            mepc_ld = 1'b0;
            mtimecmp_ld = 1'b0;
        end
    end
    
    always @ (*) begin 
        if (rst)
            CSR = 32'd0;
        else
        if (!writePulse) begin 
            case (addr)
                12'h341:    //mepc
                    CSR = mepc_out;
                12'h304:    //mie
                    CSR = {28'b0, mie_out};
                12'h344:    //mip
                    CSR = {29'b0, mip_out};
                12'hB00:    //mcycle 
                    CSR = mcycle_out;
                12'hB01:    //mtime 
                    CSR = mtime_out;
                12'hB03:    //mtimecmp
                    CSR = mtimecmp_out;
                12'hB02: //minstret 
                    CSR = minstret_out;
                default: 
                    CSR = 32'b0;
            endcase
        end
        else begin
            CSR = 32'd0;
        end
    end
    
endmodule




