// =================================================================================================
// File Name    : sim_model.v
// Entity       : SIM_MODEL
// =================================================================================================
// Function     : behave simulation
// -------------------------------------------------------------------------------------------------
// Updata History:
// -------------------------------------------------------------------------------------------------
// REV.Level    Date        Coded-by        Contents
// v0.1.0       2019/06/10  Jacky           Create New
// -------------------------------------------------------------------------------------------------
// End Revision
// =================================================================================================

`timescale 1ps / 1ps

module SIM_MODEL (
    //clock and reset
    output                              CLK0_P                                  ,//(o)  [  1]  Systerm clock 0 P # 250 MHz
    output                              CLK0_N                                  ,//(o)  [  1]  Systerm clock 0 N # 250 MHz
    output                              CLK1_P                                  ,//(o)  [  1]  Systerm clock 1 P #  25 MHz
    output                              CLK1_N                                  ,//(o)  [  1]  Systerm clock 1 N #  25 MHz
    output                              CLK2_P                                  ,//(o)  [  1]  Systerm clock 2 P # 200 MHz
    output                              CLK2_N                                  ,//(o)  [  1]  Systerm clock 2 N # 200 MHz
    output                              CLK3_P                                  ,//(o)  [  1]  Systerm clock 3 P # 200 MHz
    output                              CLK3_N                                  ,//(o)  [  1]  Systerm clock 3 N # 200 MHz

    output                              XRST0                                   ,//(o)  [  1]  Reset 0 (low active)
    output                              XRST1                                   ,//(o)  [  1]  Reset 1 (low active)
    output                              XRST2                                   ,//(o)  [  1]  Reset 2 (low active)
    output                              XRST3                                   ,//(o)  [  1]  Reset 3 (low active)

    //push_sw and dip_sw
    output      [   7:0]                DIP_SW                                  ,//(o)  [  8]  Dipswitch
    output      [   7:0]                PSH_SW                                  ,//(o)  [  8]  Pushswitch  (low active)

    input       [   7:0]                TRIG_RX_P                               ,//(i)  [  8]  Trig RX
    input       [   7:0]                TRIG_RX_N                               ,//(i)  [  8]  Trig RX
    output      [   7:0]                TRIG_TX_P                               ,//(o)  [  8]  Trig TX
    output      [   7:0]                TRIG_TX_N                               ,//(o)  [  8]  Trig TX

    //Local bus interface
    output                              LBUS_CS                                 ,//(o)  [  1]  Local bus select
    output                              LBUS_RD                                 ,//(o)  [  1]  Local bus read
    output                              LBUS_WR                                 ,//(o)  [  1]  Local bus write
    output      [  12:0]                LBUS_ADDR                               ,//(o)  [ 13]  Local bus address
    inout       [  31:0]                LBUS_DATA                               ,//(io) [ 32]  Local bus data

    //backplane
    output                              SOFT_START                              ,//(o)  [  1]  Softwart start
    output                              TOAL_START                              ,//(o)  [  1]  Total start
    output                              FAIL_O                                  ,//(o)  [  1]  Fail output
    input                               FAIL_I                                  ,//(i)  [  1]  Fail input
    input                               TRIG_I                                  ,//(i)  [  1]  Trig input

    //register I/F
    output                              REG0_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG0_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG0_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG0_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG0_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG0_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [   9:0]                REG0_OP_ADDR                            ,//(o)  [ 10]  Register operation address

    output                              REG1_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG1_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG1_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG1_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG1_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG1_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [   9:0]                REG1_OP_ADDR                            ,//(o)  [ 10]  Register operation address

    output                              REG2_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG2_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG2_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG2_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG2_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG2_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [   9:0]                REG2_OP_ADDR                            ,//(o)  [ 10]  Register operation address

    output                              REG3_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG3_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG3_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG3_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG3_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG3_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [   9:0]                REG3_OP_ADDR                            ,//(o)  [ 10]  Register operation address

    output                              REG4_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG4_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG4_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG4_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG4_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG4_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [   9:0]                REG4_OP_ADDR                            ,//(o)  [ 10]  Register operation address

    output                              REG5_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG5_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG5_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG5_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG5_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG5_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [   9:0]                REG5_OP_ADDR                            ,//(o)  [ 10]  Register operation address

    output                              REG6_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG6_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG6_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG6_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG6_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG6_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [   9:0]                REG6_OP_ADDR                            ,//(o)  [ 10]  Register operation address

    output                              REG7_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG7_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG7_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG7_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG7_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG7_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [   9:0]                REG7_OP_ADDR                            ,//(o)  [ 10]  Register operation address

    //bram I/F
    output                              BRAM0_WR_REQ                            ,//(o)  [  1]  BRAM write request
    output      [  15:0]                BRAM0_WR_ADDR                           ,//(o)  [ 16]  BRAM write address
    output      [  31:0]                BRAM0_WR_DATA                           ,//(o)  [ 32]  BRAM write data
    input                               BRAM0_WR_ACK                            ,//(i)  [  1]  BRAM write acknowledge
    output                              BRAM0_RD_REQ                            ,//(o)  [  1]  BRAM read request
    output      [  15:0]                BRAM0_RD_ADDR                           ,//(o)  [ 16]  BRAM read address
    input       [  31:0]                BRAM0_RD_DATA                           ,//(i)  [ 32]  BRAM read data
    input                               BRAM0_RD_ACK                            ,//(i)  [  1]  BRAM read acknowledge

    output                              BRAM1_WR_REQ                            ,//(o)  [  1]  BRAM write request
    output      [  15:0]                BRAM1_WR_ADDR                           ,//(o)  [ 16]  BRAM write address
    output      [  31:0]                BRAM1_WR_DATA                           ,//(o)  [ 32]  BRAM write data
    input                               BRAM1_WR_ACK                            ,//(i)  [  1]  BRAM write acknowledge
    output                              BRAM1_RD_REQ                            ,//(o)  [  1]  BRAM read request
    output      [  15:0]                BRAM1_RD_ADDR                           ,//(o)  [ 16]  BRAM read address
    input       [  31:0]                BRAM1_RD_DATA                           ,//(i)  [ 32]  BRAM read data
    input                               BRAM1_RD_ACK                            ,//(i)  [  1]  BRAM read acknowledge

    output                              BRAM2_WR_REQ                            ,//(o)  [  1]  BRAM write request
    output      [  15:0]                BRAM2_WR_ADDR                           ,//(o)  [ 16]  BRAM write address
    output      [  31:0]                BRAM2_WR_DATA                           ,//(o)  [ 32]  BRAM write data
    input                               BRAM2_WR_ACK                            ,//(i)  [  1]  BRAM write acknowledge
    output                              BRAM2_RD_REQ                            ,//(o)  [  1]  BRAM read request
    output      [  15:0]                BRAM2_RD_ADDR                           ,//(o)  [ 16]  BRAM read address
    input       [  31:0]                BRAM2_RD_DATA                           ,//(i)  [ 32]  BRAM read data
    input                               BRAM2_RD_ACK                            ,//(i)  [  1]  BRAM read acknowledge

    output                              BRAM3_WR_REQ                            ,//(o)  [  1]  BRAM write request
    output      [  15:0]                BRAM3_WR_ADDR                           ,//(o)  [ 16]  BRAM write address
    output      [  31:0]                BRAM3_WR_DATA                           ,//(o)  [ 32]  BRAM write data
    input                               BRAM3_WR_ACK                            ,//(i)  [  1]  BRAM write acknowledge
    output                              BRAM3_RD_REQ                            ,//(o)  [  1]  BRAM read request
    output      [  15:0]                BRAM3_RD_ADDR                           ,//(o)  [ 16]  BRAM read address
    input       [  31:0]                BRAM3_RD_DATA                           ,//(i)  [ 32]  BRAM read data
    input                               BRAM3_RD_ACK                            ,//(i)  [  1]  BRAM read acknowledge

    output                              BRAM4_WR_REQ                            ,//(o)  [  1]  BRAM write request
    output      [  15:0]                BRAM4_WR_ADDR                           ,//(o)  [ 16]  BRAM write address
    output      [  31:0]                BRAM4_WR_DATA                           ,//(o)  [ 32]  BRAM write data
    input                               BRAM4_WR_ACK                            ,//(i)  [  1]  BRAM write acknowledge
    output                              BRAM4_RD_REQ                            ,//(o)  [  1]  BRAM read request
    output      [  15:0]                BRAM4_RD_ADDR                           ,//(o)  [ 16]  BRAM read address
    input       [  31:0]                BRAM4_RD_DATA                           ,//(i)  [ 32]  BRAM read data
    input                               BRAM4_RD_ACK                            ,//(i)  [  1]  BRAM read acknowledge

    output                              BRAM5_WR_REQ                            ,//(o)  [  1]  BRAM write request
    output      [  15:0]                BRAM5_WR_ADDR                           ,//(o)  [ 16]  BRAM write address
    output      [  31:0]                BRAM5_WR_DATA                           ,//(o)  [ 32]  BRAM write data
    input                               BRAM5_WR_ACK                            ,//(i)  [  1]  BRAM write acknowledge
    output                              BRAM5_RD_REQ                            ,//(o)  [  1]  BRAM read request
    output      [  15:0]                BRAM5_RD_ADDR                           ,//(o)  [ 16]  BRAM read address
    input       [  31:0]                BRAM5_RD_DATA                           ,//(i)  [ 32]  BRAM read data
    input                               BRAM5_RD_ACK                            ,//(i)  [  1]  BRAM read acknowledge

    output                              BRAM6_WR_REQ                            ,//(o)  [  1]  BRAM write request
    output      [  15:0]                BRAM6_WR_ADDR                           ,//(o)  [ 16]  BRAM write address
    output      [  31:0]                BRAM6_WR_DATA                           ,//(o)  [ 32]  BRAM write data
    input                               BRAM6_WR_ACK                            ,//(i)  [  1]  BRAM write acknowledge
    output                              BRAM6_RD_REQ                            ,//(o)  [  1]  BRAM read request
    output      [  15:0]                BRAM6_RD_ADDR                           ,//(o)  [ 16]  BRAM read address
    input       [  31:0]                BRAM6_RD_DATA                           ,//(i)  [ 32]  BRAM read data
    input                               BRAM6_RD_ACK                            ,//(i)  [  1]  BRAM read acknowledge

    output                              BRAM7_WR_REQ                            ,//(o)  [  1]  BRAM write request
    output      [  15:0]                BRAM7_WR_ADDR                           ,//(o)  [ 16]  BRAM write address
    output      [  31:0]                BRAM7_WR_DATA                           ,//(o)  [ 32]  BRAM write data
    input                               BRAM7_WR_ACK                            ,//(i)  [  1]  BRAM write acknowledge
    output                              BRAM7_RD_REQ                            ,//(o)  [  1]  BRAM read request
    output      [  15:0]                BRAM7_RD_ADDR                           ,//(o)  [ 16]  BRAM read address
    input       [  31:0]                BRAM7_RD_DATA                           ,//(i)  [ 32]  BRAM read data
    input                               BRAM7_RD_ACK                            ,//(i)  [  1]  BRAM read acknowledge

    //sdram I/F
    input                               DRAM0_WR_RDY                            ,//(i)  [  1]  SDRAM write ready
    output                              DRAM0_WR_REQ                            ,//(o)  [  1]  SDRAM write request
    input                               DRAM0_WR_ACK                            ,//(i)  [  1]  SDRAM write acknowledge
    output      [  24:0]                DRAM0_WR_ADDR                           ,//(o)  [ 25]  SDRAM write address
    output      [  15:0]                DRAM0_WR_SIZE                           ,//(o)  [ 12]  SDRAM write size
    output                              DRAM0_WR_SOP                            ,//(o)  [  1]  SDRAM write start of packet
    output                              DRAM0_WR_EOP                            ,//(o)  [  1]  SDRAM write end of packet
    output                              DRAM0_WR_DVLD                           ,//(o)  [  1]  SDRAM write data valid
    output      [  63:0]                DRAM0_WR_DATA                           ,//(o)  [ 32]  SDRAM write data
    output                              DRAM0_RD_RDY                            ,//(o)  [  1]  SDRAM read ready
    output                              DRAM0_RD_REQ                            ,//(o)  [  1]  SDRAM read request
    input                               DRAM0_RD_ACK                            ,//(i)  [  1]  SDRAM read acknowledge
    output      [  24:0]                DRAM0_RD_ADDR                           ,//(o)  [ 25]  SDRAM read address
    output      [  11:0]                DRAM0_RD_SIZE                           ,//(o)  [ 12]  SDRAM read size
    input                               DRAM0_RD_SOP                            ,//(i)  [  1]  SDRAM read start of packet
    input                               DRAM0_RD_EOP                            ,//(i)  [  1]  SDRAM read end of packet
    input                               DRAM0_RD_DVLD                           ,//(i)  [  1]  SDRAM read data valid
    input       [  31:0]                DRAM0_RD_DATA                           ,//(i)  [ 32]  SDRAM read data

    input                               DRAM1_WR_RDY                            ,//(i)  [  1]  SDRAM write ready
    output                              DRAM1_WR_REQ                            ,//(o)  [  1]  SDRAM write request
    input                               DRAM1_WR_ACK                            ,//(i)  [  1]  SDRAM write acknowledge
    output      [  24:0]                DRAM1_WR_ADDR                           ,//(o)  [ 25]  SDRAM write address
    output      [  15:0]                DRAM1_WR_SIZE                           ,//(o)  [ 12]  SDRAM write size
    output                              DRAM1_WR_SOP                            ,//(o)  [  1]  SDRAM write start of packet
    output                              DRAM1_WR_EOP                            ,//(o)  [  1]  SDRAM write end of packet
    output                              DRAM1_WR_DVLD                           ,//(o)  [  1]  SDRAM write data valid
    output      [  63:0]                DRAM1_WR_DATA                           ,//(o)  [ 32]  SDRAM write data
    output                              DRAM1_RD_RDY                            ,//(o)  [  1]  SDRAM read ready
    output                              DRAM1_RD_REQ                            ,//(o)  [  1]  SDRAM read request
    input                               DRAM1_RD_ACK                            ,//(i)  [  1]  SDRAM read acknowledge
    output      [  24:0]                DRAM1_RD_ADDR                           ,//(o)  [ 25]  SDRAM read address
    output      [  11:0]                DRAM1_RD_SIZE                           ,//(o)  [ 12]  SDRAM read size
    input                               DRAM1_RD_SOP                            ,//(i)  [  1]  SDRAM read start of packet
    input                               DRAM1_RD_EOP                            ,//(i)  [  1]  SDRAM read end of packet
    input                               DRAM1_RD_DVLD                           ,//(i)  [  1]  SDRAM read data valid
    input       [  31:0]                DRAM1_RD_DATA                           ,//(i)  [ 32]  SDRAM read data

    input                               DRAM2_WR_RDY                            ,//(i)  [  1]  SDRAM write ready
    output                              DRAM2_WR_REQ                            ,//(o)  [  1]  SDRAM write request
    input                               DRAM2_WR_ACK                            ,//(i)  [  1]  SDRAM write acknowledge
    output      [  24:0]                DRAM2_WR_ADDR                           ,//(o)  [ 25]  SDRAM write address
    output      [  15:0]                DRAM2_WR_SIZE                           ,//(o)  [ 12]  SDRAM write size
    output                              DRAM2_WR_SOP                            ,//(o)  [  1]  SDRAM write start of packet
    output                              DRAM2_WR_EOP                            ,//(o)  [  1]  SDRAM write end of packet
    output                              DRAM2_WR_DVLD                           ,//(o)  [  1]  SDRAM write data valid
    output      [  63:0]                DRAM2_WR_DATA                           ,//(o)  [ 32]  SDRAM write data
    output                              DRAM2_RD_RDY                            ,//(o)  [  1]  SDRAM read ready
    output                              DRAM2_RD_REQ                            ,//(o)  [  1]  SDRAM read request
    input                               DRAM2_RD_ACK                            ,//(i)  [  1]  SDRAM read acknowledge
    output      [  24:0]                DRAM2_RD_ADDR                           ,//(o)  [ 25]  SDRAM read address
    output      [  11:0]                DRAM2_RD_SIZE                           ,//(o)  [ 12]  SDRAM read size
    input                               DRAM2_RD_SOP                            ,//(i)  [  1]  SDRAM read start of packet
    input                               DRAM2_RD_EOP                            ,//(i)  [  1]  SDRAM read end of packet
    input                               DRAM2_RD_DVLD                           ,//(i)  [  1]  SDRAM read data valid
    input       [  31:0]                DRAM2_RD_DATA                           ,//(i)  [ 32]  SDRAM read data

    input                               DRAM3_WR_RDY                            ,//(i)  [  1]  SDRAM write ready
    output                              DRAM3_WR_REQ                            ,//(o)  [  1]  SDRAM write request
    input                               DRAM3_WR_ACK                            ,//(i)  [  1]  SDRAM write acknowledge
    output      [  24:0]                DRAM3_WR_ADDR                           ,//(o)  [ 25]  SDRAM write address
    output      [  15:0]                DRAM3_WR_SIZE                           ,//(o)  [ 12]  SDRAM write size
    output                              DRAM3_WR_SOP                            ,//(o)  [  1]  SDRAM write start of packet
    output                              DRAM3_WR_EOP                            ,//(o)  [  1]  SDRAM write end of packet
    output                              DRAM3_WR_DVLD                           ,//(o)  [  1]  SDRAM write data valid
    output      [  63:0]                DRAM3_WR_DATA                           ,//(o)  [ 32]  SDRAM write data
    output                              DRAM3_RD_RDY                            ,//(o)  [  1]  SDRAM read ready
    output                              DRAM3_RD_REQ                            ,//(o)  [  1]  SDRAM read request
    input                               DRAM3_RD_ACK                            ,//(i)  [  1]  SDRAM read acknowledge
    output      [  24:0]                DRAM3_RD_ADDR                           ,//(o)  [ 25]  SDRAM read address
    output      [  11:0]                DRAM3_RD_SIZE                           ,//(o)  [ 12]  SDRAM read size
    input                               DRAM3_RD_SOP                            ,//(i)  [  1]  SDRAM read start of packet
    input                               DRAM3_RD_EOP                            ,//(i)  [  1]  SDRAM read end of packet
    input                               DRAM3_RD_DVLD                           ,//(i)  [  1]  SDRAM read data valid
    input       [  31:0]                DRAM3_RD_DATA                           ,//(i)  [ 32]  SDRAM read data

    input                               DRAM4_WR_RDY                            ,//(i)  [  1]  SDRAM write ready
    output                              DRAM4_WR_REQ                            ,//(o)  [  1]  SDRAM write request
    input                               DRAM4_WR_ACK                            ,//(i)  [  1]  SDRAM write acknowledge
    output      [  24:0]                DRAM4_WR_ADDR                           ,//(o)  [ 25]  SDRAM write address
    output      [  15:0]                DRAM4_WR_SIZE                           ,//(o)  [ 12]  SDRAM write size
    output                              DRAM4_WR_SOP                            ,//(o)  [  1]  SDRAM write start of packet
    output                              DRAM4_WR_EOP                            ,//(o)  [  1]  SDRAM write end of packet
    output                              DRAM4_WR_DVLD                           ,//(o)  [  1]  SDRAM write data valid
    output      [  63:0]                DRAM4_WR_DATA                           ,//(o)  [ 32]  SDRAM write data
    output                              DRAM4_RD_RDY                            ,//(o)  [  1]  SDRAM read ready
    output                              DRAM4_RD_REQ                            ,//(o)  [  1]  SDRAM read request
    input                               DRAM4_RD_ACK                            ,//(i)  [  1]  SDRAM read acknowledge
    output      [  24:0]                DRAM4_RD_ADDR                           ,//(o)  [ 25]  SDRAM read address
    output      [  11:0]                DRAM4_RD_SIZE                           ,//(o)  [ 12]  SDRAM read size
    input                               DRAM4_RD_SOP                            ,//(i)  [  1]  SDRAM read start of packet
    input                               DRAM4_RD_EOP                            ,//(i)  [  1]  SDRAM read end of packet
    input                               DRAM4_RD_DVLD                           ,//(i)  [  1]  SDRAM read data valid
    input       [  31:0]                DRAM4_RD_DATA                           ,//(i)  [ 32]  SDRAM read data

    input                               DRAM5_WR_RDY                            ,//(i)  [  1]  SDRAM write ready
    output                              DRAM5_WR_REQ                            ,//(o)  [  1]  SDRAM write request
    input                               DRAM5_WR_ACK                            ,//(i)  [  1]  SDRAM write acknowledge
    output      [  24:0]                DRAM5_WR_ADDR                           ,//(o)  [ 25]  SDRAM write address
    output      [  15:0]                DRAM5_WR_SIZE                           ,//(o)  [ 12]  SDRAM write size
    output                              DRAM5_WR_SOP                            ,//(o)  [  1]  SDRAM write start of packet
    output                              DRAM5_WR_EOP                            ,//(o)  [  1]  SDRAM write end of packet
    output                              DRAM5_WR_DVLD                           ,//(o)  [  1]  SDRAM write data valid
    output      [  63:0]                DRAM5_WR_DATA                           ,//(o)  [ 32]  SDRAM write data
    output                              DRAM5_RD_RDY                            ,//(o)  [  1]  SDRAM read ready
    output                              DRAM5_RD_REQ                            ,//(o)  [  1]  SDRAM read request
    input                               DRAM5_RD_ACK                            ,//(i)  [  1]  SDRAM read acknowledge
    output      [  24:0]                DRAM5_RD_ADDR                           ,//(o)  [ 25]  SDRAM read address
    output      [  11:0]                DRAM5_RD_SIZE                           ,//(o)  [ 12]  SDRAM read size
    input                               DRAM5_RD_SOP                            ,//(i)  [  1]  SDRAM read start of packet
    input                               DRAM5_RD_EOP                            ,//(i)  [  1]  SDRAM read end of packet
    input                               DRAM5_RD_DVLD                           ,//(i)  [  1]  SDRAM read data valid
    input       [  31:0]                DRAM5_RD_DATA                           ,//(i)  [ 32]  SDRAM read data

    input                               DRAM6_WR_RDY                            ,//(i)  [  1]  SDRAM write ready
    output                              DRAM6_WR_REQ                            ,//(o)  [  1]  SDRAM write request
    input                               DRAM6_WR_ACK                            ,//(i)  [  1]  SDRAM write acknowledge
    output      [  24:0]                DRAM6_WR_ADDR                           ,//(o)  [ 25]  SDRAM write address
    output      [  15:0]                DRAM6_WR_SIZE                           ,//(o)  [ 12]  SDRAM write size
    output                              DRAM6_WR_SOP                            ,//(o)  [  1]  SDRAM write start of packet
    output                              DRAM6_WR_EOP                            ,//(o)  [  1]  SDRAM write end of packet
    output                              DRAM6_WR_DVLD                           ,//(o)  [  1]  SDRAM write data valid
    output      [  63:0]                DRAM6_WR_DATA                           ,//(o)  [ 32]  SDRAM write data
    output                              DRAM6_RD_RDY                            ,//(o)  [  1]  SDRAM read ready
    output                              DRAM6_RD_REQ                            ,//(o)  [  1]  SDRAM read request
    input                               DRAM6_RD_ACK                            ,//(i)  [  1]  SDRAM read acknowledge
    output      [  24:0]                DRAM6_RD_ADDR                           ,//(o)  [ 25]  SDRAM read address
    output      [  11:0]                DRAM6_RD_SIZE                           ,//(o)  [ 12]  SDRAM read size
    input                               DRAM6_RD_SOP                            ,//(i)  [  1]  SDRAM read start of packet
    input                               DRAM6_RD_EOP                            ,//(i)  [  1]  SDRAM read end of packet
    input                               DRAM6_RD_DVLD                           ,//(i)  [  1]  SDRAM read data valid
    input       [  31:0]                DRAM6_RD_DATA                           ,//(i)  [ 32]  SDRAM read data

    //sim end
    input                               SIM_ERR0                                ,//(i)  [ 1]  Sim error input from other module
    input                               SIM_ERR1                                ,//(i)  [ 1]  Sim error input from other module
    input                               SIM_ERR2                                ,//(i)  [ 1]  Sim error input from other module
    input                               SIM_ERR3                                ,//(i)  [ 1]  Sim error input from other module
    output                              SIM_END                                  //(o)  [ 1]  Sim end
    ) ;

// =============================================================================
// Parameter Declare
// =============================================================================

    //clk generate
    parameter                           p_CLK0              = 5000              ;//(p) clock 0
    parameter                           p_CLK1              = 5000              ;//(p) clock 1
    parameter                           p_CLK2              = 5000              ;//(p) clock 2
    parameter                           p_CLK3              = 5000              ;//(p) clock 3

    //command decode
    parameter                           cmd_RST0            = 8'h00             ;//(p) 00 : reset by clock cycle
    parameter                           cmd_RST1            = 8'h01             ;//(p) 01 : reset by ns
    parameter                           cmd_RST2            = 8'h02             ;//(p) 02 : reset by us
    parameter                           cmd_RST3            = 8'h03             ;//(p) 03 : reset by ms
    parameter                           cmd_CLKEN           = 8'h04             ;//(p) 04 : clock enable
    parameter                           cmd_PSHSW           = 8'h05             ;//(p) 05 : pushswitch
    parameter                           cmd_DIPSW           = 8'h06             ;//(p) 06 : dipswitch

    parameter                           cmd_WAIT_CYC        = 8'h10             ;//(p) 10 : Wait cycles
    parameter                           cmd_WAIT_NS         = 8'h11             ;//(p) 11 : Wait ns
    parameter                           cmd_WAIT_US         = 8'h12             ;//(p) 12 : Wait us
    parameter                           cmd_WAIT_MS         = 8'h13             ;//(p) 13 : Wait ms

    parameter                           cmd_REG_WR          = 8'h20             ;//(p) 20 : Register write
    parameter                           cmd_REG_RD          = 8'h21             ;//(p) 21 : Register read
    parameter                           cmd_BRAM_WR         = 8'h22             ;//(p) 22 : BRAM write
    parameter                           cmd_BRAM_RD         = 8'h23             ;//(p) 23 : BRAM read
    parameter                           cmd_DRAM_WR         = 8'h24             ;//(p) 24 : DRAM write
    parameter                           cmd_DRAM_RD         = 8'h25             ;//(p) 25 : DRAM read

    parameter                           cmd_LBUS_REG_WR     = 8'h30             ;//(p) 30 : Local bus register write
    parameter                           cmd_LBUS_REG_RD     = 8'h31             ;//(p) 31 : Local bus register read
    parameter                           cmd_LBUS_BRAM_WR    = 8'h32             ;//(p) 32 : Local bus bram write
    parameter                           cmd_LBUS_BRAM_RD    = 8'h33             ;//(p) 33 : Local bus bram read
    parameter                           cmd_LBUS_DRAM_WR    = 8'h34             ;//(p) 34 : Local bus dram write
    parameter                           cmd_LBUS_DRAM_RD    = 8'h35             ;//(p) 35 : Local bus dram read

    parameter                           cmd_TRIG_TX         = 8'h40             ;//(p) 40 : Trig tx
    parameter                           cmd_TRIG_RX         = 8'h41             ;//(p) 41 : Trig rx

    parameter                           cmd_SOFT_START      = 8'h50             ;//(p) 50 : Softwart start
    parameter                           cmd_TOAL_START      = 8'h51             ;//(p) 51 : Total start
    parameter                           cmd_FAIL_OGEN       = 8'h52             ;//(p) 52 : Fail output generate
    parameter                           cmd_FAIL_ICHK       = 8'h53             ;//(p) 53 : Fail input check
    parameter                           cmd_TRIG_ICHK       = 8'h54             ;//(p) 54 : Trig input check

    parameter                           cmd_SIMEND          = 8'hFF             ;//(p) FF : sim-end

    //File
    parameter                           p_TB_NAME           = "tb_xxxx_xx"      ;//(p) Test patten name
    parameter                           p_CMD_IDIR          = "tb_pattern/"     ;//(p) Command file direction
    parameter                           p_LOG_ODIR          = "tb_pattern/"     ;//(p) Log file direction
    parameter                           p_FILE_IDIR         = "tb_pattern/"     ;//(p) Data file direction
    parameter                           p_FILE_ODIR         = "tb_pattern/"     ;//(p) Data file direction

    //Output delay
    parameter                           p_ODLY0             = 0                 ;//(p) Output delay
    parameter                           p_ODLY1             = 200               ;//(p) Output delay

// =============================================================================
// Internal Signal Declare
// =============================================================================

    //integer signal
    integer                             LOG                                     ;//(i) Open file
    integer                             file_bram0_rd                           ;//(i) Open file
    integer                             file_bram1_rd                           ;//(i) Open file
    integer                             file_bram2_rd                           ;//(i) Open file
    integer                             file_bram3_rd                           ;//(i) Open file
    integer                             file_bram4_rd                           ;//(i) Open file
    integer                             file_bram5_rd                           ;//(i) Open file
    integer                             file_bram6_rd                           ;//(i) Open file
    integer                             file_bram7_rd                           ;//(i) Open file

    integer                             file_dram0_rd                           ;//(i) Open file
    integer                             file_dram1_rd                           ;//(i) Open file
    integer                             file_dram2_rd                           ;//(i) Open file
    integer                             file_dram3_rd                           ;//(i) Open file
    integer                             file_dram4_rd                           ;//(i) Open file
    integer                             file_dram5_rd                           ;//(i) Open file
    integer                             file_dram6_rd                           ;//(i) Open file
    integer                             file_dram7_rd                           ;//(i) Open file

    integer                             cmd_line              = 1               ;//(i) Commond line
    integer                             file_line             = 1               ;//(i) File line
    integer                             tb_number             = 1               ;//(i) Test bench number
    //file control
    reg         [  8*20:1]              operation                               ;//(r) Operation prompt message
    reg         [   1:160]              cmd                   [1:8192]          ;//(r) Commond data (one line)
    reg         [   1: 32]              file_bram0_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram1_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram2_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram3_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram4_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram5_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram6_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram7_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram0_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram1_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram2_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram3_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram4_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram5_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram6_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 32]              file_bram7_exp        [1:8192]          ;//(r) Read file

    reg         [   1: 64]              file_dram0_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram1_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram2_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram3_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram4_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram5_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram6_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram7_wr         [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram0_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram1_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram2_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram3_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram4_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram5_exp        [1:8192]          ;//(r) Read file
    reg         [   1: 64]              file_dram6_exp        [1:8192]          ;//(r) Read file
    reg                                 simend                = 0               ;//(r) Simend

    //command control
    reg         [     7:0]              r_cmd                                   ;//(r) Commond
    reg         [     7:0]              r_vb1                                   ;//(r) Variable 1
    reg         [    15:0]              r_vb2                                   ;//(r) Variable 2
    reg         [    31:0]              r_vb3                                   ;//(r) Variable 3
    reg         [    31:0]              r_vb4                                   ;//(r) Variable 4
    reg         [    31:0]              r_vb5                                   ;//(r) Variable 5
    reg         [    31:0]              r_vb6                                   ;//(r) Variable 6

    //clk&rst
    reg                                 r_CLK0                                  ;//(r) Clock 0
    reg                                 r_CLK1                                  ;//(r) Clock 1
    reg                                 r_CLK2                                  ;//(r) Clock 2
    reg                                 r_CLK3                                  ;//(r) Clock 3
    reg                                 r_XRST0                                 ;//(r) Reset 0
    reg                                 r_XRST1                                 ;//(r) Reset 1
    reg                                 r_XRST2                                 ;//(r) Reset 2
    reg                                 r_XRST3                                 ;//(r) Reset 3
    reg         [     7:0]              r_DIPSW                                 ;//(r)
    reg         [     7:0]              r_PSHSW                                 ;//(r)
    reg         [     3:0]              r_CLKEN                                 ;//(r)

    reg         [     7:0]              r_TRIG_RX                               ;//(r)
    reg         [     7:0]              r_TRIG_TX                               ;//(r)
    reg                                 r_TRIG_LD                               ;//(r)
    reg         [     7:0]              r_TIME_CNT                              ;//(r)
    reg                                 r_TIME_OUT                              ;//(r)

    reg                                 r_LBUS_CS                               ;//(r)
    reg                                 r_LBUS_RD                               ;//(r)
    reg                                 r_LBUS_WR                               ;//(r)
    reg         [    12:0]              r_LBUS_ADDR                             ;//(r)
    reg         [    31:0]              r_LBUS_DOFF                             ;//(r)
    reg         [    31:0]              r_LBUS_DIFF                             ;//(r)
    wire        [    31:0]              s_LBUS_DIFF                             ;//(r)
    reg                                 r_LBUS_DTFF                             ;//(r)

    reg                                 r_SOFT_START                            ;//(r)
    reg                                 r_TOAL_START                            ;//(r)
    reg                                 r_FAIL_O                                ;//(r)
    reg                                 r_FAIL_I                                ;//(r)

    //register
    reg         [     7:0]              r_REG_CH_SEL                            ;//(r) Register channel select
    reg         [     9:0]              r_REG_OP_ADDR                           ;//(r) Register operation address
    reg                                 r_REG_WR_REQ                            ;//(r) Register write request
    reg         [    31:0]              r_REG_WR_DATA                           ;//(r) Register write data
    reg                                 r_REG_WR_ERR                            ;//(r) Register write error
    reg                                 r_REG_RD_REQ                            ;//(r) Register read request
    reg         [    31:0]              r_REG_RD_DATA                           ;//(r) Register read data
    reg                                 r_REG_RD_ERR                            ;//(r) Register read error

    wire                                s_REG_RD_ACK                            ;//(s) Register read request
    wire                                s_REG_WR_ACK                            ;//(s) Register write request
    wire        [    31:0]              s_REG_RD_DATA                           ;//(s) Register read data

    reg         [     7:0]              r_BRAM_CH_SEL                           ;//(r) BRAM channel select
    reg                                 r_BRAM_WR_REQ                           ;//(r) BRAM write request
    reg         [    15:0]              r_BRAM_WR_ADDR                          ;//(r) BRAM write address
    reg         [    31:0]              r_BRAM_WR_DATA                          ;//(r) BRAM write data
    reg                                 r_BRAM_WR_ERR                           ;//(r) BRAM write error
    wire                                s_BRAM_WR_ACK                           ;//(s) Register write request

    reg                                 r_BRAM_RD_REQ                           ;//(r) BRAM read request
    reg         [    15:0]              r_BRAM_RD_ADDR                          ;//(r) BRAM read address
    reg         [    31:0]              r_BRAM_RD_DATA                          ;//(r) BRAM read data
    reg         [    31:0]              r_BRAM_RD_EXPD                          ;//(r) BRAM read
    reg                                 r_BRAM_RD_ERR                           ;//(r) BRAM read
    wire                                s_BRAM_RD_ACK                           ;//(s) Register read request
    wire        [    31:0]              s_BRAM_RD_DATA                          ;//(s) Register read data

    reg         [     6:0]              r_DRAM_CH_SEL                           ;//(r) DRAM channel select
    reg                                 r_DRAM_WR_REQ                           ;//(r) DRAM write request
    reg         [    31:0]              r_DRAM_WR_ADDR                          ;//(r) DRAM write address
    reg         [    31:0]              r_DRAM_WR_SIZE                          ;//(r) DRAM write size
    reg                                 r_DRAM_WR_SOP                           ;//(r) DRAM write start of packet
    reg                                 r_DRAM_WR_EOP                           ;//(r) DRAM write end of packet
    reg                                 r_DRAM_WR_DVLD                          ;//(r) DRAM write data valid
    reg         [    63:0]              r_DRAM_WR_DATA                          ;//(r) DRAM write data
    reg                                 r_DRAM_WR_ERR                           ;//(r) DRAM write error

    reg                                 r_DRAM_RD_REQ                           ;//(r) DRAM read request
    reg         [    31:0]              r_DRAM_RD_ADDR                          ;//(r) DRAM read address
    reg         [    31:0]              r_DRAM_RD_SIZE                          ;//(r) DRAM read size
    reg                                 r_DRAM_RD_SOP                           ;//(r) DRAM read start of packet
    reg                                 r_DRAM_RD_EOP                           ;//(r) DRAM read end of packet
    reg                                 r_DRAM_RD_DVLD                          ;//(r) DRAM read data valid
    reg         [    31:0]              r_DRAM_RD_DATA                          ;//(r) DRAM read data
    reg                                 r_DRAM_RD_END                           ;//(r) DRAM read read end
    reg         [    31:0]              r_DRAM_RD_EXPD                          ;//(r) DRAM read read exp data
    reg         [    11:0]              r_DRAM_RD_DCNT                          ;//(r) DRAM read data count
    reg                                 r_DRAM_RD_ERR                           ;//(r) DRAM read error

    wire                                s_DRAM_RD_ACK                           ;//(s)
    wire                                s_DRAM_WR_ACK                           ;//(s)
    wire                                s_DRAM_WR_RDY                           ;//(s)
    wire                                s_DRAM_RD_SOP                           ;//(s)
    wire                                s_DRAM_RD_EOP                           ;//(s)
    wire                                s_DRAM_RD_DVLD                          ;//(s)
    wire        [    31:0]              s_DRAM_RD_DATA                          ;//(s)

    reg                                 r_LBUS_REG_RD_ERR                       ;//(r)
    reg         [    31:0]              r_LBUS_REG_RD_DATA                      ;//(r)
    reg                                 r_LBUS_BRAM_RD_ERR                      ;//(r)
    reg                                 r_LBUS_DRAM_WR_ERR                      ;//(r)
    reg                                 r_LBUS_DRAM_RD_ERR                      ;//(r)
    reg                                 r_DRAM_WR_BUSY                          ;//(r)
    reg                                 r_DRAM_RD_BUSY                          ;//(r)

    wire                                s_ERR                                   ;//(s) Error
    reg                                 r_ERR                                   ;//(r) Error

// =================================================================================================
//  Sim boday
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              output ports                                   ||
||                                                                             ||
/+=============================================================================*/

    assign #p_ODLY0  CLK0_P             =  r_CLK0                               ;//(o)  [  1]  Systerm clock 0 P
    assign #p_ODLY0  CLK0_N             = ~r_CLK0                               ;//(o)  [  1]  Systerm clock 0 N
    assign #p_ODLY0  CLK1_P             =  r_CLK1                               ;//(o)  [  1]  Systerm clock 1 P
    assign #p_ODLY0  CLK1_N             = ~r_CLK1                               ;//(o)  [  1]  Systerm clock 1 N
    assign #p_ODLY0  CLK2_P             =  r_CLK2                               ;//(o)  [  1]  Systerm clock 2 P
    assign #p_ODLY0  CLK2_N             = ~r_CLK2                               ;//(o)  [  1]  Systerm clock 2 N
    assign #p_ODLY0  CLK3_P             =  r_CLK3                               ;//(o)  [  1]  Systerm clock 3 P
    assign #p_ODLY0  CLK3_N             = ~r_CLK3                               ;//(o)  [  1]  Systerm clock 3 N

    assign #p_ODLY0  XRST0              = r_XRST0                               ;//(o)  [  1]  Reset 0 (low active)
    assign #p_ODLY0  XRST1              = r_XRST1                               ;//(o)  [  1]  Reset 1 (low active)
    assign #p_ODLY0  XRST2              = r_XRST2                               ;//(o)  [  1]  Reset 2 (low active)
    assign #p_ODLY0  XRST3              = r_XRST3                               ;//(o)  [  1]  Reset 3 (low active)

    assign #p_ODLY0  DIP_SW             = r_DIPSW                               ;//(o)  [  8]  Dipswitch
    assign #p_ODLY0  PSH_SW             = r_PSHSW                               ;//(o)  [  8]  Pushswitch  (low active)

    assign #p_ODLY0  TRIG_TX_P[0]       = r_TRIG_TX                             ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_P[1]       = r_TRIG_TX                             ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_P[2]       = r_TRIG_TX                             ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_P[3]       = r_TRIG_TX                             ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_P[4]       = r_TRIG_TX                             ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_P[5]       = r_TRIG_TX                             ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_P[6]       = r_TRIG_TX                             ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_P[7]       = r_TRIG_TX                             ;//(o)  [  1]  Trig tx

    assign #p_ODLY0  TRIG_TX_N[0]       = ~ r_TRIG_TX                           ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_N[1]       = ~ r_TRIG_TX                           ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_N[2]       = ~ r_TRIG_TX                           ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_N[3]       = ~ r_TRIG_TX                           ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_N[4]       = ~ r_TRIG_TX                           ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_N[5]       = ~ r_TRIG_TX                           ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_N[6]       = ~ r_TRIG_TX                           ;//(o)  [  1]  Trig tx
    assign #p_ODLY0  TRIG_TX_N[7]       = ~ r_TRIG_TX                           ;//(o)  [  1]  Trig tx

    //backplane
    assign #p_ODLY0  LBUS_CS            = r_LBUS_CS                             ;//(o)  [  1]  Local bus select
    assign #p_ODLY0  LBUS_RD            = r_LBUS_RD                             ;//(o)  [  1]  Local bus read
    assign #p_ODLY0  LBUS_WR            = r_LBUS_WR                             ;//(o)  [  1]  Local bus write
    assign #p_ODLY0  LBUS_ADDR          = r_LBUS_ADDR                           ;//(o)  [ 13]  Local bus address

    assign #p_ODLY0  LBUS_DATA          = (r_LBUS_DTFF) ? r_LBUS_DOFF : 32'hz   ;//(io) [ 32]  Local bus data
    assign #p_ODLY0  s_LBUS_DIFF        = LBUS_DATA                             ;//(io) [ 32]  Local bus data

    pullup                              (LBUS_DATA[00])                         ;
    pullup                              (LBUS_DATA[01])                         ;
    pullup                              (LBUS_DATA[02])                         ;
    pullup                              (LBUS_DATA[03])                         ;
    pullup                              (LBUS_DATA[04])                         ;
    pullup                              (LBUS_DATA[05])                         ;
    pullup                              (LBUS_DATA[06])                         ;
    pullup                              (LBUS_DATA[07])                         ;
    pullup                              (LBUS_DATA[08])                         ;
    pullup                              (LBUS_DATA[09])                         ;
    pullup                              (LBUS_DATA[10])                         ;
    pullup                              (LBUS_DATA[11])                         ;
    pullup                              (LBUS_DATA[12])                         ;
    pullup                              (LBUS_DATA[13])                         ;
    pullup                              (LBUS_DATA[14])                         ;
    pullup                              (LBUS_DATA[15])                         ;
    pullup                              (LBUS_DATA[16])                         ;
    pullup                              (LBUS_DATA[17])                         ;
    pullup                              (LBUS_DATA[18])                         ;
    pullup                              (LBUS_DATA[19])                         ;
    pullup                              (LBUS_DATA[20])                         ;
    pullup                              (LBUS_DATA[21])                         ;
    pullup                              (LBUS_DATA[22])                         ;
    pullup                              (LBUS_DATA[23])                         ;
    pullup                              (LBUS_DATA[24])                         ;
    pullup                              (LBUS_DATA[25])                         ;
    pullup                              (LBUS_DATA[26])                         ;
    pullup                              (LBUS_DATA[27])                         ;
    pullup                              (LBUS_DATA[28])                         ;
    pullup                              (LBUS_DATA[29])                         ;
    pullup                              (LBUS_DATA[30])                         ;
    pullup                              (LBUS_DATA[31])                         ;


    assign #p_ODLY0  SOFT_START         = r_SOFT_START                          ;//(o)  [  1]  Softwart start
    assign #p_ODLY0  TOAL_START         = r_TOAL_START                          ;//(o)  [  1]  Total start
    assign #p_ODLY0  FAIL_O             = r_FAIL_O                              ;//(o)  [  1]  Fail output

    assign #p_ODLY0  REG0_WR_REQ        = r_REG_WR_REQ      & r_REG_CH_SEL[0]   ;//(o)  [  1]  Register write request
    assign #p_ODLY0  REG0_RD_REQ        = r_REG_RD_REQ      & r_REG_CH_SEL[0]   ;//(o)  [  1]  Register read request
    assign #p_ODLY0  REG0_WR_DATA       = r_REG_WR_DATA                         ;//(o)  [ 32]  Register write data
    assign #p_ODLY0  REG0_OP_ADDR       = r_REG_OP_ADDR                         ;//(o)  [ 10]  Register operation address

    assign #p_ODLY0  REG1_WR_REQ        = r_REG_WR_REQ      & r_REG_CH_SEL[1]   ;//(o)  [  1]  Register write request
    assign #p_ODLY0  REG1_RD_REQ        = r_REG_RD_REQ      & r_REG_CH_SEL[1]   ;//(o)  [  1]  Register read request
    assign #p_ODLY0  REG1_WR_DATA       = r_REG_WR_DATA                         ;//(o)  [ 32]  Register write data
    assign #p_ODLY0  REG1_OP_ADDR       = r_REG_OP_ADDR                         ;//(o)  [ 10]  Register operation address

    assign #p_ODLY0  REG2_WR_REQ        = r_REG_WR_REQ      & r_REG_CH_SEL[2]   ;//(o)  [  1]  Register write request
    assign #p_ODLY0  REG2_RD_REQ        = r_REG_RD_REQ      & r_REG_CH_SEL[2]   ;//(o)  [  1]  Register read request
    assign #p_ODLY0  REG2_WR_DATA       = r_REG_WR_DATA                         ;//(o)  [ 32]  Register write data
    assign #p_ODLY0  REG2_OP_ADDR       = r_REG_OP_ADDR                         ;//(o)  [ 10]  Register operation address

    assign #p_ODLY0  REG3_WR_REQ        = r_REG_WR_REQ      & r_REG_CH_SEL[3]   ;//(o)  [  1]  Register write request
    assign #p_ODLY0  REG3_RD_REQ        = r_REG_RD_REQ      & r_REG_CH_SEL[3]   ;//(o)  [  1]  Register read request
    assign #p_ODLY0  REG3_WR_DATA       = r_REG_WR_DATA                         ;//(o)  [ 32]  Register write data
    assign #p_ODLY0  REG3_OP_ADDR       = r_REG_OP_ADDR                         ;//(o)  [ 10]  Register operation address

    assign #p_ODLY0  REG4_WR_REQ        = r_REG_WR_REQ      & r_REG_CH_SEL[4]   ;//(o)  [  1]  Register write request
    assign #p_ODLY0  REG4_RD_REQ        = r_REG_RD_REQ      & r_REG_CH_SEL[4]   ;//(o)  [  1]  Register read request
    assign #p_ODLY0  REG4_WR_DATA       = r_REG_WR_DATA                         ;//(o)  [ 32]  Register write data
    assign #p_ODLY0  REG4_OP_ADDR       = r_REG_OP_ADDR                         ;//(o)  [ 10]  Register operation address

    assign #p_ODLY0  REG5_WR_REQ        = r_REG_WR_REQ      & r_REG_CH_SEL[5]   ;//(o)  [  1]  Register write request
    assign #p_ODLY0  REG5_RD_REQ        = r_REG_RD_REQ      & r_REG_CH_SEL[5]   ;//(o)  [  1]  Register read request
    assign #p_ODLY0  REG5_WR_DATA       = r_REG_WR_DATA                         ;//(o)  [ 32]  Register write data
    assign #p_ODLY0  REG5_OP_ADDR       = r_REG_OP_ADDR                         ;//(o)  [ 10]  Register operation address

    assign #p_ODLY0  REG6_WR_REQ        = r_REG_WR_REQ      & r_REG_CH_SEL[6]   ;//(o)  [  1]  Register write request
    assign #p_ODLY0  REG6_RD_REQ        = r_REG_RD_REQ      & r_REG_CH_SEL[6]   ;//(o)  [  1]  Register read request
    assign #p_ODLY0  REG6_WR_DATA       = r_REG_WR_DATA                         ;//(o)  [ 32]  Register write data
    assign #p_ODLY0  REG6_OP_ADDR       = r_REG_OP_ADDR                         ;//(o)  [ 10]  Register operation address

    assign #p_ODLY0  REG7_WR_REQ        = r_REG_WR_REQ      & r_REG_CH_SEL[7]   ;//(o)  [  1]  Register write request
    assign #p_ODLY0  REG7_RD_REQ        = r_REG_RD_REQ      & r_REG_CH_SEL[7]   ;//(o)  [  1]  Register read request
    assign #p_ODLY0  REG7_WR_DATA       = r_REG_WR_DATA                         ;//(o)  [ 32]  Register write data
    assign #p_ODLY0  REG7_OP_ADDR       = r_REG_OP_ADDR                         ;//(o)  [ 10]  Register operation address

    assign #p_ODLY0  BRAM0_WR_REQ       = r_BRAM_WR_REQ     & r_BRAM_CH_SEL[0]  ;//(o)  [  1]  BRAM write request
    assign #p_ODLY0  BRAM0_WR_ADDR      = r_BRAM_WR_ADDR                        ;//(o)  [ 16]  BRAM write address
    assign #p_ODLY0  BRAM0_WR_DATA      = r_BRAM_WR_DATA                        ;//(o)  [ 32]  BRAM write data
    assign #p_ODLY0  BRAM0_RD_REQ       = r_BRAM_RD_REQ     & r_BRAM_CH_SEL[0]  ;//(o)  [  1]  BRAM read request
    assign #p_ODLY0  BRAM0_RD_ADDR      = r_BRAM_RD_ADDR                        ;//(o)  [ 16]  BRAM read address

    assign #p_ODLY0  BRAM1_WR_REQ       = r_BRAM_WR_REQ     & r_BRAM_CH_SEL[1]  ;//(o)  [  1]  BRAM write request
    assign #p_ODLY0  BRAM1_WR_ADDR      = r_BRAM_WR_ADDR                        ;//(o)  [ 16]  BRAM write address
    assign #p_ODLY0  BRAM1_WR_DATA      = r_BRAM_WR_DATA                        ;//(o)  [ 32]  BRAM write data
    assign #p_ODLY0  BRAM1_RD_REQ       = r_BRAM_RD_REQ     & r_BRAM_CH_SEL[1]  ;//(o)  [  1]  BRAM read request
    assign #p_ODLY0  BRAM1_RD_ADDR      = r_BRAM_RD_ADDR                        ;//(o)  [ 16]  BRAM read address

    assign #p_ODLY0  BRAM2_WR_REQ       = r_BRAM_WR_REQ     & r_BRAM_CH_SEL[2]  ;//(o)  [  1]  BRAM write request
    assign #p_ODLY0  BRAM2_WR_ADDR      = r_BRAM_WR_ADDR                        ;//(o)  [ 16]  BRAM write address
    assign #p_ODLY0  BRAM2_WR_DATA      = r_BRAM_WR_DATA                        ;//(o)  [ 32]  BRAM write data
    assign #p_ODLY0  BRAM2_RD_REQ       = r_BRAM_RD_REQ     & r_BRAM_CH_SEL[2]  ;//(o)  [  1]  BRAM read request
    assign #p_ODLY0  BRAM2_RD_ADDR      = r_BRAM_RD_ADDR                        ;//(o)  [ 16]  BRAM read address

    assign #p_ODLY0  BRAM3_WR_REQ       = r_BRAM_WR_REQ     & r_BRAM_CH_SEL[3]  ;//(o)  [  1]  BRAM write request
    assign #p_ODLY0  BRAM3_WR_ADDR      = r_BRAM_WR_ADDR                        ;//(o)  [ 16]  BRAM write address
    assign #p_ODLY0  BRAM3_WR_DATA      = r_BRAM_WR_DATA                        ;//(o)  [ 32]  BRAM write data
    assign #p_ODLY0  BRAM3_RD_REQ       = r_BRAM_RD_REQ     & r_BRAM_CH_SEL[3]  ;//(o)  [  1]  BRAM read request
    assign #p_ODLY0  BRAM3_RD_ADDR      = r_BRAM_RD_ADDR                        ;//(o)  [ 16]  BRAM read address

    assign #p_ODLY0  BRAM4_WR_REQ       = r_BRAM_WR_REQ     & r_BRAM_CH_SEL[4]  ;//(o)  [  1]  BRAM write request
    assign #p_ODLY0  BRAM4_WR_ADDR      = r_BRAM_WR_ADDR                        ;//(o)  [ 16]  BRAM write address
    assign #p_ODLY0  BRAM4_WR_DATA      = r_BRAM_WR_DATA                        ;//(o)  [ 32]  BRAM write data
    assign #p_ODLY0  BRAM4_RD_REQ       = r_BRAM_RD_REQ     & r_BRAM_CH_SEL[4]  ;//(o)  [  1]  BRAM read request
    assign #p_ODLY0  BRAM4_RD_ADDR      = r_BRAM_RD_ADDR                        ;//(o)  [ 16]  BRAM read address

    assign #p_ODLY0  BRAM5_WR_REQ       = r_BRAM_WR_REQ     & r_BRAM_CH_SEL[5]  ;//(o)  [  1]  BRAM write request
    assign #p_ODLY0  BRAM5_WR_ADDR      = r_BRAM_WR_ADDR                        ;//(o)  [ 16]  BRAM write address
    assign #p_ODLY0  BRAM5_WR_DATA      = r_BRAM_WR_DATA                        ;//(o)  [ 32]  BRAM write data
    assign #p_ODLY0  BRAM5_RD_REQ       = r_BRAM_RD_REQ     & r_BRAM_CH_SEL[5]  ;//(o)  [  1]  BRAM read request
    assign #p_ODLY0  BRAM5_RD_ADDR      = r_BRAM_RD_ADDR                        ;//(o)  [ 16]  BRAM read address

    assign #p_ODLY0  BRAM6_WR_REQ       = r_BRAM_WR_REQ     & r_BRAM_CH_SEL[6]  ;//(o)  [  1]  BRAM write request
    assign #p_ODLY0  BRAM6_WR_ADDR      = r_BRAM_WR_ADDR                        ;//(o)  [ 16]  BRAM write address
    assign #p_ODLY0  BRAM6_WR_DATA      = r_BRAM_WR_DATA                        ;//(o)  [ 32]  BRAM write data
    assign #p_ODLY0  BRAM6_RD_REQ       = r_BRAM_RD_REQ     & r_BRAM_CH_SEL[6]  ;//(o)  [  1]  BRAM read request
    assign #p_ODLY0  BRAM6_RD_ADDR      = r_BRAM_RD_ADDR                        ;//(o)  [ 16]  BRAM read address

    assign #p_ODLY0  BRAM7_WR_REQ       = r_BRAM_WR_REQ     & r_BRAM_CH_SEL[7]  ;//(o)  [  1]  BRAM write request
    assign #p_ODLY0  BRAM7_WR_ADDR      = r_BRAM_WR_ADDR                        ;//(o)  [ 16]  BRAM write address
    assign #p_ODLY0  BRAM7_WR_DATA      = r_BRAM_WR_DATA                        ;//(o)  [ 32]  BRAM write data
    assign #p_ODLY0  BRAM7_RD_REQ       = r_BRAM_RD_REQ     & r_BRAM_CH_SEL[7]  ;//(o)  [  1]  BRAM read request
    assign #p_ODLY0  BRAM7_RD_ADDR      = r_BRAM_RD_ADDR                        ;//(o)  [ 16]  BRAM read address

    assign #p_ODLY0  DRAM0_WR_REQ       = r_DRAM_WR_REQ     & r_DRAM_CH_SEL[0]  ;//(o)  [  1]  SDRAM write request
    assign #p_ODLY0  DRAM0_WR_ADDR      = r_DRAM_WR_ADDR                        ;//(o)  [ 25]  SDRAM write address
    assign #p_ODLY0  DRAM0_WR_SIZE      = r_DRAM_WR_SIZE                        ;//(o)  [ 12]  SDRAM write size
    assign #p_ODLY0  DRAM0_WR_SOP       = r_DRAM_WR_SOP     & r_DRAM_CH_SEL[0]  ;//(o)  [  1]  SDRAM write start of packet
    assign #p_ODLY0  DRAM0_WR_EOP       = r_DRAM_WR_EOP     & r_DRAM_CH_SEL[0]  ;//(o)  [  1]  SDRAM write end of packet
    assign #p_ODLY0  DRAM0_WR_DVLD      = r_DRAM_WR_DVLD    & r_DRAM_CH_SEL[0]  ;//(o)  [  1]  SDRAM write data valid
    assign #p_ODLY0  DRAM0_WR_DATA      = r_DRAM_WR_DATA                        ;//(o)  [ 32]  SDRAM write data
    assign #p_ODLY0  DRAM0_RD_REQ       = r_DRAM_RD_REQ     & r_DRAM_CH_SEL[0]  ;//(o)  [  1]  SDRAM read request
    assign #p_ODLY0  DRAM0_RD_ADDR      = r_DRAM_RD_ADDR                        ;//(o)  [ 25]  SDRAM read address
    assign #p_ODLY0  DRAM0_RD_SIZE      = r_DRAM_RD_SIZE                        ;//(o)  [ 12]  SDRAM read size

    assign #p_ODLY0  DRAM1_WR_REQ       = r_DRAM_WR_REQ     & r_DRAM_CH_SEL[1]  ;//(o)  [  1]  SDRAM write request
    assign #p_ODLY0  DRAM1_WR_ADDR      = r_DRAM_WR_ADDR                        ;//(o)  [ 25]  SDRAM write address
    assign #p_ODLY0  DRAM1_WR_SIZE      = r_DRAM_WR_SIZE                        ;//(o)  [ 12]  SDRAM write size
    assign #p_ODLY0  DRAM1_WR_SOP       = r_DRAM_WR_SOP     & r_DRAM_CH_SEL[1]  ;//(o)  [  1]  SDRAM write start of packet
    assign #p_ODLY0  DRAM1_WR_EOP       = r_DRAM_WR_EOP     & r_DRAM_CH_SEL[1]  ;//(o)  [  1]  SDRAM write end of packet
    assign #p_ODLY0  DRAM1_WR_DVLD      = r_DRAM_WR_DVLD    & r_DRAM_CH_SEL[1]  ;//(o)  [  1]  SDRAM write data valid
    assign #p_ODLY0  DRAM1_WR_DATA      = r_DRAM_WR_DATA                        ;//(o)  [ 32]  SDRAM write data
    assign #p_ODLY0  DRAM1_RD_REQ       = r_DRAM_RD_REQ     & r_DRAM_CH_SEL[1]  ;//(o)  [  1]  SDRAM read request
    assign #p_ODLY0  DRAM1_RD_ADDR      = r_DRAM_RD_ADDR                        ;//(o)  [ 25]  SDRAM read address
    assign #p_ODLY0  DRAM1_RD_SIZE      = r_DRAM_RD_SIZE                        ;//(o)  [ 12]  SDRAM read size

    assign #p_ODLY0  DRAM2_WR_REQ       = r_DRAM_WR_REQ     & r_DRAM_CH_SEL[2]  ;//(o)  [  1]  SDRAM write request
    assign #p_ODLY0  DRAM2_WR_ADDR      = r_DRAM_WR_ADDR                        ;//(o)  [ 25]  SDRAM write address
    assign #p_ODLY0  DRAM2_WR_SIZE      = r_DRAM_WR_SIZE                        ;//(o)  [ 12]  SDRAM write size
    assign #p_ODLY0  DRAM2_WR_SOP       = r_DRAM_WR_SOP     & r_DRAM_CH_SEL[2]  ;//(o)  [  1]  SDRAM write start of packet
    assign #p_ODLY0  DRAM2_WR_EOP       = r_DRAM_WR_EOP     & r_DRAM_CH_SEL[2]  ;//(o)  [  1]  SDRAM write end of packet
    assign #p_ODLY0  DRAM2_WR_DVLD      = r_DRAM_WR_DVLD    & r_DRAM_CH_SEL[2]  ;//(o)  [  1]  SDRAM write data valid
    assign #p_ODLY0  DRAM2_WR_DATA      = r_DRAM_WR_DATA                        ;//(o)  [ 32]  SDRAM write data
    assign #p_ODLY0  DRAM2_RD_REQ       = r_DRAM_RD_REQ     & r_DRAM_CH_SEL[2]  ;//(o)  [  1]  SDRAM read request
    assign #p_ODLY0  DRAM2_RD_ADDR      = r_DRAM_RD_ADDR                        ;//(o)  [ 25]  SDRAM read address
    assign #p_ODLY0  DRAM2_RD_SIZE      = r_DRAM_RD_SIZE                        ;//(o)  [ 12]  SDRAM read size

    assign #p_ODLY0  DRAM3_WR_REQ       = r_DRAM_WR_REQ     & r_DRAM_CH_SEL[3]  ;//(o)  [  1]  SDRAM write request
    assign #p_ODLY0  DRAM3_WR_ADDR      = r_DRAM_WR_ADDR                        ;//(o)  [ 25]  SDRAM write address
    assign #p_ODLY0  DRAM3_WR_SIZE      = r_DRAM_WR_SIZE                        ;//(o)  [ 12]  SDRAM write size
    assign #p_ODLY0  DRAM3_WR_SOP       = r_DRAM_WR_SOP     & r_DRAM_CH_SEL[3]  ;//(o)  [  1]  SDRAM write start of packet
    assign #p_ODLY0  DRAM3_WR_EOP       = r_DRAM_WR_EOP     & r_DRAM_CH_SEL[3]  ;//(o)  [  1]  SDRAM write end of packet
    assign #p_ODLY0  DRAM3_WR_DVLD      = r_DRAM_WR_DVLD    & r_DRAM_CH_SEL[3]  ;//(o)  [  1]  SDRAM write data valid
    assign #p_ODLY0  DRAM3_WR_DATA      = r_DRAM_WR_DATA                        ;//(o)  [ 32]  SDRAM write data
    assign #p_ODLY0  DRAM3_RD_REQ       = r_DRAM_RD_REQ     & r_DRAM_CH_SEL[3]  ;//(o)  [  1]  SDRAM read request
    assign #p_ODLY0  DRAM3_RD_ADDR      = r_DRAM_RD_ADDR                        ;//(o)  [ 25]  SDRAM read address
    assign #p_ODLY0  DRAM3_RD_SIZE      = r_DRAM_RD_SIZE                        ;//(o)  [ 12]  SDRAM read size

    assign #p_ODLY0  DRAM4_WR_REQ       = r_DRAM_WR_REQ     & r_DRAM_CH_SEL[4]  ;//(o)  [  1]  SDRAM write request
    assign #p_ODLY0  DRAM4_WR_ADDR      = r_DRAM_WR_ADDR                        ;//(o)  [ 25]  SDRAM write address
    assign #p_ODLY0  DRAM4_WR_SIZE      = r_DRAM_WR_SIZE                        ;//(o)  [ 12]  SDRAM write size
    assign #p_ODLY0  DRAM4_WR_SOP       = r_DRAM_WR_SOP     & r_DRAM_CH_SEL[4]  ;//(o)  [  1]  SDRAM write start of packet
    assign #p_ODLY0  DRAM4_WR_EOP       = r_DRAM_WR_EOP     & r_DRAM_CH_SEL[4]  ;//(o)  [  1]  SDRAM write end of packet
    assign #p_ODLY0  DRAM4_WR_DVLD      = r_DRAM_WR_DVLD    & r_DRAM_CH_SEL[4]  ;//(o)  [  1]  SDRAM write data valid
    assign #p_ODLY0  DRAM4_WR_DATA      = r_DRAM_WR_DATA                        ;//(o)  [ 32]  SDRAM write data
    assign #p_ODLY0  DRAM4_RD_REQ       = r_DRAM_RD_REQ     & r_DRAM_CH_SEL[4]  ;//(o)  [  1]  SDRAM read request
    assign #p_ODLY0  DRAM4_RD_ADDR      = r_DRAM_RD_ADDR                        ;//(o)  [ 25]  SDRAM read address
    assign #p_ODLY0  DRAM4_RD_SIZE      = r_DRAM_RD_SIZE                        ;//(o)  [ 12]  SDRAM read size

    assign #p_ODLY0  DRAM5_WR_REQ       = r_DRAM_WR_REQ     & r_DRAM_CH_SEL[5]  ;//(o)  [  1]  SDRAM write request
    assign #p_ODLY0  DRAM5_WR_ADDR      = r_DRAM_WR_ADDR                        ;//(o)  [ 25]  SDRAM write address
    assign #p_ODLY0  DRAM5_WR_SIZE      = r_DRAM_WR_SIZE                        ;//(o)  [ 12]  SDRAM write size
    assign #p_ODLY0  DRAM5_WR_SOP       = r_DRAM_WR_SOP     & r_DRAM_CH_SEL[5]  ;//(o)  [  1]  SDRAM write start of packet
    assign #p_ODLY0  DRAM5_WR_EOP       = r_DRAM_WR_EOP     & r_DRAM_CH_SEL[5]  ;//(o)  [  1]  SDRAM write end of packet
    assign #p_ODLY0  DRAM5_WR_DVLD      = r_DRAM_WR_DVLD    & r_DRAM_CH_SEL[5]  ;//(o)  [  1]  SDRAM write data valid
    assign #p_ODLY0  DRAM5_WR_DATA      = r_DRAM_WR_DATA                        ;//(o)  [ 32]  SDRAM write data
    assign #p_ODLY0  DRAM5_RD_REQ       = r_DRAM_RD_REQ     & r_DRAM_CH_SEL[5]  ;//(o)  [  1]  SDRAM read request
    assign #p_ODLY0  DRAM5_RD_ADDR      = r_DRAM_RD_ADDR                        ;//(o)  [ 25]  SDRAM read address
    assign #p_ODLY0  DRAM5_RD_SIZE      = r_DRAM_RD_SIZE                        ;//(o)  [ 12]  SDRAM read size

    assign #p_ODLY0  DRAM6_WR_REQ       = r_DRAM_WR_REQ     & r_DRAM_CH_SEL[6]  ;//(o)  [  1]  SDRAM write request
    assign #p_ODLY0  DRAM6_WR_ADDR      = r_DRAM_WR_ADDR                        ;//(o)  [ 25]  SDRAM write address
    assign #p_ODLY0  DRAM6_WR_SIZE      = r_DRAM_WR_SIZE                        ;//(o)  [ 12]  SDRAM write size
    assign #p_ODLY0  DRAM6_WR_SOP       = r_DRAM_WR_SOP     & r_DRAM_CH_SEL[6]  ;//(o)  [  1]  SDRAM write start of packet
    assign #p_ODLY0  DRAM6_WR_EOP       = r_DRAM_WR_EOP     & r_DRAM_CH_SEL[6]  ;//(o)  [  1]  SDRAM write end of packet
    assign #p_ODLY0  DRAM6_WR_DVLD      = r_DRAM_WR_DVLD    & r_DRAM_CH_SEL[6]  ;//(o)  [  1]  SDRAM write data valid
    assign #p_ODLY0  DRAM6_WR_DATA      = r_DRAM_WR_DATA                        ;//(o)  [ 32]  SDRAM write data
    assign #p_ODLY0  DRAM6_RD_REQ       = r_DRAM_RD_REQ     & r_DRAM_CH_SEL[6]  ;//(o)  [  1]  SDRAM read request
    assign #p_ODLY0  DRAM6_RD_ADDR      = r_DRAM_RD_ADDR                        ;//(o)  [ 25]  SDRAM read address
    assign #p_ODLY0  DRAM6_RD_SIZE      = r_DRAM_RD_SIZE                        ;//(o)  [ 12]  SDRAM read size

    assign #p_ODLY0  DRAM0_RD_RDY       = 1'b1                                  ;//(o)  [  1]  SDRAM read ready
    assign #p_ODLY0  DRAM1_RD_RDY       = 1'b1                                  ;//(o)  [  1]  SDRAM read ready
    assign #p_ODLY0  DRAM2_RD_RDY       = 1'b1                                  ;//(o)  [  1]  SDRAM read ready
    assign #p_ODLY0  DRAM3_RD_RDY       = 1'b1                                  ;//(o)  [  1]  SDRAM read ready
    assign #p_ODLY0  DRAM4_RD_RDY       = 1'b1                                  ;//(o)  [  1]  SDRAM read ready
    assign #p_ODLY0  DRAM5_RD_RDY       = 1'b1                                  ;//(o)  [  1]  SDRAM read ready
    assign #p_ODLY0  DRAM6_RD_RDY       = 1'b1                                  ;//(o)  [  1]  SDRAM read ready

    assign #p_ODLY0  SIM_END            = simend                                ;//(o)  [  1]  Sim end

/*============================================================================+/
||                                                                            ||
||                            Port Select                                     ||
||                                                                            ||
/+============================================================================*/

    assign s_REG_WR_ACK             = (r_REG_CH_SEL[0] == 1'b1) ? REG0_WR_ACK  :
                                      (r_REG_CH_SEL[1] == 1'b1) ? REG1_WR_ACK  :
                                      (r_REG_CH_SEL[2] == 1'b1) ? REG2_WR_ACK  :
                                      (r_REG_CH_SEL[3] == 1'b1) ? REG3_WR_ACK  :
                                      (r_REG_CH_SEL[4] == 1'b1) ? REG4_WR_ACK  :
                                      (r_REG_CH_SEL[5] == 1'b1) ? REG5_WR_ACK  :
                                      (r_REG_CH_SEL[6] == 1'b1) ? REG6_WR_ACK  :
                                      (r_REG_CH_SEL[7] == 1'b1) ? REG7_WR_ACK  : 1'b0 ;

    assign s_REG_RD_ACK             = (r_REG_CH_SEL[0] == 1'b1) ? REG0_RD_ACK  :
                                      (r_REG_CH_SEL[1] == 1'b1) ? REG1_RD_ACK  :
                                      (r_REG_CH_SEL[2] == 1'b1) ? REG2_RD_ACK  :
                                      (r_REG_CH_SEL[3] == 1'b1) ? REG3_RD_ACK  :
                                      (r_REG_CH_SEL[4] == 1'b1) ? REG4_RD_ACK  :
                                      (r_REG_CH_SEL[5] == 1'b1) ? REG5_RD_ACK  :
                                      (r_REG_CH_SEL[6] == 1'b1) ? REG6_RD_ACK  :
                                      (r_REG_CH_SEL[7] == 1'b1) ? REG7_RD_ACK  : 1'b0 ;

    assign s_REG_RD_DATA             = (r_REG_CH_SEL[0] == 1'b1) ? REG0_RD_DATA :
                                      (r_REG_CH_SEL[1] == 1'b1) ? REG1_RD_DATA :
                                      (r_REG_CH_SEL[2] == 1'b1) ? REG2_RD_DATA :
                                      (r_REG_CH_SEL[3] == 1'b1) ? REG3_RD_DATA :
                                      (r_REG_CH_SEL[4] == 1'b1) ? REG4_RD_DATA :
                                      (r_REG_CH_SEL[5] == 1'b1) ? REG5_RD_DATA :
                                      (r_REG_CH_SEL[6] == 1'b1) ? REG6_RD_DATA :
                                      (r_REG_CH_SEL[7] == 1'b1) ? REG7_RD_DATA : 32'b0 ;


    assign s_BRAM_WR_ACK            = (r_BRAM_CH_SEL[0] == 1'b1) ? BRAM0_WR_ACK  :
                                      (r_BRAM_CH_SEL[1] == 1'b1) ? BRAM1_WR_ACK  :
                                      (r_BRAM_CH_SEL[2] == 1'b1) ? BRAM2_WR_ACK  :
                                      (r_BRAM_CH_SEL[3] == 1'b1) ? BRAM3_WR_ACK  :
                                      (r_BRAM_CH_SEL[4] == 1'b1) ? BRAM4_WR_ACK  :
                                      (r_BRAM_CH_SEL[5] == 1'b1) ? BRAM5_WR_ACK  :
                                      (r_BRAM_CH_SEL[6] == 1'b1) ? BRAM6_WR_ACK  :
                                      (r_BRAM_CH_SEL[7] == 1'b1) ? BRAM7_WR_ACK  : 1'b0 ;

    assign s_BRAM_RD_ACK            = (r_BRAM_CH_SEL[0] == 1'b1) ? BRAM0_RD_ACK  :
                                      (r_BRAM_CH_SEL[1] == 1'b1) ? BRAM1_RD_ACK  :
                                      (r_BRAM_CH_SEL[2] == 1'b1) ? BRAM2_RD_ACK  :
                                      (r_BRAM_CH_SEL[3] == 1'b1) ? BRAM3_RD_ACK  :
                                      (r_BRAM_CH_SEL[4] == 1'b1) ? BRAM4_RD_ACK  :
                                      (r_BRAM_CH_SEL[5] == 1'b1) ? BRAM5_RD_ACK  :
                                      (r_BRAM_CH_SEL[6] == 1'b1) ? BRAM6_RD_ACK  :
                                      (r_BRAM_CH_SEL[7] == 1'b1) ? BRAM7_RD_ACK  : 1'b0 ;

    assign s_BRAM_RD_DATA           = (r_BRAM_CH_SEL[0] == 1'b1) ? BRAM0_RD_DATA :
                                      (r_BRAM_CH_SEL[1] == 1'b1) ? BRAM1_RD_DATA :
                                      (r_BRAM_CH_SEL[2] == 1'b1) ? BRAM2_RD_DATA :
                                      (r_BRAM_CH_SEL[3] == 1'b1) ? BRAM3_RD_DATA :
                                      (r_BRAM_CH_SEL[4] == 1'b1) ? BRAM4_RD_DATA :
                                      (r_BRAM_CH_SEL[5] == 1'b1) ? BRAM5_RD_DATA :
                                      (r_BRAM_CH_SEL[6] == 1'b1) ? BRAM6_RD_DATA :
                                      (r_BRAM_CH_SEL[7] == 1'b1) ? BRAM7_RD_DATA : 32'b0 ;


    assign s_DRAM_RD_ACK            = (r_DRAM_CH_SEL[0] == 1'b1) ? DRAM0_RD_ACK :
                                      (r_DRAM_CH_SEL[1] == 1'b1) ? DRAM1_RD_ACK :
                                      (r_DRAM_CH_SEL[2] == 1'b1) ? DRAM2_RD_ACK :
                                      (r_DRAM_CH_SEL[3] == 1'b1) ? DRAM3_RD_ACK :
                                      (r_DRAM_CH_SEL[4] == 1'b1) ? DRAM4_RD_ACK :
                                      (r_DRAM_CH_SEL[5] == 1'b1) ? DRAM5_RD_ACK :
                                      (r_DRAM_CH_SEL[6] == 1'b1) ? DRAM6_RD_ACK : 1'b0 ;

    assign s_DRAM_WR_ACK            = (r_DRAM_CH_SEL[0] == 1'b1) ? DRAM0_WR_ACK :
                                      (r_DRAM_CH_SEL[1] == 1'b1) ? DRAM1_WR_ACK :
                                      (r_DRAM_CH_SEL[2] == 1'b1) ? DRAM2_WR_ACK :
                                      (r_DRAM_CH_SEL[3] == 1'b1) ? DRAM3_WR_ACK :
                                      (r_DRAM_CH_SEL[4] == 1'b1) ? DRAM4_WR_ACK :
                                      (r_DRAM_CH_SEL[5] == 1'b1) ? DRAM5_WR_ACK :
                                      (r_DRAM_CH_SEL[6] == 1'b1) ? DRAM6_WR_ACK : 1'b0 ;

    assign s_DRAM_WR_RDY            = (r_DRAM_CH_SEL[0] == 1'b1) ? DRAM0_WR_RDY :
                                      (r_DRAM_CH_SEL[1] == 1'b1) ? DRAM1_WR_RDY :
                                      (r_DRAM_CH_SEL[2] == 1'b1) ? DRAM2_WR_RDY :
                                      (r_DRAM_CH_SEL[3] == 1'b1) ? DRAM3_WR_RDY :
                                      (r_DRAM_CH_SEL[4] == 1'b1) ? DRAM4_WR_RDY :
                                      (r_DRAM_CH_SEL[5] == 1'b1) ? DRAM5_WR_RDY :
                                      (r_DRAM_CH_SEL[6] == 1'b1) ? DRAM6_WR_RDY : 1'b0 ;


    assign s_DRAM_RD_SOP            = (r_DRAM_CH_SEL[0] == 1'b1) ? DRAM0_RD_SOP :
                                      (r_DRAM_CH_SEL[1] == 1'b1) ? DRAM1_RD_SOP :
                                      (r_DRAM_CH_SEL[2] == 1'b1) ? DRAM2_RD_SOP :
                                      (r_DRAM_CH_SEL[3] == 1'b1) ? DRAM3_RD_SOP :
                                      (r_DRAM_CH_SEL[4] == 1'b1) ? DRAM4_RD_SOP :
                                      (r_DRAM_CH_SEL[5] == 1'b1) ? DRAM5_RD_SOP :
                                      (r_DRAM_CH_SEL[6] == 1'b1) ? DRAM6_RD_SOP : 1'b0 ;

    assign s_DRAM_RD_EOP            = (r_DRAM_CH_SEL[0] == 1'b1) ? DRAM0_RD_EOP :
                                      (r_DRAM_CH_SEL[1] == 1'b1) ? DRAM1_RD_EOP :
                                      (r_DRAM_CH_SEL[2] == 1'b1) ? DRAM2_RD_EOP :
                                      (r_DRAM_CH_SEL[3] == 1'b1) ? DRAM3_RD_EOP :
                                      (r_DRAM_CH_SEL[4] == 1'b1) ? DRAM4_RD_EOP :
                                      (r_DRAM_CH_SEL[5] == 1'b1) ? DRAM5_RD_EOP :
                                      (r_DRAM_CH_SEL[6] == 1'b1) ? DRAM6_RD_EOP : 1'b0 ;

    assign s_DRAM_RD_DVLD           = (r_DRAM_CH_SEL[0] == 1'b1) ? DRAM0_RD_DVLD :
                                      (r_DRAM_CH_SEL[1] == 1'b1) ? DRAM1_RD_DVLD :
                                      (r_DRAM_CH_SEL[2] == 1'b1) ? DRAM2_RD_DVLD :
                                      (r_DRAM_CH_SEL[3] == 1'b1) ? DRAM3_RD_DVLD :
                                      (r_DRAM_CH_SEL[4] == 1'b1) ? DRAM4_RD_DVLD :
                                      (r_DRAM_CH_SEL[5] == 1'b1) ? DRAM5_RD_DVLD :
                                      (r_DRAM_CH_SEL[6] == 1'b1) ? DRAM6_RD_DVLD : 1'b0 ;

    assign s_DRAM_RD_DATA           = (r_DRAM_CH_SEL[0] == 1'b1) ? DRAM0_RD_DATA :
                                      (r_DRAM_CH_SEL[1] == 1'b1) ? DRAM1_RD_DATA :
                                      (r_DRAM_CH_SEL[2] == 1'b1) ? DRAM2_RD_DATA :
                                      (r_DRAM_CH_SEL[3] == 1'b1) ? DRAM3_RD_DATA :
                                      (r_DRAM_CH_SEL[4] == 1'b1) ? DRAM4_RD_DATA :
                                      (r_DRAM_CH_SEL[5] == 1'b1) ? DRAM5_RD_DATA :
                                      (r_DRAM_CH_SEL[6] == 1'b1) ? DRAM6_RD_DATA : 32'b0 ;

/*=============================================================================+/
||                                                                             ||
||                              signal initial                                 ||
||                                                                             ||
/+=============================================================================*/

    initial begin

        r_cmd                           =    8'h0                           ; //command
        r_vb1                           =    8'h0                           ; //variable 1
        r_vb2                           =   16'h0                           ; //variable 2
        r_vb3                           =   32'h0                           ; //variable 3
        r_vb4                           =   32'h0                           ; //variable 4
        r_vb5                           =   32'h0                           ; //variable 5
        r_vb6                           =   32'h0                           ; //variable 6

        r_CLK0                          =    1'b0                           ;
        r_CLK1                          =    1'b0                           ;
        r_CLK2                          =    1'b0                           ;
        r_CLK3                          =    1'b0                           ;
        r_XRST0                         =    1'b0                           ;
        r_XRST1                         =    1'b0                           ;
        r_XRST2                         =    1'b0                           ;
        r_XRST3                         =    1'b0                           ;
        r_DIPSW                         =    8'h00                          ;
        r_PSHSW                         =    8'hFF                          ;
        r_CLKEN                         =    4'd0                           ;
        r_TRIG_RX                       =    8'h00                          ;
        r_TRIG_TX                       =    8'h00                          ;
        r_TRIG_LD                       =    1'b0                           ;
        r_TIME_CNT                      =    8'h00                          ;
        r_TIME_OUT                      =    1'b0                           ;

        r_LBUS_CS                       =    1'b1                           ;
        r_LBUS_RD                       =    1'b1                           ;
        r_LBUS_WR                       =    1'b1                           ;
        r_LBUS_ADDR                     =   13'b0                           ;
        r_LBUS_DOFF                     =   32'b0                           ;
        r_LBUS_DIFF                     =   32'b0                           ;
        r_LBUS_DTFF                     =    1'b0                           ;

        r_SOFT_START                    =    1'b0                           ;
        r_TOAL_START                    =    1'b0                           ;
        r_FAIL_O                        =    1'b0                           ;
        r_FAIL_I                        =    1'b0                           ;

        r_REG_CH_SEL                    =     'd0                           ;
        r_REG_OP_ADDR                   =     'd0                           ;
        r_REG_WR_REQ                    =     'd0                           ;
        r_REG_WR_DATA                   =     'd0                           ;
        r_REG_WR_ERR                    =     'd0                           ;
        r_REG_RD_REQ                    =     'd0                           ;
        r_REG_RD_DATA                   =     'd0                           ;
        r_REG_RD_ERR                    =     'd0                           ;

        r_BRAM_CH_SEL                   =     'd0                           ;
        r_BRAM_WR_REQ                   =     'd0                           ;
        r_BRAM_WR_ADDR                  =     'd0                           ;
        r_BRAM_WR_DATA                  =     'd0                           ;
        r_BRAM_WR_ERR                   =     'd0                           ;

        r_BRAM_RD_REQ                   =     'd0                           ;
        r_BRAM_RD_ADDR                  =     'd0                           ;
        r_BRAM_RD_DATA                  =     'd0                           ;
        r_BRAM_RD_EXPD                  =     'd0                           ;
        r_BRAM_RD_ERR                   =     'd0                           ;

        r_DRAM_CH_SEL                   =     'd0                           ;
        r_DRAM_WR_REQ                   =     'd0                           ;
        r_DRAM_WR_ADDR                  =     'd0                           ;
        r_DRAM_WR_SIZE                  =     'd0                           ;
        r_DRAM_WR_SOP                   =     'd0                           ;
        r_DRAM_WR_EOP                   =     'd0                           ;
        r_DRAM_WR_DVLD                  =     'd0                           ;
        r_DRAM_WR_DATA                  =     'd0                           ;
        r_DRAM_WR_ERR                   =     'd0                           ;

        r_DRAM_RD_REQ                   =     'd0                           ;
        r_DRAM_RD_ADDR                  =     'd0                           ;
        r_DRAM_RD_SIZE                  =     'd0                           ;
        r_DRAM_RD_SOP                   =     'd0                           ;
        r_DRAM_RD_EOP                   =     'd0                           ;
        r_DRAM_RD_DVLD                  =     'd0                           ;
        r_DRAM_RD_DATA                  =     'd0                           ;
        r_DRAM_RD_END                   =     'd0                           ;
        r_DRAM_RD_EXPD                  =     'd0                           ;
        r_DRAM_RD_DCNT                  =     'd0                           ;
        r_DRAM_RD_ERR                   =     'd0                           ;

        r_LBUS_REG_RD_ERR               =     'd0                           ;
        r_LBUS_REG_RD_DATA              =     'd0                           ;
        r_LBUS_BRAM_RD_ERR              =     'd0                           ;
        r_LBUS_DRAM_WR_ERR              =     'd0                           ;
        r_LBUS_DRAM_RD_ERR              =     'd0                           ;
        r_DRAM_WR_BUSY                  =     'd0                           ;
        r_DRAM_RD_BUSY                  =     'd0                           ;

        r_ERR                           =     'd0                           ;
        simend                          =     'd0                           ;

        # 10000
        r_XRST0                         =    1'b1                           ;
        r_XRST1                         =    1'b1                           ;
        r_XRST2                         =    1'b1                           ;
        r_XRST3                         =    1'b1                           ;

    end

/*=============================================================================+/
||                                                                             ||
||                              clock generate                                 ||
||                                                                             ||
/+=============================================================================*/

    initial begin
        r_CLK0 = 0 ;
        while (simend == 1'b0) begin
            # p_CLK0  ;
            while (simend == 1'b0 && r_CLKEN[0] == 1'b1) begin # (p_CLK0/2) r_CLK0 = ~ r_CLK0 ; end
            # p_CLK0  ;
        end
        r_CLK0 = 0 ;
    end

    initial begin
        r_CLK1 = 0 ;
        while (simend == 1'b0) begin
            # p_CLK1  ;
            while (simend == 1'b0 && r_CLKEN[1] == 1'b1) begin # (p_CLK1/2) r_CLK1 = ~ r_CLK1 ; end
            # p_CLK1  ;
        end
        r_CLK1 = 0 ;
    end

    initial begin
        r_CLK2 = 0 ;
        while (simend == 1'b0) begin
            # p_CLK2  ;
            while (simend == 1'b0 && r_CLKEN[2] == 1'b1) begin # (p_CLK2/2) r_CLK2 = ~ r_CLK2 ; end
            # p_CLK2  ;
        end
        r_CLK2 = 0 ;
    end

    initial begin
        r_CLK3 = 0 ;
        while (simend == 1'b0) begin
            # p_CLK3  ;
            while (simend == 1'b0 && r_CLKEN[3] == 1'b1) begin # (p_CLK3/2) r_CLK3 = ~ r_CLK3 ; end
            # p_CLK3  ;
        end
        r_CLK3 = 0 ;
    end

/*=============================================================================+/
||                                                                             ||
||                         Open File Operation                                 ||
||                                                                             ||
/+=============================================================================*/

    initial begin
        LOG                 = $fopen    ( { p_LOG_ODIR , p_TB_NAME, "/log.txt"              }, "w" ) ; //open file

        file_bram0_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/bram0_rd.txt"  }, "w" ) ; //open file
        file_bram1_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/bram1_rd.txt"  }, "w" ) ; //open file
        file_bram2_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/bram2_rd.txt"  }, "w" ) ; //open file
        file_bram3_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/bram3_rd.txt"  }, "w" ) ; //open file
        file_bram4_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/bram4_rd.txt"  }, "w" ) ; //open file
        file_bram5_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/bram5_rd.txt"  }, "w" ) ; //open file
        file_bram6_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/bram6_rd.txt"  }, "w" ) ; //open file
        file_bram7_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/bram7_rd.txt"  }, "w" ) ; //open file

        file_dram0_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/dram0_rd.txt"  }, "w" ) ; //open file
        file_dram1_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/dram1_rd.txt"  }, "w" ) ; //open file
        file_dram2_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/dram2_rd.txt"  }, "w" ) ; //open file
        file_dram3_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/dram3_rd.txt"  }, "w" ) ; //open file
        file_dram4_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/dram4_rd.txt"  }, "w" ) ; //open file
        file_dram5_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/dram5_rd.txt"  }, "w" ) ; //open file
        file_dram6_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/dram6_rd.txt"  }, "w" ) ; //open file
        file_dram7_rd       = $fopen    ( { p_FILE_ODIR, p_TB_NAME, "/file_o/dram7_rd.txt"  }, "w" ) ; //open file

        # 1000 ;
        $fdisplay           ( LOG, "// ================================================================" ) ;
        $fdisplay           ( LOG, "// File Name    : log.txt                                          " ) ;
        $fdisplay           ( LOG, "// Test Pattern : %s                                     ",p_TB_NAME ) ;
        $fdisplay           ( LOG, "// ================================================================" ) ;

        while (simend  == 1'b0) begin
            @ (posedge r_CLK0) ;
        end

        # 400000 ;
        $fclose             (LOG            ) ; //close file
        $fclose             (file_bram0_rd  ) ; //close file
        $fclose             (file_bram1_rd  ) ; //close file
        $fclose             (file_bram2_rd  ) ; //close file
        $fclose             (file_bram3_rd  ) ; //close file
        $fclose             (file_bram4_rd  ) ; //close file
        $fclose             (file_bram5_rd  ) ; //close file
        $fclose             (file_bram6_rd  ) ; //close file
        $fclose             (file_bram7_rd  ) ; //close file

        $fclose             (file_dram0_rd  ) ; //close file
        $fclose             (file_dram1_rd  ) ; //close file
        $fclose             (file_dram2_rd  ) ; //close file
        $fclose             (file_dram3_rd  ) ; //close file
        $fclose             (file_dram4_rd  ) ; //close file
        $fclose             (file_dram5_rd  ) ; //close file
        $fclose             (file_dram6_rd  ) ; //close file
        $fclose             (file_dram7_rd  ) ; //close file
        # 100000 ;
    end

/*=============================================================================+/
||                                                                             ||
||                         Read File Operation                                 ||
||                                                                             ||
/+=============================================================================*/

    initial begin
        $readmemh       ({ p_CMD_IDIR , p_TB_NAME, "/cmd.txt"                   }, cmd              ) ; //read command file

        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram0_wr.txt"       }, file_bram0_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram1_wr.txt"       }, file_bram1_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram2_wr.txt"       }, file_bram2_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram3_wr.txt"       }, file_bram3_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram4_wr.txt"       }, file_bram4_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram5_wr.txt"       }, file_bram5_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram6_wr.txt"       }, file_bram6_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram7_wr.txt"       }, file_bram7_wr    ) ; //open file

        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram0_exp.txt"      }, file_bram0_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram1_exp.txt"      }, file_bram1_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram2_exp.txt"      }, file_bram2_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram3_exp.txt"      }, file_bram3_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram4_exp.txt"      }, file_bram4_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram5_exp.txt"      }, file_bram5_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram6_exp.txt"      }, file_bram6_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/bram7_exp.txt"      }, file_bram7_exp   ) ; //open file

        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram0_wr.txt"       }, file_dram0_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram1_wr.txt"       }, file_dram1_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram2_wr.txt"       }, file_dram2_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram3_wr.txt"       }, file_dram3_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram4_wr.txt"       }, file_dram4_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram5_wr.txt"       }, file_dram5_wr    ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram6_wr.txt"       }, file_dram6_wr    ) ; //open file

        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram0_exp.txt"      }, file_dram0_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram1_exp.txt"      }, file_dram1_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram2_exp.txt"      }, file_dram2_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram3_exp.txt"      }, file_dram3_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram4_exp.txt"      }, file_dram4_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram5_exp.txt"      }, file_dram5_exp   ) ; //open file
        $readmemh       ({ p_FILE_IDIR, p_TB_NAME, "/file_i/dram6_exp.txt"      }, file_dram6_exp   ) ; //open file
    end

/*=============================================================================+/
||                                                                             ||
||                                sim end control                              ||
||                                                                             ||
/+=============================================================================*/

   assign s_ERR        = r_REG_RD_ERR          |
                         r_BRAM_RD_ERR         |
                         r_BRAM_WR_ERR         |
                         r_DRAM_RD_ERR         |
                         r_LBUS_REG_RD_ERR     |
                         r_LBUS_BRAM_RD_ERR    |
                         r_LBUS_DRAM_WR_ERR    |
                         r_LBUS_DRAM_RD_ERR    |
                         SIM_ERR0              |
                         SIM_ERR1              |
                         SIM_ERR2              |
                         SIM_ERR3              ;

    // Error flag
    always @(posedge r_CLK0) begin
        if ( s_ERR ) begin
            r_ERR       <= 1'b1 ;
        end
    end

    always @(posedge simend) begin
        # 200000 ;
        if (r_ERR === 1'b1) begin
            $display    (" ") ;
            $display    ("******<<<<<<<<<<<<<<<<<<<<<<Simulation %s Fail End>>>>>>>>>>>>>>>>>>>>>>> ******",p_TB_NAME) ;
            $display    (" ") ;
            $fdisplay   (LOG," ") ;
            $fdisplay   (LOG,"-- ======================================================================") ;
            $fdisplay   (LOG,"--                     Simulation %s Fail End                            "  , p_TB_NAME) ;
            $fdisplay   (LOG,"-- ======================================================================") ;
//          $stop  ;
//          $finsh ;
        end else begin
            $display    (" ") ;
            $display    ("******<<<<<<<<<<<<<<<<<<<<Simulation %s Successful End>>>>>>>>>>>>>>>>>>> ******",p_TB_NAME) ;
            $display    (" ") ;
            $fdisplay   (LOG," ") ;
            $fdisplay   (LOG,"-- ======================================================================") ;
            $fdisplay   (LOG,"--                    Simulation %s Successful End                       "  , p_TB_NAME) ;
            $fdisplay   (LOG,"-- ======================================================================") ;
//          $stop  ;
//          $finsh ;
        end
    end

// ===============================================================================================================================
//  command format
//  [1:8]        [9:16]       [17:32]     [33:64]      [65:96]      [97:128]     [129:160]
//  command      variable1    variable2   variable3    variable4    variable5    variable6
//  xx           xx           xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx
//  8bt          8bit         16bit       32bit        32bit        32bit        32bit

// -------------------------------------------------------------------------------------------------------------------------------
//  Reset & Clock & Switch
//  00           times        xrst_sel    xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- reset by clock cycle     -- times[15:0]  xrst_sel[3:0]
//  01           times        xrst_sel    xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- reset by ns              -- times[15:0]  xrst_sel[3:0]
//  02           times        xrst_sel    xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- reset by us              -- times[15:0]  xrst_sel[3:0]
//  03           times        xrst_sel    xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- reset by ms              -- times[15:0]  xrst_sel[3:0]
//  04           clk_en       xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- clock enable(high active)-- clk_en[3:0]
//  05           psh_sw       xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- pushswitch               -- psh_sw[7:0]
//  06           dip_sw       xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- dipswitch                -- dip_sw[7:0]

// -------------------------------------------------------------------------------------------------------------------------------
//  Wait
//  10           times        xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- wait with clock cycle    -- times[15:0]
//  11           times        xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- wait with ns             -- times[15:0]
//  12           times        xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- wait with us             -- times[15:0]
//  13           times        xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- wait with ms             -- times[15:0]

// -------------------------------------------------------------------------------------------------------------------------------
//  Reg & ram & sdr
//  20           ch_sel       xxxx        xxxxxxxx     xxxxxxxx     address      wr_data    -- register write           -- ch_sel[2:0]                  address[9:0]   wr_data[31:0]
//  21           ch_sel       xxxx        xxxxxxxx     xxxxxxxx     address      rd_data    -- register read            -- ch_sel[2:0]                  address[9:0]   rd_data[31:0]
//  22           ch_sel       line_num    xxxxxxxx     xxxxxxxx     address      size       -- bram write               -- ch_sel[7:0]  line_num[15:0]  address[15:0]  size[11:0]
//  23           ch_sel       line_num    xxxxxxxx     xxxxxxxx     address      size       -- bram read                -- ch_sel[7:0]  line_num[15:0]  address[15:0]  size[11:0]
//  24           ch_sel       line_num    xxxxxxxx     xxxxxxxx     address      size       -- sdram write              -- ch_sel[6:0]  line_num[15:0]  address[24:0]  size[11:0]
//  25           ch_sel       line_num    xxxxxxxx     xxxxxxxx     address      size       -- sdram read               -- ch_sel[6:0]  line_num[15:0]  address[24:0]  size[11:0]

// -------------------------------------------------------------------------------------------------------------------------------
//  Local bus Reg & bram & sdram
//  30           ch_sel       xxxx        xxxxxxxx     xxxxxxxx     address      wr_data    -- loack bus register write -- ch_sel[2:0]                  address[9:0]   wr_data[31:0]
//  31           ch_sel       xxxx        xxxxxxxx     xxxxxxxx     address      rd_data    -- loack bus register read  -- ch_sel[2:0]                  address[9:0]   rd_data[31:0]
//  32           ch_sel       line_num    xxxxxxxx     xxxxxxxx     address      size       -- loack bus bram write     -- ch_sel[7:0]  line_num[15:0]  address[15:0]  size[11:0]
//  33           ch_sel       line_num    xxxxxxxx     xxxxxxxx     address      size       -- loack bus bram read      -- ch_sel[7:0]  line_num[15:0]  address[15:0]  size[11:0]
//  34           ch_sel       line_num    xxxxxxxx     xxxxxxxx     address      size       -- loack bus sdram write    -- ch_sel[6:0]  line_num[15:0]  address[24:0]  size[11:0]
//  35           ch_sel       line_num    xxxxxxxx     xxxxxxxx     address      size       -- loack bus sdram read     -- ch_sel[6:0]  line_num[15:0]  address[24:0]  size[11:0]

// -------------------------------------------------------------------------------------------------------------------------------
//  Trig
//  40           xx           tirg_tx     xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx    -- trig tx                 -- trig_tx[7:0]
//  41           timeout      tirg_rx     xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx    -- trig rx                 -- trig_rx[7:0]     timeout[7:0]

// -------------------------------------------------------------------------------------------------------------------------------
//  Backplane
//  50           xx           soft_start  xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx    -- Softwart start          -- soft_start[0]
//  51           xx           toal_start  xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx    -- Total start             -- toal_start[0]
//  52           xx           fail_o      xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx    -- Fail output generate    -- fail_o[0]
//  53           timeout      fail_i      xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx    -- Fail input check        -- fail_i[0]        timeout[7:0]
//  54           timeout      trig_i      xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx    -- Trig input check        -- trig_i[0]        timeout[7:0]

// -------------------------------------------------------------------------------------------------------------------------------
//  End
//  FF           xx           xxxx        xxxxxxxx     xxxxxxxx     xxxxxxxx     xxxxxxxx   -- sim end

// ===============================================================================================================================

/*=============================================================================+/
||                                                                             ||
||                        Read Stimulus Pattern File                           ||
||                                                                             ||
/+=============================================================================*/

    initial begin
        $display    (" ") ;
        $display    ("******<<<<<<<<<<<<<<<<<<<<<<Simulation %s start>>>>>>>>>>>>>>>>>>>>>>> ******" , p_TB_NAME) ;
        $display    (" ") ;
        $fdisplay   (LOG," ") ;
        $fdisplay   (LOG,"-- ======================================================================") ;
        $fdisplay   (LOG,"--                     Simulation %s start                               "  , p_TB_NAME) ;
        $fdisplay   (LOG,"-- ======================================================================") ;

        operation       <= "initial             "       ; //operation statu message

        $display        (    "---- Initial simulation") ;
        $fdisplay       (LOG,"---- Initial simulation") ;

        # 10000 ;

        cmd_line        =  1'h1                         ; //command line
        file_line       =  1'h1                         ; //file line

        r_cmd           =  8'h0                         ; //command
        r_vb1           =  8'h0                         ; //variable 1
        r_vb2           = 16'h0                         ; //variable 2
        r_vb3           = 32'h0                         ; //variable 3
        r_vb4           = 32'h0                         ; //variable 4
        r_vb5           = 32'h0                         ; //variable 5
        r_vb6           = 32'h0                         ; //variable 6

        # 10000 ;

        while (simend ==  1'b0) begin
            r_cmd       = cmd[cmd_line][  1:  8]        ;//command
            r_vb1       = cmd[cmd_line][  9: 16]        ;//variable 1
            r_vb2       = cmd[cmd_line][ 17: 32]        ;//variable 2
            r_vb3       = cmd[cmd_line][ 33: 64]        ;//variable 3
            r_vb4       = cmd[cmd_line][ 65: 96]        ;//variable 4
            r_vb5       = cmd[cmd_line][ 97:128]        ;//variable 5
            r_vb6       = cmd[cmd_line][129:160]        ;//variable 6

            # 1000 ;
            cmd_line    = cmd_line + 1                  ;//read next line command
            # 1000 ;

            case(r_cmd)
            /*00:Reset*/
                                cmd_RST0 : begin
                                    operation           <= "reset by cycle    "     ;
                                    r_XRST0             <= ~r_vb2[0]                ;
                                    r_XRST1             <= ~r_vb2[1]                ;
                                    r_XRST2             <= ~r_vb2[2]                ;
                                    r_XRST3             <= ~r_vb2[3]                ;
                                    $display            ("---- reseting by cycle")  ;
                                    WAIT_CYC            (r_vb1)                     ;
                                    r_XRST0             <= 1'b1                     ;
                                    r_XRST1             <= 1'b1                     ;
                                    r_XRST2             <= 1'b1                     ;
                                    r_XRST3             <= 1'b1                     ;

                                    if (r_vb2[0]) begin
                                        $display        (    "---- reset0  %d cycle end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset0  %d cycle end",r_vb1) ;
                                    end
                                    if (r_vb2[1]) begin
                                        $display        (    "---- reset1  %d cycle end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset1  %d cycle end",r_vb1) ;
                                    end
                                    if (r_vb2[2]) begin
                                        $display        (    "---- reset2  %d cycle end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset2  %d cycle end",r_vb1) ;
                                    end
                                    if (r_vb2[3]) begin
                                        $display        (    "---- reset3  %d cycle end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset3  %d cycle end",r_vb1) ;
                                    end
                                end
            /*01:Reset*/
                                cmd_RST1 : begin
                                    operation           <= "reset by ns    "        ;
                                    r_XRST0             <= ~r_vb2[0]                ;
                                    r_XRST1             <= ~r_vb2[1]                ;
                                    r_XRST2             <= ~r_vb2[2]                ;
                                    r_XRST3             <= ~r_vb2[3]                ;
                                    $display            ("---- reseting by ns")     ;
                                    WAIT_NS             (r_vb1)                     ;
                                    r_XRST0             <= 1'b1                     ;
                                    r_XRST1             <= 1'b1                     ;
                                    r_XRST2             <= 1'b1                     ;
                                    r_XRST3             <= 1'b1                     ;

                                    if (r_vb2[0]) begin
                                        $display        (    "---- reset0  %d ns end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset0  %d ns end",r_vb1) ;
                                    end
                                    if (r_vb2[1]) begin
                                        $display        (    "---- reset1  %d ns end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset1  %d ns end",r_vb1) ;
                                    end
                                    if (r_vb2[2]) begin
                                        $display        (    "---- reset2  %d ns end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset2  %d ns end",r_vb1) ;
                                    end
                                    if (r_vb2[3]) begin
                                        $display        (    "---- reset3  %d ns end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset3  %d ns end",r_vb1) ;
                                    end
                                end
            /*02:Reset*/
                                cmd_RST2 : begin
                                    operation           <= "reset by us    "        ;
                                    r_XRST0             <= ~r_vb2[0]                ;
                                    r_XRST1             <= ~r_vb2[1]                ;
                                    r_XRST2             <= ~r_vb2[2]                ;
                                    r_XRST3             <= ~r_vb2[3]                ;
                                    $display            ("---- reseting by us")     ;
                                    WAIT_US             (r_vb1)                     ;
                                    r_XRST0             <= 1'b1                     ;
                                    r_XRST1             <= 1'b1                     ;
                                    r_XRST2             <= 1'b1                     ;
                                    r_XRST3             <= 1'b1                     ;

                                    if (r_vb2[0]) begin
                                        $display        (    "---- reset0  %d us end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset0  %d us end",r_vb1) ;
                                    end
                                    if (r_vb2[1]) begin
                                        $display        (    "---- reset1  %d us end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset1  %d us end",r_vb1) ;
                                    end
                                    if (r_vb2[2]) begin
                                        $display        (    "---- reset2  %d us end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset2  %d us end",r_vb1) ;
                                    end
                                    if (r_vb2[3]) begin
                                        $display        (    "---- reset3  %d us end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset3  %d us end",r_vb1) ;
                                    end                                end
            /*03:Reset*/
                                cmd_RST3 : begin
                                    operation           <= "reset by ms    "        ;
                                    r_XRST0             <= ~r_vb2[0]                ;
                                    r_XRST1             <= ~r_vb2[1]                ;
                                    r_XRST2             <= ~r_vb2[2]                ;
                                    r_XRST3             <= ~r_vb2[3]                ;
                                    $display            ("---- reseting by ms")     ;
                                    WAIT_MS             (r_vb1)                     ;
                                    r_XRST0             <= 1'b1                     ;
                                    r_XRST1             <= 1'b1                     ;
                                    r_XRST2             <= 1'b1                     ;
                                    r_XRST3             <= 1'b1                     ;

                                    if (r_vb2[0]) begin
                                        $display        (    "---- reset0  %d ms end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset0  %d ms end",r_vb1) ;
                                    end
                                    if (r_vb2[1]) begin
                                        $display        (    "---- reset1  %d ms end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset1  %d ms end",r_vb1) ;
                                    end
                                    if (r_vb2[2]) begin
                                        $display        (    "---- reset2  %d ms end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset2  %d ms end",r_vb1) ;
                                    end
                                    if (r_vb2[3]) begin
                                        $display        (    "---- reset3  %d ms end",r_vb1) ;
                                        $fdisplay       (LOG,"---- reset3  %d ms end",r_vb1) ;
                                    end                                end
            /*04:CLK enable*/
                                cmd_CLKEN : begin
                                    operation           <= "clock enable   "        ;
                                    r_CLKEN             <= r_vb1[3:0]               ;
                                    $display            (    "---- clock ---- %b ---- enable", r_vb1[3:0]) ;
                                    $fdisplay           (LOG,"---- clock ---- %b ---- enable", r_vb1[3:0]) ;
                                end
           /*05:Pushswitch*/
                                cmd_PSHSW : begin
                                    operation           <= "push switch    "        ;
                                    # 10000                                         ;
                                    r_PSHSW             <= r_vb1[7:0]               ;
                                    # 100000                                        ;
                                    r_PSHSW             <= 8'hFF                    ;
                                    $display            (    "---- push switch ---- %b ----", r_vb1[7:0]) ;
                                    $fdisplay           (LOG,"---- push switch ---- %b ----", r_vb1[7:0]) ;
                                end
           /*06:Dipswitch*/
                                cmd_DIPSW : begin
                                    operation           <= "dip switch     "        ;
                                    r_DIPSW             <= r_vb1[7:0]               ;
                                    $display            (    "---- dip switch ---- %b ----", r_vb1[7:0]) ;
                                    $fdisplay           (LOG,"---- dip switch ---- %b ----", r_vb1[7:0]) ;
                                end

            /*10:Wait cycles*/
                                cmd_WAIT_CYC : begin
                                    operation           <= "wait cycles         "   ;
                                    $display            (    "---- Wait for %d cycles",     r_vb1) ;
                                    WAIT_CYC            (r_vb1[7:0])                ;
                                    $display            (    "---- Wait for %d cycles end", r_vb1) ;
                                    $fdisplay           (LOG,"---- Wait for %d cycles end", r_vb1) ;
                                end
            /*11:Wait ns*/
                                cmd_WAIT_NS : begin
                                    operation           <= "wait ns             " ;
                                    $display            (    "---- Wait for %d ns",     r_vb1) ;
                                    WAIT_NS             (r_vb1[7:0]) ;
                                    $display            (    "---- Wait for %d ns end", r_vb1) ;
                                    $fdisplay           (LOG,"---- Wait for %d ns end", r_vb1) ;
                                end
            /*12:Wait us*/
                                cmd_WAIT_US : begin
                                    operation           <= "wait us             "   ;
                                    $display            (    "---- Wait for %d us",     r_vb1) ;
                                    WAIT_US             (r_vb1[7:0])                ;
                                    $display            (    "---- Wait for %d us end", r_vb1) ;
                                    $fdisplay           (LOG,"---- Wait for %d us end", r_vb1) ;
                                end
            /*13:Wait ms*/
                                cmd_WAIT_MS : begin
                                    operation           <= "wait ms             "   ;
                                    $display            (    "---- Wait for %d ms",     r_vb1) ;
                                    WAIT_MS             (r_vb1[7:0])                ;
                                    $display            (    "---- Wait for %d ms end", r_vb1) ;
                                    $fdisplay           (LOG,"---- Wait for %d ms end", r_vb1) ;
                                end

            /*20:REG WR*/
                                cmd_REG_WR : begin
                                    operation           <= "REG write           "   ;
                                    @                   (posedge r_CLK0)            ;
                                    r_REG_CH_SEL[0]     <= (r_vb1[2:0] == 3'h0) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[1]     <= (r_vb1[2:0] == 3'h1) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[2]     <= (r_vb1[2:0] == 3'h2) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[3]     <= (r_vb1[2:0] == 3'h3) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[4]     <= (r_vb1[2:0] == 3'h4) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[5]     <= (r_vb1[2:0] == 3'h5) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[6]     <= (r_vb1[2:0] == 3'h6) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[7]     <= (r_vb1[2:0] == 3'h7) ? 1'b1 : 1'b0 ;
                                    @                   (posedge r_CLK0)            ;
                                    $display            (    "---- Write register   PORT :0x%h    ADD :0x%h    DATA :0x%h", r_vb1[2:0], r_vb5[9:0], r_vb6[31:0]) ;
                                    $fdisplay           (LOG,"---- Write register   PORT :0x%h    ADD :0x%h    DATA :0x%h", r_vb1[2:0], r_vb5[9:0], r_vb6[31:0]) ;
                                    REG_WRITE           (r_vb5[9:0], r_vb6[31:0])   ;
                                end
            /*21:REG RD*/
                                cmd_REG_RD : begin
                                    operation           <= "REG read            "   ;
                                    @                   (posedge r_CLK0)            ;
                                    r_REG_CH_SEL[0]     <= (r_vb1[2:0] == 3'h0) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[1]     <= (r_vb1[2:0] == 3'h1) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[2]     <= (r_vb1[2:0] == 3'h2) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[3]     <= (r_vb1[2:0] == 3'h3) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[4]     <= (r_vb1[2:0] == 3'h4) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[5]     <= (r_vb1[2:0] == 3'h5) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[6]     <= (r_vb1[2:0] == 3'h6) ? 1'b1 : 1'b0 ;
                                    r_REG_CH_SEL[7]     <= (r_vb1[2:0] == 3'h7) ? 1'b1 : 1'b0 ;
                                    @                   (posedge r_CLK0)            ;
                                    REG_READ            (r_vb5[9:0], r_vb6[31:0])   ;
                                    if (r_REG_RD_ERR == 1'b1) begin
                                    $display            (    "---- [Error      ]Read register   PORT :0x%h    ADD :0x%h    EDAT :0x%h    RDAT :0x%h", r_vb1[2:0], r_vb5[9:0], r_vb6[31:0], r_REG_RD_DATA) ;
                                    $fdisplay           (LOG,"---- [Error      ]Read register   PORT :0x%h    ADD :0x%h    EDAT :0x%h    RDAT :0x%h", r_vb1[2:0], r_vb5[9:0], r_vb6[31:0], r_REG_RD_DATA) ;
                                    end else begin
                                    $display            (    "---- [Success  ]Read register   PORT :0x%h    ADD :0x%h    EDAT :0x%h    RDAT :0x%h", r_vb1[2:0], r_vb5[9:0], r_vb6[31:0], r_REG_RD_DATA) ;
                                    $fdisplay           (LOG,"---- [Success  ]Read register   PORT :0x%h    ADD :0x%h    EDAT :0x%h    RDAT :0x%h", r_vb1[2:0], r_vb5[9:0], r_vb6[31:0], r_REG_RD_DATA) ;
                                    end
                                    r_REG_RD_ERR        <= 1'b0                     ;
                                end

            /*22:BRAM WR*/
                                cmd_BRAM_WR : begin
                                    operation           <= "BRAM write          "   ;
                                    @                   (posedge r_CLK0)            ;
                                    r_BRAM_CH_SEL       <= r_vb1[7:0]               ;
                                    @                   (posedge r_CLK0)            ;
                                    $display            (    "---- BRAM write   PORT :0x%h    ADD :0x%h    SIZE :0x%h", r_vb1[7:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- BRAM write   PORT :0x%h    ADD :0x%h    SIZE :0x%h", r_vb1[7:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    BRAM_WRITE          (r_vb1[7:0], r_vb2[15:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    $display            (    "---- BRAM write end") ;
                                    $fdisplay           (LOG,"---- BRAM write end") ;
                                end
            /*23:BRAM RD*/
                                cmd_BRAM_RD : begin
                                    operation           <= "BRAM read           "   ;
                                    @                   (posedge r_CLK0)            ;
                                    r_BRAM_CH_SEL       <= r_vb1[7:0]               ;
                                    @                   (posedge r_CLK0)            ;
                                    $display            (    "---- BRAM read   PORT :0x%h    ADD :0x%h    SIZE :0x%h", r_vb1[7:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- BRAM read   PORT :0x%h    ADD :0x%h    SIZE :0x%h", r_vb1[7:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    BRAM_READ           (r_vb1[7:0], r_vb2[15:0], r_vb5[15:0], r_vb6[11:0]) ;

                                    if (r_BRAM_RD_ERR == 1'b1) begin
                                    $display            (    "---- [Error      ]BRAM PORT :0x%h    ADD :0x%h    SIZE :0x%h    faild read end" ,r_vb1[7:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- [Error      ]BRAM PORT :0x%h    ADD :0x%h    SIZE :0x%h    faild read end" ,r_vb1[7:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    end else begin
                                    $display            (    "---- [Success  ]BRAM PORT :0x%h    ADD :0x%h    SIZE :0x%h    success read end" ,r_vb1[7:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- [Success  ]BRAM PORT :0x%h    ADD :0x%h    SIZE :0x%h    success read end" ,r_vb1[7:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    end
                                    r_BRAM_RD_ERR       <= 1'b0                     ;
                                end

            /*24:DRAM WR*/
                                cmd_DRAM_WR : begin
                                    operation           <= "DRAM write          "   ;
                                    @                   (posedge r_CLK0)            ;
                                    r_DRAM_CH_SEL       <= r_vb1[6:0]               ;
                                    @                   (posedge r_CLK0)            ;
                                    $display            (    "---- DRAM write PORT :0x%h    ADD :0x%h    SIZE :0x%h", r_vb1[6:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- DRAM write PORT :0x%h    ADD :0x%h    SIZE :0x%h", r_vb1[6:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    DRAM_WRITE          (r_vb1[6:0], r_vb2[15:0], r_vb5[24:0], r_vb6[15:0]) ;
                                    $display            (    "---- DRAM write end") ;
                                    $fdisplay           (LOG,"---- DRAM write end") ;
                                end
            /*25:DRAM RD*/
                                cmd_DRAM_RD : begin
                                    operation           <= "DRAM read           "   ;
                                    @                   (posedge r_CLK0)            ;
                                    r_DRAM_CH_SEL       <= r_vb1[6:0]               ;
                                    @                   (posedge r_CLK0)            ;
                                    $display            (    "---- DRAM read PORT :0x%h    ADD :0x%h    SIZE :0x%h", r_vb1[6:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- DRAM read PORT :0x%h    ADD :0x%h    SIZE :0x%h", r_vb1[6:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    DRAM_READ           (r_vb1[6:0], r_vb2[15:0], r_vb5[24:0], r_vb6[11:0]) ;

                                    if (r_DRAM_RD_ERR == 1'b1) begin
                                    $display            (    "---- [Error      ]DRAM  PORT :0x%h    ADD :0x%h    SIZE :0x%h    faild read end", r_vb1[6:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- [Error      ]DRAM  PORT :0x%h    ADD :0x%h    SIZE :0x%h    faild read end", r_vb1[6:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    end else begin
                                    $display            (    "---- [Success  ]DRAM  PORT :0x%h    ADD :0x%h    SIZE :0x%h    success read end", r_vb1[6:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- [Success  ]DRAM  PORT :0x%h    ADD :0x%h    SIZE :0x%h    success read end", r_vb1[6:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    end
                                    r_DRAM_RD_ERR       <= 1'b0                     ;
                                end


            /*30:LBUS REG WR*/
                                cmd_LBUS_REG_WR : begin
                                    operation           <= "LBUS REG write       "  ;
                                    LBUS_REG_WRITE      (r_vb1[2:0], r_vb5[9:0], r_vb6[31:0]) ;
                                    $display            (    "---- LBUS Write register   ADD :0x%h    DATA :0x%h", {r_vb1[2:0],r_vb5[9:0]}, r_vb6[31:0]) ;
                                    $fdisplay           (LOG,"---- LBUS Write register   ADD :0x%h    DATA :0x%h", {r_vb1[2:0],r_vb5[9:0]}, r_vb6[31:0]) ;
                                end
            /*31:LBUS REG RD*/
                                cmd_LBUS_REG_RD : begin
                                    operation           <= "LBUS REG read        "  ;
                                    LBUS_REG_READ       (r_vb1[2:0], r_vb5[9:0], r_vb6[31:0], 1'b1) ;

                                    if (r_LBUS_REG_RD_ERR == 1'b1) begin
                                    $display            (    "---- [Error      ]LBUS Read register   ADD :0x%h    EDAT :0x%h    RDAT :0x%h", {r_vb1[2:0],r_vb5[9:0]}, r_vb6[31:0], r_LBUS_REG_RD_DATA) ;
                                    $fdisplay           (LOG,"---- [Error      ]LBUS Read register   ADD :0x%h    EDAT :0x%h    RDAT :0x%h", {r_vb1[2:0],r_vb5[9:0]}, r_vb6[31:0], r_LBUS_REG_RD_DATA) ;
                                    end else begin
                                    $display            (    "---- [Success  ]LBUS Read register   ADD :0x%h    EDAT :0x%h    RDAT :0x%h",   {r_vb1[2:0],r_vb5[9:0]}, r_vb6[31:0], r_LBUS_REG_RD_DATA) ;
                                    $fdisplay           (LOG,"---- [Success  ]LBUS Read register   ADD :0x%h    EDAT :0x%h    RDAT :0x%h",   {r_vb1[2:0],r_vb5[9:0]}, r_vb6[31:0], r_LBUS_REG_RD_DATA) ;
                                    end
                                    r_LBUS_REG_RD_ERR    <= 1'b0                     ;
                                end

            /*32:LBUS BRAM WR*/
                                cmd_LBUS_BRAM_WR : begin
                                    operation           <= "LBUS BRAM write      "  ;
                                    $display            (    "---- LBUS BRAM write   ADD :0x%h    SIZE :0x%h", {8'b0,r_vb1[7:0],r_vb5[15:0]}, r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- LBUS BRAM write   ADD :0x%h    SIZE :0x%h", {8'b0,r_vb1[7:0],r_vb5[15:0]}, r_vb6[11:0]) ;
                                    LBUS_BRAM_WRITE     (r_vb1[7:0], r_vb2[15:0], r_vb5[15:0], r_vb6[11:0]) ;
                                    $display            (    "---- LBUS BRAM write end") ;
                                    $fdisplay           (LOG,"---- LBUS BRAM write end") ;
                                end
            /*33:LBUS BRAM RD*/
                                cmd_LBUS_BRAM_RD : begin
                                    operation           <= "LBUS BRAM read       "  ;
                                    $display            (    "---- LBUS BRAM read   ADD :0x%h    SIZE :0x%h", {8'b0,r_vb1[7:0],r_vb5[15:0]}, r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- LBUS BRAM read   ADD :0x%h    SIZE :0x%h", {8'b0,r_vb1[7:0],r_vb5[15:0]}, r_vb6[11:0]) ;
                                    LBUS_BRAM_READ      (r_vb1[7:0], r_vb2[15:0], r_vb5[15:0], r_vb6[11:0]) ;

                                    if (r_LBUS_BRAM_RD_ERR == 1'b1) begin
                                    $display            (    "---- [Error      ]LBUS BRAM   ADD :0x%h    SIZE :0x%h faild read end", {8'b0,r_vb1[7:0],r_vb5[15:0]}, r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- [Error      ]LBUS BRAM   ADD :0x%h    SIZE :0x%h faild read end", {8'b0,r_vb1[7:0],r_vb5[15:0]}, r_vb6[11:0]) ;
                                    end else begin
                                    $display            (    "---- [Success  ]LBUS BRAM   ADD :0x%h    SIZE :0x%h success read end", {8'b0,r_vb1[7:0],r_vb5[15:0]}, r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- [Success  ]LBUS BRAM   ADD :0x%h    SIZE :0x%h success read end", {8'b0,r_vb1[7:0],r_vb5[15:0]}, r_vb6[11:0]) ;
                                    end
                                    r_LBUS_BRAM_RD_ERR   <= 1'b0                     ;
                                end

            /*34:LBUS DRAM WR*/
                                cmd_LBUS_DRAM_WR : begin
                                    operation           <= "LBUS DRAM write      "  ;
                                    $display            (    "---- LBUS DRAM write   ADD :0x%h      SIZE :0x%h", {r_vb1[6:0],r_vb5[24:0]}, r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- LBUS DRAM write   ADD :0x%h      SIZE :0x%h", {r_vb1[6:0],r_vb5[24:0]}, r_vb6[11:0]) ;
                                    LBUS_DRAM_WRITE     (r_vb1[6:0], r_vb2[15:0], r_vb5[24:0], r_vb6[11:0]) ;
                                    $display            (    "---- LBUS DRAM write end") ;
                                    $fdisplay           (LOG,"---- LBUS DRAM write end") ;
                                end
            /*35:LBUS DRAM RD*/
                                cmd_LBUS_DRAM_RD : begin
                                    operation           <= "LBUS DRAM read       "  ;
                                    $display            (    "---- LBUS DRAM read   ADD :0x%h      SIZE :0x%h", {r_vb1[6:0],r_vb5[24:0]}, r_vb6[11:0]) ;
                                    $fdisplay           (LOG,"---- LBUS DRAM read   ADD :0x%h      SIZE :0x%h", {r_vb1[6:0],r_vb5[24:0]}, r_vb6[11:0]) ;
                                    LBUS_DRAM_READ      (r_vb1[6:0], r_vb2[15:0], r_vb5[24:0], r_vb6[11:0]) ;

                                    if (r_LBUS_DRAM_RD_ERR == 1'b1) begin
                                    $display            (    "---- [Error      ]LBUS DRAM faild read end") ;
                                    $fdisplay           (LOG,"---- [Error      ]LBUS DRAM faild read end") ;
                                    end else begin
                                    $display            (    "---- [Success  ]LBUS DRAM success read end") ;
                                    $fdisplay           (LOG,"---- [Success  ]LBUS DRAM success read end") ;
                                    end
                                    r_LBUS_DRAM_RD_ERR   <= 1'b0                    ;
                                end

            /*40:Trig TX*/
                                cmd_TRIG_TX : begin
                                    operation           <= "Trig TX        "        ;
                                    TRIG_TX_8           (r_vb2[7:0])                ;
                                    $display            (    "---- Trig TX 0x%h", r_vb2[7:0]) ;
                                    $fdisplay           (LOG,"---- Trig TX 0x%h", r_vb2[7:0]) ;
                                end

            /*41:Trig RX*/
                                cmd_TRIG_RX : begin
                                    operation           <= "Trig RX        "        ;
                                    TRIG_RX_8           (r_vb1,r_vb2[7:0])          ;
                                    if (r_TIME_OUT == 1'b0) begin
                                    $display            (    "---- Trig RX_EXP :0x%h Trig RX :0x%h" , r_vb2[7:0] , r_TRIG_RX) ;
                                    $fdisplay           (LOG,"---- Trig RX_EXP :0x%h Trig RX :0x%h" , r_vb2[7:0] , r_TRIG_RX) ;
                                    end else begin
                                    $display            (    "---- Trig RX Timeout") ;
                                    $fdisplay           (LOG,"---- Trig RX Timeout") ;
                                    end

                                end

            /*50:Soft_start*/
                                cmd_SOFT_START : begin
                                    operation           <= "Soft start     "        ;
                                    @                   (posedge r_CLK1)            ;
                                    r_SOFT_START        <= 1'b0                     ;
                                    @                   (posedge r_CLK1)            ;
                                    r_SOFT_START        <= 1'b1                     ;
                                    @                   (posedge r_CLK1)            ;
                                    r_SOFT_START        <= 1'b0                     ;
                                    @                   (posedge r_CLK1)            ;
                                    $display            (    "---- Soft start") ;
                                    $fdisplay           (LOG,"---- Soft start") ;
                                end

            /*51:Toal_start*/
                                cmd_TOAL_START : begin
                                    operation           <= "Toal start     "        ;
                                    @                   (posedge r_CLK1)            ;
                                    r_TOAL_START        <= 1'b0                     ;
                                    @                   (posedge r_CLK1)            ;
                                    r_TOAL_START        <= 1'b1                     ;
                                    @                   (posedge r_CLK1)            ;
                                    r_TOAL_START        <= 1'b0                     ;
                                    @                   (posedge r_CLK1)            ;
                                    $display            (    "---- Total start") ;
                                    $fdisplay           (LOG,"---- Total start") ;
                                end

            /*52:Fail_o*/
                                cmd_FAIL_OGEN : begin
                                    operation           <= "Fail output     "       ;
                                    @                   (posedge r_CLK1)            ;
                                    r_FAIL_O            <= 1'b1                     ;
                                    @                   (posedge r_CLK1)            ;
                                    $display            (    "---- Fail output")    ;
                                    $fdisplay           (LOG,"---- Fail output")    ;
                                end

            /*53:Fail_i*/
                                cmd_FAIL_ICHK : begin
                                    operation           <= "Fail input check     "  ;
                                    @                   (posedge r_CLK1)            ;
                                    FAIL_ICHK           (r_vb1[7:0])                ;
                                    if (r_TIME_OUT == 1'b0) begin
                                    $display            (    "---- Fail input check success") ;
                                    $fdisplay           (LOG,"---- Fail input check success") ;
                                    end else begin
                                    $display            (    "---- Fail input check Timeout") ;
                                    $fdisplay           (LOG,"---- Fail input check Timeout") ;
                                    end
                                end

            /*54:Trig_i*/
                                cmd_TRIG_ICHK : begin
                                    operation           <= "Trig input check     "  ;
                                    @                   (posedge r_CLK1)            ;
                                    TRIG_ICHK           (r_vb1[7:0])                ;
                                    if (r_TIME_OUT == 1'b0) begin
                                    $display            (    "---- Trig input check success") ;
                                    $fdisplay           (LOG,"---- Trig input check success") ;
                                    end else begin
                                    $display            (    "---- Trig input check Timeout") ;
                                    $fdisplay           (LOG,"---- Trig input check Timeout") ;
                                    end
                                end

            /*FF:sim-end*/
                                cmd_SIMEND : begin
                                    operation       <= "sim end             "   ;
                                    simend          <= 1'b1                     ;
                                    # 10000;
                                    $display        (    "---- %s test completed !",p_TB_NAME) ;
                                    $fdisplay       (LOG,"---- %s test completed !",p_TB_NAME) ;
                                end

                                default: begin
                                    operation       <= "no operation        "   ;
                                    $display        (    "---- Error command")  ;
                                    $fdisplay       (LOG,"---- Error command")  ;
                                end
            endcase
        end
    end

/*======================================================================================================================+/
||                                                                                                                      ||
|| simulation task :                                                                                                    ||
||                                                                                                                      ||
||            cmd                       Task name                       Function                                        ||
||                                      -                                                                               ||
||            00                        -                               Reset by clock cycle                            ||
||            01                        -                               Reset by ns                                     ||
||            02                        -                               Reset by us                                     ||
||            03                        -                               Reset by ms                                     ||
||            04                        -                               Clock enable                                    ||
||            05                        -                               Pushswitch                                      ||
||            06                        -                               Dipswitch                                       ||
||            10                        WAIT_CYC                        Wait with clock cycle                           ||
||            11                        WAIT_NS                         Wait with ns                                    ||
||            12                        WAIT_US                         Wait with us                                    ||
||            13                        WAIT_MS                         Wait with ms                                    ||
||            20                        REG_WRITE                       Register write                                  ||
||            21                        REG_READ                        Register read                                   ||
||            22                        BRAM_WRITE                      Bram write                                      ||
||            23                        BRAM_READ                       Bram read                                       ||
||            24                        DRAM_WRITE                      DRAM write                                      ||
||            25                        DRAM_READ                       DRAM read                                       ||
||            30                        LBUS_REG_WRITE                  LBUS register write (single)                    ||
||            31                        LBUS_REG_READ                   LBUS register read (single)                     ||
||            32                        LBUS_BRAM_WRITE                 LBUS bram write                                 ||
||            33                        LBUS_BRAM_READ                  LBUS bram read                                  ||
||            34                        LBUS_DRAM_WRITE                 LBUS DRAM write                                 ||
||            35                        LBUS_DRAM_READ                  LBUS DRAM read                                  ||
||            40                        TRIG_TX_8                       Trig tx[7:0]                                    ||
||            41                        TRIG_RX_8                       Trig rx[7:0]  (timeout cycles)                  ||
||            50                        -                               Softwart start                                  ||
||            51                        -                               Total start                                     ||
||            52                        -                               Fail output generate                            ||
||            53                        FAIL_ICHK                       Fail input check                                ||
||            54                        TRIG_ICHK                       Trig input check                                ||
||            FF                        -                               Sim end                                         ||
||                                                                                                                      ||
/+======================================================================================================================*/

/*=============================================================================+/
||                                                                             ||
||                       task of Wait in units of clk cycle                    ||
||                                                                             ||
/+=============================================================================*/

    task WAIT_CYC ;
        input       [7:0]   waitcycle   ;
        integer     m0                  ;
        begin
            for (m0=0; m0< waitcycle ; m0=m0+1 ) begin
                @ (posedge r_CLK0) ; // Wait 1 colck cycle
            end
        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                          task of Wait in units of ns                        ||
||                                                                             ||
/+=============================================================================*/

    task WAIT_NS ;
        input       [7:0]   waitns  ;
        integer             m1      ;
        begin
            for (m1=0; m1< waitns ; m1=m1+1 ) begin
                # 1000  ; // Wait 1 ns
            end
        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                           task of Wait in units of us                       ||
||                                                                             ||
/+=============================================================================*/

    task WAIT_US ;
        input       [7:0]   waitus  ;
        integer             m2      ;
        begin
            for (m2=0; m2< waitus ; m2=m2+1 ) begin
                # 1000000   ; // Wait 1 us

                $display  (    "---- Wait %d us of %d us", m2+1, waitus) ;
                $fdisplay (LOG,"---- Wait %d us of %d us", m2+1, waitus) ;
            end
        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                           task of Wait in units of ms                       ||
||                                                                             ||
/+=============================================================================*/

    task WAIT_MS ;
        input       [7:0]   waitms  ;
        integer             m3      ;
        begin
            for (m3=0; m3< waitms ; m3=m3+1 ) begin
                # 1000000000   ; // Wait 1 ms

                $display  (    "---- Wait %d ms of %d ms", m3+1, waitms) ;
                $fdisplay (LOG,"---- Wait %d ms of %d ms", m3+1, waitms) ;
            end
        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                             task of Trig TX                                 ||
||                                                                             ||
/+=============================================================================*/

    task TRIG_TX_8 ;
        input     [ 7:0]    trig_tx    ;

        begin
            @ ( posedge r_CLK1 )                ;
            @ ( posedge r_CLK1 )                ;
                r_TRIG_TX       <= trig_tx      ;
            @ ( posedge r_CLK1 )                ;
                r_TRIG_TX       <= 8'h00        ;
            @ ( posedge r_CLK1 )                ;
            @ ( posedge r_CLK1 )                ;
        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                             task of Trig RX                                 ||
||                                                                             ||
/+=============================================================================*/

    task TRIG_RX_8 ;
        input     [ 7:0]    timeout                 ;
        input     [ 7:0]    trig_exp                ;

        begin
            @ ( posedge r_CLK1 )                    ;
            @ ( posedge r_CLK1 )                    ;
            @ ( posedge r_CLK1 )                    ;
            @ ( posedge r_CLK1 )                    ;
            r_TIME_CNT                  <= 8'h04    ;
            r_TRIG_LD                   <= 1'b0     ;
            r_TIME_OUT                  <= 1'b0     ;

            while (r_TRIG_LD == 1'b0 && r_TIME_OUT == 1'b0) begin
                @ (posedge r_CLK1) ; begin

                    if (TRIG_RX_P == trig_exp) begin
                        r_TRIG_RX       <= TRIG_RX_P;
                        r_TRIG_LD       <= 1'b1     ;
                    end else begin
                        r_TRIG_RX       <= 8'b0     ;
                        r_TRIG_LD       <= 1'b0     ;
                    end

                    if (r_TIME_CNT == timeout) begin
                        r_TIME_OUT      <= 1'b1     ;
                    end else begin
                        r_TIME_OUT      <= 1'b0     ;
                    end
                end

                #1000

                r_TIME_CNT              <= r_TIME_CNT + 1'b1 ;

            end

            @ ( posedge r_CLK1 )                    ;
            @ ( posedge r_CLK1 )                    ;
        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                             task of Register Write                          ||
||                                                                             ||
/+=============================================================================*/

    task REG_WRITE ;
        input     [ 9:0] address    ;
        input     [31:0] data       ;
        integer          m4         ;

        begin
            @ ( posedge r_CLK0 ) ; begin
                r_REG_OP_ADDR       <= address  ;
                r_REG_WR_REQ        <= 1'b1     ;
                r_REG_WR_DATA       <= data     ;
                r_REG_WR_ERR        <= 1'b0     ;
            end

            @ ( posedge r_CLK0 ) ; begin
                r_REG_OP_ADDR       <= address  ;
                r_REG_WR_REQ        <= 1'b0     ;
                r_REG_WR_DATA       <= data     ;
                r_TIME_OUT          <= 1'b0     ;
                r_TIME_CNT          <= 8'd0     ;
            end

            while (s_REG_WR_ACK == 1'b0 && r_TIME_OUT == 1'b0) begin
                @ (posedge r_CLK0) ; begin
                    if (r_TIME_CNT == 8'h10) begin
                        r_TIME_OUT      <= 1'b1 ;
                        r_REG_WR_ERR    <= 1'b1 ;
                        $display (     "---- [Error      ]write register timeout ADD :0x%h", r_REG_OP_ADDR) ;
                        $fdisplay (LOG,"---- [Error      ]Write register timeout ADD :0x%h", r_REG_OP_ADDR) ;
                    end else begin
                        r_TIME_CNT      <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            begin
                r_TIME_CNT          <= 8'd0     ;
                r_TIME_OUT          <= 1'b0     ;
                r_REG_OP_ADDR       <= 10'h0    ;
                r_REG_WR_REQ        <=  1'b0    ;
                r_REG_WR_DATA       <= 32'h0    ;
            end

            for (m4=0; m4<=7 ; m4=m4+1 ) begin
                @ ( posedge r_CLK0 ) ;
            end
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                             task of Register Read                           ||
||                                                                             ||
/+=============================================================================*/

    task REG_READ ;
        input       [ 9:0]  address     ;
        input       [31:0]  data        ;
        integer             m5          ;

        begin
            @ ( posedge r_CLK0 ) ; begin
                r_REG_OP_ADDR       <= address      ;
                r_REG_RD_REQ        <= 1'b1         ;
                r_REG_RD_ERR        <= 1'b0         ;
            end

            @ ( posedge r_CLK0 ) ; begin
                r_REG_OP_ADDR       <= address      ;
                r_REG_RD_REQ        <= 1'b0         ;
            end

            while (s_REG_RD_ACK == 1'b0 && r_TIME_OUT == 1'b0) begin
                @ (posedge r_CLK0) ; begin
                    if (r_TIME_CNT == 8'h10) begin
                        r_TIME_OUT      <= 1'b1 ;
                        r_REG_RD_ERR    <= 1'b1 ;
                        $display (     "---- [Error      ]Read register timeout ADD :0x%h", r_REG_OP_ADDR) ;
                        $fdisplay (LOG,"---- [Error      ]Read register timeout ADD :0x%h", r_REG_OP_ADDR) ;
                    end else begin
                        r_TIME_CNT      <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            begin
                r_TIME_CNT          <= 8'd0          ;
                r_TIME_OUT          <= 1'b0          ;
                r_REG_OP_ADDR       <= 10'h0         ;
                r_REG_RD_REQ        <=  1'b0         ;
                r_REG_RD_DATA       <= s_REG_RD_DATA ;
            end

            @ ( posedge r_CLK0 ) ;
                if (r_REG_RD_DATA != data) begin
                    r_REG_RD_ERR    <= 1'b1;
                end

            for (m5=0; m5<=7; m5=m5+1) begin
                @ ( posedge r_CLK0 ) ;
            end
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                             BRAM write                                      ||
||                                                                             ||
/+=============================================================================*/

    task BRAM_WRITE ;
        input       [ 7:0]  fsel            ;
        input       [15:0]  line            ;
        input       [15:0]  addr            ;
        input       [11:0]  size            ;
        integer             m6              ;

        begin
            @ ( posedge r_CLK0 ) ; begin
                r_BRAM_WR_REQ               <= 1'b0     ;
                r_BRAM_WR_ADDR              <= addr     ;
                r_BRAM_WR_DATA              <= 32'd0    ;
                file_line                   <= line     ;
            end

            @ ( posedge r_CLK0 ) ;

            for (m6=0 ; m6<size[11:2] ; m6=m6+1) begin
                @ ( posedge r_CLK0 ) ; begin
                    r_BRAM_WR_REQ           <= 1'b1 ;
                    r_BRAM_WR_ADDR          <= r_BRAM_WR_ADDR ;
                    case (fsel)
                        8'h01   : r_BRAM_WR_DATA    <= file_bram0_wr[file_line][1:32] ;
                        8'h02   : r_BRAM_WR_DATA    <= file_bram1_wr[file_line][1:32] ;
                        8'h04   : r_BRAM_WR_DATA    <= file_bram2_wr[file_line][1:32] ;
                        8'h08   : r_BRAM_WR_DATA    <= file_bram3_wr[file_line][1:32] ;
                        8'h10   : r_BRAM_WR_DATA    <= file_bram4_wr[file_line][1:32] ;
                        8'h20   : r_BRAM_WR_DATA    <= file_bram5_wr[file_line][1:32] ;
                        8'h40   : r_BRAM_WR_DATA    <= file_bram6_wr[file_line][1:32] ;
                        8'h80   : r_BRAM_WR_DATA    <= file_bram7_wr[file_line][1:32] ;
                        default : r_BRAM_WR_DATA    <= file_bram0_wr[file_line][1:32] ;
                    endcase
                end

                @ ( posedge r_CLK0 ) ; begin
                    r_BRAM_WR_REQ           <= 1'b0 ;
                    r_TIME_OUT              <= 1'b0 ;
                    r_TIME_CNT              <= 8'd0 ;
                end

                while (s_BRAM_WR_ACK == 1'b0 && r_TIME_OUT == 1'b0) begin
                    @ (posedge r_CLK0) ; begin
                        if (r_TIME_CNT == 8'h10) begin
                            r_TIME_OUT      <= 1'b1 ;
                            r_BRAM_WR_ERR   <= 1'b1 ;
                            $display (     "---- [Error      ]write bram timeout ADD :0x%h", r_BRAM_WR_ADDR) ;
                            $fdisplay (LOG,"---- [Error      ]Write bram timeout ADD :0x%h", r_BRAM_WR_ADDR) ;
                        end else begin
                            r_TIME_CNT      <= r_TIME_CNT + 1'b1 ;
                        end
                    end
                end

                @ ( posedge r_CLK0 ) ; begin
                    r_BRAM_WR_REQ           <= 1'b0 ;
                    r_TIME_CNT              <= 8'd0 ;
                    r_TIME_OUT              <= 1'b0 ;

                    r_BRAM_WR_ADDR          <= r_BRAM_WR_ADDR + 1'b1 ;
                    file_line               <= file_line + 1'b1 ;
                end
            end

            @ ( posedge r_CLK0 ) ; begin
                r_BRAM_WR_REQ               <= 1'b0     ;
                r_BRAM_WR_ADDR              <= 16'd0    ;
                r_BRAM_WR_DATA              <= 32'd0    ;
            end

            @ ( posedge r_CLK0 ) ;
            @ ( posedge r_CLK0 ) ;
            @ ( posedge r_CLK0 ) ;
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                             BRAM Read                                       ||
||                                                                             ||
/+=============================================================================*/

    task BRAM_READ ;
        input       [ 7:0]  fsel            ;
        input       [15:0]  line            ;
        input       [15:0]  addr            ;
        input       [11:0]  size            ;
        integer             m7              ;

        begin
            @ ( posedge r_CLK0 ) ; begin
                r_BRAM_RD_REQ               <= 1'b0     ;
                r_BRAM_RD_ADDR              <= addr     ;
                r_BRAM_RD_DATA              <= 32'd0    ;
                r_BRAM_RD_EXPD              <= 32'd0    ;
                file_line                   <= line     ;
            end

            @ ( posedge r_CLK0 ) ;

            for (m7=0 ; m7<size[11:2] ; m7=m7+1) begin
                @ ( posedge r_CLK0 ) ; begin
                    r_BRAM_RD_REQ           <= 1'b1             ;

                    case (fsel)
                        8'h01   : r_BRAM_RD_EXPD    <= file_bram0_exp[file_line][1:32] ;
                        8'h02   : r_BRAM_RD_EXPD    <= file_bram1_exp[file_line][1:32] ;
                        8'h04   : r_BRAM_RD_EXPD    <= file_bram2_exp[file_line][1:32] ;
                        8'h08   : r_BRAM_RD_EXPD    <= file_bram3_exp[file_line][1:32] ;
                        8'h10   : r_BRAM_RD_EXPD    <= file_bram4_exp[file_line][1:32] ;
                        8'h20   : r_BRAM_RD_EXPD    <= file_bram5_exp[file_line][1:32] ;
                        8'h40   : r_BRAM_RD_EXPD    <= file_bram6_exp[file_line][1:32] ;
                        8'h80   : r_BRAM_RD_EXPD    <= file_bram7_exp[file_line][1:32] ;
                        default : r_BRAM_RD_EXPD    <= file_bram0_exp[file_line][1:32] ;
                    endcase
                end

                @ ( posedge r_CLK0 ) ; begin
                    r_BRAM_RD_REQ           <= 1'b0 ;
                    r_TIME_OUT              <= 1'b0 ;
                    r_TIME_CNT              <= 8'd0 ;
                end

                while (s_BRAM_RD_ACK == 1'b0 && r_TIME_OUT == 1'b0 ) begin
                    @ (posedge r_CLK0) ; begin
                        if (r_TIME_CNT == 8'h10) begin
                            r_TIME_OUT      <= 1'b1 ;
                            r_BRAM_RD_ERR   <= 1'b1 ;
                            $display (     "---- [Error      ]Read bram timeout ADD :0x%h", r_BRAM_RD_ADDR) ;
                            $fdisplay (LOG,"---- [Error      ]Read bram timeout ADD :0x%h", r_BRAM_RD_ADDR) ;
                        end else begin
                            r_TIME_CNT      <= r_TIME_CNT + 1'b1 ;
                        end
                    end
                end

                begin
                    r_BRAM_RD_DATA          <= s_BRAM_RD_DATA ;
                end

                @ ( posedge r_CLK0 ) ; begin
                    case (fsel)
                        8'h01   : $fdisplay (file_bram0_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h02   : $fdisplay (file_bram1_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h04   : $fdisplay (file_bram2_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h08   : $fdisplay (file_bram3_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h10   : $fdisplay (file_bram4_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h20   : $fdisplay (file_bram5_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h40   : $fdisplay (file_bram6_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h80   : $fdisplay (file_bram7_rd,"%h",r_BRAM_RD_DATA)   ;
                        default :                                                 ;
                    endcase

                    if (r_BRAM_RD_EXPD != r_BRAM_RD_DATA && r_TIME_OUT == 1'b0) begin
                        r_BRAM_RD_ERR       <= 1'b1 ;
                        $display (     "---- [Error      ]Read bram ADD :0x%h  EDAT :0x%h  RDAT :0x%h", r_BRAM_RD_ADDR, r_BRAM_RD_EXPD, r_BRAM_RD_DATA) ;
                        $fdisplay (LOG,"---- [Error      ]Read bram ADD :0x%h  EDAT :0x%h  RDAT :0x%h", r_BRAM_RD_ADDR, r_BRAM_RD_EXPD, r_BRAM_RD_DATA) ;
                    end
                end

                @ ( posedge r_CLK0 ) ; begin
                    r_TIME_CNT              <= 8'd0 ;
                    r_TIME_OUT              <= 1'b0 ;

                    r_BRAM_RD_ADDR          <= r_BRAM_RD_ADDR + 1'b1 ;
                    file_line               <= file_line + 1'b1 ;
                end
            end

            @ ( posedge r_CLK0 ) ;
            @ ( posedge r_CLK0 ) ;
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                             DRAM write                                      ||
||                                                                             ||
/+=============================================================================*/

    task DRAM_WRITE ;
        input       [ 6:0]  fsel            ;
        input       [15:0]  line            ;
        input       [24:0]  addr            ;
        input       [15:0]  size            ;
        integer             m8              ;

        begin
            @ ( posedge r_CLK0 ) ; begin
                r_DRAM_WR_ADDR              <= addr     ;
                r_DRAM_WR_SIZE              <= size     ;
                r_DRAM_WR_REQ               <= 1'b0     ;
                r_DRAM_WR_SOP               <= 1'b0     ;
                r_DRAM_WR_EOP               <= 1'b0     ;
                r_DRAM_WR_DVLD              <= 1'b0     ;
                r_DRAM_WR_DATA              <= 64'd0    ;

                r_DRAM_WR_ERR               <= 1'b0     ;
                r_TIME_OUT                  <= 1'b0     ;
                r_TIME_CNT                  <= 8'd0     ;
                file_line                   <= line     ;
            end

            while (s_DRAM_WR_RDY == 1'b0 && r_TIME_OUT == 1'b0) begin
                @ (posedge r_CLK0) ; begin
                    if (r_TIME_CNT == 8'h80) begin
                        r_TIME_OUT          <= 1'b1 ;
                        r_DRAM_WR_ERR       <= 1'b1 ;
                        $display (     "---- [Error      ]write dram wait ready timeout") ;
                        $fdisplay (LOG,"---- [Error      ]Write dram wait ready timeout") ;
                    end else begin
                        r_TIME_CNT          <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            @ ( posedge r_CLK0 ) ; begin
                r_TIME_OUT                  <= 1'b0 ;
                r_TIME_CNT                  <= 8'd0 ;
                r_DRAM_WR_REQ               <= 1'b1 ;
            end

            while (s_DRAM_WR_ACK == 1'b0 && r_TIME_OUT == 1'b0) begin
                @ (posedge r_CLK0) ; begin
                    if (r_TIME_CNT == 8'h80) begin
                        r_TIME_OUT          <= 1'b1 ;
                        r_DRAM_WR_ERR       <= 1'b1 ;
                        $display (     "---- [Error      ]write dram wait acknowledge timeout") ;
                        $fdisplay (LOG,"---- [Error      ]Write dram wait acknowledge timeout") ;
                    end else begin
                        r_TIME_CNT          <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            @ ( posedge r_CLK0 ) ; begin
                r_DRAM_WR_REQ               <= 1'b0 ;
            end

            for (m8=0 ; m8<size[15:3] ; m8=m8+1) begin
                @ ( posedge r_CLK0 ) ; begin

                    r_DRAM_WR_DVLD          <= ~r_DRAM_WR_ERR ;

                    case (fsel)
                        8'h01   : r_DRAM_WR_DATA    <= file_dram0_wr[file_line][1:64] ;
                        8'h02   : r_DRAM_WR_DATA    <= file_dram1_wr[file_line][1:64] ;
                        8'h04   : r_DRAM_WR_DATA    <= file_dram2_wr[file_line][1:64] ;
                        8'h08   : r_DRAM_WR_DATA    <= file_dram3_wr[file_line][1:64] ;
                        8'h10   : r_DRAM_WR_DATA    <= file_dram4_wr[file_line][1:64] ;
                        8'h20   : r_DRAM_WR_DATA    <= file_dram5_wr[file_line][1:64] ;
                        8'h40   : r_DRAM_WR_DATA    <= file_dram6_wr[file_line][1:64] ;
                        default : r_DRAM_WR_DATA    <= file_dram0_wr[file_line][1:64] ;
                    endcase

                    if (m8==0) begin
                        r_DRAM_WR_SOP       <= 1'b1 & (~r_DRAM_WR_ERR) ;
                    end else begin
                        r_DRAM_WR_SOP       <= 1'b0 ;
                    end

                    if (m8==size[15:3] - 1) begin
                        r_DRAM_WR_EOP       <= 1'b1 & (~r_DRAM_WR_ERR) ;
                    end else begin
                        r_DRAM_WR_EOP       <= 1'b0 ;
                    end

                    #1000
                    file_line               <= file_line + 1'b1 ;

                end
            end

            @ ( posedge r_CLK0 ) ; begin
                r_DRAM_WR_ERR               <= 1'b0     ;
                r_DRAM_WR_ADDR              <= 32'd0    ;
                r_DRAM_WR_SIZE              <= 32'd0    ;
                r_DRAM_WR_REQ               <= 1'b0     ;

                r_DRAM_WR_SOP               <= 1'b0     ;
                r_DRAM_WR_EOP               <= 1'b0     ;
                r_DRAM_WR_DVLD              <= 1'b0     ;
                r_DRAM_WR_DATA              <= 64'd0    ;
            end

            @ ( posedge r_CLK0 ) ;
            @ ( posedge r_CLK0 ) ;
            @ ( posedge r_CLK0 ) ;
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                             DRAM Read                                       ||
||                                                                             ||
/+=============================================================================*/

    task DRAM_READ ;
        input       [ 6:0]  fsel            ;
        input       [15:0]  line            ;
        input       [24:0]  addr            ;
        input       [11:0]  size            ;
        integer             m8              ;

        begin
            @ ( posedge r_CLK0 ) ; begin
                r_DRAM_RD_REQ               <=  1'd0    ;
                r_DRAM_RD_ADDR              <= 32'd0    ;
                r_DRAM_RD_SIZE              <= 32'd0    ;

                r_DRAM_RD_SOP               <=  1'd0    ;
                r_DRAM_RD_EOP               <=  1'd0    ;
                r_DRAM_RD_DVLD              <=  1'd0    ;
                r_DRAM_RD_DATA              <= 32'd0    ;
                r_DRAM_RD_DCNT              <= 12'd0    ;
                r_DRAM_RD_END               <= 1'b0     ;

                r_DRAM_RD_ERR               <= 1'b0     ;
                r_TIME_CNT                  <= 8'h00    ;
                r_TIME_OUT                  <= 1'b0     ;
                file_line                   <= line     ;
            end

            @ ( posedge r_CLK0 ) ; begin
                r_DRAM_RD_ADDR              <= addr     ;
                r_DRAM_RD_SIZE              <= size     ;
                r_DRAM_RD_REQ               <= 1'b1     ;
            end

            while (s_DRAM_RD_ACK == 1'b0 && r_TIME_OUT == 1'b0) begin
                @ (posedge r_CLK0) ; begin
                    if (r_TIME_CNT == 8'h80) begin
                        r_TIME_OUT          <= 1'b1     ;
                        r_DRAM_RD_ERR       <= 1'b1     ;
                        $display (     "---- [Error      ]read dram wait acknowledge timeout") ;
                        $fdisplay (LOG,"---- [Error      ]read dram wait acknowledge timeout") ;
                    end else begin
                        r_TIME_CNT          <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            @ ( posedge r_CLK0 ) ; begin
                r_TIME_CNT                  <= 8'h00    ;
                r_TIME_OUT                  <= 1'b0     ;
                r_DRAM_RD_REQ               <= 1'b0     ;
            end

            while (r_DRAM_RD_END == 1'b0 && r_TIME_OUT == 1'b0) begin

                @ ( posedge r_CLK0 ) ; begin
                    case (fsel)
                        8'h01   : r_DRAM_RD_EXPD   <= file_dram0_exp[file_line][1:32] ;
                        8'h02   : r_DRAM_RD_EXPD   <= file_dram1_exp[file_line][1:32] ;
                        8'h04   : r_DRAM_RD_EXPD   <= file_dram2_exp[file_line][1:32] ;
                        8'h08   : r_DRAM_RD_EXPD   <= file_dram3_exp[file_line][1:32] ;
                        8'h10   : r_DRAM_RD_EXPD   <= file_dram4_exp[file_line][1:32] ;
                        8'h20   : r_DRAM_RD_EXPD   <= file_dram5_exp[file_line][1:32] ;
                        8'h40   : r_DRAM_RD_EXPD   <= file_dram6_exp[file_line][1:32] ;
                        default : r_DRAM_RD_EXPD   <= file_dram0_exp[file_line][1:32] ;
                    endcase

                    r_DRAM_RD_SOP           <= s_DRAM_RD_SOP  ;
                    r_DRAM_RD_EOP           <= s_DRAM_RD_EOP  ;
                    r_DRAM_RD_DVLD          <= s_DRAM_RD_DVLD ;
                    r_DRAM_RD_DATA          <= s_DRAM_RD_DATA ;

                    # 1000

                    if (r_DRAM_RD_DVLD == 1'b1) begin
                        r_DRAM_RD_DCNT      <= r_DRAM_RD_DCNT + 1'b1    ;

                        case (fsel)
                            8'h01   : $fdisplay (file_dram0_rd,"%h",r_DRAM_RD_DATA)   ;
                            8'h02   : $fdisplay (file_dram1_rd,"%h",r_DRAM_RD_DATA)   ;
                            8'h04   : $fdisplay (file_dram2_rd,"%h",r_DRAM_RD_DATA)   ;
                            8'h08   : $fdisplay (file_dram3_rd,"%h",r_DRAM_RD_DATA)   ;
                            8'h10   : $fdisplay (file_dram4_rd,"%h",r_DRAM_RD_DATA)   ;
                            8'h20   : $fdisplay (file_dram5_rd,"%h",r_DRAM_RD_DATA)   ;
                            8'h40   : $fdisplay (file_dram6_rd,"%h",r_DRAM_RD_DATA)   ;
                            8'h80   : $fdisplay (file_dram7_rd,"%h",r_DRAM_RD_DATA)   ;
                            default :                                                 ;
                        endcase

                        if (r_DRAM_RD_EXPD != r_DRAM_RD_DATA) begin
                            r_DRAM_RD_ERR   <= 1'b1 ;
                            $display (     "---- [Error      ]Read DRAM  EXP_DATA :0x%h  RD_DATA :0x%h", r_DRAM_RD_EXPD, r_DRAM_RD_DATA) ;
                            $fdisplay (LOG,"---- [Error      ]Read DRAM  EXP_DATA :0x%h  RD_DATA :0x%h", r_DRAM_RD_EXPD, r_DRAM_RD_DATA) ;
                        end

                        #1000
                        file_line           <= file_line + 1'b1 ;

                        if (r_DRAM_RD_DCNT >= size[11:2]) begin
                            r_DRAM_RD_END   <= 1'b1  ;
                        end else begin
                            r_DRAM_RD_END   <= 1'b0  ;
                        end
                    end else begin
                        r_DRAM_RD_DVLD      <=  1'd0 ;
                        r_DRAM_RD_DATA      <= 32'd0 ;
                    end

                    if (r_TIME_CNT == 8'hFF) begin
                        r_TIME_OUT          <= 1'b1     ;
                        r_DRAM_RD_ERR       <= 1'b1     ;
                        $display (     "---- [Error      ]Read dram wait data timeout") ;
                        $fdisplay (LOG,"---- [Error      ]Read dram wait data timeout") ;

                    end else begin
                        r_TIME_OUT          <= 1'b0     ;
                    end

                    r_TIME_CNT              <= r_TIME_CNT + 1'b1 ;

                end
            end

            @ ( posedge r_CLK0 ) ;
            @ ( posedge r_CLK0 ) ;

        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                       task of LBUS Register Write                           ||
||                                                                             ||
/+=============================================================================*/

    task LBUS_REG_WRITE ;

        input     [ 2:0]    sel         ;
        input     [ 9:0]    address     ;
        input     [31:0]    data        ;

        begin

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b1        ;
                r_LBUS_WR               <=  1'b1        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_DTFF             <=  1'b1        ;
                r_LBUS_DOFF             <= data         ;
            end

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b0        ;
                r_LBUS_WR               <=  1'b0        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_DTFF             <=  1'b1        ;
                r_LBUS_DOFF             <= data         ;
            end

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b1        ;
                r_LBUS_WR               <=  1'b1        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_DTFF             <=  1'b1        ;
                r_LBUS_DOFF             <= data         ;
            end
            @ ( posedge r_CLK1 ) ;
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                       task of LBUS Register Read                            ||
||                                                                             ||
/+=============================================================================*/

    task LBUS_REG_READ ;

        input     [ 2:0]    sel         ;
        input     [ 9:0]    address     ;
        input     [31:0]    data        ;
        input               err_chk     ;

        begin
            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b1        ;
                r_LBUS_RD               <=  1'b1        ;
                r_LBUS_DTFF             <=  1'b1        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_DIFF             <= 32'd0        ;
                r_LBUS_REG_RD_ERR       <= 1'b0         ;
            end

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b0        ;
                r_LBUS_RD               <=  1'b0        ;
                r_LBUS_DTFF             <=  1'b0        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_DIFF             <= 32'd0        ;
            end

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b1        ;
                r_LBUS_RD               <=  1'b1        ;
                r_LBUS_DTFF             <=  1'b0        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_DIFF             <= 32'd0        ;
            end

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b1        ;
                r_LBUS_RD               <=  1'b1        ;
                r_LBUS_DTFF             <=  1'b0        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_DIFF             <= 32'd0        ;
            end

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b0        ;
                r_LBUS_RD               <=  1'b1        ;
                r_LBUS_DTFF             <=  1'b0        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_DIFF             <= s_LBUS_DIFF  ;
            end

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b1        ;
                r_LBUS_RD               <=  1'b1        ;
                r_LBUS_DTFF             <=  1'b0        ;
                r_LBUS_ADDR             <= {sel , address} ;
                r_LBUS_REG_RD_DATA      <= r_LBUS_DIFF  ;

                if (r_LBUS_DIFF != data) begin
                    r_LBUS_REG_RD_ERR   <= err_chk      ;
                end
            end

            @ ( posedge r_CLK1 ) ; begin
                r_LBUS_CS               <=  1'b1        ;
                r_LBUS_RD               <=  1'b1        ;
                r_LBUS_DTFF             <=  1'b1        ;
                r_LBUS_ADDR             <= {sel , address} ;
            end

            @ ( posedge r_CLK1 ) ;
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                            LBUS BRAM write                                  ||
||                                                                             ||
/+=============================================================================*/

    task LBUS_BRAM_WRITE ;

        input       [ 7:0]  fsel            ;
        input       [15:0]  line            ;
        input       [15:0]  addr            ;
        input       [11:0]  size            ;
        integer             k0              ;

        begin
            @ ( posedge r_CLK1 ) ; begin
                file_line                   <= line     ;
                r_BRAM_WR_ADDR              <= addr     ;
            end

            # 1000

            LBUS_REG_WRITE (3'b001, 10'h007, {8'd0,fsel,r_BRAM_WR_ADDR}) ;

            @ ( posedge r_CLK1 ) ;

            for (k0=0 ; k0<size[11:2] ; k0=k0+1) begin
                @ ( posedge r_CLK1 ) ; begin
                    case (fsel)
                        8'h01   : r_BRAM_WR_DATA    <= file_bram0_wr[file_line][1:32] ;
                        8'h02   : r_BRAM_WR_DATA    <= file_bram1_wr[file_line][1:32] ;
                        8'h04   : r_BRAM_WR_DATA    <= file_bram2_wr[file_line][1:32] ;
                        8'h08   : r_BRAM_WR_DATA    <= file_bram3_wr[file_line][1:32] ;
                        8'h10   : r_BRAM_WR_DATA    <= file_bram4_wr[file_line][1:32] ;
                        8'h20   : r_BRAM_WR_DATA    <= file_bram5_wr[file_line][1:32] ;
                        8'h40   : r_BRAM_WR_DATA    <= file_bram6_wr[file_line][1:32] ;
                        8'h80   : r_BRAM_WR_DATA    <= file_bram7_wr[file_line][1:32] ;
                        default : r_BRAM_WR_DATA    <= file_bram0_wr[file_line][1:32] ;
                    endcase
                end

                #1000

                LBUS_REG_WRITE (3'b001, 10'h008, r_BRAM_WR_DATA) ;

                @ ( posedge r_CLK1 ) ; begin
                    file_line               <= file_line + 1'b1 ;
                end
            end

            @ ( posedge r_CLK1 ) ;
            @ ( posedge r_CLK1 ) ;
            @ ( posedge r_CLK1 ) ;
            @ ( posedge r_CLK1 ) ;
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                           LBUS BRAM Read                                    ||
||                                                                             ||
/+=============================================================================*/

    task LBUS_BRAM_READ ;

        input       [ 7:0]  fsel            ;
        input       [15:0]  line            ;
        input       [15:0]  addr            ;
        input       [11:0]  size            ;
        integer             k1              ;

        begin
            @ ( posedge r_CLK1 ) ; begin
                file_line                   <= line     ;
                r_BRAM_RD_ADDR              <= addr     ;
            end

            # 1000

            LBUS_REG_WRITE (3'b001, 10'h009, {8'd0,fsel,r_BRAM_RD_ADDR}) ;

            @ ( posedge r_CLK1 ) ;

            for (k1=0 ; k1<size[11:2] ; k1=k1+1) begin

                @ ( posedge r_CLK1 ) ; begin
                    case (fsel)
                        8'h01   : r_BRAM_RD_EXPD    <= file_bram0_exp[file_line][1:32] ;
                        8'h02   : r_BRAM_RD_EXPD    <= file_bram1_exp[file_line][1:32] ;
                        8'h04   : r_BRAM_RD_EXPD    <= file_bram2_exp[file_line][1:32] ;
                        8'h08   : r_BRAM_RD_EXPD    <= file_bram3_exp[file_line][1:32] ;
                        8'h10   : r_BRAM_RD_EXPD    <= file_bram4_exp[file_line][1:32] ;
                        8'h20   : r_BRAM_RD_EXPD    <= file_bram5_exp[file_line][1:32] ;
                        8'h40   : r_BRAM_RD_EXPD    <= file_bram6_exp[file_line][1:32] ;
                        8'h80   : r_BRAM_RD_EXPD    <= file_bram7_exp[file_line][1:32] ;
                        default : r_BRAM_RD_EXPD    <= file_bram0_exp[file_line][1:32] ;
                    endcase
                end

                # 1000

                LBUS_REG_READ (3'b001, 10'h00A, r_BRAM_RD_EXPD, 1'b1) ;

                @ ( posedge r_CLK1 ) ; begin
                    r_BRAM_RD_DATA          <= r_LBUS_REG_RD_DATA ;
                end

                @ ( posedge r_CLK1 ) ; begin
                    case (fsel)
                        8'h01   : $fdisplay (file_bram0_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h02   : $fdisplay (file_bram1_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h04   : $fdisplay (file_bram2_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h08   : $fdisplay (file_bram3_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h10   : $fdisplay (file_bram4_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h20   : $fdisplay (file_bram5_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h40   : $fdisplay (file_bram6_rd,"%h",r_BRAM_RD_DATA)   ;
                        8'h80   : $fdisplay (file_bram7_rd,"%h",r_BRAM_RD_DATA)   ;
                        default :                                                 ;
                    endcase

                    # 1000

                    if (r_LBUS_REG_RD_ERR) begin
                        r_LBUS_BRAM_RD_ERR  <= 1'b1 ;
                        $display (     "---- [Error      ]Read bram ADD :0x%h  EDAT :0x%h  RDAT :0x%h", {fsel,r_BRAM_RD_ADDR}, r_BRAM_RD_EXPD, r_BRAM_RD_DATA) ;
                        $fdisplay (LOG,"---- [Error      ]Read bram ADD :0x%h  EDAT :0x%h  RDAT :0x%h", {fsel,r_BRAM_RD_ADDR}, r_BRAM_RD_EXPD, r_BRAM_RD_DATA) ;
                    end

                    # 1000

                    file_line               <= file_line + 1'b1 ;
                    r_BRAM_RD_ADDR          <= r_BRAM_RD_ADDR + 1'b1 ;
                end
            end

            @ ( posedge r_CLK1 ) ;
            @ ( posedge r_CLK1 ) ;
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                            LBUS DRAM write                                  ||
||                                                                             ||
/+=============================================================================*/

    task LBUS_DRAM_WRITE ;

        input       [ 6:0]  fsel            ;
        input       [15:0]  line            ;
        input       [24:0]  addr            ;
        input       [11:0]  size            ;
        integer             k2              ;
        integer             k3              ;
        integer             k4              ;

        begin

            @ ( posedge r_CLK1 ) ; begin
                file_line                   <= line     ;
                r_LBUS_DRAM_WR_ERR          <= 1'b0     ;
                r_DRAM_WR_ADDR              <= addr     ;
                r_DRAM_WR_BUSY              <= 1'b1     ;
                r_TIME_OUT                  <= 1'b0     ;
                r_TIME_CNT                  <= 8'd0     ;
            end

            while (r_DRAM_WR_BUSY == 1'b1 && r_TIME_OUT == 1'b0) begin

                LBUS_REG_READ (3'b001, 10'h006, 32'd0, 1'b0) ;

                # 1000

                @ (posedge r_CLK1) ; begin
                    r_DRAM_WR_BUSY          <= r_LBUS_REG_RD_DATA[0] ;
                end

                @ (posedge r_CLK1) ; begin
                    if (r_TIME_CNT == 8'h20) begin
                        r_TIME_OUT          <= 1'b1 ;
                        r_LBUS_DRAM_WR_ERR  <= 1'b1 ;
                        $display (     "---- [Error      ]LBUS write dram wait busy timeout") ;
                        $fdisplay (LOG,"---- [Error      ]LBUS write dram wait busy timeout") ;
                    end else begin
                        r_TIME_CNT          <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            # 1000
            LBUS_REG_WRITE (3'b001, 10'h000, {fsel,addr}) ;

            @ ( posedge r_CLK1 ) ;

            for (k2=0 ; k2<size[11:2] ; k2=k2+1) begin
                @ ( posedge r_CLK1 ) ; begin
                    case (fsel)
                        8'h01   : r_DRAM_WR_DATA    <= file_dram0_wr[file_line][1:32] ;
                        8'h02   : r_DRAM_WR_DATA    <= file_dram1_wr[file_line][1:32] ;
                        8'h04   : r_DRAM_WR_DATA    <= file_dram2_wr[file_line][1:32] ;
                        8'h08   : r_DRAM_WR_DATA    <= file_dram3_wr[file_line][1:32] ;
                        8'h10   : r_DRAM_WR_DATA    <= file_dram4_wr[file_line][1:32] ;
                        8'h20   : r_DRAM_WR_DATA    <= file_dram5_wr[file_line][1:32] ;
                        8'h40   : r_DRAM_WR_DATA    <= file_dram6_wr[file_line][1:32] ;
                        default : r_DRAM_WR_DATA    <= file_dram0_wr[file_line][1:32] ;
                    endcase

                end

                # 1000
                LBUS_REG_WRITE (3'b001, 10'h001, r_DRAM_WR_DATA) ;

                @ ( posedge r_CLK1 ) ; begin
                    file_line               <= file_line + 1'b1 ;
                end
            end

            @ ( posedge r_CLK1 ) ;
            LBUS_REG_WRITE (3'b001, 10'h005, {14'd0,1'b0,1'b1,4'b0,size}) ;

            for (k3=0; k3<size[11:2] ; k3=k3+1 ) begin
                @ ( posedge r_CLK0 ) ;
            end
        end

    endtask

/*=============================================================================+/
||                                                                             ||
||                           LBUS DRAM Read                                    ||
||                                                                             ||
/+=============================================================================*/

    task LBUS_DRAM_READ ;

        input       [ 6:0]  fsel            ;
        input       [15:0]  line            ;
        input       [24:0]  addr            ;
        input       [11:0]  size            ;
        integer             k5              ;

        begin

            @ ( posedge r_CLK1 ) ; begin
                file_line                   <= line     ;
                r_LBUS_DRAM_RD_ERR          <= 1'b0     ;
                r_DRAM_RD_ADDR              <= addr     ;
                r_DRAM_RD_BUSY              <= 1'b1     ;
                r_TIME_OUT                  <= 1'b0     ;
                r_TIME_CNT                  <= 8'd0     ;
            end

            while (r_DRAM_RD_BUSY == 1'b1 && r_TIME_OUT == 1'b0) begin

                LBUS_REG_READ (3'b001, 10'h006, 32'd0, 1'b0) ;

                @ (posedge r_CLK1) ; begin
                    r_DRAM_RD_BUSY          <= r_LBUS_REG_RD_DATA[1] ;
                end

                @ (posedge r_CLK1) ; begin
                    if (r_TIME_CNT == 8'h20) begin
                        r_TIME_OUT          <= 1'b1 ;
                        r_LBUS_DRAM_RD_ERR  <= 1'b1 ;
                        $display (     "---- [Error      ]LBUS read dram wait busy timeout") ;
                        $fdisplay (LOG,"---- [Error      ]LBUS read dram wait busy timeout") ;
                    end else begin
                        r_TIME_CNT          <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            LBUS_REG_WRITE (3'b001, 10'h000, {fsel,addr}) ;
            LBUS_REG_WRITE (3'b001, 10'h005, {14'd0,1'b1,1'b0,4'b0,size}) ;

            @ ( posedge r_CLK1 ) ; begin
                file_line                   <= line     ;
                r_DRAM_RD_BUSY              <= 1'b1     ;
                r_TIME_OUT                  <= 1'b0     ;
                r_TIME_CNT                  <= 8'd0     ;
            end

            while (r_DRAM_RD_BUSY == 1'b1 && r_TIME_OUT == 1'b0) begin

                LBUS_REG_READ (3'b001, 10'h006, 32'd0, 1'b0) ;

                @ (posedge r_CLK1) ; begin
                    r_DRAM_RD_BUSY          <= r_LBUS_REG_RD_DATA[1] ;
                end

                @ (posedge r_CLK1) ; begin
                    if (r_TIME_CNT == 8'h40) begin
                        r_TIME_OUT          <= 1'b1 ;
                        r_LBUS_DRAM_RD_ERR  <= 1'b1 ;
                        $display (     "---- [Error      ]LBUS read dram wait ack timeout") ;
                        $fdisplay (LOG,"---- [Error      ]LBUS read dram wait ack timeout") ;
                    end else begin
                        r_TIME_CNT          <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            @ ( posedge r_CLK1 ) ;

            for (k5=0 ; k5<size[11:2] ; k5=k5+1) begin

                @ ( posedge r_CLK1 ) ; begin
                    case (fsel)
                        8'h01   : r_DRAM_RD_EXPD    <= file_dram0_exp[file_line][1:32] ;
                        8'h02   : r_DRAM_RD_EXPD    <= file_dram1_exp[file_line][1:32] ;
                        8'h04   : r_DRAM_RD_EXPD    <= file_dram2_exp[file_line][1:32] ;
                        8'h08   : r_DRAM_RD_EXPD    <= file_dram3_exp[file_line][1:32] ;
                        8'h10   : r_DRAM_RD_EXPD    <= file_dram4_exp[file_line][1:32] ;
                        8'h20   : r_DRAM_RD_EXPD    <= file_dram5_exp[file_line][1:32] ;
                        8'h40   : r_DRAM_RD_EXPD    <= file_dram6_exp[file_line][1:32] ;
                        default : r_DRAM_RD_EXPD    <= file_dram0_exp[file_line][1:32] ;
                    endcase
                end

                # 1000

                LBUS_REG_READ (3'b001, 10'h002, r_DRAM_RD_EXPD, 1'b1) ;

                @ ( posedge r_CLK1 ) ; begin
                    r_DRAM_RD_DATA          <= r_LBUS_REG_RD_DATA ;
                end

                @ ( posedge r_CLK1 ) ; begin
                    case (fsel)
                        8'h01   : $fdisplay (file_dram0_rd,"%h",r_DRAM_RD_DATA)   ;
                        8'h02   : $fdisplay (file_dram1_rd,"%h",r_DRAM_RD_DATA)   ;
                        8'h04   : $fdisplay (file_dram2_rd,"%h",r_DRAM_RD_DATA)   ;
                        8'h08   : $fdisplay (file_dram3_rd,"%h",r_DRAM_RD_DATA)   ;
                        8'h10   : $fdisplay (file_dram4_rd,"%h",r_DRAM_RD_DATA)   ;
                        8'h20   : $fdisplay (file_dram5_rd,"%h",r_DRAM_RD_DATA)   ;
                        8'h40   : $fdisplay (file_dram6_rd,"%h",r_DRAM_RD_DATA)   ;
                        default :                                                 ;
                    endcase

                    if (r_LBUS_REG_RD_ERR) begin
                        r_LBUS_DRAM_RD_ERR  <= 1'b1 ;
                        $display (     "---- [Error      ]LBUS read dram ADD :0x%h  EDAT :0x%h  RDAT :0x%h", {fsel,r_DRAM_RD_ADDR}, r_DRAM_RD_EXPD, r_DRAM_RD_DATA) ;
                        $fdisplay (LOG,"---- [Error      ]LBUS read dram ADD :0x%h  EDAT :0x%h  RDAT :0x%h", {fsel,r_DRAM_RD_ADDR}, r_DRAM_RD_EXPD, r_DRAM_RD_DATA) ;
                    end

                    file_line               <= file_line + 1'b1 ;
                    r_DRAM_RD_ADDR          <= r_DRAM_RD_ADDR + 1'b1 ;
                end
            end

            @ ( posedge r_CLK1 ) ;
            @ ( posedge r_CLK1 ) ;

        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                             task of Fail input check                        ||
||                                                                             ||
/+=============================================================================*/

    task FAIL_ICHK ;
        input     [ 7:0]    timeout                 ;

        begin
            @ ( posedge r_CLK1 )                    ;
            r_TIME_CNT                  <= 8'h00    ;
            r_TIME_OUT                  <= 1'b0     ;

            while (FAIL_I == 1'b0 && r_TIME_OUT == 1'b0) begin
                @ (posedge r_CLK1) ; begin
                    if (r_TIME_CNT == timeout) begin
                        r_TIME_OUT      <= 1'b1     ;
                        r_TIME_CNT      <= 8'h00    ;
                    end else begin
                        r_TIME_OUT      <= 1'b0     ;
                        r_TIME_CNT      <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            @ ( posedge r_CLK1 )                    ;
            @ ( posedge r_CLK1 )                    ;
        end
    endtask

/*=============================================================================+/
||                                                                             ||
||                             task of Trig input check                        ||
||                                                                             ||
/+=============================================================================*/

    task TRIG_ICHK ;
        input     [ 7:0]    timeout                 ;

        begin
            @ ( posedge r_CLK1 )                    ;
            r_TIME_CNT                  <= 8'h00    ;
            r_TIME_OUT                  <= 1'b0     ;

            while (TRIG_I == 1'b0 && r_TIME_OUT == 1'b0) begin
                @ (posedge r_CLK1) ; begin
                    if (r_TIME_CNT == timeout) begin
                        r_TIME_OUT      <= 1'b1     ;
                        r_TIME_CNT      <= 8'h00    ;
                    end else begin
                        r_TIME_OUT      <= 1'b0     ;
                        r_TIME_CNT      <= r_TIME_CNT + 1'b1 ;
                    end
                end
            end

            @ ( posedge r_CLK1 )                    ;
            @ ( posedge r_CLK1 )                    ;
        end
    endtask

endmodule