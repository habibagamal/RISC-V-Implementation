/*********************************************************
 *
 *  Module: controlUnit.v
 *  Project: Hunter_RV32
 *  Author: Ali El-Said (ali.elsaid@aucegypt.edu), Ahmed Wael (awael@aucegypt.edu), Habiba Bassem (habibabassem@aucegypt.edu)
 *  Description: Control Unit
 *
 *********************************************************/
`include "defines/defines.v"
`timescale 1ns/1ns

module controlUnit (
input [6:0] opcode,
input [2:0] funct3,
input [0:0] funct7,
input [11:0] funct12,
output reg [0:0] memWrite,
output reg [0:0] rfWrite,
output reg [0:0] aluSrcA,
output reg [0:0] aluSrcB,
output reg [0:0] pcSrc,
output reg [0:0] pcWrite,
output reg [1:0] memOp,
output reg [3:0] rfWriteData,
output reg [3:0] aluOp,
output reg bInst,
output reg ebreak,
output reg ecall,
output reg csrImmInst,
output reg [1:0] csrInstType,
output reg csrWrite,
output reg mret
);

    always @ (*) begin
    
    case (opcode)
        //LUI
        `LUI_OPCODE: 
        begin
            bInst    = 1'b0;
            memOp    = 2'b00;
            pcWrite  = 1'b0;
            memWrite = 1'b0;
            rfWrite  = 1'b1;
            aluSrcA  = 1'b0;
            aluSrcB  = 1'b1;
            pcSrc    = 1'b0;
            rfWriteData = `RF_ALU;
            aluOp = `ALU_0P_LUI;
            ebreak = 1'b0;
            ecall = 1'b0;
            csrImmInst = 1'b0;
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0;
        end
        
        //AUIPC
        `AUIPC_OPCODE: 
        begin
            bInst    = 1'b0;
            memOp    = 2'b00;
            pcWrite  = 1'b0;
            memWrite = 1'b0;
            rfWrite  = 1'b1;
            aluSrcA  = 1'b0;
            aluSrcB  = 1'b1;
            pcSrc    = 1'b0;
            rfWriteData = `RF_ALU;
            aluOp = `ALU_0P_ADD;
            ebreak = 1'b0;      
            ecall = 1'b0;       
            csrImmInst = 1'b0;  
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0;    
        end
        
        //JAL
        `JAL_OPCODE: 
        begin
            bInst    = 1'b0;
            memOp    = 2'b00;
            pcWrite  = 1'b1;
            memWrite = 1'b0;
            rfWrite  = 1'b1;
            aluSrcA  = 1'b0;
            aluSrcB  = 1'b1;
            pcSrc    = 1'b1;
            rfWriteData = `RF_PC4;
            aluOp = `ALU_0P_ADD;
            ebreak = 1'b0;      
            ecall = 1'b0;       
            csrImmInst = 1'b0;  
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0;   
        end
        
        //JALR
        `JALR_OPCODE: 
        begin
            bInst    = 1'b0;
            memOp    = 2'b00;
            pcWrite  = 1'b1;
            memWrite = 1'b0;
            rfWrite  = 1'b1;
            aluSrcA  = 1'b1;
            aluSrcB  = 1'b1;
            pcSrc    = 1'b1;
            rfWriteData = `RF_PC4;
            aluOp = `ALU_0P_ADD;
            ebreak = 1'b0;      
            ecall = 1'b0;       
            csrImmInst = 1'b0;  
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0;   
        end
        
        //BEQ -> BGEU
        `B_OPCODE: 
        begin
            bInst    = 1'b1;
            memOp    = 2'b00;
            pcWrite  = 1'b0;
            memWrite = 0;
            rfWrite  = 0;
            aluSrcA  = 1;
            aluSrcB  = 0;
            pcSrc    = 0;
            rfWriteData = `RF_PC4;
            aluOp = `ALU_0P_SUB;
            ebreak = 1'b0;      
            ecall = 1'b0;       
            csrImmInst = 1'b0;  
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0;  
        end
        
        //LB->LHU
       `LOAD_OPCODE: 
        begin
            bInst    = 1'b0;
            memOp    = 2'b00;
            pcWrite  = 0;
            memWrite = 0;
            rfWrite  = 1;
            aluSrcA  = 1;
            aluSrcB  = 1;
            pcSrc    = 0;
            aluOp = `ALU_0P_ADD;
            ebreak = 1'b0;      
            ecall = 1'b0;       
            csrImmInst = 1'b0;  
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0; 
            if (funct3 == `F3_LB) 
                rfWriteData = `RF_LB;
            else if (funct3 == `F3_LH)//LH
                rfWriteData = `RF_LH;
            else if (funct3 == `F3_LW)//LW
                rfWriteData = `RF_MEMOUT;
            else if (funct3 == 3'b100)//LBU
                rfWriteData = `RF_LBU;
            else if (funct3 == `F3_LHU)//LHU
                rfWriteData = `RF_LHU;
            else
                rfWriteData = `RF_PC4;
        end
        
        //SB->SW
        `STORE_OPCODE: 
        begin
            bInst    = 1'b0;
            pcWrite  = 0;
            memWrite = 1;
            rfWrite  = 0;
            aluSrcA  = 1;
            aluSrcB  = 1;
            pcSrc    = 0;
            rfWriteData = `RF_PC4;
            aluOp = `ALU_0P_ADD;
            ebreak = 1'b0;      
            ecall = 1'b0;       
            csrImmInst = 1'b0;  
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0;   
            if (funct3 == `F3_SB )//SB
                memOp    = 2'b10;
            else if (funct3 == `F3_SH )//SH
                memOp    = 2'b01;
            else if (funct3 == `F3_SW )//SW
                memOp    = 2'b11;
            else
                memOp    = 2'b00;        
        end
        
        //ADDI->SRAI
        `I_OPCODE: 
        begin
            bInst    = 1'b0;
            memOp    = 2'b00;
            pcWrite  = 0;
            memWrite = 0;
            rfWrite  = 1;
            aluSrcA  = 1;
            aluSrcB  = 1;
            pcSrc    = 0;
            ebreak = 1'b0;      
            ecall = 1'b0;       
            csrImmInst = 1'b0;  
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0;  
            if (funct3 == `F3_ADDI) begin  //ADDI
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_ADD;
            end
            else if (funct3 == `F3_SLTI) begin  //SLTI
                rfWriteData = `RF_MSB;
                aluOp = `ALU_0P_SUB;
            end
            else if (funct3 == `F3_SLTIU) begin  //SLTIU
                rfWriteData = `RF_NOTCOUT;
                aluOp = `ALU_0P_SUB;
            end
            else if (funct3 == `F3_XORI) begin  //XORI
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_XOR;
            end
            else if (funct3 == `F3_ORI) begin  //ORI
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_OR;
            end
            else if (funct3 == `F3_ANDI) begin  //ANDI
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_AND;
            end
            else if (funct3 == `F3_SLLI) begin  //SLLI
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_SLL;
            end
            else if (funct3 == `F3_SRLI_SRAI) begin  //SRLI,SRAI
                rfWriteData = `RF_ALU;
                if (funct7 == 0)//SRLI
                aluOp = `ALU_0P_SRL;
                else            //SRAI
                aluOp = `ALU_0P_SRAI;
            end
            else begin 
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_SRAI;
            end
        end
        
        //ADD->AND
        `R_OPCODE: 
        begin
            bInst    = 1'b0;
            memOp    = 2'b00;
            pcWrite  = 0;
            memWrite = 0;
            rfWrite  = 1;
            aluSrcA  = 1;
            aluSrcB  = 0;
            pcSrc    = 0;
            ebreak = 1'b0;      
            ecall = 1'b0;       
            csrImmInst = 1'b0;  
            csrInstType = 2'b00;
            csrWrite = 1'b0;
            mret = 1'b0;
            if (funct3 == `F3_ADD_SUB) //ADD,SUB
            begin
                if (funct7 == 0) begin//ADD
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_ADD;
                end
                else begin //SUB
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_SUB;
                end
            end
            else if (funct3 == `F3_SLL)//SLL
            begin
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_SLL;
            end
            else if (funct3 == `F3_SLT)//SLT
            begin
                rfWriteData = `RF_MSB;
                aluOp = `ALU_0P_SUB;
            end
            else if (funct3 == `F3_SLTU)//SLTU
            begin
                rfWriteData = `RF_NOTCOUT;
                aluOp = `ALU_0P_SUB;
            end
            else if (funct3 == `F3_XOR)//XOR
            begin
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_XOR;
            end
            else if (funct3 == `F3_SRL_SRA)//SRL,SRA
            begin
                if (funct7 == 0)begin//SRL
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_SRL;
                end
                else begin//SRA
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_SRA;
                end
            end
            else if (funct3 == `F3_OR)//OR
            begin
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_OR;
            end
            else if (funct3 == `F3_AND)//AND
            begin
                rfWriteData = `RF_ALU;
                aluOp = `ALU_0P_AND;
            end
            else begin
                rfWriteData = `RF_PC4;
                aluOp = `ALU_0P_ADD;
            end
        end
        `SYSTEM_OPCODE: begin
            bInst    = 1'b0;
            memOp    = 2'b00;
            pcWrite  = 1'b0;
            memWrite = 1'b0;
            aluSrcA  = 1'b0;
            aluSrcB  = 1'b0;
            pcSrc    = 1'b0;
            aluOp    = `ALU_0P_ADD;

            case (funct3)
                `F3_E: begin //ebreak and ecall
                    rfWrite  = 1'b0;
                    rfWriteData = `RF_PC4;
                    csrImmInst = 1'b0;  
                    csrInstType = 2'b00;
                    csrWrite = 1'b0;
                    if(funct12 == 12'h001) begin
                        ebreak = 1'b1;
                        ecall = 1'b0;
                        mret = 1'b0;
                    end
                    else if(funct12 == 12'h000) begin
                        ebreak = 1'b0;
                        ecall = 1'b1;
                        mret = 1'b0;
                    end
                    else if(funct12 == 12'h302) begin
                        ebreak = 1'b0;
                        ecall = 1'b0;
                        mret = 1'b1;
                    end
                    else begin
                        ebreak = 1'b0;
                        ecall = 1'b0;
                        mret = 1'b0;
                    end
                end
                `F3_CSRRW: begin //csrrw
                    rfWrite  = 1'b1;
                    ebreak = 1'b0;
                    ecall = 1'b0;
                    rfWriteData = `RF_CSR;
                    csrImmInst = 1'b0;
                    csrInstType = 2'b00;
                    csrWrite = 1'b1;
                    mret = 1'b0;
                end
                `F3_CSRRS: begin //csrrs
                    rfWrite  = 1'b1;
                    ebreak = 1'b0;
                    ecall = 1'b0;
                    rfWriteData = `RF_CSR;
                    csrImmInst = 1'b0;
                    csrInstType = 2'b01;
                    csrWrite = 1'b1;
                    mret = 1'b0;
                end
                `F3_CSRRC: begin //csrrc
                    rfWrite  = 1'b1;
                    ebreak = 1'b0;
                    ecall = 1'b0;
                    rfWriteData = `RF_CSR;
                    csrImmInst = 1'b0;
                    csrInstType = 2'b10;
                    csrWrite = 1'b1;
                    mret = 1'b0;
                end
                `F3_CSRRWI: begin //csrrwi
                    rfWrite  = 1'b1;
                    ebreak = 1'b0;
                    ecall = 1'b0;
                    rfWriteData = `RF_CSR;
                    csrImmInst = 1'b1;
                    csrInstType = 2'b00;
                    csrWrite = 1'b1;
                    mret = 1'b0;
                end
                `F3_CSRRSI: begin //csrrsi
                    rfWrite  = 1'b1;
                    ebreak = 1'b0;
                    ecall = 1'b0;
                    rfWriteData = `RF_CSR;
                    csrImmInst = 1'b1;
                    csrInstType = 2'b01;
                    csrWrite = 1'b1;
                    mret = 1'b0;
                end
                `F3_CSRRCI: begin //csrrci
                    rfWrite  = 1'b1;
                    ebreak = 1'b0;
                    ecall = 1'b0;
                    rfWriteData = `RF_CSR;
                    csrImmInst = 1'b1;
                    csrInstType = 2'b10;
                    csrWrite = 1'b1;
                    mret = 1'b0;
                end
                default: begin
                    rfWrite  = 1'b0;      
                    ebreak = 1'b0;        
                    ecall = 1'b0;         
                    rfWriteData = `RF_PC4;
                    csrImmInst = 1'b0;    
                    csrInstType = 2'b00;  
                    csrWrite = 1'b0;      
                    mret = 1'b0;          
                end
            endcase
        end
        default:
            begin
                bInst    = 1'b0;
                memOp    = 2'b00;
                pcWrite  = 1'b0;
                memWrite = 1'b0;
                rfWrite  = 1'b0;
                aluSrcA  = 1'b0;
                aluSrcB  = 1'b0;
                pcSrc    = 1'b0;
                rfWriteData = `RF_PC4;
                aluOp = `ALU_0P_ADD;
                ebreak = 1'b0;      
                ecall = 1'b0;       
                csrImmInst = 1'b0;  
                csrInstType = 2'b00;
                csrWrite = 1'b0;
                mret = 1'b0;
            end
    endcase
    end
endmodule

