// =================================================================================================
// File Name      : fpga_top_sima.v
// Module         : FPGA_TOP_SIMA
// Function       : FPGA_TOP_SIMA
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2019/06/11   xxxxxx            create new
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ps / 1ps

module FPGA_TOP_SIMA (
    //clock and reset
    input                               CLK                                     ,//(i)  [  1]  Systerm clock 0 P
    input                               RST                                     ,//(i)  [  1]  Systerm clock 0 N

    //register I/F
    input                               REG0_WR_REQ                             ,//(i)  [  1]  Register write request
    output                              REG0_WR_ACK                             ,//(o)  [  1]  Register write acknowledge
    input       [  31:0]                REG0_WR_DATA                            ,//(i)  [ 32]  Register write data
    input                               REG0_RD_REQ                             ,//(i)  [  1]  Register read request
    output                              REG0_RD_ACK                             ,//(o)  [  1]  Register read acknowledge
    output      [  31:0]                REG0_RD_DATA                            ,//(o)  [ 32]  Register read data
    input       [   9:0]                REG0_OP_ADDR                            ,//(i)  [ 10]  Register operation address

    input                               REG1_WR_REQ                             ,//(i)  [  1]  Register write request
    output                              REG1_WR_ACK                             ,//(o)  [  1]  Register write acknowledge
    input       [  31:0]                REG1_WR_DATA                            ,//(i)  [ 32]  Register write data
    input                               REG1_RD_REQ                             ,//(i)  [  1]  Register read request
    output                              REG1_RD_ACK                             ,//(o)  [  1]  Register read acknowledge
    output      [  31:0]                REG1_RD_DATA                            ,//(o)  [ 32]  Register read data
    input       [   9:0]                REG1_OP_ADDR                            ,//(i)  [ 10]  Register operation address

    input                               REG2_WR_REQ                             ,//(i)  [  1]  Register write request
    output                              REG2_WR_ACK                             ,//(o)  [  1]  Register write acknowledge
    input       [  31:0]                REG2_WR_DATA                            ,//(i)  [ 32]  Register write data
    input                               REG2_RD_REQ                             ,//(i)  [  1]  Register read request
    output                              REG2_RD_ACK                             ,//(o)  [  1]  Register read acknowledge
    output      [  31:0]                REG2_RD_DATA                            ,//(o)  [ 32]  Register read data
    input       [   9:0]                REG2_OP_ADDR                            ,//(i)  [ 10]  Register operation address

    input                               REG3_WR_REQ                             ,//(i)  [  1]  Register write request
    output                              REG3_WR_ACK                             ,//(o)  [  1]  Register write acknowledge
    input       [  31:0]                REG3_WR_DATA                            ,//(i)  [ 32]  Register write data
    input                               REG3_RD_REQ                             ,//(i)  [  1]  Register read request
    output                              REG3_RD_ACK                             ,//(o)  [  1]  Register read acknowledge
    output      [  31:0]                REG3_RD_DATA                            ,//(o)  [ 32]  Register read data
    input       [   9:0]                REG3_OP_ADDR                            ,//(i)  [ 10]  Register operation address

    input                               REG4_WR_REQ                             ,//(i)  [  1]  Register write request
    output                              REG4_WR_ACK                             ,//(o)  [  1]  Register write acknowledge
    input       [  31:0]                REG4_WR_DATA                            ,//(i)  [ 32]  Register write data
    input                               REG4_RD_REQ                             ,//(i)  [  1]  Register read request
    output                              REG4_RD_ACK                             ,//(o)  [  1]  Register read acknowledge
    output      [  31:0]                REG4_RD_DATA                            ,//(o)  [ 32]  Register read data
    input       [   9:0]                REG4_OP_ADDR                            ,//(i)  [ 10]  Register operation address

    input                               REG5_WR_REQ                             ,//(i)  [  1]  Register write request
    output                              REG5_WR_ACK                             ,//(o)  [  1]  Register write acknowledge
    input       [  31:0]                REG5_WR_DATA                            ,//(i)  [ 32]  Register write data
    input                               REG5_RD_REQ                             ,//(i)  [  1]  Register read request
    output                              REG5_RD_ACK                             ,//(o)  [  1]  Register read acknowledge
    output      [  31:0]                REG5_RD_DATA                            ,//(o)  [ 32]  Register read data
    input       [   9:0]                REG5_OP_ADDR                            ,//(i)  [ 10]  Register operation address

    input                               REG6_WR_REQ                             ,//(i)  [  1]  Register write request
    output                              REG6_WR_ACK                             ,//(o)  [  1]  Register write acknowledge
    input       [  31:0]                REG6_WR_DATA                            ,//(i)  [ 32]  Register write data
    input                               REG6_RD_REQ                             ,//(i)  [  1]  Register read request
    output                              REG6_RD_ACK                             ,//(o)  [  1]  Register read acknowledge
    output      [  31:0]                REG6_RD_DATA                            ,//(o)  [ 32]  Register read data
    input       [   9:0]                REG6_OP_ADDR                            ,//(i)  [ 10]  Register operation address

    input                               REG7_WR_REQ                             ,//(i)  [  1]  Register write request
    output                              REG7_WR_ACK                             ,//(o)  [  1]  Register write acknowledge
    input       [  31:0]                REG7_WR_DATA                            ,//(i)  [ 32]  Register write data
    input                               REG7_RD_REQ                             ,//(i)  [  1]  Register read request
    output                              REG7_RD_ACK                             ,//(o)  [  1]  Register read acknowledge
    output      [  31:0]                REG7_RD_DATA                            ,//(o)  [ 32]  Register read data
    input       [   9:0]                REG7_OP_ADDR                            ,//(i)  [ 10]  Register operation address

    //bram I/F
    input                               BRAM0_WR_REQ                            ,//(i)  [  1]  BRAM write request
    input       [  15:0]                BRAM0_WR_ADDR                           ,//(i)  [ 16]  BRAM write address
    input       [  31:0]                BRAM0_WR_DATA                           ,//(i)  [ 32]  BRAM write data
    output                              BRAM0_WR_ACK                            ,//(o)  [  1]  BRAM write acknowledge
    input                               BRAM0_RD_REQ                            ,//(i)  [  1]  BRAM read request
    input       [  15:0]                BRAM0_RD_ADDR                           ,//(i)  [ 16]  BRAM read address
    output      [  31:0]                BRAM0_RD_DATA                           ,//(o)  [ 32]  BRAM read data
    output                              BRAM0_RD_ACK                            ,//(o)  [  1]  BRAM read acknowledge

    input                               BRAM1_WR_REQ                            ,//(i)  [  1]  BRAM write request
    input       [  15:0]                BRAM1_WR_ADDR                           ,//(i)  [ 16]  BRAM write address
    input       [  31:0]                BRAM1_WR_DATA                           ,//(i)  [ 32]  BRAM write data
    output                              BRAM1_WR_ACK                            ,//(o)  [  1]  BRAM write acknowledge
    input                               BRAM1_RD_REQ                            ,//(i)  [  1]  BRAM read request
    input       [  15:0]                BRAM1_RD_ADDR                           ,//(i)  [ 16]  BRAM read address
    output      [  31:0]                BRAM1_RD_DATA                           ,//(o)  [ 32]  BRAM read data
    output                              BRAM1_RD_ACK                            ,//(o)  [  1]  BRAM read acknowledge

    input                               BRAM2_WR_REQ                            ,//(i)  [  1]  BRAM write request
    input       [  15:0]                BRAM2_WR_ADDR                           ,//(i)  [ 16]  BRAM write address
    input       [  31:0]                BRAM2_WR_DATA                           ,//(i)  [ 32]  BRAM write data
    output                              BRAM2_WR_ACK                            ,//(o)  [  1]  BRAM write acknowledge
    input                               BRAM2_RD_REQ                            ,//(i)  [  1]  BRAM read request
    input       [  15:0]                BRAM2_RD_ADDR                           ,//(i)  [ 16]  BRAM read address
    output      [  31:0]                BRAM2_RD_DATA                           ,//(o)  [ 32]  BRAM read data
    output                              BRAM2_RD_ACK                            ,//(o)  [  1]  BRAM read acknowledge

    input                               BRAM3_WR_REQ                            ,//(i)  [  1]  BRAM write request
    input       [  15:0]                BRAM3_WR_ADDR                           ,//(i)  [ 16]  BRAM write address
    input       [  31:0]                BRAM3_WR_DATA                           ,//(i)  [ 32]  BRAM write data
    output                              BRAM3_WR_ACK                            ,//(o)  [  1]  BRAM write acknowledge
    input                               BRAM3_RD_REQ                            ,//(i)  [  1]  BRAM read request
    input       [  15:0]                BRAM3_RD_ADDR                           ,//(i)  [ 16]  BRAM read address
    output      [  31:0]                BRAM3_RD_DATA                           ,//(o)  [ 32]  BRAM read data
    output                              BRAM3_RD_ACK                            ,//(o)  [  1]  BRAM read acknowledge

    input                               BRAM4_WR_REQ                            ,//(i)  [  1]  BRAM write request
    input       [  15:0]                BRAM4_WR_ADDR                           ,//(i)  [ 16]  BRAM write address
    input       [  31:0]                BRAM4_WR_DATA                           ,//(i)  [ 32]  BRAM write data
    output                              BRAM4_WR_ACK                            ,//(o)  [  1]  BRAM write acknowledge
    input                               BRAM4_RD_REQ                            ,//(i)  [  1]  BRAM read request
    input       [  15:0]                BRAM4_RD_ADDR                           ,//(i)  [ 16]  BRAM read address
    output      [  31:0]                BRAM4_RD_DATA                           ,//(o)  [ 32]  BRAM read data
    output                              BRAM4_RD_ACK                            ,//(o)  [  1]  BRAM read acknowledge

    input                               BRAM5_WR_REQ                            ,//(i)  [  1]  BRAM write request
    input       [  15:0]                BRAM5_WR_ADDR                           ,//(i)  [ 16]  BRAM write address
    input       [  31:0]                BRAM5_WR_DATA                           ,//(i)  [ 32]  BRAM write data
    output                              BRAM5_WR_ACK                            ,//(o)  [  1]  BRAM write acknowledge
    input                               BRAM5_RD_REQ                            ,//(i)  [  1]  BRAM read request
    input       [  15:0]                BRAM5_RD_ADDR                           ,//(i)  [ 16]  BRAM read address
    output      [  31:0]                BRAM5_RD_DATA                           ,//(o)  [ 32]  BRAM read data
    output                              BRAM5_RD_ACK                            ,//(o)  [  1]  BRAM read acknowledge

    input                               BRAM6_WR_REQ                            ,//(i)  [  1]  BRAM write request
    input       [  15:0]                BRAM6_WR_ADDR                           ,//(i)  [ 16]  BRAM write address
    input       [  31:0]                BRAM6_WR_DATA                           ,//(i)  [ 32]  BRAM write data
    output                              BRAM6_WR_ACK                            ,//(o)  [  1]  BRAM write acknowledge
    input                               BRAM6_RD_REQ                            ,//(i)  [  1]  BRAM read request
    input       [  15:0]                BRAM6_RD_ADDR                           ,//(i)  [ 16]  BRAM read address
    output      [  31:0]                BRAM6_RD_DATA                           ,//(o)  [ 32]  BRAM read data
    output                              BRAM6_RD_ACK                            ,//(o)  [  1]  BRAM read acknowledge

    input                               BRAM7_WR_REQ                            ,//(i)  [  1]  BRAM write request
    input       [  15:0]                BRAM7_WR_ADDR                           ,//(i)  [ 16]  BRAM write address
    input       [  31:0]                BRAM7_WR_DATA                           ,//(i)  [ 32]  BRAM write data
    output                              BRAM7_WR_ACK                            ,//(o)  [  1]  BRAM write acknowledge
    input                               BRAM7_RD_REQ                            ,//(i)  [  1]  BRAM read request
    input       [  15:0]                BRAM7_RD_ADDR                           ,//(i)  [ 16]  BRAM read address
    output      [  31:0]                BRAM7_RD_DATA                           ,//(o)  [ 32]  BRAM read data
    output                              BRAM7_RD_ACK                            ,//(o)  [  1]  BRAM read acknowledge

    //sdram I/F
    output                              DRAM0_WR_RDY                            ,//(o)  [  1]  SDRAM write ready
    input                               DRAM0_WR_REQ                            ,//(i)  [  1]  SDRAM write request
    output                              DRAM0_WR_ACK                            ,//(o)  [  1]  SDRAM write acknowledge
    input       [  24:0]                DRAM0_WR_ADDR                           ,//(i)  [ 25]  SDRAM write address
    input       [  11:0]                DRAM0_WR_SIZE                           ,//(i)  [ 12]  SDRAM write size
    input                               DRAM0_WR_SOP                            ,//(i)  [  1]  SDRAM write start of packet
    input                               DRAM0_WR_EOP                            ,//(i)  [  1]  SDRAM write end of packet
    input                               DRAM0_WR_DVLD                           ,//(i)  [  1]  SDRAM write data valid
    input       [  31:0]                DRAM0_WR_DATA                           ,//(i)  [ 32]  SDRAM write data
    input                               DRAM0_RD_RDY                            ,//(i)  [  1]  SDRAM read ready
    input                               DRAM0_RD_REQ                            ,//(i)  [  1]  SDRAM read request
    output                              DRAM0_RD_ACK                            ,//(o)  [  1]  SDRAM read acknowledge
    input       [  24:0]                DRAM0_RD_ADDR                           ,//(i)  [ 25]  SDRAM read address
    input       [  11:0]                DRAM0_RD_SIZE                           ,//(i)  [ 12]  SDRAM read size
    output                              DRAM0_RD_SOP                            ,//(o)  [  1]  SDRAM read start of packet
    output                              DRAM0_RD_EOP                            ,//(o)  [  1]  SDRAM read end of packet
    output                              DRAM0_RD_DVLD                           ,//(o)  [  1]  SDRAM read data valid
    output      [  31:0]                DRAM0_RD_DATA                           ,//(o)  [ 32]  SDRAM read data

    output                              DRAM1_WR_RDY                            ,//(o)  [  1]  SDRAM write ready
    input                               DRAM1_WR_REQ                            ,//(i)  [  1]  SDRAM write request
    output                              DRAM1_WR_ACK                            ,//(o)  [  1]  SDRAM write acknowledge
    input       [  24:0]                DRAM1_WR_ADDR                           ,//(i)  [ 25]  SDRAM write address
    input       [  11:0]                DRAM1_WR_SIZE                           ,//(i)  [ 12]  SDRAM write size
    input                               DRAM1_WR_SOP                            ,//(i)  [  1]  SDRAM write start of packet
    input                               DRAM1_WR_EOP                            ,//(i)  [  1]  SDRAM write end of packet
    input                               DRAM1_WR_DVLD                           ,//(i)  [  1]  SDRAM write data valid
    input       [  31:0]                DRAM1_WR_DATA                           ,//(i)  [ 32]  SDRAM write data
    input                               DRAM1_RD_RDY                            ,//(i)  [  1]  SDRAM read ready
    input                               DRAM1_RD_REQ                            ,//(i)  [  1]  SDRAM read request
    output                              DRAM1_RD_ACK                            ,//(o)  [  1]  SDRAM read acknowledge
    input       [  24:0]                DRAM1_RD_ADDR                           ,//(i)  [ 25]  SDRAM read address
    input       [  11:0]                DRAM1_RD_SIZE                           ,//(i)  [ 12]  SDRAM read size
    output                              DRAM1_RD_SOP                            ,//(o)  [  1]  SDRAM read start of packet
    output                              DRAM1_RD_EOP                            ,//(o)  [  1]  SDRAM read end of packet
    output                              DRAM1_RD_DVLD                           ,//(o)  [  1]  SDRAM read data valid
    output      [  31:0]                DRAM1_RD_DATA                           ,//(o)  [ 32]  SDRAM read data

    output                              DRAM2_WR_RDY                            ,//(o)  [  1]  SDRAM write ready
    input                               DRAM2_WR_REQ                            ,//(i)  [  1]  SDRAM write request
    output                              DRAM2_WR_ACK                            ,//(o)  [  1]  SDRAM write acknowledge
    input       [  24:0]                DRAM2_WR_ADDR                           ,//(i)  [ 25]  SDRAM write address
    input       [  11:0]                DRAM2_WR_SIZE                           ,//(i)  [ 12]  SDRAM write size
    input                               DRAM2_WR_SOP                            ,//(i)  [  1]  SDRAM write start of packet
    input                               DRAM2_WR_EOP                            ,//(i)  [  1]  SDRAM write end of packet
    input                               DRAM2_WR_DVLD                           ,//(i)  [  1]  SDRAM write data valid
    input       [  31:0]                DRAM2_WR_DATA                           ,//(i)  [ 32]  SDRAM write data
    input                               DRAM2_RD_RDY                            ,//(i)  [  1]  SDRAM read ready
    input                               DRAM2_RD_REQ                            ,//(i)  [  1]  SDRAM read request
    output                              DRAM2_RD_ACK                            ,//(o)  [  1]  SDRAM read acknowledge
    input       [  24:0]                DRAM2_RD_ADDR                           ,//(i)  [ 25]  SDRAM read address
    input       [  11:0]                DRAM2_RD_SIZE                           ,//(i)  [ 12]  SDRAM read size
    output                              DRAM2_RD_SOP                            ,//(o)  [  1]  SDRAM read start of packet
    output                              DRAM2_RD_EOP                            ,//(o)  [  1]  SDRAM read end of packet
    output                              DRAM2_RD_DVLD                           ,//(o)  [  1]  SDRAM read data valid
    output      [  31:0]                DRAM2_RD_DATA                           ,//(o)  [ 32]  SDRAM read data

    output                              DRAM3_WR_RDY                            ,//(o)  [  1]  SDRAM write ready
    input                               DRAM3_WR_REQ                            ,//(i)  [  1]  SDRAM write request
    output                              DRAM3_WR_ACK                            ,//(o)  [  1]  SDRAM write acknowledge
    input       [  24:0]                DRAM3_WR_ADDR                           ,//(i)  [ 25]  SDRAM write address
    input       [  11:0]                DRAM3_WR_SIZE                           ,//(i)  [ 12]  SDRAM write size
    input                               DRAM3_WR_SOP                            ,//(i)  [  1]  SDRAM write start of packet
    input                               DRAM3_WR_EOP                            ,//(i)  [  1]  SDRAM write end of packet
    input                               DRAM3_WR_DVLD                           ,//(i)  [  1]  SDRAM write data valid
    input       [  31:0]                DRAM3_WR_DATA                           ,//(i)  [ 32]  SDRAM write data
    input                               DRAM3_RD_RDY                            ,//(i)  [  1]  SDRAM read ready
    input                               DRAM3_RD_REQ                            ,//(i)  [  1]  SDRAM read request
    output                              DRAM3_RD_ACK                            ,//(o)  [  1]  SDRAM read acknowledge
    input       [  24:0]                DRAM3_RD_ADDR                           ,//(i)  [ 25]  SDRAM read address
    input       [  11:0]                DRAM3_RD_SIZE                           ,//(i)  [ 12]  SDRAM read size
    output                              DRAM3_RD_SOP                            ,//(o)  [  1]  SDRAM read start of packet
    output                              DRAM3_RD_EOP                            ,//(o)  [  1]  SDRAM read end of packet
    output                              DRAM3_RD_DVLD                           ,//(o)  [  1]  SDRAM read data valid
    output      [  31:0]                DRAM3_RD_DATA                           ,//(o)  [ 32]  SDRAM read data

    output                              DRAM4_WR_RDY                            ,//(o)  [  1]  SDRAM write ready
    input                               DRAM4_WR_REQ                            ,//(i)  [  1]  SDRAM write request
    output                              DRAM4_WR_ACK                            ,//(o)  [  1]  SDRAM write acknowledge
    input       [  24:0]                DRAM4_WR_ADDR                           ,//(i)  [ 25]  SDRAM write address
    input       [  11:0]                DRAM4_WR_SIZE                           ,//(i)  [ 12]  SDRAM write size
    input                               DRAM4_WR_SOP                            ,//(i)  [  1]  SDRAM write start of packet
    input                               DRAM4_WR_EOP                            ,//(i)  [  1]  SDRAM write end of packet
    input                               DRAM4_WR_DVLD                           ,//(i)  [  1]  SDRAM write data valid
    input       [  31:0]                DRAM4_WR_DATA                           ,//(i)  [ 32]  SDRAM write data
    input                               DRAM4_RD_RDY                            ,//(i)  [  1]  SDRAM read ready
    input                               DRAM4_RD_REQ                            ,//(i)  [  1]  SDRAM read request
    output                              DRAM4_RD_ACK                            ,//(o)  [  1]  SDRAM read acknowledge
    input       [  24:0]                DRAM4_RD_ADDR                           ,//(i)  [ 25]  SDRAM read address
    input       [  11:0]                DRAM4_RD_SIZE                           ,//(i)  [ 12]  SDRAM read size
    output                              DRAM4_RD_SOP                            ,//(o)  [  1]  SDRAM read start of packet
    output                              DRAM4_RD_EOP                            ,//(o)  [  1]  SDRAM read end of packet
    output                              DRAM4_RD_DVLD                           ,//(o)  [  1]  SDRAM read data valid
    output      [  31:0]                DRAM4_RD_DATA                           ,//(o)  [ 32]  SDRAM read data

    output                              DRAM5_WR_RDY                            ,//(o)  [  1]  SDRAM write ready
    input                               DRAM5_WR_REQ                            ,//(i)  [  1]  SDRAM write request
    output                              DRAM5_WR_ACK                            ,//(o)  [  1]  SDRAM write acknowledge
    input       [  24:0]                DRAM5_WR_ADDR                           ,//(i)  [ 25]  SDRAM write address
    input       [  11:0]                DRAM5_WR_SIZE                           ,//(i)  [ 12]  SDRAM write size
    input                               DRAM5_WR_SOP                            ,//(i)  [  1]  SDRAM write start of packet
    input                               DRAM5_WR_EOP                            ,//(i)  [  1]  SDRAM write end of packet
    input                               DRAM5_WR_DVLD                           ,//(i)  [  1]  SDRAM write data valid
    input       [  31:0]                DRAM5_WR_DATA                           ,//(i)  [ 32]  SDRAM write data
    input                               DRAM5_RD_RDY                            ,//(i)  [  1]  SDRAM read ready
    input                               DRAM5_RD_REQ                            ,//(i)  [  1]  SDRAM read request
    output                              DRAM5_RD_ACK                            ,//(o)  [  1]  SDRAM read acknowledge
    input       [  24:0]                DRAM5_RD_ADDR                           ,//(i)  [ 25]  SDRAM read address
    input       [  11:0]                DRAM5_RD_SIZE                           ,//(i)  [ 12]  SDRAM read size
    output                              DRAM5_RD_SOP                            ,//(o)  [  1]  SDRAM read start of packet
    output                              DRAM5_RD_EOP                            ,//(o)  [  1]  SDRAM read end of packet
    output                              DRAM5_RD_DVLD                           ,//(o)  [  1]  SDRAM read data valid
    output      [  31:0]                DRAM5_RD_DATA                           ,//(o)  [ 32]  SDRAM read data

    output                              DRAM6_WR_RDY                            ,//(o)  [  1]  SDRAM write ready
    input                               DRAM6_WR_REQ                            ,//(i)  [  1]  SDRAM write request
    output                              DRAM6_WR_ACK                            ,//(o)  [  1]  SDRAM write acknowledge
    input       [  24:0]                DRAM6_WR_ADDR                           ,//(i)  [ 25]  SDRAM write address
    input       [  11:0]                DRAM6_WR_SIZE                           ,//(i)  [ 12]  SDRAM write size
    input                               DRAM6_WR_SOP                            ,//(i)  [  1]  SDRAM write start of packet
    input                               DRAM6_WR_EOP                            ,//(i)  [  1]  SDRAM write end of packet
    input                               DRAM6_WR_DVLD                           ,//(i)  [  1]  SDRAM write data valid
    input       [  31:0]                DRAM6_WR_DATA                           ,//(i)  [ 32]  SDRAM write data
    input                               DRAM6_RD_RDY                            ,//(i)  [  1]  SDRAM read ready
    input                               DRAM6_RD_REQ                            ,//(i)  [  1]  SDRAM read request
    output                              DRAM6_RD_ACK                            ,//(o)  [  1]  SDRAM read acknowledge
    input       [  24:0]                DRAM6_RD_ADDR                           ,//(i)  [ 25]  SDRAM read address
    input       [  11:0]                DRAM6_RD_SIZE                           ,//(i)  [ 12]  SDRAM read size
    output                              DRAM6_RD_SOP                            ,//(o)  [  1]  SDRAM read start of packet
    output                              DRAM6_RD_EOP                            ,//(o)  [  1]  SDRAM read end of packet
    output                              DRAM6_RD_DVLD                           ,//(o)  [  1]  SDRAM read data valid
    output      [  31:0]                DRAM6_RD_DATA                            //(o)  [ 32]  SDRAM read data
    ) ;

