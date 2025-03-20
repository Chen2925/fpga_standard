module FPGA_TOP_SIM (
    //system signals
    input                               CLK                                     ,//(i)  [  1]
    input                               RST                                     ,//(i)  [  1]

    //LBUS interface signals
    input                               LBUS_WR                                 ,//(i)  [  1] Active low
    input                               LBUS_RD                                 ,//(i)  [  1] Active low
    input                               LBUS_CS                                 ,//(i)  [  1] Active low
    input       [  12:0]                LBUS_ADDR                               ,//(i)  [ 13]
    inout       [  31:0]                LBUS_DATA                                //(io) [ 32]
    );

// =============================================================================
// Internal signal define
// =============================================================================

    wire                                s_DRAM0_WR_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM0_WR_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM0_WR_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM0_WR_BL                           ;//(s)  [  12]
    wire                                s_DRAM0_WR_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM0_WR_DATA                         ;//(s)  [  32]
    wire                                s_DRAM0_WR_SOP                          ;//(s)  [   1]
    wire                                s_DRAM0_WR_EOP                          ;//(s)  [   1]
    wire                                s_DRAM0_WR_RDY                          ;//(s)  [   1]
    wire                                s_DRAM0_WR_ACK                          ;//(s)  [   1]

    wire                                s_DRAM0_RD_ACK                          ;//(s)  [   1]
    wire                                s_DRAM0_RD_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM0_RD_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM0_RD_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM0_RD_BL                           ;//(s)  [  12]
    wire                                s_DRAM0_RD_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM0_RD_DATA                         ;//(s)  [  32]
    wire                                s_DRAM0_RD_SOP                          ;//(s)  [   1]
    wire                                s_DRAM0_RD_EOP                          ;//(s)  [   1]
    wire                                s_DRAM0_RD_RDY                          ;//(s)  [   1]

    wire                                s_DRAM1_WR_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM1_WR_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM1_WR_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM1_WR_BL                           ;//(s)  [  12]
    wire                                s_DRAM1_WR_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM1_WR_DATA                         ;//(s)  [  32]
    wire                                s_DRAM1_WR_SOP                          ;//(s)  [   1]
    wire                                s_DRAM1_WR_EOP                          ;//(s)  [   1]
    wire                                s_DRAM1_WR_RDY                          ;//(s)  [   1]
    wire                                s_DRAM1_WR_ACK                          ;//(s)  [   1]

    wire                                s_DRAM1_RD_ACK                          ;//(s)  [   1]
    wire                                s_DRAM1_RD_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM1_RD_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM1_RD_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM1_RD_BL                           ;//(s)  [  12]
    wire                                s_DRAM1_RD_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM1_RD_DATA                         ;//(s)  [  32]
    wire                                s_DRAM1_RD_SOP                          ;//(s)  [   1]
    wire                                s_DRAM1_RD_EOP                          ;//(s)  [   1]
    wire                                s_DRAM1_RD_RDY                          ;//(s)  [   1]

    wire                                s_DRAM2_WR_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM2_WR_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM2_WR_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM2_WR_BL                           ;//(s)  [  12]
    wire                                s_DRAM2_WR_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM2_WR_DATA                         ;//(s)  [  32]
    wire                                s_DRAM2_WR_SOP                          ;//(s)  [   1]
    wire                                s_DRAM2_WR_EOP                          ;//(s)  [   1]
    wire                                s_DRAM2_WR_RDY                          ;//(s)  [   1]
    wire                                s_DRAM2_WR_ACK                          ;//(s)  [   1]

    wire                                s_DRAM2_RD_ACK                          ;//(s)  [   1]
    wire                                s_DRAM2_RD_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM2_RD_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM2_RD_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM2_RD_BL                           ;//(s)  [  12]
    wire                                s_DRAM2_RD_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM2_RD_DATA                         ;//(s)  [  32]
    wire                                s_DRAM2_RD_SOP                          ;//(s)  [   1]
    wire                                s_DRAM2_RD_EOP                          ;//(s)  [   1]
    wire                                s_DRAM2_RD_RDY                          ;//(s)  [   1]

    wire                                s_DRAM3_WR_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM3_WR_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM3_WR_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM3_WR_BL                           ;//(s)  [  12]
    wire                                s_DRAM3_WR_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM3_WR_DATA                         ;//(s)  [  32]
    wire                                s_DRAM3_WR_SOP                          ;//(s)  [   1]
    wire                                s_DRAM3_WR_EOP                          ;//(s)  [   1]
    wire                                s_DRAM3_WR_RDY                          ;//(s)  [   1]
    wire                                s_DRAM3_WR_ACK                          ;//(s)  [   1]

    wire                                s_DRAM3_RD_ACK                          ;//(s)  [   1]
    wire                                s_DRAM3_RD_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM3_RD_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM3_RD_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM3_RD_BL                           ;//(s)  [  12]
    wire                                s_DRAM3_RD_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM3_RD_DATA                         ;//(s)  [  32]
    wire                                s_DRAM3_RD_SOP                          ;//(s)  [   1]
    wire                                s_DRAM3_RD_EOP                          ;//(s)  [   1]
    wire                                s_DRAM3_RD_RDY                          ;//(s)  [   1]

    wire                                s_DRAM4_WR_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM4_WR_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM4_WR_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM4_WR_BL                           ;//(s)  [  12]
    wire                                s_DRAM4_WR_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM4_WR_DATA                         ;//(s)  [  32]
    wire                                s_DRAM4_WR_SOP                          ;//(s)  [   1]
    wire                                s_DRAM4_WR_EOP                          ;//(s)  [   1]
    wire                                s_DRAM4_WR_RDY                          ;//(s)  [   1]
    wire                                s_DRAM4_WR_ACK                          ;//(s)  [   1]

    wire                                s_DRAM4_RD_ACK                          ;//(s)  [   1]
    wire                                s_DRAM4_RD_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM4_RD_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM4_RD_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM4_RD_BL                           ;//(s)  [  12]
    wire                                s_DRAM4_RD_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM4_RD_DATA                         ;//(s)  [  32]
    wire                                s_DRAM4_RD_SOP                          ;//(s)  [   1]
    wire                                s_DRAM4_RD_EOP                          ;//(s)  [   1]
    wire                                s_DRAM4_RD_RDY                          ;//(s)  [   1]

    wire                                s_DRAM5_WR_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM5_WR_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM5_WR_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM5_WR_BL                           ;//(s)  [  12]
    wire                                s_DRAM5_WR_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM5_WR_DATA                         ;//(s)  [  32]
    wire                                s_DRAM5_WR_SOP                          ;//(s)  [   1]
    wire                                s_DRAM5_WR_EOP                          ;//(s)  [   1]
    wire                                s_DRAM5_WR_RDY                          ;//(s)  [   1]
    wire                                s_DRAM5_WR_ACK                          ;//(s)  [   1]

    wire                                s_DRAM5_RD_ACK                          ;//(s)  [   1]
    wire                                s_DRAM5_RD_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM5_RD_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM5_RD_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM5_RD_BL                           ;//(s)  [  12]
    wire                                s_DRAM5_RD_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM5_RD_DATA                         ;//(s)  [  32]
    wire                                s_DRAM5_RD_SOP                          ;//(s)  [   1]
    wire                                s_DRAM5_RD_EOP                          ;//(s)  [   1]
    wire                                s_DRAM5_RD_RDY                          ;//(s)  [   1]

    wire                                s_DRAM6_WR_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM6_WR_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM6_WR_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM6_WR_BL                           ;//(s)  [  12]
    wire                                s_DRAM6_WR_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM6_WR_DATA                         ;//(s)  [  32]
    wire                                s_DRAM6_WR_SOP                          ;//(s)  [   1]
    wire                                s_DRAM6_WR_EOP                          ;//(s)  [   1]
    wire                                s_DRAM6_WR_RDY                          ;//(s)  [   1]
    wire                                s_DRAM6_WR_ACK                          ;//(s)  [   1]

    wire                                s_DRAM6_RD_ACK                          ;//(s)  [   1]
    wire                                s_DRAM6_RD_REQ                          ;//(s)  [   1]
    wire        [  24:0]                s_DRAM6_RD_ADDR                         ;//(s)  [  32]
    wire        [  11:0]                s_DRAM6_RD_SIZE                         ;//(s)  [  12]
    wire        [  11:0]                s_DRAM6_RD_BL                           ;//(s)  [  12]
    wire                                s_DRAM6_RD_DVLD                         ;//(s)  [   1]
    wire        [  31:0]                s_DRAM6_RD_DATA                         ;//(s)  [  32]
    wire                                s_DRAM6_RD_SOP                          ;//(s)  [   1]
    wire                                s_DRAM6_RD_EOP                          ;//(s)  [   1]
    wire                                s_DRAM6_RD_RDY                          ;//(s)  [   1]

    wire                                s_BRAM0_WR_ACK                          ;//(s)  [   1]
    wire                                s_BRAM0_WR_REQ                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM0_WR_DATA                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM0_WR_ADDR                         ;//(s)  [  16]
    wire        [  15:0]                s_BRAM0_RD_ADDR                         ;//(s)  [  16]
    wire                                s_BRAM0_RD_REQ                          ;//(s)  [   1]
    wire                                s_BRAM0_RD_ACK                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM0_RD_DATA                         ;//(s)  [  32]

    wire                                s_BRAM1_WR_ACK                          ;//(s)  [   1]
    wire                                s_BRAM1_WR_REQ                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM1_WR_DATA                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM1_WR_ADDR                         ;//(s)  [  16]
    wire        [  15:0]                s_BRAM1_RD_ADDR                         ;//(s)  [  16]
    wire                                s_BRAM1_RD_REQ                          ;//(s)  [   1]
    wire                                s_BRAM1_RD_ACK                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM1_RD_DATA                         ;//(s)  [  32]

    wire                                s_BRAM2_WR_ACK                          ;//(s)  [   1]
    wire                                s_BRAM2_WR_REQ                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM2_WR_DATA                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM2_WR_ADDR                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM2_RD_ADDR                         ;//(s)  [  32]
    wire                                s_BRAM2_RD_REQ                          ;//(s)  [   1]
    wire                                s_BRAM2_RD_ACK                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM2_RD_DATA                         ;//(s)  [  32]

    wire                                s_BRAM3_WR_ACK                          ;//(s)  [   1]
    wire                                s_BRAM3_WR_REQ                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM3_WR_DATA                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM3_WR_ADDR                         ;//(s)  [  16]
    wire        [  15:0]                s_BRAM3_RD_ADDR                         ;//(s)  [  16]
    wire                                s_BRAM3_RD_REQ                          ;//(s)  [   1]
    wire                                s_BRAM3_RD_ACK                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM3_RD_DATA                         ;//(s)  [  32]

    wire                                s_BRAM4_WR_ACK                          ;//(s)  [   1]
    wire                                s_BRAM4_WR_REQ                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM4_WR_DATA                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM4_WR_ADDR                         ;//(s)  [  16]
    wire        [  15:0]                s_BRAM4_RD_ADDR                         ;//(s)  [  16]
    wire                                s_BRAM4_RD_REQ                          ;//(s)  [   1]
    wire                                s_BRAM4_RD_ACK                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM4_RD_DATA                         ;//(s)  [  32]

    wire                                s_BRAM5_WR_ACK                          ;//(s)  [   1]
    wire                                s_BRAM5_WR_REQ                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM5_WR_DATA                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM5_WR_ADDR                         ;//(s)  [  16]
    wire        [  15:0]                s_BRAM5_RD_ADDR                         ;//(s)  [  16]
    wire                                s_BRAM5_RD_REQ                          ;//(s)  [   1]
    wire                                s_BRAM5_RD_ACK                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM5_RD_DATA                         ;//(s)  [  32]

    wire                                s_BRAM6_WR_ACK                          ;//(s)  [   1]
    wire                                s_BRAM6_WR_REQ                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM6_WR_DATA                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM6_WR_ADDR                         ;//(s)  [  16]
    wire        [  15:0]                s_BRAM6_RD_ADDR                         ;//(s)  [  16]
    wire                                s_BRAM6_RD_REQ                          ;//(s)  [   1]
    wire                                s_BRAM6_RD_ACK                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM6_RD_DATA                         ;//(s)  [  32]

    wire                                s_BRAM7_WR_ACK                          ;//(s)  [   1]
    wire                                s_BRAM7_WR_REQ                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM7_WR_DATA                         ;//(s)  [  32]
    wire        [  15:0]                s_BRAM7_WR_ADDR                         ;//(s)  [  16]
    wire        [  15:0]                s_BRAM7_RD_ADDR                         ;//(s)  [  16]
    wire                                s_BRAM7_RD_REQ                          ;//(s)  [   1]
    wire                                s_BRAM7_RD_ACK                          ;//(s)  [   1]
    wire        [  31:0]                s_BRAM7_RD_DATA                         ;//(s)  [  32]

    wire                                s_REG0_WR_ACK                           ;//(s)  [   1]
    wire                                s_REG0_WR_REQ                           ;//(s)  [   1]
    wire        [  31:0]                s_REG0_WR_DATA                          ;//(s)  [  32]
    wire        [   9:0]                s_REG0_OP_ADDR                          ;//(s)  [  10]
    wire                                s_REG0_RD_REQ                           ;//(s)  [   1]
    wire                                s_REG0_RD_ACK                           ;//(s)  [   1]
    wire        [  31:0]                s_REG0_RD_DATA                          ;//(s)  [  32]

    wire                                s_REG1_WR_ACK                           ;//(s)  [   1]
    wire                                s_REG1_WR_REQ                           ;//(s)  [   1]
    wire        [  31:0]                s_REG1_WR_DATA                          ;//(s)  [  32]
    wire        [   9:0]                s_REG1_OP_ADDR                          ;//(s)  [  10]
    wire                                s_REG1_RD_REQ                           ;//(s)  [   1]
    wire                                s_REG1_RD_ACK                           ;//(s)  [   1]
    wire        [  31:0]                s_REG1_RD_DATA                          ;//(s)  [  32]

    wire                                s_REG2_WR_ACK                           ;//(s)  [   1]
    wire                                s_REG2_WR_REQ                           ;//(s)  [   1]
    wire        [  31:0]                s_REG2_WR_DATA                          ;//(s)  [  32]
    wire        [   9:0]                s_REG2_OP_ADDR                          ;//(s)  [  10]
    wire                                s_REG2_RD_REQ                           ;//(s)  [   1]
    wire                                s_REG2_RD_ACK                           ;//(s)  [   1]
    wire        [  31:0]                s_REG2_RD_DATA                          ;//(s)  [  32]

    wire                                s_REG3_WR_ACK                           ;//(s)  [   1]
    wire                                s_REG3_WR_REQ                           ;//(s)  [   1]
    wire        [  31:0]                s_REG3_WR_DATA                          ;//(s)  [  32]
    wire        [   9:0]                s_REG3_OP_ADDR                          ;//(s)  [  13]
    wire                                s_REG3_RD_REQ                           ;//(s)  [   1]
    wire                                s_REG3_RD_ACK                           ;//(s)  [   1]
    wire        [  31:0]                s_REG3_RD_DATA                          ;//(s)  [  32]

    wire                                s_REG4_WR_ACK                           ;//(s)  [   1]
    wire                                s_REG4_WR_REQ                           ;//(s)  [   1]
    wire        [  31:0]                s_REG4_WR_DATA                          ;//(s)  [  32]
    wire        [   9:0]                s_REG4_OP_ADDR                          ;//(s)  [  10]
    wire                                s_REG4_RD_REQ                           ;//(s)  [   1]
    wire                                s_REG4_RD_ACK                           ;//(s)  [   1]
    wire        [  31:0]                s_REG4_RD_DATA                          ;//(s)  [  32]

    wire                                s_REG5_WR_ACK                           ;//(s)  [   1]
    wire                                s_REG5_WR_REQ                           ;//(s)  [   1]
    wire        [  31:0]                s_REG5_WR_DATA                          ;//(s)  [  32]
    wire        [   9:0]                s_REG5_OP_ADDR                          ;//(s)  [  10]
    wire                                s_REG5_RD_REQ                           ;//(s)  [   1]
    wire                                s_REG5_RD_ACK                           ;//(s)  [   1]
    wire        [  31:0]                s_REG5_RD_DATA                          ;//(s)  [  32]

    wire                                s_REG6_WR_ACK                           ;//(s)  [   1]
    wire                                s_REG6_WR_REQ                           ;//(s)  [   1]
    wire        [  31:0]                s_REG6_WR_DATA                          ;//(s)  [  32]
    wire        [   9:0]                s_REG6_OP_ADDR                          ;//(s)  [  10]
    wire                                s_REG6_RD_REQ                           ;//(s)  [   1]
    wire                                s_REG6_RD_ACK                           ;//(s)  [   1]
    wire        [  31:0]                s_REG6_RD_DATA                          ;//(s)  [  32]

    wire                                s_REG7_WR_ACK                           ;//(s)  [   1]
    wire                                s_REG7_WR_REQ                           ;//(s)  [   1]
    wire        [  31:0]                s_REG7_WR_DATA                          ;//(s)  [  32]
    wire        [   9:0]                s_REG7_OP_ADDR                          ;//(s)  [  10]
    wire                                s_REG7_RD_REQ                           ;//(s)  [   1]
    wire                                s_REG7_RD_ACK                           ;//(s)  [   1]
    wire        [  31:0]                s_REG7_RD_DATA                          ;//(s)  [  32]

