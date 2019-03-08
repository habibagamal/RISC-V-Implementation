// file: defines.v
// author: @shalan

`define     IR_rs1          19:15
`define     IR_rs2          24:20
`define     IR_rd           11:7
`define     IR_opcode       6:2
`define     IR_funct3       14:12
`define     IR_funct7       31:25
`define     IR_shamt        24:20
`define     IR_csr          31:20

//OPCODE FOR IMM GEN
`define     OPCODE          IR[`IR_opcode]
`define     OPCODE_Branch   5'b11_000
`define     OPCODE_Load     5'b00_000
`define     OPCODE_Store    5'b01_000
`define     OPCODE_JALR     5'b11_001
`define     OPCODE_JAL      5'b11_011
`define     OPCODE_Arith_I  5'b00_100
`define     OPCODE_Arith_R  5'b01_100
`define     OPCODE_AUIPC    5'b00_101
`define     OPCODE_LUI      5'b01_101
`define     OPCODE_SYSTEM   5'b11_100 
`define     OPCODE_Custom   5'b10_001

//ALU OPERATIONS
`define     ALU_0P_ADD        4'b0000
`define     ALU_0P_SUB        4'b0001
`define     ALU_0P_AND        4'b0010
`define     ALU_0P_OR         4'b0011
`define     ALU_0P_XOR        4'b0100
`define     ALU_0P_SLL        4'b0101
`define     ALU_0P_SRL        4'b0110
`define     ALU_0P_SRA        4'b0111
`define     ALU_0P_LUI        4'b1000
`define     ALU_0P_SRAI       4'b1001

//F3 for I instructions
`define     F3_ADDI         3'b000
`define     F3_SLTI         3'b010
`define     F3_SLTIU        3'b011
`define     F3_XORI         3'b100
`define     F3_ORI          3'b110
`define     F3_ANDI         3'b111
`define     F3_SLLI         3'b001
`define     F3_SRLI_SRAI    3'b101


//F3 FOR STORED
`define     F3_SB          3'b000
`define     F3_SH           3'b001
`define     F3_SW           3'b010

//F3 for R instructions

`define     F3_ADD_SUB      3'b000
`define     F3_SLL          3'b001
`define     F3_SLT          3'b010
`define     F3_SLTU         3'b011
`define     F3_XOR          3'b100
`define     F3_SRL_SRA      3'b101
`define     F3_OR           3'b110
`define     F3_AND          3'b111

//F3 FOR LOADS
`define     F3_LB          3'b000
`define     F3_LH          3'b001
`define     F3_LW          3'b010
`define     F3_LBU         3'b100
`define     F3_LHU         3'b101

//F3 FOR SYSTEMS
`define     F3_E            3'b000
`define     F3_CSRRW        3'b001
`define     F3_CSRRS        3'b010
`define     F3_CSRRC        3'b011
`define     F3_CSRRWI       3'b101
`define     F3_CSRRSI       3'b110
`define     F3_CSRRCI       3'b111


//INSTRUCTION OPCODES
`define     LUI_OPCODE      7'b0110111
`define     AUIPC_OPCODE    7'b0010111
`define     JAL_OPCODE      7'b1101111
`define     JALR_OPCODE     7'b1100111
`define     B_OPCODE        7'b1100011
`define     LOAD_OPCODE     7'b0000011
`define     STORE_OPCODE    7'b0100011
`define     I_OPCODE        7'b0010011
`define     R_OPCODE        7'b0110011
`define     SYSTEM_OPCODE   7'b1110011

//BRANCHES FUNC3
`define     BR_BEQ          3'b000
`define     BR_BNE          3'b001
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101
`define     BR_BLTU         3'b110
`define     BR_BGEU         3'b111

//RF write data
`define     RF_PC4          4'b0000
`define     RF_MEMOUT       4'b0001
`define     RF_LH           4'b0010
`define     RF_LHU          4'b0011
`define     RF_LB           4'b0100
`define     RF_LBU          4'b0101
`define     RF_MSB          4'b0110
`define     RF_ALU          4'b0111
`define     RF_NOTCOUT      4'b1000
`define     RF_CSR          4'b1001

`define     ADDR_LSB_00     2'b00
`define     ADDR_LSB_01     2'b01
`define     ADDR_LSB_10     2'b10
`define     ADDR_LSB_11     2'b11

`define     MEM_OP_00       2'b00
`define     MEM_OP_01       2'b01
`define     MEM_OP_10       2'b10

`define     C_OP_00         2'b00
`define     C_OP_01         2'b01
`define     C_OP_10         2'b10

`define     C_funct3_000    3'b000
`define     C_funct3_001    3'b001
`define     C_funct3_010    3'b010
`define     C_funct3_011    3'b011
`define     C_funct3_100    3'b100
`define     C_funct3_101    3'b101
`define     C_funct3_110    3'b110
`define     C_funct3_111    3'b111

`define     bits_00         2'b00
`define     bits_01         2'b00
`define     bits_10         2'b00
`define     bits_11         2'b00

`define     NUM_ZERO            3'b000
`define     NUM_ONE             3'b001
`define     NUM_TWO             3'b010
`define     NUM_THREE           3'b011
`define     NUM_FOUR            3'b100
`define     NUM_FIVE            3'b101
`define     NUM_SIX             3'b110
`define     NUM_SEVEN           3'b111

//`define     ALU_ADD         4'b00_00
//`define     ALU_SUB         4'b00_01
//`define     ALU_PASS        4'b00_11
//`define     ALU_OR          4'b01_00
//`define     ALU_AND         4'b01_01
//`define     ALU_XOR         4'b01_11
//`define     ALU_SRL         4'b10_00
//`define     ALU_SRA         4'b10_10
//`define     ALU_SLL         4'b10_01
//`define     ALU_SLT         4'b11_01
//`define     ALU_SLTU        4'b11_11

//`define     SYS_EC_EB       3'b000
//`define     SYS_CSRRW       3'b001
//`define     SYS_CSRRS       3'b010
//`define     SYS_CSRRC       3'b011
//`define     SYS_CSRRWI      3'b101
//`define     SYS_CSRRSI      3'b110
//`define     SYS_CSRRCI      3'b111
