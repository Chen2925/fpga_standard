// =================================================================================================
// File Name    : tb_top.v
// Entity       : TB_TOP
// =================================================================================================
// Function     : behave simulation
// -------------------------------------------------------------------------------------------------
// Updata History:
// -------------------------------------------------------------------------------------------------
// REV.Level    Date        Coded-by        Contents
// v0.1.0       2012/06/28  xxxxxx          Create New
// -------------------------------------------------------------------------------------------------
// End Revision
// =================================================================================================

   `include   "sim_model/define/define.v"
   `timescale 1ps/1ps

module tb_top ;

// ==============================================================================
// Internal Parameter Declare
// ==============================================================================

    parameter                           p_GND       = {256{1'b0}}               ;
    parameter                           p_PWR       = {256{1'b1}}               ;

// =============================================================================
// Internal Signal Declare
// =============================================================================

    wire                                s_CLK0_P                                ;//(s)  [  1]  Systerm clock 0 P
    wire                                s_CLK0_N                                ;//(s)  [  1]  Systerm clock 0 N
    wire                                s_CLK1_P                                ;//(s)  [  1]  Systerm clock 1 P
    wire                                s_CLK1_N                                ;//(s)  [  1]  Systerm clock 1 N
    wire                                s_CLK2_P                                ;//(s)  [  1]  Systerm clock 2 P
    wire                                s_CLK2_N                                ;//(s)  [  1]  Systerm clock 2 N
    wire                                s_CLK3_P                                ;//(s)  [  1]  Systerm clock 3 P
    wire                                s_CLK3_N                                ;//(s)  [  1]  Systerm clock 3 N

    wire                                s_XRST0                                 ;//(s)  [  1]  Reset 0 (low active)
    wire                                s_XRST1                                 ;//(s)  [  1]  Reset 1 (low active)
    wire                                s_XRST2                                 ;//(s)  [  1]  Reset 2 (low active)
    wire                                s_XRST3                                 ;//(s)  [  1]  Reset 3 (low active)

    wire        [   7:0]                s_DIP_SW                                ;//(s)  [  8]  Dipswitch
    wire        [   7:0]                s_PSH_SW                                ;//(s)  [  8]  Pushswitch  (low active)

    wire        [   7:0]                s_TRIG_TX_P                             ;//(s)  [  8]  Trig TX
    wire        [   7:0]                s_TRIG_TX_N                             ;//(s)  [  8]  Trig TX

    //Local bus interface
    wire                                s_LBUS_CS                               ;//(s)  [  1]  Local bus select
    wire                                s_LBUS_RD                               ;//(s)  [  1]  Local bus read
    wire                                s_LBUS_WR                               ;//(s)  [  1]  Local bus write
    wire        [  12:0]                s_LBUS_ADDR                             ;//(s)  [ 13]  Local bus address
    wire        [  31:0]                s_LBUS_DATA                             ;//(s)  [ 32]  Local bus data

    //backplane
    wire                                s_SOFT_START                            ;//(s)  [  1]  Softwart start
    wire                                s_TOAL_START                            ;//(s)  [  1]  Total start
    wire                                s_FAIL_O                                ;//(s)  [  1]  Fail output

    //register I/F
    wire                                s_REG0_WR_REQ                           ;//(s)  [  1]  Register write request
    wire                                s_REG0_WR_ACK                           ;//(s)  [  1]  Register write acknowledge
    wire        [  31:0]                s_REG0_WR_DATA                          ;//(s)  [ 32]  Register write data
    wire                                s_REG0_RD_REQ                           ;//(s)  [  1]  Register read request
    wire                                s_REG0_RD_ACK                           ;//(s)  [  1]  Register read acknowledge
    wire        [  31:0]                s_REG0_RD_DATA                          ;//(s)  [ 32]  Register read data
    wire        [   9:0]                s_REG0_OP_ADDR                          ;//(s)  [ 10]  Register operation address

    wire                                s_REG1_WR_REQ                           ;//(s)  [  1]  Register write request
    wire                                s_REG1_WR_ACK                           ;//(s)  [  1]  Register write acknowledge
    wire        [  31:0]                s_REG1_WR_DATA                          ;//(s)  [ 32]  Register write data
    wire                                s_REG1_RD_REQ                           ;//(s)  [  1]  Register read request
    wire                                s_REG1_RD_ACK                           ;//(s)  [  1]  Register read acknowledge
    wire        [  31:0]                s_REG1_RD_DATA                          ;//(s)  [ 32]  Register read data
    wire        [   9:0]                s_REG1_OP_ADDR                          ;//(s)  [ 10]  Register operation address

    wire                                s_REG2_WR_REQ                           ;//(s)  [  1]  Register write request
    wire                                s_REG2_WR_ACK                           ;//(s)  [  1]  Register write acknowledge
    wire        [  31:0]                s_REG2_WR_DATA                          ;//(s)  [ 32]  Register write data
    wire                                s_REG2_RD_REQ                           ;//(s)  [  1]  Register read request
    wire                                s_REG2_RD_ACK                           ;//(s)  [  1]  Register read acknowledge
    wire        [  31:0]                s_REG2_RD_DATA                          ;//(s)  [ 32]  Register read data
    wire        [   9:0]                s_REG2_OP_ADDR                          ;//(s)  [ 10]  Register operation address

    wire                                s_REG3_WR_REQ                           ;//(s)  [  1]  Register write request
    wire                                s_REG3_WR_ACK                           ;//(s)  [  1]  Register write acknowledge
    wire        [  31:0]                s_REG3_WR_DATA                          ;//(s)  [ 32]  Register write data
    wire                                s_REG3_RD_REQ                           ;//(s)  [  1]  Register read request
    wire                                s_REG3_RD_ACK                           ;//(s)  [  1]  Register read acknowledge
    wire        [  31:0]                s_REG3_RD_DATA                          ;//(s)  [ 32]  Register read data
    wire        [   9:0]                s_REG3_OP_ADDR                          ;//(s)  [ 10]  Register operation address

    wire                                s_REG4_WR_REQ                           ;//(s)  [  1]  Register write request
    wire                                s_REG4_WR_ACK                           ;//(s)  [  1]  Register write acknowledge
    wire        [  31:0]                s_REG4_WR_DATA                          ;//(s)  [ 32]  Register write data
    wire                                s_REG4_RD_REQ                           ;//(s)  [  1]  Register read request
    wire                                s_REG4_RD_ACK                           ;//(s)  [  1]  Register read acknowledge
    wire        [  31:0]                s_REG4_RD_DATA                          ;//(s)  [ 32]  Register read data
    wire        [   9:0]                s_REG4_OP_ADDR                          ;//(s)  [ 10]  Register operation address

    wire                                s_REG5_WR_REQ                           ;//(s)  [  1]  Register write request
    wire                                s_REG5_WR_ACK                           ;//(s)  [  1]  Register write acknowledge
    wire        [  31:0]                s_REG5_WR_DATA                          ;//(s)  [ 32]  Register write data
    wire                                s_REG5_RD_REQ                           ;//(s)  [  1]  Register read request
    wire                                s_REG5_RD_ACK                           ;//(s)  [  1]  Register read acknowledge
    wire        [  31:0]                s_REG5_RD_DATA                          ;//(s)  [ 32]  Register read data
    wire        [   9:0]                s_REG5_OP_ADDR                          ;//(s)  [ 10]  Register operation address

    wire                                s_REG6_WR_REQ                           ;//(s)  [  1]  Register write request
    wire                                s_REG6_WR_ACK                           ;//(s)  [  1]  Register write acknowledge
    wire        [  31:0]                s_REG6_WR_DATA                          ;//(s)  [ 32]  Register write data
    wire                                s_REG6_RD_REQ                           ;//(s)  [  1]  Register read request
    wire                                s_REG6_RD_ACK                           ;//(s)  [  1]  Register read acknowledge
    wire        [  31:0]                s_REG6_RD_DATA                          ;//(s)  [ 32]  Register read data
    wire        [   9:0]                s_REG6_OP_ADDR                          ;//(s)  [ 10]  Register operation address

    wire                                s_REG7_WR_REQ                           ;//(s)  [  1]  Register write request
    wire                                s_REG7_WR_ACK                           ;//(s)  [  1]  Register write acknowledge
    wire        [  31:0]                s_REG7_WR_DATA                          ;//(s)  [ 32]  Register write data
    wire                                s_REG7_RD_REQ                           ;//(s)  [  1]  Register read request
    wire                                s_REG7_RD_ACK                           ;//(s)  [  1]  Register read acknowledge
    wire        [  31:0]                s_REG7_RD_DATA                          ;//(s)  [ 32]  Register read data
    wire        [   9:0]                s_REG7_OP_ADDR                          ;//(s)  [ 10]  Register operation address

    //bram I/F
    wire                                s_BRAM0_WR_REQ                          ;//(s)  [  1]  BRAM write request
    wire        [  15:0]                s_BRAM0_WR_ADDR                         ;//(s)  [ 16]  BRAM write address
    wire        [  31:0]                s_BRAM0_WR_DATA                         ;//(s)  [ 32]  BRAM write data
    wire                                s_BRAM0_WR_ACK                          ;//(s)  [  1]  BRAM write acknowledge
    wire                                s_BRAM0_RD_REQ                          ;//(s)  [  1]  BRAM read request
    wire        [  15:0]                s_BRAM0_RD_ADDR                         ;//(s)  [ 16]  BRAM read address
    wire        [  31:0]                s_BRAM0_RD_DATA                         ;//(s)  [ 32]  BRAM read data
    wire                                s_BRAM0_RD_ACK                          ;//(s)  [  1]  BRAM read acknowledge

    wire                                s_BRAM1_WR_REQ                          ;//(s)  [  1]  BRAM write request
    wire        [  15:0]                s_BRAM1_WR_ADDR                         ;//(s)  [ 16]  BRAM write address
    wire        [  31:0]                s_BRAM1_WR_DATA                         ;//(s)  [ 32]  BRAM write data
    wire                                s_BRAM1_WR_ACK                          ;//(s)  [  1]  BRAM write acknowledge
    wire                                s_BRAM1_RD_REQ                          ;//(s)  [  1]  BRAM read request
    wire        [  15:0]                s_BRAM1_RD_ADDR                         ;//(s)  [ 16]  BRAM read address
    wire        [  31:0]                s_BRAM1_RD_DATA                         ;//(s)  [ 32]  BRAM read data
    wire                                s_BRAM1_RD_ACK                          ;//(s)  [  1]  BRAM read acknowledge

    wire                                s_BRAM2_WR_REQ                          ;//(s)  [  1]  BRAM write request
    wire        [  15:0]                s_BRAM2_WR_ADDR                         ;//(s)  [ 16]  BRAM write address
    wire        [  31:0]                s_BRAM2_WR_DATA                         ;//(s)  [ 32]  BRAM write data
    wire                                s_BRAM2_WR_ACK                          ;//(s)  [  1]  BRAM write acknowledge
    wire                                s_BRAM2_RD_REQ                          ;//(s)  [  1]  BRAM read request
    wire        [  15:0]                s_BRAM2_RD_ADDR                         ;//(s)  [ 16]  BRAM read address
    wire        [  31:0]                s_BRAM2_RD_DATA                         ;//(s)  [ 32]  BRAM read data
    wire                                s_BRAM2_RD_ACK                          ;//(s)  [  1]  BRAM read acknowledge

    wire                                s_BRAM3_WR_REQ                          ;//(s)  [  1]  BRAM write request
    wire        [  15:0]                s_BRAM3_WR_ADDR                         ;//(s)  [ 16]  BRAM write address
    wire        [  31:0]                s_BRAM3_WR_DATA                         ;//(s)  [ 32]  BRAM write data
    wire                                s_BRAM3_WR_ACK                          ;//(s)  [  1]  BRAM write acknowledge
    wire                                s_BRAM3_RD_REQ                          ;//(s)  [  1]  BRAM read request
    wire        [  15:0]                s_BRAM3_RD_ADDR                         ;//(s)  [ 16]  BRAM read address
    wire        [  31:0]                s_BRAM3_RD_DATA                         ;//(s)  [ 32]  BRAM read data
    wire                                s_BRAM3_RD_ACK                          ;//(s)  [  1]  BRAM read acknowledge

    wire                                s_BRAM4_WR_REQ                          ;//(s)  [  1]  BRAM write request
    wire        [  15:0]                s_BRAM4_WR_ADDR                         ;//(s)  [ 16]  BRAM write address
    wire        [  31:0]                s_BRAM4_WR_DATA                         ;//(s)  [ 32]  BRAM write data
    wire                                s_BRAM4_WR_ACK                          ;//(s)  [  1]  BRAM write acknowledge
    wire                                s_BRAM4_RD_REQ                          ;//(s)  [  1]  BRAM read request
    wire        [  15:0]                s_BRAM4_RD_ADDR                         ;//(s)  [ 16]  BRAM read address
    wire        [  31:0]                s_BRAM4_RD_DATA                         ;//(s)  [ 32]  BRAM read data
    wire                                s_BRAM4_RD_ACK                          ;//(s)  [  1]  BRAM read acknowledge

    wire                                s_BRAM5_WR_REQ                          ;//(s)  [  1]  BRAM write request
    wire        [  15:0]                s_BRAM5_WR_ADDR                         ;//(s)  [ 16]  BRAM write address
    wire        [  31:0]                s_BRAM5_WR_DATA                         ;//(s)  [ 32]  BRAM write data
    wire                                s_BRAM5_WR_ACK                          ;//(s)  [  1]  BRAM write acknowledge
    wire                                s_BRAM5_RD_REQ                          ;//(s)  [  1]  BRAM read request
    wire        [  15:0]                s_BRAM5_RD_ADDR                         ;//(s)  [ 16]  BRAM read address
    wire        [  31:0]                s_BRAM5_RD_DATA                         ;//(s)  [ 32]  BRAM read data
    wire                                s_BRAM5_RD_ACK                          ;//(s)  [  1]  BRAM read acknowledge

    wire                                s_BRAM6_WR_REQ                          ;//(s)  [  1]  BRAM write request
    wire        [  15:0]                s_BRAM6_WR_ADDR                         ;//(s)  [ 16]  BRAM write address
    wire        [  31:0]                s_BRAM6_WR_DATA                         ;//(s)  [ 32]  BRAM write data
    wire                                s_BRAM6_WR_ACK                          ;//(s)  [  1]  BRAM write acknowledge
    wire                                s_BRAM6_RD_REQ                          ;//(s)  [  1]  BRAM read request
    wire        [  15:0]                s_BRAM6_RD_ADDR                         ;//(s)  [ 16]  BRAM read address
    wire        [  31:0]                s_BRAM6_RD_DATA                         ;//(s)  [ 32]  BRAM read data
    wire                                s_BRAM6_RD_ACK                          ;//(s)  [  1]  BRAM read acknowledge

    wire                                s_BRAM7_WR_REQ                          ;//(s)  [  1]  BRAM write request
    wire        [  15:0]                s_BRAM7_WR_ADDR                         ;//(s)  [ 16]  BRAM write address
    wire        [  31:0]                s_BRAM7_WR_DATA                         ;//(s)  [ 32]  BRAM write data
    wire                                s_BRAM7_WR_ACK                          ;//(s)  [  1]  BRAM write acknowledge
    wire                                s_BRAM7_RD_REQ                          ;//(s)  [  1]  BRAM read request
    wire        [  15:0]                s_BRAM7_RD_ADDR                         ;//(s)  [ 16]  BRAM read address
    wire        [  31:0]                s_BRAM7_RD_DATA                         ;//(s)  [ 32]  BRAM read data
    wire                                s_BRAM7_RD_ACK                          ;//(s)  [  1]  BRAM read acknowledge

    //sdram I/F
    wire                                s_DRAM0_WR_RDY                          ;//(s)  [  1]  SDRAM write ready
    wire                                s_DRAM0_WR_REQ                          ;//(s)  [  1]  SDRAM write request
    wire                                s_DRAM0_WR_ACK                          ;//(s)  [  1]  SDRAM write acknowledge
    wire        [  24:0]                s_DRAM0_WR_ADDR                         ;//(s)  [ 25]  SDRAM write address
    wire        [  15:0]                s_DRAM0_WR_SIZE                         ;//(s)  [ 12]  SDRAM write size
    wire                                s_DRAM0_WR_SOP                          ;//(s)  [  1]  SDRAM write start of packet
    wire                                s_DRAM0_WR_EOP                          ;//(s)  [  1]  SDRAM write end of packet
    wire                                s_DRAM0_WR_DVLD                         ;//(s)  [  1]  SDRAM write data valid
    wire        [  63:0]                s_DRAM0_WR_DATA                         ;//(s)  [ 32]  SDRAM write data
    wire                                s_DRAM0_RD_RDY                          ;//(s)  [  1]  SDRAM read ready
    wire                                s_DRAM0_RD_REQ                          ;//(s)  [  1]  SDRAM read request
    wire                                s_DRAM0_RD_ACK                          ;//(s)  [  1]  SDRAM read acknowledge
    wire        [  24:0]                s_DRAM0_RD_ADDR                         ;//(s)  [ 25]  SDRAM read address
    wire        [  11:0]                s_DRAM0_RD_SIZE                         ;//(s)  [ 12]  SDRAM read size
    wire                                s_DRAM0_RD_SOP                          ;//(s)  [  1]  SDRAM read start of packet
    wire                                s_DRAM0_RD_EOP                          ;//(s)  [  1]  SDRAM read end of packet
    wire                                s_DRAM0_RD_DVLD                         ;//(s)  [  1]  SDRAM read data valid
    wire        [  31:0]                s_DRAM0_RD_DATA                         ;//(s)  [ 32]  SDRAM read data

    wire                                s_DRAM1_WR_RDY                          ;//(s)  [  1]  SDRAM write ready
    wire                                s_DRAM1_WR_REQ                          ;//(s)  [  1]  SDRAM write request
    wire                                s_DRAM1_WR_ACK                          ;//(s)  [  1]  SDRAM write acknowledge
    wire        [  24:0]                s_DRAM1_WR_ADDR                         ;//(s)  [ 25]  SDRAM write address
    wire        [  15:0]                s_DRAM1_WR_SIZE                         ;//(s)  [ 12]  SDRAM write size
    wire                                s_DRAM1_WR_SOP                          ;//(s)  [  1]  SDRAM write start of packet
    wire                                s_DRAM1_WR_EOP                          ;//(s)  [  1]  SDRAM write end of packet
    wire                                s_DRAM1_WR_DVLD                         ;//(s)  [  1]  SDRAM write data valid
    wire        [  63:0]                s_DRAM1_WR_DATA                         ;//(s)  [ 32]  SDRAM write data
    wire                                s_DRAM1_RD_RDY                          ;//(s)  [  1]  SDRAM read ready
    wire                                s_DRAM1_RD_REQ                          ;//(s)  [  1]  SDRAM read request
    wire                                s_DRAM1_RD_ACK                          ;//(s)  [  1]  SDRAM read acknowledge
    wire        [  24:0]                s_DRAM1_RD_ADDR                         ;//(s)  [ 25]  SDRAM read address
    wire        [  11:0]                s_DRAM1_RD_SIZE                         ;//(s)  [ 12]  SDRAM read size
    wire                                s_DRAM1_RD_SOP                          ;//(s)  [  1]  SDRAM read start of packet
    wire                                s_DRAM1_RD_EOP                          ;//(s)  [  1]  SDRAM read end of packet
    wire                                s_DRAM1_RD_DVLD                         ;//(s)  [  1]  SDRAM read data valid
    wire        [  31:0]                s_DRAM1_RD_DATA                         ;//(s)  [ 32]  SDRAM read data

    wire                                s_DRAM2_WR_RDY                          ;//(s)  [  1]  SDRAM write ready
    wire                                s_DRAM2_WR_REQ                          ;//(s)  [  1]  SDRAM write request
    wire                                s_DRAM2_WR_ACK                          ;//(s)  [  1]  SDRAM write acknowledge
    wire        [  24:0]                s_DRAM2_WR_ADDR                         ;//(s)  [ 25]  SDRAM write address
    wire        [  15:0]                s_DRAM2_WR_SIZE                         ;//(s)  [ 12]  SDRAM write size
    wire                                s_DRAM2_WR_SOP                          ;//(s)  [  1]  SDRAM write start of packet
    wire                                s_DRAM2_WR_EOP                          ;//(s)  [  1]  SDRAM write end of packet
    wire                                s_DRAM2_WR_DVLD                         ;//(s)  [  1]  SDRAM write data valid
    wire        [  63:0]                s_DRAM2_WR_DATA                         ;//(s)  [ 32]  SDRAM write data
    wire                                s_DRAM2_RD_RDY                          ;//(s)  [  1]  SDRAM read ready
    wire                                s_DRAM2_RD_REQ                          ;//(s)  [  1]  SDRAM read request
    wire                                s_DRAM2_RD_ACK                          ;//(s)  [  1]  SDRAM read acknowledge
    wire        [  24:0]                s_DRAM2_RD_ADDR                         ;//(s)  [ 25]  SDRAM read address
    wire        [  11:0]                s_DRAM2_RD_SIZE                         ;//(s)  [ 12]  SDRAM read size
    wire                                s_DRAM2_RD_SOP                          ;//(s)  [  1]  SDRAM read start of packet
    wire                                s_DRAM2_RD_EOP                          ;//(s)  [  1]  SDRAM read end of packet
    wire                                s_DRAM2_RD_DVLD                         ;//(s)  [  1]  SDRAM read data valid
    wire        [  31:0]                s_DRAM2_RD_DATA                         ;//(s)  [ 32]  SDRAM read data

    wire                                s_DRAM3_WR_RDY                          ;//(s)  [  1]  SDRAM write ready
    wire                                s_DRAM3_WR_REQ                          ;//(s)  [  1]  SDRAM write request
    wire                                s_DRAM3_WR_ACK                          ;//(s)  [  1]  SDRAM write acknowledge
    wire        [  24:0]                s_DRAM3_WR_ADDR                         ;//(s)  [ 25]  SDRAM write address
    wire        [  15:0]                s_DRAM3_WR_SIZE                         ;//(s)  [ 12]  SDRAM write size
    wire                                s_DRAM3_WR_SOP                          ;//(s)  [  1]  SDRAM write start of packet
    wire                                s_DRAM3_WR_EOP                          ;//(s)  [  1]  SDRAM write end of packet
    wire                                s_DRAM3_WR_DVLD                         ;//(s)  [  1]  SDRAM write data valid
    wire        [  63:0]                s_DRAM3_WR_DATA                         ;//(s)  [ 32]  SDRAM write data
    wire                                s_DRAM3_RD_RDY                          ;//(s)  [  1]  SDRAM read ready
    wire                                s_DRAM3_RD_REQ                          ;//(s)  [  1]  SDRAM read request
    wire                                s_DRAM3_RD_ACK                          ;//(s)  [  1]  SDRAM read acknowledge
    wire        [  24:0]                s_DRAM3_RD_ADDR                         ;//(s)  [ 25]  SDRAM read address
    wire        [  11:0]                s_DRAM3_RD_SIZE                         ;//(s)  [ 12]  SDRAM read size
    wire                                s_DRAM3_RD_SOP                          ;//(s)  [  1]  SDRAM read start of packet
    wire                                s_DRAM3_RD_EOP                          ;//(s)  [  1]  SDRAM read end of packet
    wire                                s_DRAM3_RD_DVLD                         ;//(s)  [  1]  SDRAM read data valid
    wire        [  31:0]                s_DRAM3_RD_DATA                         ;//(s)  [ 32]  SDRAM read data

    wire                                s_DRAM4_WR_RDY                          ;//(s)  [  1]  SDRAM write ready
    wire                                s_DRAM4_WR_REQ                          ;//(s)  [  1]  SDRAM write request
    wire                                s_DRAM4_WR_ACK                          ;//(s)  [  1]  SDRAM write acknowledge
    wire        [  24:0]                s_DRAM4_WR_ADDR                         ;//(s)  [ 25]  SDRAM write address
    wire        [  15:0]                s_DRAM4_WR_SIZE                         ;//(s)  [ 12]  SDRAM write size
    wire                                s_DRAM4_WR_SOP                          ;//(s)  [  1]  SDRAM write start of packet
    wire                                s_DRAM4_WR_EOP                          ;//(s)  [  1]  SDRAM write end of packet
    wire                                s_DRAM4_WR_DVLD                         ;//(s)  [  1]  SDRAM write data valid
    wire        [  63:0]                s_DRAM4_WR_DATA                         ;//(s)  [ 32]  SDRAM write data
    wire                                s_DRAM4_RD_RDY                          ;//(s)  [  1]  SDRAM read ready
    wire                                s_DRAM4_RD_REQ                          ;//(s)  [  1]  SDRAM read request
    wire                                s_DRAM4_RD_ACK                          ;//(s)  [  1]  SDRAM read acknowledge
    wire        [  24:0]                s_DRAM4_RD_ADDR                         ;//(s)  [ 25]  SDRAM read address
    wire        [  11:0]                s_DRAM4_RD_SIZE                         ;//(s)  [ 12]  SDRAM read size
    wire                                s_DRAM4_RD_SOP                          ;//(s)  [  1]  SDRAM read start of packet
    wire                                s_DRAM4_RD_EOP                          ;//(s)  [  1]  SDRAM read end of packet
    wire                                s_DRAM4_RD_DVLD                         ;//(s)  [  1]  SDRAM read data valid
    wire        [  31:0]                s_DRAM4_RD_DATA                         ;//(s)  [ 32]  SDRAM read data

    wire                                s_DRAM5_WR_RDY                          ;//(s)  [  1]  SDRAM write ready
    wire                                s_DRAM5_WR_REQ                          ;//(s)  [  1]  SDRAM write request
    wire                                s_DRAM5_WR_ACK                          ;//(s)  [  1]  SDRAM write acknowledge
    wire        [  24:0]                s_DRAM5_WR_ADDR                         ;//(s)  [ 25]  SDRAM write address
    wire        [  15:0]                s_DRAM5_WR_SIZE                         ;//(s)  [ 12]  SDRAM write size
    wire                                s_DRAM5_WR_SOP                          ;//(s)  [  1]  SDRAM write start of packet
    wire                                s_DRAM5_WR_EOP                          ;//(s)  [  1]  SDRAM write end of packet
    wire                                s_DRAM5_WR_DVLD                         ;//(s)  [  1]  SDRAM write data valid
    wire        [  63:0]                s_DRAM5_WR_DATA                         ;//(s)  [ 32]  SDRAM write data
    wire                                s_DRAM5_RD_RDY                          ;//(s)  [  1]  SDRAM read ready
    wire                                s_DRAM5_RD_REQ                          ;//(s)  [  1]  SDRAM read request
    wire                                s_DRAM5_RD_ACK                          ;//(s)  [  1]  SDRAM read acknowledge
    wire        [  24:0]                s_DRAM5_RD_ADDR                         ;//(s)  [ 25]  SDRAM read address
    wire        [  11:0]                s_DRAM5_RD_SIZE                         ;//(s)  [ 12]  SDRAM read size
    wire                                s_DRAM5_RD_SOP                          ;//(s)  [  1]  SDRAM read start of packet
    wire                                s_DRAM5_RD_EOP                          ;//(s)  [  1]  SDRAM read end of packet
    wire                                s_DRAM5_RD_DVLD                         ;//(s)  [  1]  SDRAM read data valid
    wire        [  31:0]                s_DRAM5_RD_DATA                         ;//(s)  [ 32]  SDRAM read data

    wire                                s_DRAM6_WR_RDY                          ;//(s)  [  1]  SDRAM write ready
    wire                                s_DRAM6_WR_REQ                          ;//(s)  [  1]  SDRAM write request
    wire                                s_DRAM6_WR_ACK                          ;//(s)  [  1]  SDRAM write acknowledge
    wire        [  24:0]                s_DRAM6_WR_ADDR                         ;//(s)  [ 25]  SDRAM write address
    wire        [  15:0]                s_DRAM6_WR_SIZE                         ;//(s)  [ 12]  SDRAM write size
    wire                                s_DRAM6_WR_SOP                          ;//(s)  [  1]  SDRAM write start of packet
    wire                                s_DRAM6_WR_EOP                          ;//(s)  [  1]  SDRAM write end of packet
    wire                                s_DRAM6_WR_DVLD                         ;//(s)  [  1]  SDRAM write data valid
    wire        [  63:0]                s_DRAM6_WR_DATA                         ;//(s)  [ 32]  SDRAM write data
    wire                                s_DRAM6_RD_RDY                          ;//(s)  [  1]  SDRAM read ready
    wire                                s_DRAM6_RD_REQ                          ;//(s)  [  1]  SDRAM read request
    wire                                s_DRAM6_RD_ACK                          ;//(s)  [  1]  SDRAM read acknowledge
    wire        [  24:0]                s_DRAM6_RD_ADDR                         ;//(s)  [ 25]  SDRAM read address
    wire        [  11:0]                s_DRAM6_RD_SIZE                         ;//(s)  [ 12]  SDRAM read size
    wire                                s_DRAM6_RD_SOP                          ;//(s)  [  1]  SDRAM read start of packet
    wire                                s_DRAM6_RD_EOP                          ;//(s)  [  1]  SDRAM read end of packet
    wire                                s_DRAM6_RD_DVLD                         ;//(s)  [  1]  SDRAM read data valid
    wire        [  31:0]                s_DRAM6_RD_DATA                         ;//(s)  [ 32]  SDRAM read data

    wire                                s_SIM_ERR0                              ;//(s)  [  1]  Sim error input from other module
    wire                                s_SIM_ERR1                              ;//(s)  [  1]  Sim error input from other module
    wire                                s_SIM_ERR2                              ;//(s)  [  1]  Sim error input from other module
    wire                                s_SIM_ERR3                              ;//(s)  [  1]  Sim error input from other module

    wire                                s_SIM_END                               ;//(s)  [  1]  Sim end

    wire        [  63:0]                s_AXIS_RX_TDATA                             ;
    wire        [   7:0]                s_AXIS_RX_TKEEP                             ;
    wire                                s_AXIS_RX_TLAST                             ;
    wire                                s_AXIS_RX_TVALID                            ;
    wire                                s_AXIS_RX_TREADY                            ;
    wire        [  21:0]                s_AXIS_RX_TUSER                             ;

    wire        [  63:0]                s_AXIS_TX_TDATA                             ;
    wire        [   7:0]                s_AXIS_TX_TKEEP                             ;
    wire                                s_AXIS_TX_TVALID                            ;
    wire                                s_AXIS_TX_TLAST                             ;
    wire                                s_AXIS_TX_TREADY                            ;
    wire        [   3:0]                s_AXIS_TX_TUSER                             ;

    wire                                s_REG_WR_REQ                                ;
    wire                                s_REG_WR_ACK                                ;
    wire        [  31:0]                s_REG_WR_DATA                               ;
    wire                                s_REG_RD_REQ                                ;
    wire                                s_REG_RD_ACK                                ;
    wire        [  31:0]                s_REG_RD_DATA                               ;
    wire        [  15:0]                s_REG_OP_ADDR                               ;

// =================================================================================================
//  Sim boday
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Sim Model                                      ||
||                                                                             ||
/+=============================================================================*/

    SIM_MODEL # (
        .p_TB_NAME                      ( `p_TB_NAME                    ),//(p)
        .p_CMD_IDIR                     ( `p_CMD_IDIR                   ),//(p)
        .p_LOG_ODIR                     ( `p_LOG_ODIR                   ),//(p)
        .p_FILE_IDIR                    ( `p_FILE_IDIR                  ),//(p)
        .p_FILE_ODIR                    ( `p_FILE_ODIR                  ),//(p)

        .p_CLK0                         ( `p_CLK0                       ),//(p)
        .p_CLK1                         ( `p_CLK1                       ),//(p)
        .p_CLK2                         ( `p_CLK2                       ),//(p)
        .p_CLK3                         ( `p_CLK3                       ),//(p)

        .p_ODLY0                        ( `p_ODLY0                      ),//(p)
        .p_ODLY1                        ( `p_ODLY1                      ) //(p)
        )
    U_SIM_MODEL (
        //clock and reset
        .CLK0_P                         ( s_CLK0_P                      ),//(o)  [  1]  Systerm clock 0 P
        .CLK0_N                         ( s_CLK0_N                      ),//(o)  [  1]  Systerm clock 0 N
        .CLK1_P                         ( s_CLK1_P                      ),//(o)  [  1]  Systerm clock 1 P
        .CLK1_N                         ( s_CLK1_N                      ),//(o)  [  1]  Systerm clock 1 N
        .CLK2_P                         ( s_CLK2_P                      ),//(o)  [  1]  Systerm clock 2 P
        .CLK2_N                         ( s_CLK2_N                      ),//(o)  [  1]  Systerm clock 2 N
        .CLK3_P                         ( s_CLK3_P                      ),//(o)  [  1]  Systerm clock 3 P
        .CLK3_N                         ( s_CLK3_N                      ),//(o)  [  1]  Systerm clock 3 N

        .XRST0                          ( s_XRST0                       ),//(o)  [  1]  Reset 0 (low active)
        .XRST1                          ( s_XRST1                       ),//(o)  [  1]  Reset 1 (low active)
        .XRST2                          ( s_XRST2                       ),//(o)  [  1]  Reset 2 (low active)
        .XRST3                          ( s_XRST3                       ),//(o)  [  1]  Reset 3 (low active)

        .DIP_SW                         ( s_DIP_SW                      ),//(o)  [  8]  Dipswitch
        .PSH_SW                         ( s_PSH_SW                      ),//(o)  [  8]  Pushswitch  (low active)

        .TRIG_RX_P                      ( 8'h00                         ),//(i)  [  8]  Trig RX
        .TRIG_RX_N                      ( 8'hFF                         ),//(i)  [  8]  Trig RX
        .TRIG_TX_P                      ( s_TRIG_TX_P                   ),//(o)  [  8]  Trig TX
        .TRIG_TX_N                      ( s_TRIG_TX_N                   ),//(o)  [  8]  Trig TX

        //Local bus interface
        .LBUS_CS                        ( s_LBUS_CS                     ),//(o)  [  1]  Local bus select
        .LBUS_RD                        ( s_LBUS_RD                     ),//(o)  [  1]  Local bus read
        .LBUS_WR                        ( s_LBUS_WR                     ),//(o)  [  1]  Local bus write
        .LBUS_ADDR                      ( s_LBUS_ADDR                   ),//(o)  [ 13]  Local bus address
        .LBUS_DATA                      ( s_LBUS_DATA                   ),//(io) [ 32]  Local bus data

        .SOFT_START                     ( s_SOFT_START                  ),//(o)  [  1]  Softwart start
        .TOAL_START                     ( s_TOAL_START                  ),//(o)  [  1]  Total start
        .FAIL_O                         ( s_FAIL_O                      ),//(o)  [  1]  Fail output
        .FAIL_I                         ( 1'b0                          ),//(i)  [  1]  Fail input
        .TRIG_I                         ( 1'b0                          ),//(i)  [  1]  Trig input

        .REG0_WR_REQ                    ( s_REG0_WR_REQ                 ),//(o)  [  1]  Register write request
        .REG0_WR_ACK                    ( s_REG0_WR_ACK                 ),//(i)  [  1]  Register write acknowledge
        .REG0_WR_DATA                   ( s_REG0_WR_DATA                ),//(o)  [ 32]  Register write data
        .REG0_RD_REQ                    ( s_REG0_RD_REQ                 ),//(o)  [  1]  Register read request
        .REG0_RD_ACK                    ( s_REG0_RD_ACK                 ),//(i)  [  1]  Register read acknowledge
        .REG0_RD_DATA                   ( s_REG0_RD_DATA                ),//(i)  [ 32]  Register read data
        .REG0_OP_ADDR                   ( s_REG0_OP_ADDR                ),//(o)  [ 10]  Register operation address

        .REG1_WR_REQ                    ( s_REG1_WR_REQ                 ),//(o)  [  1]  Register write request
        .REG1_WR_ACK                    ( s_REG1_WR_ACK                 ),//(i)  [  1]  Register write acknowledge
        .REG1_WR_DATA                   ( s_REG1_WR_DATA                ),//(o)  [ 32]  Register write data
        .REG1_RD_REQ                    ( s_REG1_RD_REQ                 ),//(o)  [  1]  Register read request
        .REG1_RD_ACK                    ( s_REG1_RD_ACK                 ),//(i)  [  1]  Register read acknowledge
        .REG1_RD_DATA                   ( s_REG1_RD_DATA                ),//(i)  [ 32]  Register read data
        .REG1_OP_ADDR                   ( s_REG1_OP_ADDR                ),//(o)  [ 10]  Register operation address

        .REG2_WR_REQ                    ( s_REG2_WR_REQ                 ),//(o)  [  1]  Register write request
        .REG2_WR_ACK                    ( s_REG2_WR_ACK                 ),//(i)  [  1]  Register write acknowledge
        .REG2_WR_DATA                   ( s_REG2_WR_DATA                ),//(o)  [ 32]  Register write data
        .REG2_RD_REQ                    ( s_REG2_RD_REQ                 ),//(o)  [  1]  Register read request
        .REG2_RD_ACK                    ( s_REG2_RD_ACK                 ),//(i)  [  1]  Register read acknowledge
        .REG2_RD_DATA                   ( s_REG2_RD_DATA                ),//(i)  [ 32]  Register read data
        .REG2_OP_ADDR                   ( s_REG2_OP_ADDR                ),//(o)  [ 10]  Register operation address

        .REG3_WR_REQ                    ( s_REG3_WR_REQ                 ),//(o)  [  1]  Register write request
        .REG3_WR_ACK                    ( s_REG3_WR_ACK                 ),//(i)  [  1]  Register write acknowledge
        .REG3_WR_DATA                   ( s_REG3_WR_DATA                ),//(o)  [ 32]  Register write data
        .REG3_RD_REQ                    ( s_REG3_RD_REQ                 ),//(o)  [  1]  Register read request
        .REG3_RD_ACK                    ( s_REG3_RD_ACK                 ),//(i)  [  1]  Register read acknowledge
        .REG3_RD_DATA                   ( s_REG3_RD_DATA                ),//(i)  [ 32]  Register read data
        .REG3_OP_ADDR                   ( s_REG3_OP_ADDR                ),//(o)  [ 10]  Register operation address

        .REG4_WR_REQ                    ( s_REG4_WR_REQ                 ),//(o)  [  1]  Register write request
        .REG4_WR_ACK                    ( s_REG4_WR_ACK                 ),//(i)  [  1]  Register write acknowledge
        .REG4_WR_DATA                   ( s_REG4_WR_DATA                ),//(o)  [ 32]  Register write data
        .REG4_RD_REQ                    ( s_REG4_RD_REQ                 ),//(o)  [  1]  Register read request
        .REG4_RD_ACK                    ( s_REG4_RD_ACK                 ),//(i)  [  1]  Register read acknowledge
        .REG4_RD_DATA                   ( s_REG4_RD_DATA                ),//(i)  [ 32]  Register read data
        .REG4_OP_ADDR                   ( s_REG4_OP_ADDR                ),//(o)  [ 10]  Register operation address

        .REG5_WR_REQ                    ( s_REG5_WR_REQ                 ),//(o)  [  1]  Register write request
        .REG5_WR_ACK                    ( s_REG5_WR_ACK                 ),//(i)  [  1]  Register write acknowledge
        .REG5_WR_DATA                   ( s_REG5_WR_DATA                ),//(o)  [ 32]  Register write data
        .REG5_RD_REQ                    ( s_REG5_RD_REQ                 ),//(o)  [  1]  Register read request
        .REG5_RD_ACK                    ( s_REG5_RD_ACK                 ),//(i)  [  1]  Register read acknowledge
        .REG5_RD_DATA                   ( s_REG5_RD_DATA                ),//(i)  [ 32]  Register read data
        .REG5_OP_ADDR                   ( s_REG5_OP_ADDR                ),//(o)  [ 10]  Register operation address

        .REG6_WR_REQ                    ( s_REG6_WR_REQ                 ),//(o)  [  1]  Register write request
        .REG6_WR_ACK                    ( s_REG6_WR_ACK                 ),//(i)  [  1]  Register write acknowledge
        .REG6_WR_DATA                   ( s_REG6_WR_DATA                ),//(o)  [ 32]  Register write data
        .REG6_RD_REQ                    ( s_REG6_RD_REQ                 ),//(o)  [  1]  Register read request
        .REG6_RD_ACK                    ( s_REG6_RD_ACK                 ),//(i)  [  1]  Register read acknowledge
        .REG6_RD_DATA                   ( s_REG6_RD_DATA                ),//(i)  [ 32]  Register read data
        .REG6_OP_ADDR                   ( s_REG6_OP_ADDR                ),//(o)  [ 10]  Register operation address

        .REG7_WR_REQ                    ( s_REG7_WR_REQ                 ),//(o)  [  1]  Register write request
        .REG7_WR_ACK                    ( s_REG7_WR_ACK                 ),//(i)  [  1]  Register write acknowledge
        .REG7_WR_DATA                   ( s_REG7_WR_DATA                ),//(o)  [ 32]  Register write data
        .REG7_RD_REQ                    ( s_REG7_RD_REQ                 ),//(o)  [  1]  Register read request
        .REG7_RD_ACK                    ( s_REG7_RD_ACK                 ),//(i)  [  1]  Register read acknowledge
        .REG7_RD_DATA                   ( s_REG7_RD_DATA                ),//(i)  [ 32]  Register read data
        .REG7_OP_ADDR                   ( s_REG7_OP_ADDR                ),//(o)  [ 10]  Register operation address

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
        .DRAM6_RD_DATA                  ( s_DRAM6_RD_DATA               ),//(i)  [ 32]  SDRAM read data

        .SIM_ERR0                       ( 1'b0                          ),//(i)  [  1]  Sim error input from other module
        .SIM_ERR1                       ( 1'b0                          ),//(i)  [  1]  Sim error input from other module
        .SIM_ERR2                       ( 1'b0                          ),//(i)  [  1]  Sim error input from other module
        .SIM_ERR3                       ( 1'b0                          ),//(i)  [  1]  Sim error input from other module
        .SIM_END                        ( s_SIM_END                     ) //(o)  [  1]  Sim end
        ) ;

/*=============================================================================+/
||                                                                             ||
||                              PCIE_MODEL                                     ||
||                                                                             ||
/+=============================================================================*/

    PC_SIM U_PC_SIM (
        .CLK                            ( s_CLK0_P                      ),
        .RST                            ( ~s_XRST0                      ),

        .DRAM_WR_RDY                    ( s_DRAM0_WR_RDY                ),//(i)  [  1]  SDRAM write ready
        .DRAM_WR_REQ                    ( s_DRAM0_WR_REQ                ),//(i)  [  1]  SDRAM write request
        .DRAM_WR_ACK                    ( s_DRAM0_WR_ACK                ),//(o)  [  1]  SDRAM write acknowledge
        .DRAM_WR_ADDR                   ( s_DRAM0_WR_ADDR               ),//(i)  [ 25]  SDRAM write address
        .DRAM_WR_SIZE                   ( s_DRAM0_WR_SIZE               ),//(i)  [ 12]  SDRAM write size
        .DRAM_WR_SOP                    ( s_DRAM0_WR_SOP                ),//(i)  [  1]  SDRAM write start of packet
        .DRAM_WR_EOP                    ( s_DRAM0_WR_EOP                ),//(i)  [  1]  SDRAM write end of packet
        .DRAM_WR_DVLD                   ( s_DRAM0_WR_DVLD               ),//(i)  [  1]  SDRAM write data valid
        .DRAM_WR_DATA                   ( s_DRAM0_WR_DATA               ),//(i)  [ 32]  SDRAM write data

        .AXIS_RX_TDATA                  ( s_AXIS_RX_TDATA               ),
        .AXIS_RX_TKEEP                  ( s_AXIS_RX_TKEEP               ),
        .AXIS_RX_TLAST                  ( s_AXIS_RX_TLAST               ),
        .AXIS_RX_TVALID                 ( s_AXIS_RX_TVALID              ),
        .AXIS_RX_TREADY                 ( s_AXIS_RX_TREADY              ),
        .AXIS_RX_TUSER                  ( s_AXIS_RX_TUSER               ),

        .AXIS_TX_TDATA                  ( s_AXIS_TX_TDATA               ),
        .AXIS_TX_TKEEP                  ( s_AXIS_TX_TKEEP               ),
        .AXIS_TX_TVALID                 ( s_AXIS_TX_TVALID              ),
        .AXIS_TX_TLAST                  ( s_AXIS_TX_TLAST               ),
        .AXIS_TX_TREADY                 ( s_AXIS_TX_TREADY              ),
        .AXIS_TX_TUSER                  ( s_AXIS_TX_TUSER               )
    );

/*=============================================================================+/
||                                                                             ||
||                              PCIE_IF_GX                                     ||
||                                                                             ||
/+=============================================================================*/

    PCIE_IF_GX U_PCIE_IF_GX (
        .PCIE_SOFT_RST                  (                               ),//(o)  [  1]

        .PCIE_CLK                       ( s_CLK0_P                      ),//(i)  [  1]
        .PCIE_RST                       ( ~s_XRST0                       ),//(i)  [  1]
        .USER_CLK                       ( s_CLK0_P                      ),//(i)  [  1]
        .USER_RST                       ( ~s_XRST0                       ),//(i)  [  1]

        .PCIE_INT_0                     ( 1'b0                          ),//(i)  [  1]
        .PCIE_INT_1                     ( 1'b0                          ),//(i)  [  1]
        .PCIE_INT_2                     ( 1'b0                          ),//(i)  [  1]
        .PCIE_INT_3                     ( 1'b0                          ),//(i)  [  1]

        .AXIS_RX_TDATA                  ( s_AXIS_RX_TDATA               ),//(i)  [ 64]
        .AXIS_RX_TKEEP                  ( s_AXIS_RX_TKEEP               ),//(i)  [  8]
        .AXIS_RX_TLAST                  ( s_AXIS_RX_TLAST               ),//(i)  [  1]
        .AXIS_RX_TVALID                 ( s_AXIS_RX_TVALID              ),//(i)  [  1]
        .AXIS_RX_TREADY                 ( s_AXIS_RX_TREADY              ),//(o)  [  1]
        .AXIS_RX_TUSER                  ( s_AXIS_RX_TUSER               ),//(i)  [ 22]

        .AXIS_TX_TDATA                  ( s_AXIS_TX_TDATA               ),//(o)  [ 64]
        .AXIS_TX_TKEEP                  ( s_AXIS_TX_TKEEP               ),//(o)  [  8]
        .AXIS_TX_TVALID                 ( s_AXIS_TX_TVALID              ),//(o)  [  1]
        .AXIS_TX_TLAST                  ( s_AXIS_TX_TLAST               ),//(o)  [  1]
        .AXIS_TX_TREADY                 ( 1'b1                          ),//(i)  [  1]
        .AXIS_TX_TUSER                  ( s_AXIS_TX_TUSER               ),//(o)  [  4]

        .DMA_DN0_RDY                    ( {15'd0,s_DMA_DN0_RDY}         ),//(i)  [ 16]
        .DMA_DN0_DATA                   (                               ),//(o)  [ 64]
        .DMA_DN0_DVLD                   (                               ),//(o)  [  1]
        .DMA_DN0_SOF                    (                               ),//(o)  [  1]
        .DMA_DN0_EOF                    (                               ),//(o)  [  1]
        .DMA_DN0_VCH                    (                               ),//(o)  [ 16]
        .DMA_DN0_ADDR                   (                               ),//(o)  [ 32]
        .DMA_DN0_SIZE                   (                               ),//(o)  [ 32]

        .DMA_WR0_START                  (                               ),//(o)  [ 16]
        .DMA_WR0_VCH                    (                               ),//(o)  [ 16]
        .DMA_WR0_ADDR                   (                               ),//(o)  [ 32]
        .DMA_WR0_SIZE                   (                               ),//(o)  [ 32]

        .DMA_DN1_RDY                    ( p_GND[15:0]                   ),//(i)  [ 16]
        .DMA_DN1_DATA                   (                               ),//(o)  [ 64]
        .DMA_DN1_DVLD                   (                               ),//(o)  [  1]
        .DMA_DN1_SOF                    (                               ),//(o)  [  1]
        .DMA_DN1_EOF                    (                               ),//(o)  [  1]
        .DMA_DN1_VCH                    (                               ),//(o)  [ 16]
        .DMA_DN1_ADDR                   (                               ),//(o)  [ 32]
        .DMA_DN1_SIZE                   (                               ),//(o)  [ 32]

        .DMA_WR1_START                  (                               ),//(o)  [ 16]
        .DMA_WR1_VCH                    (                               ),//(o)  [ 16]
        .DMA_WR1_ADDR                   (                               ),//(o)  [ 32]
        .DMA_WR1_SIZE                   (                               ),//(o)  [ 32]

        .DMA_UP0_RDY                    ( s_DRAM1_WR_RDY                ),//(o)  [  1]
        .DMA_UP0_DATA                   ( s_DRAM1_WR_DATA               ),//(i)  [ 64]
        .DMA_UP0_DVLD                   ( s_DRAM1_WR_DVLD               ),//(i)  [  1]
        .DMA_UP0_SOF                    ( s_DRAM1_WR_SOP                ),//(i)  [  1]
        .DMA_UP0_EOF                    ( s_DRAM1_WR_EOP                ),//(i)  [  1]
        .DMA_UP0_VCH                    ( p_GND[15:0]                   ),//(i)  [ 16]
        .DMA_UP0_SIZE                   ( p_GND[31:0]                   ),//(i)  [ 32]
        .DMA_UP0_ADDR                   ( p_GND[31:0]                   ),//(i)  [ 32]

        .DMA_RD0_START                  (                               ),//(o)  [ 16]
        .DMA_RD0_VCH                    (                               ),//(o)  [ 16]
        .DMA_RD0_ADDR                   (                               ),//(o)  [ 32]
        .DMA_RD0_SIZE                   (                               ),//(o)  [ 32]

        .DMA_UP1_RDY                    (                               ),//(o)  [  1]
        .DMA_UP1_DATA                   ( p_GND[63:0]                   ),//(i)  [ 64]
        .DMA_UP1_DVLD                   ( p_GND[0]                      ),//(i)  [  1]
        .DMA_UP1_SOF                    ( p_GND[0]                      ),//(i)  [  1]
        .DMA_UP1_EOF                    ( p_GND[0]                      ),//(i)  [  1]
        .DMA_UP1_VCH                    ( p_GND[15:0]                   ),//(i)  [ 16]
        .DMA_UP1_SIZE                   ( p_GND[31:0]                   ),//(i)  [ 32]
        .DMA_UP1_ADDR                   ( p_GND[31:0]                   ),//(i)  [ 32]

        .DMA_RD1_START                  (                               ),//(o)  [ 16]
        .DMA_RD1_VCH                    (                               ),//(o)  [ 16]
        .DMA_RD1_ADDR                   (                               ),//(o)  [ 32]
        .DMA_RD1_SIZE                   (                               ),//(o)  [ 32]

        .REG3_WR_REQ                    ( s_REG_WR_REQ                  ),//(o)  [  1]
        .REG3_WR_ACK                    ( s_REG_WR_ACK                  ),//(i)  [  1]
        .REG3_WR_DATA                   ( s_REG_WR_DATA                 ),//(o)  [ 32]
        .REG3_RD_REQ                    ( s_REG_RD_REQ                  ),//(o)  [  1]
        .REG3_RD_ACK                    ( s_REG_RD_ACK                  ),//(i)  [  1]
        .REG3_RD_DATA                   ( s_REG_RD_DATA                 ),//(i)  [ 32]
        .REG3_OP_ADDR                   ( s_REG_OP_ADDR                 ),//(o)  [ 16]

        .REG4_WR_REQ                    (                               ),//(o)  [  1]
        .REG4_WR_ACK                    ( 1'b0                          ),//(i)  [  1]
        .REG4_WR_DATA                   (                               ),//(o)  [ 32]
        .REG4_RD_REQ                    (                               ),//(o)  [  1]
        .REG4_RD_ACK                    ( 1'b0                          ),//(i)  [  1]
        .REG4_RD_DATA                   ( 32'h0                         ),//(i)  [ 32]
        .REG4_OP_ADDR                   (                               ),//(o)  [ 16]

        .REG5_WR_REQ                    (                               ),//(o)  [  1]
        .REG5_WR_ACK                    ( 1'b0                          ),//(i)  [  1]
        .REG5_WR_DATA                   (                               ),//(o)  [ 32]
        .REG5_RD_REQ                    (                               ),//(o)  [  1]
        .REG5_RD_ACK                    ( 1'b0                          ),//(i)  [  1]
        .REG5_RD_DATA                   ( 32'h0                         ),//(i)  [ 32]
        .REG5_OP_ADDR                   (                               ),//(o)  [ 16]

        .REG6_WR_REQ                    (                               ),//(o)  [  1]
        .REG6_WR_ACK                    ( 1'b0                          ),//(i)  [  1]
        .REG6_WR_DATA                   (                               ),//(o)  [ 32]
        .REG6_RD_REQ                    (                               ),//(o)  [  1]
        .REG6_RD_ACK                    ( 1'b0                          ),//(i)  [  1]
        .REG6_RD_DATA                   ( 32'h0                         ),//(i)  [ 32]
        .REG6_OP_ADDR                   (                               ) //(o)  [ 16]
    );

/*=============================================================================+/
||                                                                             ||
||                              BIST_REG                                       ||
||                                                                             ||
/+=============================================================================*/

    BIST_REG U_BIST_REG(
        .CLK                            ( s_CLK0_P                      ),//(i)  [   1]
        .RST                            ( ~s_XRST0                      ),//(i)  [   1]

        .REG_WR_REQ                     ( s_REG_WR_REQ                  ),//(i)  [   1]
        .REG_RD_REQ                     ( s_REG_RD_REQ                  ),//(i)  [   1]
        .REG_WR_ACK                     ( s_REG_WR_ACK                  ),//(o)  [   1]
        .REG_RD_ACK                     ( s_REG_RD_ACK                  ),//(o)  [   1]
        .REG_WR_DATA                    ( s_REG_WR_DATA                 ),//(i)  [  32]
        .REG_RD_DATA                    ( s_REG_RD_DATA                 ),//(o)  [  32]
        .REG_OP_ADDR                    ( s_REG_OP_ADDR                 ),//(i)  [  16]

        .DEBUG_DI0                      ( 32'hFFFF_FFFF                 ),//(i)  [  32]
        .DEBUG_DI1                      ( 32'h0000_0000                 ),//(i)  [  32]
        .DEBUG_DI2                      ( 32'h0F0F_0F0F                 ),//(i)  [  32]
        .DEBUG_DI3                      ( 32'hF0F0_F0F0                 ),//(i)  [  32]
        .DEBUG_DI4                      ( 32'h5A5A_5A5A                 ),//(i)  [  32]
        .DEBUG_DI5                      ( 32'hA5A5_A5A5                 ),//(i)  [  32]
        .DEBUG_DI6                      ( 32'h0123_4567                 ),//(i)  [  32]
        .DEBUG_DI7                      ( 32'h89AB_CDEF                 ),//(i)  [  32]

        .DEBUG_DO0                      (                               ),//(o)  [  32]
        .DEBUG_DO1                      (                               ),//(o)  [  32]
        .DEBUG_DO2                      (                               ),//(o)  [  32]
        .DEBUG_DO3                      (                               ),//(o)  [  32]
        .DEBUG_DO4                      (                               ),//(o)  [  32]
        .DEBUG_DO5                      (                               ),//(o)  [  32]
        .DEBUG_DO6                      (                               ),//(o)  [  32]
        .DEBUG_DO7                      (                               ),//(o)  [  32]

        .DEBUG_TRIG0                    (                               ),//(o)  [   1]
        .DEBUG_TRIG1                    (                               ),//(o)  [   1]
        .DEBUG_TRIG2                    (                               ),//(o)  [   1]
        .DEBUG_TRIG3                    (                               ),//(o)  [   1]
        .DEBUG_TRIG4                    (                               ),//(o)  [   1]
        .DEBUG_TRIG5                    (                               ),//(o)  [   1]
        .DEBUG_TRIG6                    (                               ),//(o)  [   1]
        .DEBUG_TRIG7                    (                               ) //(o)  [   1]
    );

endmodule