// ==========================================================================================
// RTL Body
// ==========================================================================================

/*============================================================================+/
||                                                                            ||
||                                  LBUS_IF                                   ||
||                                                                            ||
/+============================================================================*/

    LBUS_TOP U01_LBUS_TOP (
       .CLK                             ( CLK                           ),//(i)  [   1]
       .RST                             ( RST                           ),//(i)  [   1]

       .LBUS_WR                         ( LBUS_WR                       ),//(i)  [   1] Active low
       .LBUS_RD                         ( LBUS_RD                       ),//(i)  [   1] Active low
       .LBUS_CS                         ( LBUS_CS                       ),//(i)  [   1] Active low
       .LBUS_ADDR                       ( LBUS_ADDR                     ),//(i)  [  13]
       .LBUS_DATA                       ( LBUS_DATA                     ),//(io) [  32]

       //REG IF
       .REG0_WR_REQ                     ( s_REG0_WR_REQ                 ),//(o)  [   1]
       .REG0_WR_ACK                     ( s_REG0_WR_ACK                 ),//(i)  [   1]
       .REG0_WR_DATA                    ( s_REG0_WR_DATA                ),//(o)  [  32]
       .REG0_RD_REQ                     ( s_REG0_RD_REQ                 ),//(o)  [   1]
       .REG0_RD_ACK                     ( s_REG0_RD_ACK                 ),//(i)  [   1]
       .REG0_RD_DATA                    ( s_REG0_RD_DATA                ),//(i)  [  32]
       .REG0_OP_ADDR                    ( s_REG0_OP_ADDR                ),//(o)  [  10]

       .REG2_WR_REQ                     ( s_REG2_WR_REQ                 ),//(o)  [   1]
       .REG2_WR_ACK                     ( s_REG2_WR_ACK                 ),//(i)  [   1]
       .REG2_WR_DATA                    ( s_REG2_WR_DATA                ),//(o)  [  32]
       .REG2_RD_REQ                     ( s_REG2_RD_REQ                 ),//(o)  [   1]
       .REG2_RD_ACK                     ( s_REG2_RD_ACK                 ),//(i)  [   1]
       .REG2_RD_DATA                    ( s_REG2_RD_DATA                ),//(i)  [  32]
       .REG2_OP_ADDR                    ( s_REG2_OP_ADDR                ),//(o)  [  10]

       .REG3_WR_REQ                     ( s_REG3_WR_REQ                 ),//(o)  [   1]
       .REG3_WR_ACK                     ( s_REG3_WR_ACK                 ),//(i)  [   1]
       .REG3_WR_DATA                    ( s_REG3_WR_DATA                ),//(o)  [  32]
       .REG3_RD_REQ                     ( s_REG3_RD_REQ                 ),//(o)  [   1]
       .REG3_RD_ACK                     ( s_REG3_RD_ACK                 ),//(i)  [   1]
       .REG3_RD_DATA                    ( s_REG3_RD_DATA                ),//(i)  [  32]
       .REG3_OP_ADDR                    ( s_REG3_OP_ADDR                ),//(o)  [  10]

       .REG4_WR_REQ                     ( s_REG4_WR_REQ                 ),//(o)  [   1]
       .REG4_WR_ACK                     ( s_REG4_WR_ACK                 ),//(i)  [   1]
       .REG4_WR_DATA                    ( s_REG4_WR_DATA                ),//(o)  [  32]
       .REG4_RD_REQ                     ( s_REG4_RD_REQ                 ),//(o)  [   1]
       .REG4_RD_ACK                     ( s_REG4_RD_ACK                 ),//(i)  [   1]
       .REG4_RD_DATA                    ( s_REG4_RD_DATA                ),//(i)  [  32]
       .REG4_OP_ADDR                    ( s_REG4_OP_ADDR                ),//(o)  [  10]

       .REG5_WR_REQ                     ( s_REG5_WR_REQ                 ),//(o)  [   1]
       .REG5_WR_ACK                     ( s_REG5_WR_ACK                 ),//(i)  [   1]
       .REG5_WR_DATA                    ( s_REG5_WR_DATA                ),//(o)  [  32]
       .REG5_RD_REQ                     ( s_REG5_RD_REQ                 ),//(o)  [   1]
       .REG5_RD_ACK                     ( s_REG5_RD_ACK                 ),//(i)  [   1]
       .REG5_RD_DATA                    ( s_REG5_RD_DATA                ),//(i)  [  32]
       .REG5_OP_ADDR                    ( s_REG5_OP_ADDR                ),//(o)  [  10]

       .REG6_WR_REQ                     ( s_REG6_WR_REQ                 ),//(o)  [   1]
       .REG6_WR_ACK                     ( s_REG6_WR_ACK                 ),//(i)  [   1]
       .REG6_WR_DATA                    ( s_REG6_WR_DATA                ),//(o)  [  32]
       .REG6_RD_REQ                     ( s_REG6_RD_REQ                 ),//(o)  [   1]
       .REG6_RD_ACK                     ( s_REG6_RD_ACK                 ),//(i)  [   1]
       .REG6_RD_DATA                    ( s_REG6_RD_DATA                ),//(i)  [  32]
       .REG6_OP_ADDR                    ( s_REG6_OP_ADDR                ),//(o)  [  10]

       .REG7_WR_REQ                     ( s_REG7_WR_REQ                 ),//(o)  [   1]
       .REG7_WR_ACK                     ( s_REG7_WR_ACK                 ),//(i)  [   1]
       .REG7_WR_DATA                    ( s_REG7_WR_DATA                ),//(o)  [  32]
       .REG7_RD_REQ                     ( s_REG7_RD_REQ                 ),//(o)  [   1]
       .REG7_RD_ACK                     ( s_REG7_RD_ACK                 ),//(i)  [   1]
       .REG7_RD_DATA                    ( s_REG7_RD_DATA                ),//(i)  [  32]
       .REG7_OP_ADDR                    ( s_REG7_OP_ADDR                ),//(o)  [  10]

       .BRAM0_WR_REQ                    ( s_BRAM0_WR_REQ                ),//(o)  [   1]
       .BRAM0_WR_ACK                    ( s_BRAM0_WR_ACK                ),//(i)  [   1]
       .BRAM0_WR_DATA                   ( s_BRAM0_WR_DATA               ),//(o)  [  32]
       .BRAM0_WR_ADDR                   ( s_BRAM0_WR_ADDR               ),//(o)  [  16]
       .BRAM0_RD_REQ                    ( s_BRAM0_RD_REQ                ),//(o)  [   1]
       .BRAM0_RD_ACK                    ( s_BRAM0_RD_ACK                ),//(i)  [   1]
       .BRAM0_RD_DATA                   ( s_BRAM0_RD_DATA               ),//(i)  [  32]
       .BRAM0_RD_ADDR                   ( s_BRAM0_RD_ADDR               ),//(o)  [  16]

       .BRAM1_WR_REQ                    ( s_BRAM1_WR_REQ                ),//(o)  [   1]
       .BRAM1_WR_ACK                    ( s_BRAM1_WR_ACK                ),//(i)  [   1]
       .BRAM1_WR_DATA                   ( s_BRAM1_WR_DATA               ),//(o)  [  32]
       .BRAM1_WR_ADDR                   ( s_BRAM1_WR_ADDR               ),//(o)  [  16]
       .BRAM1_RD_REQ                    ( s_BRAM1_RD_REQ                ),//(o)  [   1]
       .BRAM1_RD_ACK                    ( s_BRAM1_RD_ACK                ),//(i)  [   1]
       .BRAM1_RD_DATA                   ( s_BRAM1_RD_DATA               ),//(i)  [  32]
       .BRAM1_RD_ADDR                   ( s_BRAM1_RD_ADDR               ),//(o)  [  16]

       .BRAM2_WR_REQ                    ( s_BRAM2_WR_REQ                ),//(o)  [   1]
       .BRAM2_WR_ACK                    ( s_BRAM2_WR_ACK                ),//(i)  [   1]
       .BRAM2_WR_DATA                   ( s_BRAM2_WR_DATA               ),//(o)  [  32]
       .BRAM2_WR_ADDR                   ( s_BRAM2_WR_ADDR               ),//(o)  [  16]
       .BRAM2_RD_REQ                    ( s_BRAM2_RD_REQ                ),//(o)  [   1]
       .BRAM2_RD_ACK                    ( s_BRAM2_RD_ACK                ),//(i)  [   1]
       .BRAM2_RD_DATA                   ( s_BRAM2_RD_DATA               ),//(i)  [  32]
       .BRAM2_RD_ADDR                   ( s_BRAM2_RD_ADDR               ),//(o)  [  16]

       .BRAM3_WR_REQ                    ( s_BRAM3_WR_REQ                ),//(o)  [   1]
       .BRAM3_WR_ACK                    ( s_BRAM3_WR_ACK                ),//(i)  [   1]
       .BRAM3_WR_DATA                   ( s_BRAM3_WR_DATA               ),//(o)  [  32]
       .BRAM3_WR_ADDR                   ( s_BRAM3_WR_ADDR               ),//(o)  [  16]
       .BRAM3_RD_REQ                    ( s_BRAM3_RD_REQ                ),//(o)  [   1]
       .BRAM3_RD_ACK                    ( s_BRAM3_RD_ACK                ),//(i)  [   1]
       .BRAM3_RD_DATA                   ( s_BRAM3_RD_DATA               ),//(i)  [  32]
       .BRAM3_RD_ADDR                   ( s_BRAM3_RD_ADDR               ),//(o)  [  16]

       .BRAM4_WR_REQ                    ( s_BRAM4_WR_REQ                ),//(o)  [   1]
       .BRAM4_WR_ACK                    ( s_BRAM4_WR_ACK                ),//(i)  [   1]
       .BRAM4_WR_DATA                   ( s_BRAM4_WR_DATA               ),//(o)  [  32]
       .BRAM4_WR_ADDR                   ( s_BRAM4_WR_ADDR               ),//(o)  [  16]
       .BRAM4_RD_REQ                    ( s_BRAM4_RD_REQ                ),//(o)  [   1]
       .BRAM4_RD_ACK                    ( s_BRAM4_RD_ACK                ),//(i)  [   1]
       .BRAM4_RD_DATA                   ( s_BRAM4_RD_DATA               ),//(i)  [  32]
       .BRAM4_RD_ADDR                   ( s_BRAM4_RD_ADDR               ),//(o)  [  16]

       .BRAM5_WR_REQ                    ( s_BRAM5_WR_REQ                ),//(o)  [   1]
       .BRAM5_WR_ACK                    ( s_BRAM5_WR_ACK                ),//(i)  [   1]
       .BRAM5_WR_DATA                   ( s_BRAM5_WR_DATA               ),//(o)  [  32]
       .BRAM5_WR_ADDR                   ( s_BRAM5_WR_ADDR               ),//(o)  [  16]
       .BRAM5_RD_REQ                    ( s_BRAM5_RD_REQ                ),//(o)  [   1]
       .BRAM5_RD_ACK                    ( s_BRAM5_RD_ACK                ),//(i)  [   1]
       .BRAM5_RD_DATA                   ( s_BRAM5_RD_DATA               ),//(i)  [  32]
       .BRAM5_RD_ADDR                   ( s_BRAM5_RD_ADDR               ),//(o)  [  16]

       .BRAM6_WR_REQ                    ( s_BRAM6_WR_REQ                ),//(o)  [   1]
       .BRAM6_WR_ACK                    ( s_BRAM6_WR_ACK                ),//(i)  [   1]
       .BRAM6_WR_DATA                   ( s_BRAM6_WR_DATA               ),//(o)  [  32]
       .BRAM6_WR_ADDR                   ( s_BRAM6_WR_ADDR               ),//(o)  [  16]
       .BRAM6_RD_REQ                    ( s_BRAM6_RD_REQ                ),//(o)  [   1]
       .BRAM6_RD_ACK                    ( s_BRAM6_RD_ACK                ),//(i)  [   1]
       .BRAM6_RD_DATA                   ( s_BRAM6_RD_DATA               ),//(i)  [  32]
       .BRAM6_RD_ADDR                   ( s_BRAM6_RD_ADDR               ),//(o)  [  16]

       .BRAM7_WR_REQ                    ( s_BRAM7_WR_REQ                ),//(o)  [   1]
       .BRAM7_WR_ACK                    ( s_BRAM7_WR_ACK                ),//(i)  [   1]
       .BRAM7_WR_DATA                   ( s_BRAM7_WR_DATA               ),//(o)  [  32]
       .BRAM7_WR_ADDR                   ( s_BRAM7_WR_ADDR               ),//(o)  [  16]
       .BRAM7_RD_REQ                    ( s_BRAM7_RD_REQ                ),//(o)  [   1]
       .BRAM7_RD_ACK                    ( s_BRAM7_RD_ACK                ),//(i)  [   1]
       .BRAM7_RD_DATA                   ( s_BRAM7_RD_DATA               ),//(i)  [  32]
       .BRAM7_RD_ADDR                   ( s_BRAM7_RD_ADDR               ),//(o)  [  16]

       .BRAM8_WR_REQ                    ( s_BRAM8_WR_REQ                ),//(o)  [   1]
       .BRAM8_WR_ACK                    ( s_BRAM8_WR_REQ                ),//(i)  [   1]
       .BRAM8_WR_DATA                   (                               ),//(o)  [  32]
       .BRAM8_WR_ADDR                   (                               ),//(o)  [  16]
       .BRAM8_RD_REQ                    ( s_BRAM8_RD_REQ                ),//(o)  [   1]
       .BRAM8_RD_ACK                    ( s_BRAM8_RD_REQ                ),//(i)  [   1]
       .BRAM8_RD_DATA                   ( 32'd0                         ),//(i)  [  32]
       .BRAM8_RD_ADDR                   (                               ),//(o)  [  16]

       .BRAM9_WR_REQ                    ( s_BRAM9_WR_REQ                ),//(o)  [   1]
       .BRAM9_WR_ACK                    ( s_BRAM9_WR_REQ                ),//(i)  [   1]
       .BRAM9_WR_DATA                   (                               ),//(o)  [  32]
       .BRAM9_WR_ADDR                   (                               ),//(o)  [  16]
       .BRAM9_RD_REQ                    ( s_BRAM9_RD_REQ                ),//(o)  [   1]
       .BRAM9_RD_ACK                    ( s_BRAM9_RD_REQ                ),//(i)  [   1]
       .BRAM9_RD_DATA                   ( 32'd0                         ),//(i)  [  32]
       .BRAM9_RD_ADDR                   (                               ),//(o)  [  16]

       .BRAM10_WR_REQ                   ( s_BRAM10_WR_REQ               ),//(o)  [   1]
       .BRAM10_WR_ACK                   ( s_BRAM10_WR_REQ               ),//(i)  [   1]
       .BRAM10_WR_DATA                  (                               ),//(o)  [  32]
       .BRAM10_WR_ADDR                  (                               ),//(o)  [  16]
       .BRAM10_RD_REQ                   ( s_BRAM10_RD_REQ               ),//(o)  [   1]
       .BRAM10_RD_ACK                   ( s_BRAM10_RD_REQ               ),//(i)  [   1]
       .BRAM10_RD_DATA                  ( 32'd0                         ),//(i)  [  32]
       .BRAM10_RD_ADDR                  (                               ),//(o)  [  16]

       .DRAM0_RD_RDY                    ( s_DRAM0_RD_RDY                ),//(o)  [   1]
       .DRAM0_RD_REQ                    ( s_DRAM0_RD_REQ                ),//(o)  [   1]
       .DRAM0_RD_ACK                    ( s_DRAM0_RD_ACK                ),//(i)  [   1]
       .DRAM0_RD_ADDR                   ( s_DRAM0_RD_ADDR               ),//(o)  [  32]
       .DRAM0_RD_SIZE                   ( s_DRAM0_RD_SIZE               ),//(o)  [  12]
       .DRAM0_RD_BL                     ( s_DRAM0_RD_BL                 ),//(o)  [  12]
       .DRAM0_RD_DVLD                   ( s_DRAM0_RD_DVLD               ),//(i)  [   1]
       .DRAM0_RD_DATA                   ( s_DRAM0_RD_DATA               ),//(i)  [  32]
       .DRAM0_RD_SOP                    ( s_DRAM0_RD_SOP                ),//(i)  [   1]
       .DRAM0_RD_EOP                    ( s_DRAM0_RD_EOP                ),//(i)  [   1]

       .DRAM0_WR_RDY                    ( s_DRAM0_WR_RDY                ),//(i)  [   1]
       .DRAM0_WR_REQ                    ( s_DRAM0_WR_REQ                ),//(o)  [   1]
       .DRAM0_WR_ACK                    ( s_DRAM0_WR_ACK                ),//(i)  [   1]
       .DRAM0_WR_ADDR                   ( s_DRAM0_WR_ADDR               ),//(o)  [  25]
       .DRAM0_WR_SIZE                   ( s_DRAM0_WR_SIZE               ),//(o)  [  12]
       .DRAM0_WR_BL                     ( s_DRAM0_WR_BL                 ),//(o)  [  12]
       .DRAM0_WR_DVLD                   ( s_DRAM0_WR_DVLD               ),//(o)  [   1]
       .DRAM0_WR_DATA                   ( s_DRAM0_WR_DATA               ),//(o)  [  32]
       .DRAM0_WR_SOP                    ( s_DRAM0_WR_SOP                ),//(o)  [   1]
       .DRAM0_WR_EOP                    ( s_DRAM0_WR_EOP                ),//(o)  [   1]

       .DRAM1_RD_RDY                    ( s_DRAM1_RD_RDY                ),//(o)  [   1]
       .DRAM1_RD_REQ                    ( s_DRAM1_RD_REQ                ),//(o)  [   1]
       .DRAM1_RD_ACK                    ( s_DRAM1_RD_ACK                ),//(i)  [   1]
       .DRAM1_RD_ADDR                   ( s_DRAM1_RD_ADDR               ),//(o)  [  32]
       .DRAM1_RD_SIZE                   ( s_DRAM1_RD_SIZE               ),//(o)  [  12]
       .DRAM1_RD_BL                     ( s_DRAM1_RD_BL                 ),//(o)  [  12]
       .DRAM1_RD_DVLD                   ( s_DRAM1_RD_DVLD               ),//(i)  [   1]
       .DRAM1_RD_DATA                   ( s_DRAM1_RD_DATA               ),//(i)  [  32]
       .DRAM1_RD_SOP                    ( s_DRAM1_RD_SOP                ),//(i)  [   1]
       .DRAM1_RD_EOP                    ( s_DRAM1_RD_EOP                ),//(i)  [   1]

       .DRAM1_WR_RDY                    ( s_DRAM1_WR_RDY                ),//(i)  [   1]
       .DRAM1_WR_REQ                    ( s_DRAM1_WR_REQ                ),//(o)  [   1]
       .DRAM1_WR_ACK                    ( s_DRAM1_WR_ACK                ),//(i)  [   1]
       .DRAM1_WR_ADDR                   ( s_DRAM1_WR_ADDR               ),//(o)  [  25]
       .DRAM1_WR_SIZE                   ( s_DRAM1_WR_SIZE               ),//(o)  [  12]
       .DRAM1_WR_BL                     ( s_DRAM1_WR_BL                 ),//(o)  [  12]
       .DRAM1_WR_DVLD                   ( s_DRAM1_WR_DVLD               ),//(o)  [   1]
       .DRAM1_WR_DATA                   ( s_DRAM1_WR_DATA               ),//(o)  [  32]
       .DRAM1_WR_SOP                    ( s_DRAM1_WR_SOP                ),//(o)  [   1]
       .DRAM1_WR_EOP                    ( s_DRAM1_WR_EOP                ),//(o)  [   1]

       .DRAM2_RD_RDY                    ( s_DRAM2_RD_RDY                ),//(o)  [   1]
       .DRAM2_RD_REQ                    ( s_DRAM2_RD_REQ                ),//(o)  [   1]
       .DRAM2_RD_ACK                    ( s_DRAM2_RD_ACK                ),//(i)  [   1]
       .DRAM2_RD_ADDR                   ( s_DRAM2_RD_ADDR               ),//(o)  [  32]
       .DRAM2_RD_SIZE                   ( s_DRAM2_RD_SIZE               ),//(o)  [  12]
       .DRAM2_RD_BL                     ( s_DRAM2_RD_BL                 ),//(o)  [  12]
       .DRAM2_RD_DVLD                   ( s_DRAM2_RD_DVLD               ),//(i)  [   1]
       .DRAM2_RD_DATA                   ( s_DRAM2_RD_DATA               ),//(i)  [  32]
       .DRAM2_RD_SOP                    ( s_DRAM2_RD_SOP                ),//(i)  [   1]
       .DRAM2_RD_EOP                    ( s_DRAM2_RD_EOP                ),//(i)  [   1]

       .DRAM2_WR_RDY                    ( s_DRAM2_WR_RDY                ),//(i)  [   1]
       .DRAM2_WR_REQ                    ( s_DRAM2_WR_REQ                ),//(o)  [   1]
       .DRAM2_WR_ACK                    ( s_DRAM2_WR_ACK                ),//(i)  [   1]
       .DRAM2_WR_ADDR                   ( s_DRAM2_WR_ADDR               ),//(o)  [  25]
       .DRAM2_WR_SIZE                   ( s_DRAM2_WR_SIZE               ),//(o)  [  12]
       .DRAM2_WR_BL                     ( s_DRAM2_WR_BL                 ),//(o)  [  12]
       .DRAM2_WR_DVLD                   ( s_DRAM2_WR_DVLD               ),//(o)  [   1]
       .DRAM2_WR_DATA                   ( s_DRAM2_WR_DATA               ),//(o)  [  32]
       .DRAM2_WR_SOP                    ( s_DRAM2_WR_SOP                ),//(o)  [   1]
       .DRAM2_WR_EOP                    ( s_DRAM2_WR_EOP                ),//(o)  [   1]

       .DRAM3_RD_RDY                    ( s_DRAM3_RD_RDY                ),//(o)  [   1]
       .DRAM3_RD_REQ                    ( s_DRAM3_RD_REQ                ),//(o)  [   1]
       .DRAM3_RD_ACK                    ( s_DRAM3_RD_ACK                ),//(i)  [   1]
       .DRAM3_RD_ADDR                   ( s_DRAM3_RD_ADDR               ),//(o)  [  32]
       .DRAM3_RD_SIZE                   ( s_DRAM3_RD_SIZE               ),//(o)  [  12]
       .DRAM3_RD_BL                     ( s_DRAM3_RD_BL                 ),//(o)  [  12]
       .DRAM3_RD_DVLD                   ( s_DRAM3_RD_DVLD               ),//(i)  [   1]
       .DRAM3_RD_DATA                   ( s_DRAM3_RD_DATA               ),//(i)  [  32]
       .DRAM3_RD_SOP                    ( s_DRAM3_RD_SOP                ),//(i)  [   1]
       .DRAM3_RD_EOP                    ( s_DRAM3_RD_EOP                ),//(i)  [   1]

       .DRAM3_WR_RDY                    ( s_DRAM3_WR_RDY                ),//(i)  [   1]
       .DRAM3_WR_REQ                    ( s_DRAM3_WR_REQ                ),//(o)  [   1]
       .DRAM3_WR_ACK                    ( s_DRAM3_WR_ACK                ),//(i)  [   1]
       .DRAM3_WR_ADDR                   ( s_DRAM3_WR_ADDR               ),//(o)  [  25]
       .DRAM3_WR_SIZE                   ( s_DRAM3_WR_SIZE               ),//(o)  [  12]
       .DRAM3_WR_BL                     ( s_DRAM3_WR_BL                 ),//(o)  [  12]
       .DRAM3_WR_DVLD                   ( s_DRAM3_WR_DVLD               ),//(o)  [   1]
       .DRAM3_WR_DATA                   ( s_DRAM3_WR_DATA               ),//(o)  [  32]
       .DRAM3_WR_SOP                    ( s_DRAM3_WR_SOP                ),//(o)  [   1]
       .DRAM3_WR_EOP                    ( s_DRAM3_WR_EOP                ),//(o)  [   1]

       .DRAM4_RD_RDY                    ( s_DRAM4_RD_RDY                ),//(o)  [   1]
       .DRAM4_RD_REQ                    ( s_DRAM4_RD_REQ                ),//(o)  [   1]
       .DRAM4_RD_ACK                    ( s_DRAM4_RD_ACK                ),//(i)  [   1]
       .DRAM4_RD_ADDR                   ( s_DRAM4_RD_ADDR               ),//(o)  [  32]
       .DRAM4_RD_SIZE                   ( s_DRAM4_RD_SIZE               ),//(o)  [  12]
       .DRAM4_RD_BL                     ( s_DRAM4_RD_BL                 ),//(o)  [  12]
       .DRAM4_RD_DVLD                   ( s_DRAM4_RD_DVLD               ),//(i)  [   1]
       .DRAM4_RD_DATA                   ( s_DRAM4_RD_DATA               ),//(i)  [  32]
       .DRAM4_RD_SOP                    ( s_DRAM4_RD_SOP                ),//(i)  [   1]
       .DRAM4_RD_EOP                    ( s_DRAM4_RD_EOP                ),//(i)  [   1]

       .DRAM4_WR_RDY                    ( s_DRAM4_WR_RDY                ),//(i)  [   1]
       .DRAM4_WR_REQ                    ( s_DRAM4_WR_REQ                ),//(o)  [   1]
       .DRAM4_WR_ACK                    ( s_DRAM4_WR_ACK                ),//(i)  [   1]
       .DRAM4_WR_ADDR                   ( s_DRAM4_WR_ADDR               ),//(o)  [  25]
       .DRAM4_WR_SIZE                   ( s_DRAM4_WR_SIZE               ),//(o)  [  12]
       .DRAM4_WR_BL                     ( s_DRAM4_WR_BL                 ),//(o)  [  12]
       .DRAM4_WR_DVLD                   ( s_DRAM4_WR_DVLD               ),//(o)  [   1]
       .DRAM4_WR_DATA                   ( s_DRAM4_WR_DATA               ),//(o)  [  32]
       .DRAM4_WR_SOP                    ( s_DRAM4_WR_SOP                ),//(o)  [   1]
       .DRAM4_WR_EOP                    ( s_DRAM4_WR_EOP                ),//(o)  [   1]

       .DRAM5_RD_RDY                    ( s_DRAM5_RD_RDY                ),//(o)  [   1]
       .DRAM5_RD_REQ                    ( s_DRAM5_RD_REQ                ),//(o)  [   1]
       .DRAM5_RD_ACK                    ( s_DRAM5_RD_ACK                ),//(i)  [   1]
       .DRAM5_RD_ADDR                   ( s_DRAM5_RD_ADDR               ),//(o)  [  32]
       .DRAM5_RD_SIZE                   ( s_DRAM5_RD_SIZE               ),//(o)  [  12]
       .DRAM5_RD_BL                     ( s_DRAM5_RD_BL                 ),//(o)  [  12]
       .DRAM5_RD_DVLD                   ( s_DRAM5_RD_DVLD               ),//(i)  [   1]
       .DRAM5_RD_DATA                   ( s_DRAM5_RD_DATA               ),//(i)  [  32]
       .DRAM5_RD_SOP                    ( s_DRAM5_RD_SOP                ),//(i)  [   1]
       .DRAM5_RD_EOP                    ( s_DRAM5_RD_EOP                ),//(i)  [   1]

       .DRAM5_WR_RDY                    ( s_DRAM5_WR_RDY                ),//(i)  [   1]
       .DRAM5_WR_REQ                    ( s_DRAM5_WR_REQ                ),//(o)  [   1]
       .DRAM5_WR_ACK                    ( s_DRAM5_WR_ACK                ),//(i)  [   1]
       .DRAM5_WR_ADDR                   ( s_DRAM5_WR_ADDR               ),//(o)  [  25]
       .DRAM5_WR_SIZE                   ( s_DRAM5_WR_SIZE               ),//(o)  [  12]
       .DRAM5_WR_BL                     ( s_DRAM5_WR_BL                 ),//(o)  [  12]
       .DRAM5_WR_DVLD                   ( s_DRAM5_WR_DVLD               ),//(o)  [   1]
       .DRAM5_WR_DATA                   ( s_DRAM5_WR_DATA               ),//(o)  [  32]
       .DRAM5_WR_SOP                    ( s_DRAM5_WR_SOP                ),//(o)  [   1]
       .DRAM5_WR_EOP                    ( s_DRAM5_WR_EOP                ),//(o)  [   1]

       .DRAM6_RD_RDY                    ( s_DRAM6_RD_RDY                ),//(o)  [   1]
       .DRAM6_RD_REQ                    ( s_DRAM6_RD_REQ                ),//(o)  [   1]
       .DRAM6_RD_ACK                    ( s_DRAM6_RD_ACK                ),//(i)  [   1]
       .DRAM6_RD_ADDR                   ( s_DRAM6_RD_ADDR               ),//(o)  [  32]
       .DRAM6_RD_SIZE                   ( s_DRAM6_RD_SIZE               ),//(o)  [  12]
       .DRAM6_RD_BL                     ( s_DRAM6_RD_BL                 ),//(o)  [  12]
       .DRAM6_RD_DVLD                   ( s_DRAM6_RD_DVLD               ),//(i)  [   1]
       .DRAM6_RD_DATA                   ( s_DRAM6_RD_DATA               ),//(i)  [  32]
       .DRAM6_RD_SOP                    ( s_DRAM6_RD_SOP                ),//(i)  [   1]
       .DRAM6_RD_EOP                    ( s_DRAM6_RD_EOP                ),//(i)  [   1]

       .DRAM6_WR_RDY                    ( s_DRAM6_WR_RDY                ),//(i)  [   1]
       .DRAM6_WR_REQ                    ( s_DRAM6_WR_REQ                ),//(o)  [   1]
       .DRAM6_WR_ACK                    ( s_DRAM6_WR_ACK                ),//(i)  [   1]
       .DRAM6_WR_ADDR                   ( s_DRAM6_WR_ADDR               ),//(o)  [  25]
       .DRAM6_WR_SIZE                   ( s_DRAM6_WR_SIZE               ),//(o)  [  12]
       .DRAM6_WR_BL                     ( s_DRAM6_WR_BL                 ),//(o)  [  12]
       .DRAM6_WR_DVLD                   ( s_DRAM6_WR_DVLD               ),//(o)  [   1]
       .DRAM6_WR_DATA                   ( s_DRAM6_WR_DATA               ),//(o)  [  32]
       .DRAM6_WR_SOP                    ( s_DRAM6_WR_SOP                ),//(o)  [   1]
       .DRAM6_WR_EOP                    ( s_DRAM6_WR_EOP                ) //(o)  [   1]
       );

/*============================================================================+/
||                                                                            ||
||                             REG_CTRL                                       ||
||                                                                            ||
/+============================================================================*/

    FPGA_TOP_SIMA U_FPGA_TOP_SIMA (
    //clock and reset
        .CLK                            ( CLK                           ),//(i)  [  1]  Systerm clock 0 P
        .RST                            ( RST                           ),//(i)  [  1]  Systerm clock 0 N

        .REG0_WR_REQ                    ( s_REG0_WR_REQ                 ),//(i)  [  1]  Register write request
        .REG0_WR_ACK                    ( s_REG0_WR_ACK                 ),//(o)  [  1]  Register write acknowledge
        .REG0_WR_DATA                   ( s_REG0_WR_DATA                ),//(i)  [ 32]  Register write data
        .REG0_RD_REQ                    ( s_REG0_RD_REQ                 ),//(i)  [  1]  Register read request
        .REG0_RD_ACK                    ( s_REG0_RD_ACK                 ),//(o)  [  1]  Register read acknowledge
        .REG0_RD_DATA                   ( s_REG0_RD_DATA                ),//(o)  [ 32]  Register read data
        .REG0_OP_ADDR                   ( s_REG0_OP_ADDR                ),//(i)  [ 10]  Register operation address

        .REG1_WR_REQ                    ( 1'b0                          ),//(i)  [  1]  Register write request
        .REG1_WR_ACK                    (                               ),//(o)  [  1]  Register write acknowledge
        .REG1_WR_DATA                   ( 32'd0                         ),//(i)  [ 32]  Register write data
        .REG1_RD_REQ                    ( 1'b0                          ),//(i)  [  1]  Register read request
        .REG1_RD_ACK                    (                               ),//(o)  [  1]  Register read acknowledge
        .REG1_RD_DATA                   (                               ),//(o)  [ 32]  Register read data
        .REG1_OP_ADDR                   ( 10'd0                         ),//(i)  [ 10]  Register operation address

        .REG2_WR_REQ                    ( s_REG2_WR_REQ                 ),//(i)  [  1]  Register write request
        .REG2_WR_ACK                    ( s_REG2_WR_ACK                 ),//(o)  [  1]  Register write acknowledge
        .REG2_WR_DATA                   ( s_REG2_WR_DATA                ),//(i)  [ 32]  Register write data
        .REG2_RD_REQ                    ( s_REG2_RD_REQ                 ),//(i)  [  1]  Register read request
        .REG2_RD_ACK                    ( s_REG2_RD_ACK                 ),//(o)  [  1]  Register read acknowledge
        .REG2_RD_DATA                   ( s_REG2_RD_DATA                ),//(o)  [ 32]  Register read data
        .REG2_OP_ADDR                   ( s_REG2_OP_ADDR                ),//(i)  [ 10]  Register operation address

        .REG3_WR_REQ                    ( s_REG3_WR_REQ                 ),//(i)  [  1]  Register write request
        .REG3_WR_ACK                    ( s_REG3_WR_ACK                 ),//(o)  [  1]  Register write acknowledge
        .REG3_WR_DATA                   ( s_REG3_WR_DATA                ),//(i)  [ 32]  Register write data
        .REG3_RD_REQ                    ( s_REG3_RD_REQ                 ),//(i)  [  1]  Register read request
        .REG3_RD_ACK                    ( s_REG3_RD_ACK                 ),//(o)  [  1]  Register read acknowledge
        .REG3_RD_DATA                   ( s_REG3_RD_DATA                ),//(o)  [ 32]  Register read data
        .REG3_OP_ADDR                   ( s_REG3_OP_ADDR                ),//(i)  [ 10]  Register operation address

        .REG4_WR_REQ                    ( s_REG4_WR_REQ                 ),//(i)  [  1]  Register write request
        .REG4_WR_ACK                    ( s_REG4_WR_ACK                 ),//(o)  [  1]  Register write acknowledge
        .REG4_WR_DATA                   ( s_REG4_WR_DATA                ),//(i)  [ 32]  Register write data
        .REG4_RD_REQ                    ( s_REG4_RD_REQ                 ),//(i)  [  1]  Register read request
        .REG4_RD_ACK                    ( s_REG4_RD_ACK                 ),//(o)  [  1]  Register read acknowledge
        .REG4_RD_DATA                   ( s_REG4_RD_DATA                ),//(o)  [ 32]  Register read data
        .REG4_OP_ADDR                   ( s_REG4_OP_ADDR                ),//(i)  [ 10]  Register operation address

        .REG5_WR_REQ                    ( s_REG5_WR_REQ                 ),//(i)  [  1]  Register write request
        .REG5_WR_ACK                    ( s_REG5_WR_ACK                 ),//(o)  [  1]  Register write acknowledge
        .REG5_WR_DATA                   ( s_REG5_WR_DATA                ),//(i)  [ 32]  Register write data
        .REG5_RD_REQ                    ( s_REG5_RD_REQ                 ),//(i)  [  1]  Register read request
        .REG5_RD_ACK                    ( s_REG5_RD_ACK                 ),//(o)  [  1]  Register read acknowledge
        .REG5_RD_DATA                   ( s_REG5_RD_DATA                ),//(o)  [ 32]  Register read data
        .REG5_OP_ADDR                   ( s_REG5_OP_ADDR                ),//(i)  [ 10]  Register operation address

        .REG6_WR_REQ                    ( s_REG6_WR_REQ                 ),//(i)  [  1]  Register write request
        .REG6_WR_ACK                    ( s_REG6_WR_ACK                 ),//(o)  [  1]  Register write acknowledge
        .REG6_WR_DATA                   ( s_REG6_WR_DATA                ),//(i)  [ 32]  Register write data
        .REG6_RD_REQ                    ( s_REG6_RD_REQ                 ),//(i)  [  1]  Register read request
        .REG6_RD_ACK                    ( s_REG6_RD_ACK                 ),//(o)  [  1]  Register read acknowledge
        .REG6_RD_DATA                   ( s_REG6_RD_DATA                ),//(o)  [ 32]  Register read data
        .REG6_OP_ADDR                   ( s_REG6_OP_ADDR                ),//(i)  [ 10]  Register operation address

        .REG7_WR_REQ                    ( s_REG7_WR_REQ                 ),//(i)  [  1]  Register write request
        .REG7_WR_ACK                    ( s_REG7_WR_ACK                 ),//(o)  [  1]  Register write acknowledge
        .REG7_WR_DATA                   ( s_REG7_WR_DATA                ),//(i)  [ 32]  Register write data
        .REG7_RD_REQ                    ( s_REG7_RD_REQ                 ),//(i)  [  1]  Register read request
        .REG7_RD_ACK                    ( s_REG7_RD_ACK                 ),//(o)  [  1]  Register read acknowledge
        .REG7_RD_DATA                   ( s_REG7_RD_DATA                ),//(o)  [ 32]  Register read data
        .REG7_OP_ADDR                   ( s_REG7_OP_ADDR                ),//(i)  [ 10]  Register operation address

        .BRAM0_WR_REQ                   ( s_BRAM0_WR_REQ                ),//(o)  [  1]  BRAM write request
        .BRAM0_WR_ADDR                  ( s_BRAM0_WR_ADDR               ),//(o)  [ 16]  BRAM write address
        .BRAM0_WR_DATA                  ( s_BRAM0_WR_DATA               ),//(o)  [ 32]  BRAM write data
        .BRAM0_WR_ACK                   ( s_BRAM0_WR_ACK                ),//(i)  [  1]  BRAM write acknowledge
        .BRAM0_RD_REQ                   ( s_BRAM0_RD_REQ                ),//(o)  [  1]  BRAM read request
        .BRAM0_RD_ADDR                  ( s_BRAM0_RD_ADDR               ),//(o)  [ 16]  BRAM read address
        .BRAM0_RD_DATA                  ( s_BRAM0_RD_DATA               ),//(i)  [ 32]  BRAM read data
        .BRAM0_RD_ACK                   ( s_BRAM0_RD_ACK                ),//(i)  [  1]  BRAM read acknowledge

        .BRAM1_WR_REQ                   ( s_BRAM1_WR_REQ                ),//(o)  [  1]  BRAM write request
        .BRAM1_WR_ADDR                  ( s_BRAM1_WR_ADDR               ),//(o)  [ 16]  BRAM write address
        .BRAM1_WR_DATA                  ( s_BRAM1_WR_DATA               ),//(o)  [ 32]  BRAM write data
        .BRAM1_WR_ACK                   ( s_BRAM1_WR_ACK                ),//(i)  [  1]  BRAM write acknowledge
        .BRAM1_RD_REQ                   ( s_BRAM1_RD_REQ                ),//(o)  [  1]  BRAM read request
        .BRAM1_RD_ADDR                  ( s_BRAM1_RD_ADDR               ),//(o)  [ 16]  BRAM read address
        .BRAM1_RD_DATA                  ( s_BRAM1_RD_DATA               ),//(i)  [ 32]  BRAM read data
        .BRAM1_RD_ACK                   ( s_BRAM1_RD_ACK                ),//(i)  [  1]  BRAM read acknowledge

        .BRAM2_WR_REQ                   ( s_BRAM2_WR_REQ                ),//(o)  [  1]  BRAM write request
        .BRAM2_WR_ADDR                  ( s_BRAM2_WR_ADDR               ),//(o)  [ 16]  BRAM write address
        .BRAM2_WR_DATA                  ( s_BRAM2_WR_DATA               ),//(o)  [ 32]  BRAM write data
        .BRAM2_WR_ACK                   ( s_BRAM2_WR_ACK                ),//(i)  [  1]  BRAM write acknowledge
        .BRAM2_RD_REQ                   ( s_BRAM2_RD_REQ                ),//(o)  [  1]  BRAM read request
        .BRAM2_RD_ADDR                  ( s_BRAM2_RD_ADDR               ),//(o)  [ 16]  BRAM read address
        .BRAM2_RD_DATA                  ( s_BRAM2_RD_DATA               ),//(i)  [ 32]  BRAM read data
        .BRAM2_RD_ACK                   ( s_BRAM2_RD_ACK                ),//(i)  [  1]  BRAM read acknowledge

        .BRAM3_WR_REQ                   ( s_BRAM3_WR_REQ                ),//(o)  [  1]  BRAM write request
        .BRAM3_WR_ADDR                  ( s_BRAM3_WR_ADDR               ),//(o)  [ 16]  BRAM write address
        .BRAM3_WR_DATA                  ( s_BRAM3_WR_DATA               ),//(o)  [ 32]  BRAM write data
        .BRAM3_WR_ACK                   ( s_BRAM3_WR_ACK                ),//(i)  [  1]  BRAM write acknowledge
        .BRAM3_RD_REQ                   ( s_BRAM3_RD_REQ                ),//(o)  [  1]  BRAM read request
        .BRAM3_RD_ADDR                  ( s_BRAM3_RD_ADDR               ),//(o)  [ 16]  BRAM read address
        .BRAM3_RD_DATA                  ( s_BRAM3_RD_DATA               ),//(i)  [ 32]  BRAM read data
        .BRAM3_RD_ACK                   ( s_BRAM3_RD_ACK                ),//(i)  [  1]  BRAM read acknowledge

        .BRAM4_WR_REQ                   ( s_BRAM4_WR_REQ                ),//(o)  [  1]  BRAM write request
        .BRAM4_WR_ADDR                  ( s_BRAM4_WR_ADDR               ),//(o)  [ 16]  BRAM write address
        .BRAM4_WR_DATA                  ( s_BRAM4_WR_DATA               ),//(o)  [ 32]  BRAM write data
        .BRAM4_WR_ACK                   ( s_BRAM4_WR_ACK                ),//(i)  [  1]  BRAM write acknowledge
        .BRAM4_RD_REQ                   ( s_BRAM4_RD_REQ                ),//(o)  [  1]  BRAM read request
        .BRAM4_RD_ADDR                  ( s_BRAM4_RD_ADDR               ),//(o)  [ 16]  BRAM read address
        .BRAM4_RD_DATA                  ( s_BRAM4_RD_DATA               ),//(i)  [ 32]  BRAM read data
        .BRAM4_RD_ACK                   ( s_BRAM4_RD_ACK                ),//(i)  [  1]  BRAM read acknowledge

        .BRAM5_WR_REQ                   ( s_BRAM5_WR_REQ                ),//(o)  [  1]  BRAM write request
        .BRAM5_WR_ADDR                  ( s_BRAM5_WR_ADDR               ),//(o)  [ 16]  BRAM write address
        .BRAM5_WR_DATA                  ( s_BRAM5_WR_DATA               ),//(o)  [ 32]  BRAM write data
        .BRAM5_WR_ACK                   ( s_BRAM5_WR_ACK                ),//(i)  [  1]  BRAM write acknowledge
        .BRAM5_RD_REQ                   ( s_BRAM5_RD_REQ                ),//(o)  [  1]  BRAM read request
        .BRAM5_RD_ADDR                  ( s_BRAM5_RD_ADDR               ),//(o)  [ 16]  BRAM read address
        .BRAM5_RD_DATA                  ( s_BRAM5_RD_DATA               ),//(i)  [ 32]  BRAM read data
        .BRAM5_RD_ACK                   ( s_BRAM5_RD_ACK                ),//(i)  [  1]  BRAM read acknowledge

        .BRAM6_WR_REQ                   ( s_BRAM6_WR_REQ                ),//(o)  [  1]  BRAM write request
        .BRAM6_WR_ADDR                  ( s_BRAM6_WR_ADDR               ),//(o)  [ 16]  BRAM write address
        .BRAM6_WR_DATA                  ( s_BRAM6_WR_DATA               ),//(o)  [ 32]  BRAM write data
        .BRAM6_WR_ACK                   ( s_BRAM6_WR_ACK                ),//(i)  [  1]  BRAM write acknowledge
        .BRAM6_RD_REQ                   ( s_BRAM6_RD_REQ                ),//(o)  [  1]  BRAM read request
        .BRAM6_RD_ADDR                  ( s_BRAM6_RD_ADDR               ),//(o)  [ 16]  BRAM read address
        .BRAM6_RD_DATA                  ( s_BRAM6_RD_DATA               ),//(i)  [ 32]  BRAM read data
        .BRAM6_RD_ACK                   ( s_BRAM6_RD_ACK                ),//(i)  [  1]  BRAM read acknowledge

        .BRAM7_WR_REQ                   ( s_BRAM7_WR_REQ                ),//(o)  [  1]  BRAM write request
        .BRAM7_WR_ADDR                  ( s_BRAM7_WR_ADDR               ),//(o)  [ 16]  BRAM write address
        .BRAM7_WR_DATA                  ( s_BRAM7_WR_DATA               ),//(o)  [ 32]  BRAM write data
        .BRAM7_WR_ACK                   ( s_BRAM7_WR_ACK                ),//(i)  [  1]  BRAM write acknowledge
        .BRAM7_RD_REQ                   ( s_BRAM7_RD_REQ                ),//(o)  [  1]  BRAM read request
        .BRAM7_RD_ADDR                  ( s_BRAM7_RD_ADDR               ),//(o)  [ 16]  BRAM read address
        .BRAM7_RD_DATA                  ( s_BRAM7_RD_DATA               ),//(i)  [ 32]  BRAM read data
        .BRAM7_RD_ACK                   ( s_BRAM7_RD_ACK                ),//(i)  [  1]  BRAM read acknowledge

        .DRAM0_WR_RDY                   ( s_DRAM0_WR_RDY                ),//(i)  [  1]  SDRAM write ready
        .DRAM0_WR_REQ                   ( s_DRAM0_WR_REQ                ),//(o)  [  1]  SDRAM write request
        .DRAM0_WR_ACK                   ( s_DRAM0_WR_ACK                ),//(i)  [  1]  SDRAM write acknowledge
        .DRAM0_WR_ADDR                  ( s_DRAM0_WR_ADDR               ),//(o)  [ 25]  SDRAM write address
        .DRAM0_WR_SIZE                  ( s_DRAM0_WR_SIZE               ),//(o)  [ 12]  SDRAM write size
        .DRAM0_WR_SOP                   ( s_DRAM0_WR_SOP                ),//(o)  [  1]  SDRAM write start of packet
        .DRAM0_WR_EOP                   ( s_DRAM0_WR_EOP                ),//(o)  [  1]  SDRAM write end of packet
        .DRAM0_WR_DVLD                  ( s_DRAM0_WR_DVLD               ),//(o)  [  1]  SDRAM write data valid
        .DRAM0_WR_DATA                  ( s_DRAM0_WR_DATA               ),//(o)  [ 32]  SDRAM write data
        .DRAM0_RD_RDY                   ( s_DRAM0_RD_RDY                ),//(o)  [  1]  SDRAM read ready
        .DRAM0_RD_REQ                   ( s_DRAM0_RD_REQ                ),//(o)  [  1]  SDRAM read request
        .DRAM0_RD_ACK                   ( s_DRAM0_RD_ACK                ),//(i)  [  1]  SDRAM read acknowledge
        .DRAM0_RD_ADDR                  ( s_DRAM0_RD_ADDR               ),//(o)  [ 25]  SDRAM read address
        .DRAM0_RD_SIZE                  ( s_DRAM0_RD_SIZE               ),//(o)  [ 12]  SDRAM read size
        .DRAM0_RD_SOP                   ( s_DRAM0_RD_SOP                ),//(i)  [  1]  SDRAM read start of packet
        .DRAM0_RD_EOP                   ( s_DRAM0_RD_EOP                ),//(i)  [  1]  SDRAM read end of packet
        .DRAM0_RD_DVLD                  ( s_DRAM0_RD_DVLD               ),//(i)  [  1]  SDRAM read data valid
        .DRAM0_RD_DATA                  ( s_DRAM0_RD_DATA               ),//(i)  [ 32]  SDRAM read data

        .DRAM1_WR_RDY                   ( s_DRAM1_WR_RDY                ),//(i)  [  1]  SDRAM write ready
        .DRAM1_WR_REQ                   ( s_DRAM1_WR_REQ                ),//(o)  [  1]  SDRAM write request
        .DRAM1_WR_ACK                   ( s_DRAM1_WR_ACK                ),//(i)  [  1]  SDRAM write acknowledge
        .DRAM1_WR_ADDR                  ( s_DRAM1_WR_ADDR               ),//(o)  [ 25]  SDRAM write address
        .DRAM1_WR_SIZE                  ( s_DRAM1_WR_SIZE               ),//(o)  [ 12]  SDRAM write size
        .DRAM1_WR_SOP                   ( s_DRAM1_WR_SOP                ),//(o)  [  1]  SDRAM write start of packet
        .DRAM1_WR_EOP                   ( s_DRAM1_WR_EOP                ),//(o)  [  1]  SDRAM write end of packet
        .DRAM1_WR_DVLD                  ( s_DRAM1_WR_DVLD               ),//(o)  [  1]  SDRAM write data valid
        .DRAM1_WR_DATA                  ( s_DRAM1_WR_DATA               ),//(o)  [ 32]  SDRAM write data
        .DRAM1_RD_RDY                   ( s_DRAM1_RD_RDY                ),//(o)  [  1]  SDRAM read ready
        .DRAM1_RD_REQ                   ( s_DRAM1_RD_REQ                ),//(o)  [  1]  SDRAM read request
        .DRAM1_RD_ACK                   ( s_DRAM1_RD_ACK                ),//(i)  [  1]  SDRAM read acknowledge
        .DRAM1_RD_ADDR                  ( s_DRAM1_RD_ADDR               ),//(o)  [ 25]  SDRAM read address
        .DRAM1_RD_SIZE                  ( s_DRAM1_RD_SIZE               ),//(o)  [ 12]  SDRAM read size
        .DRAM1_RD_SOP                   ( s_DRAM1_RD_SOP                ),//(i)  [  1]  SDRAM read start of packet
        .DRAM1_RD_EOP                   ( s_DRAM1_RD_EOP                ),//(i)  [  1]  SDRAM read end of packet
        .DRAM1_RD_DVLD                  ( s_DRAM1_RD_DVLD               ),//(i)  [  1]  SDRAM read data valid
        .DRAM1_RD_DATA                  ( s_DRAM1_RD_DATA               ),//(i)  [ 32]  SDRAM read data

        .DRAM2_WR_RDY                   ( s_DRAM2_WR_RDY                ),//(i)  [  1]  SDRAM write ready
        .DRAM2_WR_REQ                   ( s_DRAM2_WR_REQ                ),//(o)  [  1]  SDRAM write request
        .DRAM2_WR_ACK                   ( s_DRAM2_WR_ACK                ),//(i)  [  1]  SDRAM write acknowledge
        .DRAM2_WR_ADDR                  ( s_DRAM2_WR_ADDR               ),//(o)  [ 25]  SDRAM write address
        .DRAM2_WR_SIZE                  ( s_DRAM2_WR_SIZE               ),//(o)  [ 12]  SDRAM write size
        .DRAM2_WR_SOP                   ( s_DRAM2_WR_SOP                ),//(o)  [  1]  SDRAM write start of packet
        .DRAM2_WR_EOP                   ( s_DRAM2_WR_EOP                ),//(o)  [  1]  SDRAM write end of packet
        .DRAM2_WR_DVLD                  ( s_DRAM2_WR_DVLD               ),//(o)  [  1]  SDRAM write data valid
        .DRAM2_WR_DATA                  ( s_DRAM2_WR_DATA               ),//(o)  [ 32]  SDRAM write data
        .DRAM2_RD_RDY                   ( s_DRAM2_RD_RDY                ),//(o)  [  1]  SDRAM read ready
        .DRAM2_RD_REQ                   ( s_DRAM2_RD_REQ                ),//(o)  [  1]  SDRAM read request
        .DRAM2_RD_ACK                   ( s_DRAM2_RD_ACK                ),//(i)  [  1]  SDRAM read acknowledge
        .DRAM2_RD_ADDR                  ( s_DRAM2_RD_ADDR               ),//(o)  [ 25]  SDRAM read address
        .DRAM2_RD_SIZE                  ( s_DRAM2_RD_SIZE               ),//(o)  [ 12]  SDRAM read size
        .DRAM2_RD_SOP                   ( s_DRAM2_RD_SOP                ),//(i)  [  1]  SDRAM read start of packet
        .DRAM2_RD_EOP                   ( s_DRAM2_RD_EOP                ),//(i)  [  1]  SDRAM read end of packet
        .DRAM2_RD_DVLD                  ( s_DRAM2_RD_DVLD               ),//(i)  [  1]  SDRAM read data valid
        .DRAM2_RD_DATA                  ( s_DRAM2_RD_DATA               ),//(i)  [ 32]  SDRAM read data

        .DRAM3_WR_RDY                   ( s_DRAM3_WR_RDY                ),//(i)  [  1]  SDRAM write ready
        .DRAM3_WR_REQ                   ( s_DRAM3_WR_REQ                ),//(o)  [  1]  SDRAM write request
        .DRAM3_WR_ACK                   ( s_DRAM3_WR_ACK                ),//(i)  [  1]  SDRAM write acknowledge
        .DRAM3_WR_ADDR                  ( s_DRAM3_WR_ADDR               ),//(o)  [ 25]  SDRAM write address
        .DRAM3_WR_SIZE                  ( s_DRAM3_WR_SIZE               ),//(o)  [ 12]  SDRAM write size
        .DRAM3_WR_SOP                   ( s_DRAM3_WR_SOP                ),//(o)  [  1]  SDRAM write start of packet
        .DRAM3_WR_EOP                   ( s_DRAM3_WR_EOP                ),//(o)  [  1]  SDRAM write end of packet
        .DRAM3_WR_DVLD                  ( s_DRAM3_WR_DVLD               ),//(o)  [  1]  SDRAM write data valid
        .DRAM3_WR_DATA                  ( s_DRAM3_WR_DATA               ),//(o)  [ 32]  SDRAM write data
        .DRAM3_RD_RDY                   ( s_DRAM3_RD_RDY                ),//(o)  [  1]  SDRAM read ready
        .DRAM3_RD_REQ                   ( s_DRAM3_RD_REQ                ),//(o)  [  1]  SDRAM read request
        .DRAM3_RD_ACK                   ( s_DRAM3_RD_ACK                ),//(i)  [  1]  SDRAM read acknowledge
        .DRAM3_RD_ADDR                  ( s_DRAM3_RD_ADDR               ),//(o)  [ 25]  SDRAM read address
        .DRAM3_RD_SIZE                  ( s_DRAM3_RD_SIZE               ),//(o)  [ 12]  SDRAM read size
        .DRAM3_RD_SOP                   ( s_DRAM3_RD_SOP                ),//(i)  [  1]  SDRAM read start of packet
        .DRAM3_RD_EOP                   ( s_DRAM3_RD_EOP                ),//(i)  [  1]  SDRAM read end of packet
        .DRAM3_RD_DVLD                  ( s_DRAM3_RD_DVLD               ),//(i)  [  1]  SDRAM read data valid
        .DRAM3_RD_DATA                  ( s_DRAM3_RD_DATA               ),//(i)  [ 32]  SDRAM read data

        .DRAM4_WR_RDY                   ( s_DRAM4_WR_RDY                ),//(i)  [  1]  SDRAM write ready
        .DRAM4_WR_REQ                   ( s_DRAM4_WR_REQ                ),//(o)  [  1]  SDRAM write request
        .DRAM4_WR_ACK                   ( s_DRAM4_WR_ACK                ),//(i)  [  1]  SDRAM write acknowledge
        .DRAM4_WR_ADDR                  ( s_DRAM4_WR_ADDR               ),//(o)  [ 25]  SDRAM write address
        .DRAM4_WR_SIZE                  ( s_DRAM4_WR_SIZE               ),//(o)  [ 12]  SDRAM write size
        .DRAM4_WR_SOP                   ( s_DRAM4_WR_SOP                ),//(o)  [  1]  SDRAM write start of packet
        .DRAM4_WR_EOP                   ( s_DRAM4_WR_EOP                ),//(o)  [  1]  SDRAM write end of packet
        .DRAM4_WR_DVLD                  ( s_DRAM4_WR_DVLD               ),//(o)  [  1]  SDRAM write data valid
        .DRAM4_WR_DATA                  ( s_DRAM4_WR_DATA               ),//(o)  [ 32]  SDRAM write data
        .DRAM4_RD_RDY                   ( s_DRAM4_RD_RDY                ),//(o)  [  1]  SDRAM read ready
        .DRAM4_RD_REQ                   ( s_DRAM4_RD_REQ                ),//(o)  [  1]  SDRAM read request
        .DRAM4_RD_ACK                   ( s_DRAM4_RD_ACK                ),//(i)  [  1]  SDRAM read acknowledge
        .DRAM4_RD_ADDR                  ( s_DRAM4_RD_ADDR               ),//(o)  [ 25]  SDRAM read address
        .DRAM4_RD_SIZE                  ( s_DRAM4_RD_SIZE               ),//(o)  [ 12]  SDRAM read size
        .DRAM4_RD_SOP                   ( s_DRAM4_RD_SOP                ),//(i)  [  1]  SDRAM read start of packet
        .DRAM4_RD_EOP                   ( s_DRAM4_RD_EOP                ),//(i)  [  1]  SDRAM read end of packet
        .DRAM4_RD_DVLD                  ( s_DRAM4_RD_DVLD               ),//(i)  [  1]  SDRAM read data valid
        .DRAM4_RD_DATA                  ( s_DRAM4_RD_DATA               ),//(i)  [ 32]  SDRAM read data

        .DRAM5_WR_RDY                   ( s_DRAM5_WR_RDY                ),//(i)  [  1]  SDRAM write ready
        .DRAM5_WR_REQ                   ( s_DRAM5_WR_REQ                ),//(o)  [  1]  SDRAM write request
        .DRAM5_WR_ACK                   ( s_DRAM5_WR_ACK                ),//(i)  [  1]  SDRAM write acknowledge
        .DRAM5_WR_ADDR                  ( s_DRAM5_WR_ADDR               ),//(o)  [ 25]  SDRAM write address
        .DRAM5_WR_SIZE                  ( s_DRAM5_WR_SIZE               ),//(o)  [ 12]  SDRAM write size
        .DRAM5_WR_SOP                   ( s_DRAM5_WR_SOP                ),//(o)  [  1]  SDRAM write start of packet
        .DRAM5_WR_EOP                   ( s_DRAM5_WR_EOP                ),//(o)  [  1]  SDRAM write end of packet
        .DRAM5_WR_DVLD                  ( s_DRAM5_WR_DVLD               ),//(o)  [  1]  SDRAM write data valid
        .DRAM5_WR_DATA                  ( s_DRAM5_WR_DATA               ),//(o)  [ 32]  SDRAM write data
        .DRAM5_RD_RDY                   ( s_DRAM5_RD_RDY                ),//(o)  [  1]  SDRAM read ready
        .DRAM5_RD_REQ                   ( s_DRAM5_RD_REQ                ),//(o)  [  1]  SDRAM read request
        .DRAM5_RD_ACK                   ( s_DRAM5_RD_ACK                ),//(i)  [  1]  SDRAM read acknowledge
        .DRAM5_RD_ADDR                  ( s_DRAM5_RD_ADDR               ),//(o)  [ 25]  SDRAM read address
        .DRAM5_RD_SIZE                  ( s_DRAM5_RD_SIZE               ),//(o)  [ 12]  SDRAM read size
        .DRAM5_RD_SOP                   ( s_DRAM5_RD_SOP                ),//(i)  [  1]  SDRAM read start of packet
        .DRAM5_RD_EOP                   ( s_DRAM5_RD_EOP                ),//(i)  [  1]  SDRAM read end of packet
        .DRAM5_RD_DVLD                  ( s_DRAM5_RD_DVLD               ),//(i)  [  1]  SDRAM read data valid
        .DRAM5_RD_DATA                  ( s_DRAM5_RD_DATA               ),//(i)  [ 32]  SDRAM read data

        .DRAM6_WR_RDY                   ( s_DRAM6_WR_RDY                ),//(i)  [  1]  SDRAM write ready
        .DRAM6_WR_REQ                   ( s_DRAM6_WR_REQ                ),//(o)  [  1]  SDRAM write request
        .DRAM6_WR_ACK                   ( s_DRAM6_WR_ACK                ),//(i)  [  1]  SDRAM write acknowledge
        .DRAM6_WR_ADDR                  ( s_DRAM6_WR_ADDR               ),//(o)  [ 25]  SDRAM write address
        .DRAM6_WR_SIZE                  ( s_DRAM6_WR_SIZE               ),//(o)  [ 12]  SDRAM write size
        .DRAM6_WR_SOP                   ( s_DRAM6_WR_SOP                ),//(o)  [  1]  SDRAM write start of packet
        .DRAM6_WR_EOP                   ( s_DRAM6_WR_EOP                ),//(o)  [  1]  SDRAM write end of packet
        .DRAM6_WR_DVLD                  ( s_DRAM6_WR_DVLD               ),//(o)  [  1]  SDRAM write data valid
        .DRAM6_WR_DATA                  ( s_DRAM6_WR_DATA               ),//(o)  [ 32]  SDRAM write data
        .DRAM6_RD_RDY                   ( s_DRAM6_RD_RDY                ),//(o)  [  1]  SDRAM read ready
        .DRAM6_RD_REQ                   ( s_DRAM6_RD_REQ                ),//(o)  [  1]  SDRAM read request
        .DRAM6_RD_ACK                   ( s_DRAM6_RD_ACK                ),//(i)  [  1]  SDRAM read acknowledge
        .DRAM6_RD_ADDR                  ( s_DRAM6_RD_ADDR               ),//(o)  [ 25]  SDRAM read address
        .DRAM6_RD_SIZE                  ( s_DRAM6_RD_SIZE               ),//(o)  [ 12]  SDRAM read size
        .DRAM6_RD_SOP                   ( s_DRAM6_RD_SOP                ),//(i)  [  1]  SDRAM read start of packet
        .DRAM6_RD_EOP                   ( s_DRAM6_RD_EOP                ),//(i)  [  1]  SDRAM read end of packet
        .DRAM6_RD_DVLD                  ( s_DRAM6_RD_DVLD               ),//(i)  [  1]  SDRAM read data valid
        .DRAM6_RD_DATA                  ( s_DRAM6_RD_DATA               ) //(i)  [ 32]  SDRAM read data
        ) ;

endmodule