// ==============================================================================
// Internal Parameter Declare
// ==============================================================================

    parameter                           p_GND       = {256{1'b0}}               ;
    parameter                           p_PWR       = {256{1'b1}}               ;

// ==============================================================================
// Internal signals declaration
// ==============================================================================

// =================================================================================================
// RTL Body
// =================================================================================================

/*============================================================================+/
||                                                                            ||
||                           Register Sim                                     ||
||                                                                            ||
/+============================================================================*/

    REG_BIST U_REG_BIST_0 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [   1]
        .RST                            ( RST                       ),//(i)  [   1]
        //register if
        .REG_WR_REQ                     ( REG0_WR_REQ               ),//(i)  [   1]
        .REG_RD_REQ                     ( REG0_RD_REQ               ),//(i)  [   1]
        .REG_WR_ACK                     ( REG0_WR_ACK               ),//(o)  [   1]
        .REG_RD_ACK                     ( REG0_RD_ACK               ),//(o)  [   1]
        .REG_WR_DATA                    ( REG0_WR_DATA              ),//(i)  [  32]
        .REG_RD_DATA                    ( REG0_RD_DATA              ),//(o)  [  32]
        .REG_OP_ADDR                    ( REG0_OP_ADDR              ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'h12345678              ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h87654321              ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h55555555              ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hAAAAAAAA              ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h00000000              ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hFFFFFFFF              ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h5A5A5A5A              ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'hA5A5A5A5              ),//(i)  [  32]

        .DEBUG_DO0                      (                           ),//(o)  [  32]
        .DEBUG_DO1                      (                           ),//(o)  [  32]
        .DEBUG_DO2                      (                           ),//(o)  [  32]
        .DEBUG_DO3                      (                           ),//(o)  [  32]
        .DEBUG_DO4                      (                           ),//(o)  [  32]
        .DEBUG_DO5                      (                           ),//(o)  [  32]
        .DEBUG_DO6                      (                           ),//(o)  [  32]
        .DEBUG_DO7                      (                           ),//(o)  [  32]

        .DEBUG_TRIG0                    (                           ),//(o)  [   1]
        .DEBUG_TRIG1                    (                           ),//(o)  [   1]
        .DEBUG_TRIG2                    (                           ),//(o)  [   1]
        .DEBUG_TRIG3                    (                           ),//(o)  [   1]
        .DEBUG_TRIG4                    (                           ),//(o)  [   1]
        .DEBUG_TRIG5                    (                           ),//(o)  [   1]
        .DEBUG_TRIG6                    (                           ),//(o)  [   1]
        .DEBUG_TRIG7                    (                           ) //(o)  [   1]
        );

    REG_BIST U_REG_BIST_1 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [   1]
        .RST                            ( RST                       ),//(i)  [   1]
        //register if
        .REG_WR_REQ                     ( REG1_WR_REQ               ),//(i)  [   1]
        .REG_RD_REQ                     ( REG1_RD_REQ               ),//(i)  [   1]
        .REG_WR_ACK                     ( REG1_WR_ACK               ),//(o)  [   1]
        .REG_RD_ACK                     ( REG1_RD_ACK               ),//(o)  [   1]
        .REG_WR_DATA                    ( REG1_WR_DATA              ),//(i)  [  32]
        .REG_RD_DATA                    ( REG1_RD_DATA              ),//(o)  [  32]
        .REG_OP_ADDR                    ( REG1_OP_ADDR              ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'h12345678              ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h87654321              ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h55555555              ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hAAAAAAAA              ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h00000000              ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hFFFFFFFF              ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h5A5A5A5A              ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'hA5A5A5A5              ),//(i)  [  32]

        .DEBUG_DO0                      (                           ),//(o)  [  32]
        .DEBUG_DO1                      (                           ),//(o)  [  32]
        .DEBUG_DO2                      (                           ),//(o)  [  32]
        .DEBUG_DO3                      (                           ),//(o)  [  32]
        .DEBUG_DO4                      (                           ),//(o)  [  32]
        .DEBUG_DO5                      (                           ),//(o)  [  32]
        .DEBUG_DO6                      (                           ),//(o)  [  32]
        .DEBUG_DO7                      (                           ),//(o)  [  32]

        .DEBUG_TRIG0                    (                           ),//(o)  [   1]
        .DEBUG_TRIG1                    (                           ),//(o)  [   1]
        .DEBUG_TRIG2                    (                           ),//(o)  [   1]
        .DEBUG_TRIG3                    (                           ),//(o)  [   1]
        .DEBUG_TRIG4                    (                           ),//(o)  [   1]
        .DEBUG_TRIG5                    (                           ),//(o)  [   1]
        .DEBUG_TRIG6                    (                           ),//(o)  [   1]
        .DEBUG_TRIG7                    (                           ) //(o)  [   1]
        );

    REG_BIST U_REG_BIST_2 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [   1]
        .RST                            ( RST                       ),//(i)  [   1]
        //register if
        .REG_WR_REQ                     ( REG2_WR_REQ               ),//(i)  [   1]
        .REG_RD_REQ                     ( REG2_RD_REQ               ),//(i)  [   1]
        .REG_WR_ACK                     ( REG2_WR_ACK               ),//(o)  [   1]
        .REG_RD_ACK                     ( REG2_RD_ACK               ),//(o)  [   1]
        .REG_WR_DATA                    ( REG2_WR_DATA              ),//(i)  [  32]
        .REG_RD_DATA                    ( REG2_RD_DATA              ),//(o)  [  32]
        .REG_OP_ADDR                    ( REG2_OP_ADDR              ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'h12345678              ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h87654321              ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h55555555              ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hAAAAAAAA              ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h00000000              ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hFFFFFFFF              ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h5A5A5A5A              ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'hA5A5A5A5              ),//(i)  [  32]

        .DEBUG_DO0                      (                           ),//(o)  [  32]
        .DEBUG_DO1                      (                           ),//(o)  [  32]
        .DEBUG_DO2                      (                           ),//(o)  [  32]
        .DEBUG_DO3                      (                           ),//(o)  [  32]
        .DEBUG_DO4                      (                           ),//(o)  [  32]
        .DEBUG_DO5                      (                           ),//(o)  [  32]
        .DEBUG_DO6                      (                           ),//(o)  [  32]
        .DEBUG_DO7                      (                           ),//(o)  [  32]

        .DEBUG_TRIG0                    (                           ),//(o)  [   1]
        .DEBUG_TRIG1                    (                           ),//(o)  [   1]
        .DEBUG_TRIG2                    (                           ),//(o)  [   1]
        .DEBUG_TRIG3                    (                           ),//(o)  [   1]
        .DEBUG_TRIG4                    (                           ),//(o)  [   1]
        .DEBUG_TRIG5                    (                           ),//(o)  [   1]
        .DEBUG_TRIG6                    (                           ),//(o)  [   1]
        .DEBUG_TRIG7                    (                           ) //(o)  [   1]
        );

    REG_BIST U_REG_BIST_3 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [   1]
        .RST                            ( RST                       ),//(i)  [   1]
        //register if
        .REG_WR_REQ                     ( REG3_WR_REQ               ),//(i)  [   1]
        .REG_RD_REQ                     ( REG3_RD_REQ               ),//(i)  [   1]
        .REG_WR_ACK                     ( REG3_WR_ACK               ),//(o)  [   1]
        .REG_RD_ACK                     ( REG3_RD_ACK               ),//(o)  [   1]
        .REG_WR_DATA                    ( REG3_WR_DATA              ),//(i)  [  32]
        .REG_RD_DATA                    ( REG3_RD_DATA              ),//(o)  [  32]
        .REG_OP_ADDR                    ( REG3_OP_ADDR              ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'h12345678              ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h87654321              ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h55555555              ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hAAAAAAAA              ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h00000000              ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hFFFFFFFF              ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h5A5A5A5A              ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'hA5A5A5A5              ),//(i)  [  32]

        .DEBUG_DO0                      (                           ),//(o)  [  32]
        .DEBUG_DO1                      (                           ),//(o)  [  32]
        .DEBUG_DO2                      (                           ),//(o)  [  32]
        .DEBUG_DO3                      (                           ),//(o)  [  32]
        .DEBUG_DO4                      (                           ),//(o)  [  32]
        .DEBUG_DO5                      (                           ),//(o)  [  32]
        .DEBUG_DO6                      (                           ),//(o)  [  32]
        .DEBUG_DO7                      (                           ),//(o)  [  32]

        .DEBUG_TRIG0                    (                           ),//(o)  [   1]
        .DEBUG_TRIG1                    (                           ),//(o)  [   1]
        .DEBUG_TRIG2                    (                           ),//(o)  [   1]
        .DEBUG_TRIG3                    (                           ),//(o)  [   1]
        .DEBUG_TRIG4                    (                           ),//(o)  [   1]
        .DEBUG_TRIG5                    (                           ),//(o)  [   1]
        .DEBUG_TRIG6                    (                           ),//(o)  [   1]
        .DEBUG_TRIG7                    (                           ) //(o)  [   1]
        );

    REG_BIST U_REG_BIST_4 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [   1]
        .RST                            ( RST                       ),//(i)  [   1]
        //register if
        .REG_WR_REQ                     ( REG4_WR_REQ               ),//(i)  [   1]
        .REG_RD_REQ                     ( REG4_RD_REQ               ),//(i)  [   1]
        .REG_WR_ACK                     ( REG4_WR_ACK               ),//(o)  [   1]
        .REG_RD_ACK                     ( REG4_RD_ACK               ),//(o)  [   1]
        .REG_WR_DATA                    ( REG4_WR_DATA              ),//(i)  [  32]
        .REG_RD_DATA                    ( REG4_RD_DATA              ),//(o)  [  32]
        .REG_OP_ADDR                    ( REG4_OP_ADDR              ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'h12345678              ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h87654321              ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h55555555              ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hAAAAAAAA              ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h00000000              ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hFFFFFFFF              ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h5A5A5A5A              ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'hA5A5A5A5              ),//(i)  [  32]

        .DEBUG_DO0                      (                           ),//(o)  [  32]
        .DEBUG_DO1                      (                           ),//(o)  [  32]
        .DEBUG_DO2                      (                           ),//(o)  [  32]
        .DEBUG_DO3                      (                           ),//(o)  [  32]
        .DEBUG_DO4                      (                           ),//(o)  [  32]
        .DEBUG_DO5                      (                           ),//(o)  [  32]
        .DEBUG_DO6                      (                           ),//(o)  [  32]
        .DEBUG_DO7                      (                           ),//(o)  [  32]

        .DEBUG_TRIG0                    (                           ),//(o)  [   1]
        .DEBUG_TRIG1                    (                           ),//(o)  [   1]
        .DEBUG_TRIG2                    (                           ),//(o)  [   1]
        .DEBUG_TRIG3                    (                           ),//(o)  [   1]
        .DEBUG_TRIG4                    (                           ),//(o)  [   1]
        .DEBUG_TRIG5                    (                           ),//(o)  [   1]
        .DEBUG_TRIG6                    (                           ),//(o)  [   1]
        .DEBUG_TRIG7                    (                           ) //(o)  [   1]
        );

    REG_BIST U_REG_BIST_5 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [   1]
        .RST                            ( RST                       ),//(i)  [   1]
        //register if
        .REG_WR_REQ                     ( REG5_WR_REQ               ),//(i)  [   1]
        .REG_RD_REQ                     ( REG5_RD_REQ               ),//(i)  [   1]
        .REG_WR_ACK                     ( REG5_WR_ACK               ),//(o)  [   1]
        .REG_RD_ACK                     ( REG5_RD_ACK               ),//(o)  [   1]
        .REG_WR_DATA                    ( REG5_WR_DATA              ),//(i)  [  32]
        .REG_RD_DATA                    ( REG5_RD_DATA              ),//(o)  [  32]
        .REG_OP_ADDR                    ( REG5_OP_ADDR              ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'h12345678              ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h87654321              ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h55555555              ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hAAAAAAAA              ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h00000000              ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hFFFFFFFF              ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h5A5A5A5A              ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'hA5A5A5A5              ),//(i)  [  32]

        .DEBUG_DO0                      (                           ),//(o)  [  32]
        .DEBUG_DO1                      (                           ),//(o)  [  32]
        .DEBUG_DO2                      (                           ),//(o)  [  32]
        .DEBUG_DO3                      (                           ),//(o)  [  32]
        .DEBUG_DO4                      (                           ),//(o)  [  32]
        .DEBUG_DO5                      (                           ),//(o)  [  32]
        .DEBUG_DO6                      (                           ),//(o)  [  32]
        .DEBUG_DO7                      (                           ),//(o)  [  32]

        .DEBUG_TRIG0                    (                           ),//(o)  [   1]
        .DEBUG_TRIG1                    (                           ),//(o)  [   1]
        .DEBUG_TRIG2                    (                           ),//(o)  [   1]
        .DEBUG_TRIG3                    (                           ),//(o)  [   1]
        .DEBUG_TRIG4                    (                           ),//(o)  [   1]
        .DEBUG_TRIG5                    (                           ),//(o)  [   1]
        .DEBUG_TRIG6                    (                           ),//(o)  [   1]
        .DEBUG_TRIG7                    (                           ) //(o)  [   1]
        );

    REG_BIST U_REG_BIST_6 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [   1]
        .RST                            ( RST                       ),//(i)  [   1]
        //register if
        .REG_WR_REQ                     ( REG6_WR_REQ               ),//(i)  [   1]
        .REG_RD_REQ                     ( REG6_RD_REQ               ),//(i)  [   1]
        .REG_WR_ACK                     ( REG6_WR_ACK               ),//(o)  [   1]
        .REG_RD_ACK                     ( REG6_RD_ACK               ),//(o)  [   1]
        .REG_WR_DATA                    ( REG6_WR_DATA              ),//(i)  [  32]
        .REG_RD_DATA                    ( REG6_RD_DATA              ),//(o)  [  32]
        .REG_OP_ADDR                    ( REG6_OP_ADDR              ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'h12345678              ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h87654321              ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h55555555              ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hAAAAAAAA              ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h00000000              ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hFFFFFFFF              ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h5A5A5A5A              ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'hA5A5A5A5              ),//(i)  [  32]

        .DEBUG_DO0                      (                           ),//(o)  [  32]
        .DEBUG_DO1                      (                           ),//(o)  [  32]
        .DEBUG_DO2                      (                           ),//(o)  [  32]
        .DEBUG_DO3                      (                           ),//(o)  [  32]
        .DEBUG_DO4                      (                           ),//(o)  [  32]
        .DEBUG_DO5                      (                           ),//(o)  [  32]
        .DEBUG_DO6                      (                           ),//(o)  [  32]
        .DEBUG_DO7                      (                           ),//(o)  [  32]

        .DEBUG_TRIG0                    (                           ),//(o)  [   1]
        .DEBUG_TRIG1                    (                           ),//(o)  [   1]
        .DEBUG_TRIG2                    (                           ),//(o)  [   1]
        .DEBUG_TRIG3                    (                           ),//(o)  [   1]
        .DEBUG_TRIG4                    (                           ),//(o)  [   1]
        .DEBUG_TRIG5                    (                           ),//(o)  [   1]
        .DEBUG_TRIG6                    (                           ),//(o)  [   1]
        .DEBUG_TRIG7                    (                           ) //(o)  [   1]
        );

    REG_BIST U_REG_BIST_7 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [   1]
        .RST                            ( RST                       ),//(i)  [   1]
        //register if
        .REG_WR_REQ                     ( REG7_WR_REQ               ),//(i)  [   1]
        .REG_RD_REQ                     ( REG7_RD_REQ               ),//(i)  [   1]
        .REG_WR_ACK                     ( REG7_WR_ACK               ),//(o)  [   1]
        .REG_RD_ACK                     ( REG7_RD_ACK               ),//(o)  [   1]
        .REG_WR_DATA                    ( REG7_WR_DATA              ),//(i)  [  32]
        .REG_RD_DATA                    ( REG7_RD_DATA              ),//(o)  [  32]
        .REG_OP_ADDR                    ( REG7_OP_ADDR              ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'h12345678              ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h87654321              ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h55555555              ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hAAAAAAAA              ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h00000000              ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hFFFFFFFF              ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h5A5A5A5A              ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'hA5A5A5A5              ),//(i)  [  32]

        .DEBUG_DO0                      (                           ),//(o)  [  32]
        .DEBUG_DO1                      (                           ),//(o)  [  32]
        .DEBUG_DO2                      (                           ),//(o)  [  32]
        .DEBUG_DO3                      (                           ),//(o)  [  32]
        .DEBUG_DO4                      (                           ),//(o)  [  32]
        .DEBUG_DO5                      (                           ),//(o)  [  32]
        .DEBUG_DO6                      (                           ),//(o)  [  32]
        .DEBUG_DO7                      (                           ),//(o)  [  32]

        .DEBUG_TRIG0                    (                           ),//(o)  [   1]
        .DEBUG_TRIG1                    (                           ),//(o)  [   1]
        .DEBUG_TRIG2                    (                           ),//(o)  [   1]
        .DEBUG_TRIG3                    (                           ),//(o)  [   1]
        .DEBUG_TRIG4                    (                           ),//(o)  [   1]
        .DEBUG_TRIG5                    (                           ),//(o)  [   1]
        .DEBUG_TRIG6                    (                           ),//(o)  [   1]
        .DEBUG_TRIG7                    (                           ) //(o)  [   1]
        );

