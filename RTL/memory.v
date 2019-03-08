/*********************************************************
 *
 *  Module: memory.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Data and Instruction Memory
 *
 *********************************************************/
`timescale 1ns/1ns

module memory(clk, rst, mem_op, dataIn, addr, dataOut);

    input           clk;
    input           rst;
    input   [1:0]   mem_op;
    input   [9:0]   addr;
    input   [31:0]  dataIn;
    output reg [31:0]  dataOut;
    
    wire    [9:0]   adder_addr;
    wire    [3:0]   write;
    wire    [7:0]   singlePortDataIn    [3:0];
    wire    [9:0]   singlePortAddrIn    [3:0];
    wire    [31:0]  singlePortOUT;
    wire    [1:0]   muxSel              [3:0];
    wire    [3:0]   in_adder;
    

    reg [31:0] mem [1023:0];

    assign adder_addr = addr >> 2; 
    
	//Produces the write signal for the different banks according to the memory operation
    memoryControl   memC    (   .memOp(mem_op), .addr_LSB(addr[1:0]), .write(write) );

	//Produces the selection lines for the mux's that select the banks data in
    MemDataINSel    memSel  (   .addr_LSB(addr[1:0]), .sel0(muxSel[0]), 
                                .sel1(muxSel[1]), .sel2(muxSel[2]), .sel3(muxSel[3]));
    
	//Produces the inputs (either 0 or 1) to the adders that calculate the address
    InputToAdders   AddIn   (.mem_op(mem_op), .addr_LSB(addr[1:0]), .out(in_adder) );
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin: addbit

            assign singlePortAddrIn[i] = adder_addr + {{9'b0} , {in_adder[i]}};
            
            mux4by1 mux (   .in0(dataIn[7:0]), .in1(dataIn[15:8]), .in2(dataIn[23:16]),
                            .in3(dataIn[31:24]), .sel(muxSel[i]), .out(singlePortDataIn[i]));
            end
    endgenerate

	
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            $readmemh("Hunter_V8_1/hex/HANDLERS.hex",mem);
            $readmemh("Hunter_V8_1/hex/CSRtest2.hex.txt",mem);
        end
        else begin
            if (write[3]) 
                mem [singlePortAddrIn[3]] [7:0]     <= singlePortDataIn[3]; //bank 0 
            if (write[2])
                mem [singlePortAddrIn[2]] [15:8]    <= singlePortDataIn[2]; //bank 1
            if (write[1])
                mem [singlePortAddrIn[1]] [23:16]   <= singlePortDataIn[1]; //bank 2
            if (write[0])
                mem [singlePortAddrIn[0]] [31:24]   <= singlePortDataIn[0]; //bank 3 
        end
    end
    
    //singlePortedMemory0 m0 ( .clk(clk), .rst(rst), .write(write[3]), 
    //                        .addr(singlePortAddrIn[3]), .dataIn (singlePortDataIn[3]), 
    //                        .dataOut ( singlePortOUT[7:0] ) );
                            
    //singlePortedMemory1 m1 ( .clk(clk), .rst(rst), .write(write[2]), 
    //                        .addr(singlePortAddrIn[2]), .dataIn (singlePortDataIn[2]), 
    //                        .dataOut (  singlePortOUT[15:8] ) );
                            
    //singlePortedMemory2 m2 ( .clk(clk), .rst(rst), .write(write[1]), 
    //                        .addr(singlePortAddrIn[1]), .dataIn (singlePortDataIn[1]), 
    //                        .dataOut (  singlePortOUT[23:16] ) );
                            
    //singlePortedMemory3 m3 ( .clk(clk), .rst(rst), .write(write[0]), 
    //                        .addr(singlePortAddrIn[0]), .dataIn (singlePortDataIn[0]), 
    //                        .dataOut (  singlePortOUT[31:24] ) );

    assign  singlePortOUT[7:0]  =   write[3] ? 0 : mem [singlePortAddrIn[3]] [7:0]; //bank 0
    assign  singlePortOUT[15:8] =   write[2] ? 0 : mem [singlePortAddrIn[2]] [15:8]; //bank 1
    assign  singlePortOUT[23:16] =  write[1] ? 0 : mem [singlePortAddrIn[1]] [23:16]; //bank 2
    assign  singlePortOUT[31:24] =  write[0] ? 0 : mem [singlePortAddrIn[0]] [31:24]; //bank 3

	//assigning dataOut according to the way the word was read (to support unaligned reads)
    always @ (*) begin
        case (in_adder)
            4'b0000:
                dataOut =   { singlePortOUT[31:24], singlePortOUT[23:16], singlePortOUT[15:8], singlePortOUT[7:0]};
            4'b1000:
                dataOut =   { singlePortOUT[7:0], singlePortOUT[31:24], singlePortOUT[23:16], singlePortOUT[15:8]};
            4'b1100:
                dataOut =   { singlePortOUT[15:8], singlePortOUT[7:0], singlePortOUT[31:24], singlePortOUT[23:16]};
            4'b1110:
                dataOut =   { singlePortOUT[23:16], singlePortOUT[15:8], singlePortOUT[7:0], singlePortOUT[31:24]};
            default:
                dataOut =   { singlePortOUT[31:24], singlePortOUT[23:16], singlePortOUT[15:8], singlePortOUT[7:0]};
        endcase
    end
endmodule











