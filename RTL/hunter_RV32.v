/*********************************************************
 *
 *  Module: hunter_RV32.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Full Datapath
 *
 *********************************************************/
`timescale 1ns/1ns

module hunter_RV32(input clk, input rst, input NMI, input INT, input [2:0] INT_NUM, input [31:0] memOut, output [31:0] memInOUT, output [1:0] memOpOUT, output [9:0] memAddrOUT, output [31:0] hunterOut);
    
    // Stage 1 wires
    wire [31:0] pc_2, pc_4, pcNext, uncInst, decompOut, bTarget, aluResult, pcIn, pcOut, iRegOut, rd_WB, rfIn, rs1, rs2, imm;
    wire [3:0]  aluOp, rfWriteData;
    wire [1:0]  memOp;
    wire        altSignal, memWrite, rfWrite, aluSrcA, aluSrcB, pcSrc, pcWrite, bInst, branch;
    wire        compInst;
    wire        interrupt, pendingInterrupt, timerInterrupt, csrWrite, ebreak, ecall, interruptPulse;
    wire [11:0] csrAddr, csrAddr_EX, csrAddr_WB, csrAddrMuxOut;
    wire [31:0] csrOld, csrOld_EX, csrNew_WB, csrOld_WB, handlerAddr, pcMuxOut, pcHandlerMux, mepcOut;
    wire [2:0]  mipIn, mipOut;
    wire [3:0]  mieOut;
    wire        ebreak_EX, ecall_EX, csrImmInst_EX, csrWrite_EX, csrWrite_WB, mret_EX, mret_WB, mie_in;
    wire [1:0]  csrInstType_EX;
    wire        habiba, wael, ali;
    
    // Stage 2 wires
    wire [3:0]  aluOp_EX, rfWriteData_EX;
    wire [1:0]  memOp_EX;
    wire        altSignal_EX, memWrite_EX, rfWrite_EX, aluSrcA_EX, aluSrcB_EX, pcSrc_EX, pcWrite_EX;
    wire [23:0] ID_EX_Control;
    wire [31:0] pcNext_EX, pcOut_EX, rs1_EX, rs2_EX, imm_EX, iRegOut_EX;
    
    wire        fwdA, fwdB;    // Forward Control Signals
    wire [31:0] aluIn1, aluIn2, memIn, memAddr;
    wire        cFlag, zFlag, vFlag;
    
    wire        csrImmInst, fwdCSR;
    wire        interruptPulse_EX, csrPulse;
    wire [31:0] csrOp1MuxOut, csrOp2MuxOut, csrRWInstRes, csrRSInstRes, csrRCInstRes, csrNew;
    wire [1:0]  csrInstType;
    wire        ecallSit, ebreakStay, timerFetch;
    
    // Stage 3 wires
    wire [31:0] pcNext_WB, memOut_WB, iRegOut_WB, aluResult_WB;
    wire [3:0]  rfWriteData_WB;
    wire        cFlag_WB, rfWrite_WB, rfWrite_EX_Branch, bInst_EX, pcWrite_WB, memWrite_WB;
    
    wire [31:0] lhOut, lhuOut, lbOut, lbuOut;
    wire bInst_EX_and_Branch, bInst_EX_and_Branch_WB;
    wire retired, mret, mretPulse;
    wire NOTaltSignal;
    
    // DataPath
    
    // STAGE 1
    
    //to produce a signal that changes every 2 clock cycles/ every stage
    clkDiv clkdiv(.clock_in(clk), .clock_out(altSignal), .rst(rst));
    
    assign NOTaltSignal = ~altSignal;
    
    //chooses the input to the PC
    mux4_1 #(32) PC_MUX (.sel({pcWrite_EX, bInst_EX_and_Branch}),
                            .in1(pcNext), .in2(bTarget), .in3(aluResult), .in4(aluResult), .out(pcMuxOut));
                            
    mux2_1 #(32) PC_HandlerMux (.sel(interruptPulse), .in1(pcMuxOut), .in2(handlerAddr), .out(pcHandlerMux));
    mux2_1 #(32) PC_MretMux (.sel(mret), .in1(pcHandlerMux), .in2(mepcOut), .out(pcIn));
    
    register PC (.clk(clk), .rst(rst), .load(NOTaltSignal), .data_in(pcIn), .data_out(pcOut));
    
    assign pc_4 = ((bInst_EX_and_Branch) | pcWrite_EX) ? pcOut : pcOut + 4;
    assign pc_2 = ((bInst_EX_and_Branch) | pcWrite_EX) ? pcOut : pcOut + 2;
    
    assign compInst = ~(uncInst[1] & uncInst[0]); // 1 if compressed instruction, 0 if uncompressed instruction
    
    mux2_1 #(32) pcNextMux (.sel(compInst), .in1(pc_4), .in2(pc_2), .out(pcNext));
    
    // DECOMP UNIT
    decompressionUnit DU (.cinst(uncInst[15:0]), .inst(decompOut));
    
    //holds the instruction register. Gets updated only after the fetch stage
    register iRegister (.clk(clk), .rst(rst), .load(altSignal), .data_in(memOut), .data_out(uncInst));
    
    mux2_1 #(32) compressedMux (.sel(compInst), .in1(uncInst), .in2(decompOut), .out(iRegOut));
    
    
    //assign pc_4 = pcOut + 4;
     
    controlUnit CU (    .opcode(iRegOut [6:0]), .funct3(iRegOut [14:12]), .funct7(iRegOut [30]),
                        .funct12(iRegOut [31:20]), .memWrite(memWrite), .rfWrite(rfWrite), .aluSrcA(aluSrcA),
                        .aluSrcB(aluSrcB), .pcSrc(pcSrc), .pcWrite(pcWrite), .memOp(memOp),
                        .rfWriteData(rfWriteData), .aluOp(aluOp), .bInst(bInst), .ebreak(ebreak), .ecall(ecall),
                        .csrImmInst(csrImmInst), .csrInstType(csrInstType), .csrWrite(csrWrite), .mret(mret));
                
    RegisterFile rf (   .clk(clk), .rst(rst), .rs1_addr(iRegOut[19:15]), .rs2_addr(iRegOut[24:20]), .rd_addr(iRegOut_WB[11:7]),
                        .rfWrite(rfWrite_WB),  .altSignal(NOTaltSignal), .rfIN(rfIn), .rs1_data(rs1), .rs2_data(rs2));
    // CSR SUPPORT

    
    mux2_1 #(12) csrAddrMux (.sel(altSignal), .in1(iRegOut[31:20]), .in2(csrAddr_WB), .out(csrAddrMuxOut)); // csr address mux
    
    assign csrAddr = iRegOut[31:20];
    
    onePulse op (.clk(clk), .in(interrupt), .out(csrPulse));
    
    assign mie_in = interruptPulse_EX ? 1'b0 : 1'b1;
    
    CSR csr (.clk(clk), .altSignal(altSignal), .rst(rst), .interrupt(csrPulse), .interrupt_EX(interruptPulse_EX), .pc(pcOut), .pending(pendingInterrupt),
                .mip_in(mipIn), .retire(retired), .addr(csrAddrMuxOut), .CSR_new(csrNew_WB), .write(csrWrite_WB), .notServiced(timerFetch), .CSR(csrOld),
                .mie_in(mie_in), .mret(mret), .mip_out(mipOut), .mie_out(mieOut), .timer_int(timerInterrupt), .mepc_out(mepcOut));                        

    rv32_ImmGen immGen (.IR(iRegOut), .Imm(imm));   // Immediate Generator

    //handles flushing because of branches taken, JAL and JALR
    assign ID_EX_Control = ((bInst_EX_and_Branch) | pcWrite_EX | interruptPulse) ? 24'd0: { mret, 
                                                                                        ebreak,
                                                                                        ecall,
                                                                                        csrImmInst,
                                                                                        csrInstType,
                                                                                        csrWrite,
                                                                                        bInst,
                                                                                        memWrite,  
                                                                                        rfWrite,
                                                                                        aluSrcA,
                                                                                        aluSrcB,
                                                                                        pcSrc,
                                                                                        pcWrite,
                                                                                        memOp,
                                                                                        rfWriteData,
                                                                                        aluOp};
    
    
    //first pipeline register
    register #(261) ID_EX (.clk(clk), .rst(rst), .load(NOTaltSignal), .data_in({
                                                                    interruptPulse,
                                                                    ID_EX_Control,
                                                                    pcNext,
                                                                    pcOut,
                                                                    rs1,
                                                                    rs2,
                                                                    imm,                                                             
                                                                    iRegOut,
                                                                    csrAddr,
                                                                    csrOld}),
                                                                    .data_out({ interruptPulse_EX, mret_EX, ebreak_EX, ecall_EX, csrImmInst_EX,
                                                                                csrInstType_EX, csrWrite_EX,
                                                                                bInst_EX, memWrite_EX, rfWrite_EX,
                                                                                aluSrcA_EX, aluSrcB_EX, pcSrc_EX, pcWrite_EX,
                                                                                memOp_EX, rfWriteData_EX, aluOp_EX,
                                                                                pcNext_EX, pcOut_EX, rs1_EX, rs2_EX, imm_EX,
                                                                                iRegOut_EX, csrAddr_EX, csrOld_EX}));
    // STAGE 2
    
    //calculating the branch target
    assign bTarget = pcOut_EX + imm_EX;

    //mux that selects first ALU operand
    mux4_1 #(32) aluOperand1mux (.sel({fwdA, aluSrcA_EX}), .in1(pcOut_EX), .in2(rs1_EX), .in3(rfIn), .in4(rfIn), .out(aluIn1));
    
    //mux that selects forwarding or rs2 data
    mux2_1 #(32) fwdBmux (.sel(fwdB), .in1(rs2_EX), .in2(rfIn), .out(memIn));

    //mux that selects 2nd ALU operand
    mux2_1 #(32) aluOperand2mux (.sel(aluSrcB_EX), .in1(memIn), .in2(imm_EX), .out(aluIn2));
    
    //CSR SUPPORT

    mux4_1 #(32) csrOp1Mux (.sel({csrImmInst_EX, fwdA}), .in1(rs1_EX), .in2(rfIn),
                            .in3({27'b0, iRegOut_EX[19:15]}), .in4({27'b0, iRegOut_EX[19:15]}), .out(csrOp1MuxOut));
    mux2_1 #(32) csrOp2Mux (.sel(fwdCSR), .in1(csrOld_EX), .in2(csrNew_WB), .out(csrOp2MuxOut));
    
    assign csrRWInstRes = csrOp1MuxOut;
    assign csrRSInstRes = (csrOp1MuxOut | csrOp2MuxOut);
    assign csrRCInstRes = ((~csrOp1MuxOut) & csrOp2MuxOut);

    mux4_1 #(32) csrNewMux (.sel(csrInstType_EX), .in1(csrRWInstRes), .in2(csrRSInstRes), .in3(csrRCInstRes),
                            .in4(32'b0), .out(csrNew));
    
    
    ALU ALU(.a(aluIn1), .b(aluIn2), .op(aluOp_EX), .out(aluResult), .zFlag(zFlag), .cFlag(cFlag), .vFlag(vFlag));

    //Mux that selects the address to the memory. The selection line is the signal that changes every stage
    mux2_1 #(32) memAddrMux (.sel(NOTaltSignal), .in1(pcOut), .in2(aluResult), .out(memAddr));
    
    //memory wires
    //memory mem (.clk(clk), .rst(rst), .mem_op((NOTaltSignal) ? memOp_EX : 2'b00), .dataIn(memIn), .addr(memAddr[9:0]), .dataOut(memOut));
    assign memInOUT = memIn;
    assign memOpOUT = (NOTaltSignal) ? memOp_EX : 2'b00;
    assign memAddrOUT = memAddr[9:0];
    
    
    //handles forwarding from RFin Data
    forwardingUnit fwdu (.MEM_WB_RD(iRegOut_WB[11:7]), .ID_EX_RS1(iRegOut_EX[19:15]), .ID_EX_RS2(iRegOut_EX[24:20]),
                        .MEM_WB_WRITE(rfWrite_WB), .fwdA(fwdA), .fwdB(fwdB));
    //CSR Forwarding Unit
    csrFwdUnit csrFU (.csrAddr_EX(csrAddr_EX), .csrAddr_WB(csrAddr_WB), .fwdCSR(fwdCSR));
    
    //outputs 1 if branch should be taken
    branchControlUnit bu (.Zflag(zFlag), .OVF(vFlag), .ALU_MSB(aluResult[31]),
                            .ALU_COUT(cFlag), .func3(iRegOut_EX [14:12]), .branch(branch));
    
    onePulse op1 (.clk(clk), .in(mret), .out(mretPulse));
    
    
    //outputs 1 if interrupt and corresponding handler address                        
    CPU_PIC cpu_pic(.ebreak(ebreakStay), .ecall(ecallSit), .nmi(NMI), .timer(timerInterrupt), .INT(INT), 
                    .INT_NUM(INT_NUM), .enables(mieOut), .mret(mretPulse), .interrupt(interrupt), .HA(handlerAddr), .pending(pendingInterrupt), .mip(mipIn));
    
    edgeDet eD(.clk(clk), .rst(rst), .in(interrupt), .out(interruptPulse));
    
    handlerEndHandler heh(.clk(clk), .rst(rst), .mret(mret_EX), .ecall(ecall_EX), .ebreak(ebreak_EX), .timer(timerInterrupt), .pc(pcOut),
                            .ecallSit(ecallSit), .ebreakStay(ebreakStay), .timerFetch(timerFetch));
    
    //outputs 1 if instruction is branch and branch should be taken
    assign bInst_EX_and_Branch = bInst_EX && branch;
    
    //    assign rfWrite_EX_Branch = (bInst_EX_and_Branch) ? 1'b0 : rfWrite_EX;

    //second pipeline register
    register #(215) M_WB (.clk(clk), .rst(rst), .load((NOTaltSignal)), .data_in( { mret_EX,
                                                                                csrWrite_EX,
                                                                                bInst_EX_and_Branch,
                                                                                memWrite_EX,
                                                                                rfWrite_EX,
                                                                                rfWriteData_EX,
                                                                                pcWrite_EX,
                                                                                pcNext_EX,
                                                                                memOut,
                                                                                aluResult,
                                                                                cFlag,
                                                                                iRegOut_EX,
                                                                                csrAddr_EX,
                                                                                csrOp2MuxOut,
                                                                                csrNew}),
                                                                                .data_out({ mret_WB, csrWrite_WB, bInst_EX_and_Branch_WB,
                                                                                            memWrite_WB, rfWrite_WB, rfWriteData_WB,
                                                                                            pcWrite_WB, pcNext_WB, memOut_WB,
                                                                                            aluResult_WB,cFlag_WB, iRegOut_WB,
                                                                                            csrAddr_WB, csrOld_WB, csrNew_WB}));
    // STAGE 3

    assign lhOut    = { {16{memOut_WB[15]}}, (memOut_WB[15:0])};
    assign lhuOut   = { (16'b0),memOut_WB[15:0]};
    assign lbOut    = { {24{memOut_WB[7]}},memOut_WB[7:0]};
    assign lbuOut   = { (24'b0),memOut_WB[7:0]};
    
    assign retired = (memWrite_WB | rfWrite_WB | pcWrite_WB | bInst_EX_and_Branch_WB | mret_WB);
    
    // mux that selects what gets written to the register file
    mux16_4 #(32) wbMux (   .sel(rfWriteData_WB),
                            .in1(pcNext_WB), .in2(memOut_WB), .in3(lhOut), .in4(lhuOut),
                            .in5(lbOut), .in6(lbuOut), .in7({{31{1'b0}}, aluResult_WB[31]}), .in8(aluResult_WB),
                            .in9({{31{1'b0}},~cFlag_WB}), .in10(csrOld_WB), .in11(32'd0), .in12(32'd0),
                            .in13(32'd0), .in14(32'd0), .in15(32'd0), .in16(32'd0), 
                            .out(rfIn));
    assign hunterOut = rfIn;
                                
endmodule