/*=============================================================================+/
||                                                                             ||
||                                BRAM Sim                                     ||
||                                                                             ||
/+=============================================================================*/

    BRAM_BIST U_BRAM_BIST0 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .BRAM_WR_REQ                    ( BRAM0_WR_REQ              ),//(i)  [  1]  BRAM write request
        .BRAM_WR_ADDR                   ( BRAM0_WR_ADDR             ),//(i)  [ 16]  BRAM write address
        .BRAM_WR_DATA                   ( BRAM0_WR_DATA             ),//(i)  [ 32]  BRAM write data
        .BRAM_WR_ACK                    ( BRAM0_WR_ACK              ),//(o)  [  1]  BRAM write acknowledge
        .BRAM_RD_REQ                    ( BRAM0_RD_REQ              ),//(i)  [  1]  BRAM read request
        .BRAM_RD_ADDR                   ( BRAM0_RD_ADDR             ),//(i)  [ 16]  BRAM read address
        .BRAM_RD_DATA                   ( BRAM0_RD_DATA             ),//(o)  [ 32]  BRAM read data
        .BRAM_RD_ACK                    ( BRAM0_RD_ACK              ) //(o)  [  1]  BRAM read acknowledge
        );

    BRAM_BIST U_BRAM_BIST1 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .BRAM_WR_REQ                    ( BRAM1_WR_REQ              ),//(i)  [  1]  BRAM write request
        .BRAM_WR_ADDR                   ( BRAM1_WR_ADDR             ),//(i)  [ 16]  BRAM write address
        .BRAM_WR_DATA                   ( BRAM1_WR_DATA             ),//(i)  [ 32]  BRAM write data
        .BRAM_WR_ACK                    ( BRAM1_WR_ACK              ),//(o)  [  1]  BRAM write acknowledge
        .BRAM_RD_REQ                    ( BRAM1_RD_REQ              ),//(i)  [  1]  BRAM read request
        .BRAM_RD_ADDR                   ( BRAM1_RD_ADDR             ),//(i)  [ 16]  BRAM read address
        .BRAM_RD_DATA                   ( BRAM1_RD_DATA             ),//(o)  [ 32]  BRAM read data
        .BRAM_RD_ACK                    ( BRAM1_RD_ACK              ) //(o)  [  1]  BRAM read acknowledge
        );

    BRAM_BIST U_BRAM_BIST2 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .BRAM_WR_REQ                    ( BRAM2_WR_REQ              ),//(i)  [  1]  BRAM write request
        .BRAM_WR_ADDR                   ( BRAM2_WR_ADDR             ),//(i)  [ 16]  BRAM write address
        .BRAM_WR_DATA                   ( BRAM2_WR_DATA             ),//(i)  [ 32]  BRAM write data
        .BRAM_WR_ACK                    ( BRAM2_WR_ACK              ),//(o)  [  1]  BRAM write acknowledge
        .BRAM_RD_REQ                    ( BRAM2_RD_REQ              ),//(i)  [  1]  BRAM read request
        .BRAM_RD_ADDR                   ( BRAM2_RD_ADDR             ),//(i)  [ 16]  BRAM read address
        .BRAM_RD_DATA                   ( BRAM2_RD_DATA             ),//(o)  [ 32]  BRAM read data
        .BRAM_RD_ACK                    ( BRAM2_RD_ACK              ) //(o)  [  1]  BRAM read acknowledge
        );

    BRAM_BIST U_BRAM_BIST3 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .BRAM_WR_REQ                    ( BRAM3_WR_REQ              ),//(i)  [  1]  BRAM write request
        .BRAM_WR_ADDR                   ( BRAM3_WR_ADDR             ),//(i)  [ 16]  BRAM write address
        .BRAM_WR_DATA                   ( BRAM3_WR_DATA             ),//(i)  [ 32]  BRAM write data
        .BRAM_WR_ACK                    ( BRAM3_WR_ACK              ),//(o)  [  1]  BRAM write acknowledge
        .BRAM_RD_REQ                    ( BRAM3_RD_REQ              ),//(i)  [  1]  BRAM read request
        .BRAM_RD_ADDR                   ( BRAM3_RD_ADDR             ),//(i)  [ 16]  BRAM read address
        .BRAM_RD_DATA                   ( BRAM3_RD_DATA             ),//(o)  [ 32]  BRAM read data
        .BRAM_RD_ACK                    ( BRAM3_RD_ACK              ) //(o)  [  1]  BRAM read acknowledge
        );

    BRAM_BIST U_BRAM_BIST4 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .BRAM_WR_REQ                    ( BRAM4_WR_REQ              ),//(i)  [  1]  BRAM write request
        .BRAM_WR_ADDR                   ( BRAM4_WR_ADDR             ),//(i)  [ 16]  BRAM write address
        .BRAM_WR_DATA                   ( BRAM4_WR_DATA             ),//(i)  [ 32]  BRAM write data
        .BRAM_WR_ACK                    ( BRAM4_WR_ACK              ),//(o)  [  1]  BRAM write acknowledge
        .BRAM_RD_REQ                    ( BRAM4_RD_REQ              ),//(i)  [  1]  BRAM read request
        .BRAM_RD_ADDR                   ( BRAM4_RD_ADDR             ),//(i)  [ 16]  BRAM read address
        .BRAM_RD_DATA                   ( BRAM4_RD_DATA             ),//(o)  [ 32]  BRAM read data
        .BRAM_RD_ACK                    ( BRAM4_RD_ACK              ) //(o)  [  1]  BRAM read acknowledge
        );

    BRAM_BIST U_BRAM_BIST5 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .BRAM_WR_REQ                    ( BRAM5_WR_REQ              ),//(i)  [  1]  BRAM write request
        .BRAM_WR_ADDR                   ( BRAM5_WR_ADDR             ),//(i)  [ 16]  BRAM write address
        .BRAM_WR_DATA                   ( BRAM5_WR_DATA             ),//(i)  [ 32]  BRAM write data
        .BRAM_WR_ACK                    ( BRAM5_WR_ACK              ),//(o)  [  1]  BRAM write acknowledge
        .BRAM_RD_REQ                    ( BRAM5_RD_REQ              ),//(i)  [  1]  BRAM read request
        .BRAM_RD_ADDR                   ( BRAM5_RD_ADDR             ),//(i)  [ 16]  BRAM read address
        .BRAM_RD_DATA                   ( BRAM5_RD_DATA             ),//(o)  [ 32]  BRAM read data
        .BRAM_RD_ACK                    ( BRAM5_RD_ACK              ) //(o)  [  1]  BRAM read acknowledge
        );

    BRAM_BIST U_BRAM_BIST6 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .BRAM_WR_REQ                    ( BRAM6_WR_REQ              ),//(i)  [  1]  BRAM write request
        .BRAM_WR_ADDR                   ( BRAM6_WR_ADDR             ),//(i)  [ 16]  BRAM write address
        .BRAM_WR_DATA                   ( BRAM6_WR_DATA             ),//(i)  [ 32]  BRAM write data
        .BRAM_WR_ACK                    ( BRAM6_WR_ACK              ),//(o)  [  1]  BRAM write acknowledge
        .BRAM_RD_REQ                    ( BRAM6_RD_REQ              ),//(i)  [  1]  BRAM read request
        .BRAM_RD_ADDR                   ( BRAM6_RD_ADDR             ),//(i)  [ 16]  BRAM read address
        .BRAM_RD_DATA                   ( BRAM6_RD_DATA             ),//(o)  [ 32]  BRAM read data
        .BRAM_RD_ACK                    ( BRAM6_RD_ACK              ) //(o)  [  1]  BRAM read acknowledge
        );

    BRAM_BIST U_BRAM_BIST7 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .BRAM_WR_REQ                    ( BRAM7_WR_REQ              ),//(i)  [  1]  BRAM write request
        .BRAM_WR_ADDR                   ( BRAM7_WR_ADDR             ),//(i)  [ 16]  BRAM write address
        .BRAM_WR_DATA                   ( BRAM7_WR_DATA             ),//(i)  [ 32]  BRAM write data
        .BRAM_WR_ACK                    ( BRAM7_WR_ACK              ),//(o)  [  1]  BRAM write acknowledge
        .BRAM_RD_REQ                    ( BRAM7_RD_REQ              ),//(i)  [  1]  BRAM read request
        .BRAM_RD_ADDR                   ( BRAM7_RD_ADDR             ),//(i)  [ 16]  BRAM read address
        .BRAM_RD_DATA                   ( BRAM7_RD_DATA             ),//(o)  [ 32]  BRAM read data
        .BRAM_RD_ACK                    ( BRAM7_RD_ACK              ) //(o)  [  1]  BRAM read acknowledge
        );

