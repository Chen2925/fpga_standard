// =================================================================================================
// File Name      : spi_ctrl.v
// Module         : SPI_CTRL
// Function       : SPI interface timing control
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date          Coded by                Contents
// 0.1.0      2018/8/20     Benson                  Create new
//
// =================================================================================================
// End Revision
// =================================================================================================

//mode0 idle 0 pos sample neg change

`timescale 1 ps/1 ps

module SPI_SIM (
    // Global signals
    input                               SYS_RST                                 ,//(i) [  1]
    input                               SYS_CLK                                 ,//(i) [  1]
    // User interface
    input                               SPI_WR_REQ                              ,//(i) [  1]
    input           [ 7:0]              SPI_WR_ADDR                             ,//(i) [  8]
    input           [15:0]              SPI_WR_DATA                             ,//(i) [ 16]
    output                              SPI_WR_ACK                              ,//(o) [  1]
    input                               SPI_RD_REQ                              ,//(i) [  1]
    input           [ 7:0]              SPI_RD_ADDR                             ,//(i) [  8]
    output                              SPI_RD_ACK                              ,//(o) [ 16]
    output          [15:0]              SPI_RD_DATA                             ,//(o) [  1]
    input                               SPI_OP_SEL                              ,//(i) [  1]
    output                              SPI_OP_BUSY                             ,//(o) [  1]
    output                              SPI_OP_ERR                              ,//(o) [  1]
    // SPI interface
    output                              REG_WR_REQ                              ,//(o)  [   1]
    output                              REG_RD_REQ                              ,//(o)  [   1]
    input                               REG_RD_ACK                              ,//(i)  [   1]
    output      [  15:0]                REG_WR_DATA                             ,//(o)  [  32]
    input       [  15:0]                REG_RD_DATA                             ,//(i)  [  32]
    output      [   7:0]                REG_OP_ADDR                              //(o)  [  16]
    ) ;

// =============================================================================
// Prameter define
// =============================================================================

// =============================================================================
// Internal signal define
// =============================================================================

    wire                                s_SPI_GP_XRST                           ;//(s)[  1]
    wire                                s_SPI_GP_CS                             ;//(s)[  1]
    wire                                s_SPI_GP_CLK                            ;//(s)[  1]
    wire                                s_SPI_GP_MOSI                           ;//(s)[  1]
    wire                                s_SPI_GP_MISO                           ;//(s)[  1]
    wire                                s_SPI_GP_BUSY                           ;//(s)[  1]

// =============================================================================
// output
// =============================================================================

// =============================================================================
//                     rtl body
// =============================================================================

/*=============================================================================+/
||                                                                             ||
||                                    xxx                                      ||
||                                                                             ||
/+=============================================================================*/

    SPI_MASTER U_SPI_MASTER(
        // Global signals
        .RST                            ( SYS_RST                               ),//(i) [  1]
        .CLK                            ( SYS_CLK                               ),//(i) [  1]
        // User interface
        .SPI_WR_REQ                     ( SPI_WR_REQ                            ),//(i) [  1]
        .SPI_WR_ADDR                    ( SPI_WR_ADDR                           ),//(i) [  8]
        .SPI_WR_DATA                    ( SPI_WR_DATA                           ),//(i) [ 16]
        .SPI_WR_ACK                     ( SPI_WR_ACK                            ),//(o) [  1]
        .SPI_RD_REQ                     ( SPI_RD_REQ                            ),//(i) [  1]
        .SPI_RD_ADDR                    ( SPI_RD_ADDR                           ),//(i) [  8]
        .SPI_RD_ACK                     ( SPI_RD_ACK                            ),//(o) [ 16]
        .SPI_RD_DATA                    ( SPI_RD_DATA                           ),//(o) [  1]
        .SPI_OP_SEL                     ( SPI_OP_SEL                            ),//(i) [  1]
        .SPI_OP_BUSY                    ( SPI_OP_BUSY                           ),//(o) [  1]
        // SPI interface
        .SPI_GP_XRST                    ( s_SPI_GP_XRST                         ),//(o) [  1]
        .SPI_GP_CS                      ( s_SPI_GP_CS                           ),//(o) [  1]
        .SPI_GP_CLK                     ( s_SPI_GP_CLK                          ),//(o) [  1]
        .SPI_GP_SDI                     ( s_SPI_GP_MOSI                         ),//(o) [  1]
        .SPI_GP_SDO                     ( s_SPI_GP_MISO                         ),//(i) [  1]
        .SPI_GP_BUSY                    ( s_SPI_GP_BUSY                         ) //(1) [  1]
    ) ;

    SPI_SLAVE U_SPI_SLAVE(
        // Global signals
        .RST                            ( SYS_RST                               ),//(i)[  1]
        .CLK                            ( SYS_CLK                               ),//(i)[  1]
        // reg interface
        .REG_WR_REQ                     ( REG_WR_REQ                            ),//(o)[  1]
        .REG_RD_REQ                     ( REG_RD_REQ                            ),//(o)[  1]
        .REG_RD_ACK                     ( REG_RD_ACK                            ),//(i)[  1]
        .REG_WR_DATA                    ( REG_WR_DATA                           ),//(o)[ 32]
        .REG_RD_DATA                    ( REG_RD_DATA                           ),//(i)[ 32]
        .REG_OP_ADDR                    ( REG_OP_ADDR                           ),//(o)[ 16]
        // SPI interface
        .SPI_GP_XRST                    ( s_SPI_GP_XRST                         ),//(o)[  1]
        .SPI_GP_CS                      ( s_SPI_GP_CS                           ),//(o)[  1]
        .SPI_GP_CLK                     ( s_SPI_GP_CLK                          ),//(o)[  1]
        .SPI_GP_MOSI                    ( s_SPI_GP_MOSI                         ),//(o)[  1]
        .SPI_GP_MISO                    ( s_SPI_GP_MISO                         ),//(i)[  1]
        .SPI_GP_BUSY                    ( s_SPI_GP_BUSY                         ) //(1)[  1]
    );


endmodule