/*=============================================================================+/
||                                                                             ||
||                                DRAM Sim                                     ||
||                                                                             ||
/+=============================================================================*/

    DRAM_BIST DRAM_BIST0 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .DRAM_WR_RDY                    ( DRAM0_WR_RDY              ),//(o)  [  1]  SDRAM write ready
        .DRAM_WR_REQ                    ( DRAM0_WR_REQ              ),//(i)  [  1]  SDRAM write request
        .DRAM_WR_ACK                    ( DRAM0_WR_ACK              ),//(o)  [  1]  SDRAM write acknowledge
        .DRAM_WR_ADDR                   ( DRAM0_WR_ADDR             ),//(i)  [ 25]  SDRAM write address
        .DRAM_WR_SIZE                   ( DRAM0_WR_SIZE             ),//(i)  [ 12]  SDRAM write size
        .DRAM_WR_SOP                    ( DRAM0_WR_SOP              ),//(i)  [  1]  SDRAM write start of packet
        .DRAM_WR_EOP                    ( DRAM0_WR_EOP              ),//(i)  [  1]  SDRAM write end of packet
        .DRAM_WR_DVLD                   ( DRAM0_WR_DVLD             ),//(i)  [  1]  SDRAM write data valid
        .DRAM_WR_DATA                   ( DRAM0_WR_DATA             ),//(i)  [ 32]  SDRAM write data

        .DRAM_RD_RDY                    ( DRAM0_RD_RDY              ),//(i)  [  1]  SDRAM read ready
        .DRAM_RD_REQ                    ( DRAM0_RD_REQ              ),//(i)  [  1]  SDRAM read request
        .DRAM_RD_ACK                    ( DRAM0_RD_ACK              ),//(o)  [  1]  SDRAM read acknowledge
        .DRAM_RD_ADDR                   ( DRAM0_RD_ADDR             ),//(i)  [ 25]  SDRAM read address
        .DRAM_RD_SIZE                   ( DRAM0_RD_SIZE             ),//(i)  [ 12]  SDRAM read size
        .DRAM_RD_SOP                    ( DRAM0_RD_SOP              ),//(o)  [  1]  SDRAM read start of packet
        .DRAM_RD_EOP                    ( DRAM0_RD_EOP              ),//(o)  [  1]  SDRAM read end of packet
        .DRAM_RD_DVLD                   ( DRAM0_RD_DVLD             ),//(o)  [  1]  SDRAM read data valid
        .DRAM_RD_DATA                   ( DRAM0_RD_DATA             ) //(o)  [ 32]  SDRAM read data
        );

    DRAM_BIST DRAM_BIST1 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .DRAM_WR_RDY                    ( DRAM1_WR_RDY              ),//(o)  [  1]  SDRAM write ready
        .DRAM_WR_REQ                    ( DRAM1_WR_REQ              ),//(i)  [  1]  SDRAM write request
        .DRAM_WR_ACK                    ( DRAM1_WR_ACK              ),//(o)  [  1]  SDRAM write acknowledge
        .DRAM_WR_ADDR                   ( DRAM1_WR_ADDR             ),//(i)  [ 25]  SDRAM write address
        .DRAM_WR_SIZE                   ( DRAM1_WR_SIZE             ),//(i)  [ 12]  SDRAM write size
        .DRAM_WR_SOP                    ( DRAM1_WR_SOP              ),//(i)  [  1]  SDRAM write start of packet
        .DRAM_WR_EOP                    ( DRAM1_WR_EOP              ),//(i)  [  1]  SDRAM write end of packet
        .DRAM_WR_DVLD                   ( DRAM1_WR_DVLD             ),//(i)  [  1]  SDRAM write data valid
        .DRAM_WR_DATA                   ( DRAM1_WR_DATA             ),//(i)  [ 32]  SDRAM write data

        .DRAM_RD_RDY                    ( DRAM1_RD_RDY              ),//(i)  [  1]  SDRAM read ready
        .DRAM_RD_REQ                    ( DRAM1_RD_REQ              ),//(i)  [  1]  SDRAM read request
        .DRAM_RD_ACK                    ( DRAM1_RD_ACK              ),//(o)  [  1]  SDRAM read acknowledge
        .DRAM_RD_ADDR                   ( DRAM1_RD_ADDR             ),//(i)  [ 25]  SDRAM read address
        .DRAM_RD_SIZE                   ( DRAM1_RD_SIZE             ),//(i)  [ 12]  SDRAM read size
        .DRAM_RD_SOP                    ( DRAM1_RD_SOP              ),//(o)  [  1]  SDRAM read start of packet
        .DRAM_RD_EOP                    ( DRAM1_RD_EOP              ),//(o)  [  1]  SDRAM read end of packet
        .DRAM_RD_DVLD                   ( DRAM1_RD_DVLD             ),//(o)  [  1]  SDRAM read data valid
        .DRAM_RD_DATA                   ( DRAM1_RD_DATA             ) //(o)  [ 32]  SDRAM read data
        );


    DRAM_BIST DRAM_BIST2 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .DRAM_WR_RDY                    ( DRAM2_WR_RDY              ),//(o)  [  1]  SDRAM write ready
        .DRAM_WR_REQ                    ( DRAM2_WR_REQ              ),//(i)  [  1]  SDRAM write request
        .DRAM_WR_ACK                    ( DRAM2_WR_ACK              ),//(o)  [  1]  SDRAM write acknowledge
        .DRAM_WR_ADDR                   ( DRAM2_WR_ADDR             ),//(i)  [ 25]  SDRAM write address
        .DRAM_WR_SIZE                   ( DRAM2_WR_SIZE             ),//(i)  [ 12]  SDRAM write size
        .DRAM_WR_SOP                    ( DRAM2_WR_SOP              ),//(i)  [  1]  SDRAM write start of packet
        .DRAM_WR_EOP                    ( DRAM2_WR_EOP              ),//(i)  [  1]  SDRAM write end of packet
        .DRAM_WR_DVLD                   ( DRAM2_WR_DVLD             ),//(i)  [  1]  SDRAM write data valid
        .DRAM_WR_DATA                   ( DRAM2_WR_DATA             ),//(i)  [ 32]  SDRAM write data

        .DRAM_RD_RDY                    ( DRAM2_RD_RDY              ),//(i)  [  1]  SDRAM read ready
        .DRAM_RD_REQ                    ( DRAM2_RD_REQ              ),//(i)  [  1]  SDRAM read request
        .DRAM_RD_ACK                    ( DRAM2_RD_ACK              ),//(o)  [  1]  SDRAM read acknowledge
        .DRAM_RD_ADDR                   ( DRAM2_RD_ADDR             ),//(i)  [ 25]  SDRAM read address
        .DRAM_RD_SIZE                   ( DRAM2_RD_SIZE             ),//(i)  [ 12]  SDRAM read size
        .DRAM_RD_SOP                    ( DRAM2_RD_SOP              ),//(o)  [  1]  SDRAM read start of packet
        .DRAM_RD_EOP                    ( DRAM2_RD_EOP              ),//(o)  [  1]  SDRAM read end of packet
        .DRAM_RD_DVLD                   ( DRAM2_RD_DVLD             ),//(o)  [  1]  SDRAM read data valid
        .DRAM_RD_DATA                   ( DRAM2_RD_DATA             ) //(o)  [ 32]  SDRAM read data
        );


    DRAM_BIST DRAM_BIST3 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .DRAM_WR_RDY                    ( DRAM3_WR_RDY              ),//(o)  [  1]  SDRAM write ready
        .DRAM_WR_REQ                    ( DRAM3_WR_REQ              ),//(i)  [  1]  SDRAM write request
        .DRAM_WR_ACK                    ( DRAM3_WR_ACK              ),//(o)  [  1]  SDRAM write acknowledge
        .DRAM_WR_ADDR                   ( DRAM3_WR_ADDR             ),//(i)  [ 25]  SDRAM write address
        .DRAM_WR_SIZE                   ( DRAM3_WR_SIZE             ),//(i)  [ 12]  SDRAM write size
        .DRAM_WR_SOP                    ( DRAM3_WR_SOP              ),//(i)  [  1]  SDRAM write start of packet
        .DRAM_WR_EOP                    ( DRAM3_WR_EOP              ),//(i)  [  1]  SDRAM write end of packet
        .DRAM_WR_DVLD                   ( DRAM3_WR_DVLD             ),//(i)  [  1]  SDRAM write data valid
        .DRAM_WR_DATA                   ( DRAM3_WR_DATA             ),//(i)  [ 32]  SDRAM write data

        .DRAM_RD_RDY                    ( DRAM3_RD_RDY              ),//(i)  [  1]  SDRAM read ready
        .DRAM_RD_REQ                    ( DRAM3_RD_REQ              ),//(i)  [  1]  SDRAM read request
        .DRAM_RD_ACK                    ( DRAM3_RD_ACK              ),//(o)  [  1]  SDRAM read acknowledge
        .DRAM_RD_ADDR                   ( DRAM3_RD_ADDR             ),//(i)  [ 25]  SDRAM read address
        .DRAM_RD_SIZE                   ( DRAM3_RD_SIZE             ),//(i)  [ 12]  SDRAM read size
        .DRAM_RD_SOP                    ( DRAM3_RD_SOP              ),//(o)  [  1]  SDRAM read start of packet
        .DRAM_RD_EOP                    ( DRAM3_RD_EOP              ),//(o)  [  1]  SDRAM read end of packet
        .DRAM_RD_DVLD                   ( DRAM3_RD_DVLD             ),//(o)  [  1]  SDRAM read data valid
        .DRAM_RD_DATA                   ( DRAM3_RD_DATA             ) //(o)  [ 32]  SDRAM read data
        );


    DRAM_BIST DRAM_BIST4 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .DRAM_WR_RDY                    ( DRAM4_WR_RDY              ),//(o)  [  1]  SDRAM write ready
        .DRAM_WR_REQ                    ( DRAM4_WR_REQ              ),//(i)  [  1]  SDRAM write request
        .DRAM_WR_ACK                    ( DRAM4_WR_ACK              ),//(o)  [  1]  SDRAM write acknowledge
        .DRAM_WR_ADDR                   ( DRAM4_WR_ADDR             ),//(i)  [ 25]  SDRAM write address
        .DRAM_WR_SIZE                   ( DRAM4_WR_SIZE             ),//(i)  [ 12]  SDRAM write size
        .DRAM_WR_SOP                    ( DRAM4_WR_SOP              ),//(i)  [  1]  SDRAM write start of packet
        .DRAM_WR_EOP                    ( DRAM4_WR_EOP              ),//(i)  [  1]  SDRAM write end of packet
        .DRAM_WR_DVLD                   ( DRAM4_WR_DVLD             ),//(i)  [  1]  SDRAM write data valid
        .DRAM_WR_DATA                   ( DRAM4_WR_DATA             ),//(i)  [ 32]  SDRAM write data

        .DRAM_RD_RDY                    ( DRAM4_RD_RDY              ),//(i)  [  1]  SDRAM read ready
        .DRAM_RD_REQ                    ( DRAM4_RD_REQ              ),//(i)  [  1]  SDRAM read request
        .DRAM_RD_ACK                    ( DRAM4_RD_ACK              ),//(o)  [  1]  SDRAM read acknowledge
        .DRAM_RD_ADDR                   ( DRAM4_RD_ADDR             ),//(i)  [ 25]  SDRAM read address
        .DRAM_RD_SIZE                   ( DRAM4_RD_SIZE             ),//(i)  [ 12]  SDRAM read size
        .DRAM_RD_SOP                    ( DRAM4_RD_SOP              ),//(o)  [  1]  SDRAM read start of packet
        .DRAM_RD_EOP                    ( DRAM4_RD_EOP              ),//(o)  [  1]  SDRAM read end of packet
        .DRAM_RD_DVLD                   ( DRAM4_RD_DVLD             ),//(o)  [  1]  SDRAM read data valid
        .DRAM_RD_DATA                   ( DRAM4_RD_DATA             ) //(o)  [ 32]  SDRAM read data
        );


    DRAM_BIST DRAM_BIST5 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .DRAM_WR_RDY                    ( DRAM5_WR_RDY              ),//(o)  [  1]  SDRAM write ready
        .DRAM_WR_REQ                    ( DRAM5_WR_REQ              ),//(i)  [  1]  SDRAM write request
        .DRAM_WR_ACK                    ( DRAM5_WR_ACK              ),//(o)  [  1]  SDRAM write acknowledge
        .DRAM_WR_ADDR                   ( DRAM5_WR_ADDR             ),//(i)  [ 25]  SDRAM write address
        .DRAM_WR_SIZE                   ( DRAM5_WR_SIZE             ),//(i)  [ 12]  SDRAM write size
        .DRAM_WR_SOP                    ( DRAM5_WR_SOP              ),//(i)  [  1]  SDRAM write start of packet
        .DRAM_WR_EOP                    ( DRAM5_WR_EOP              ),//(i)  [  1]  SDRAM write end of packet
        .DRAM_WR_DVLD                   ( DRAM5_WR_DVLD             ),//(i)  [  1]  SDRAM write data valid
        .DRAM_WR_DATA                   ( DRAM5_WR_DATA             ),//(i)  [ 32]  SDRAM write data

        .DRAM_RD_RDY                    ( DRAM5_RD_RDY              ),//(i)  [  1]  SDRAM read ready
        .DRAM_RD_REQ                    ( DRAM5_RD_REQ              ),//(i)  [  1]  SDRAM read request
        .DRAM_RD_ACK                    ( DRAM5_RD_ACK              ),//(o)  [  1]  SDRAM read acknowledge
        .DRAM_RD_ADDR                   ( DRAM5_RD_ADDR             ),//(i)  [ 25]  SDRAM read address
        .DRAM_RD_SIZE                   ( DRAM5_RD_SIZE             ),//(i)  [ 12]  SDRAM read size
        .DRAM_RD_SOP                    ( DRAM5_RD_SOP              ),//(o)  [  1]  SDRAM read start of packet
        .DRAM_RD_EOP                    ( DRAM5_RD_EOP              ),//(o)  [  1]  SDRAM read end of packet
        .DRAM_RD_DVLD                   ( DRAM5_RD_DVLD             ),//(o)  [  1]  SDRAM read data valid
        .DRAM_RD_DATA                   ( DRAM5_RD_DATA             ) //(o)  [ 32]  SDRAM read data
        );

    DRAM_BIST DRAM_BIST6 (
        //system signals
        .CLK                            ( CLK                       ),//(i)  [  1]
        .RST                            ( RST                       ),//(i)  [  1]

        .DRAM_WR_RDY                    ( DRAM6_WR_RDY              ),//(o)  [  1]  SDRAM write ready
        .DRAM_WR_REQ                    ( DRAM6_WR_REQ              ),//(i)  [  1]  SDRAM write request
        .DRAM_WR_ACK                    ( DRAM6_WR_ACK              ),//(o)  [  1]  SDRAM write acknowledge
        .DRAM_WR_ADDR                   ( DRAM6_WR_ADDR             ),//(i)  [ 25]  SDRAM write address
        .DRAM_WR_SIZE                   ( DRAM6_WR_SIZE             ),//(i)  [ 12]  SDRAM write size
        .DRAM_WR_SOP                    ( DRAM6_WR_SOP              ),//(i)  [  1]  SDRAM write start of packet
        .DRAM_WR_EOP                    ( DRAM6_WR_EOP              ),//(i)  [  1]  SDRAM write end of packet
        .DRAM_WR_DVLD                   ( DRAM6_WR_DVLD             ),//(i)  [  1]  SDRAM write data valid
        .DRAM_WR_DATA                   ( DRAM6_WR_DATA             ),//(i)  [ 32]  SDRAM write data

        .DRAM_RD_RDY                    ( DRAM6_RD_RDY              ),//(i)  [  1]  SDRAM read ready
        .DRAM_RD_REQ                    ( DRAM6_RD_REQ              ),//(i)  [  1]  SDRAM read request
        .DRAM_RD_ACK                    ( DRAM6_RD_ACK              ),//(o)  [  1]  SDRAM read acknowledge
        .DRAM_RD_ADDR                   ( DRAM6_RD_ADDR             ),//(i)  [ 25]  SDRAM read address
        .DRAM_RD_SIZE                   ( DRAM6_RD_SIZE             ),//(i)  [ 12]  SDRAM read size
        .DRAM_RD_SOP                    ( DRAM6_RD_SOP              ),//(o)  [  1]  SDRAM read start of packet
        .DRAM_RD_EOP                    ( DRAM6_RD_EOP              ),//(o)  [  1]  SDRAM read end of packet
        .DRAM_RD_DVLD                   ( DRAM6_RD_DVLD             ),//(o)  [  1]  SDRAM read data valid
        .DRAM_RD_DATA                   ( DRAM6_RD_DATA             ) //(o)  [ 32]  SDRAM read data
        );

endmodule