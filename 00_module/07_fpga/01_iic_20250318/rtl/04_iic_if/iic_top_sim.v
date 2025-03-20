// =================================================================================================
// File Name        : I2C_IF.v
// Module           : I2C_IF
// Function         : I2C_IF
// Type             : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
//
// =================================================================================================
// End Revision
// =================================================================================================

`define SIM

`timescale 1ps / 1ps

module I2C_TOP_SIM (
    input                               CLK                                     ,//(i)[1] System clock  200M
    input                               RST                                     ,//(i)[1] System reset
    // I2C master
    input                               I2C_WR_EN                               ,//(i)[  1] I2C write enable
    input       [ 7:0]                  I2C_WR_DATA                             ,//(i)[  8] I2C write data
    output                              I2C_WR_ACK                              ,//(o)[  1] I2C Write ack
    input                               I2C_RD_EN                               ,//(i)[  1] I2C read enable
    output                              I2C_RD_ACK                              ,//(o)[  1] I2C read ack
    output      [ 7:0]                  I2C_RD_DATA                             ,//(o)[  8] I2C read data
    input       [ 7:0]                  I2C_SLV_ADDR                            ,//(i)[  8] I2C slaver address
    input       [ 7:0]                  I2C_SUB_ADDR                            ,//(i)[  8] I2C sub address
    output                              I2C_ACK_ERR                             ,//(o)[  1] I2C access error
    output                              I2C_BUSY                                ,//(o)[  1] I2C access busy
    // I2C slaver0
    output                              I2C_SLAV0_WR_EN                         ,//(o)[  1] I2C slaver0 write enable
    output      [   7:0]                I2C_SLAV0_WR_DATA                       ,//(o)[  8] I2C slaver0 write data
    output      [   7:0]                I2C_SLAV0_OP_ADDR                       ,//(o)[  8] I2C slaver0 write address
    output                              I2C_SLAV0_RD_EN                         ,//(o)[  1] I2C slaver0 read  enable
    input       [   7:0]                I2C_SLAV0_RD_DATA                       ,//(o)[  8] I2C slaver0 read  data
    input                               I2C_SLAV0_RD_ACK                        ,//(o)[  1] I2C slaver0 read  data ACK
    // I2C slaver1
    output                              I2C_SLAV1_WR_EN                         ,//(o)[  1] I2C slaver1 write enable
    output      [   7:0]                I2C_SLAV1_WR_DATA                       ,//(o)[  8] I2C slaver1 write data
    output      [   7:0]                I2C_SLAV1_OP_ADDR                       ,//(o)[  8] I2C slaver1 write address
    output                              I2C_SLAV1_RD_EN                         ,//(o)[  1] I2C slaver1 read  enable
    input       [   7:0]                I2C_SLAV1_RD_DATA                       ,//(o)[  8] I2C slaver1 read  data
    input                               I2C_SLAV1_RD_ACK                         //(o)[  1] I2C slaver1 read  data ACK
    );

// =============================================================================
// Prameter define
// =============================================================================

// =============================================================================
// Internal signal define
// =============================================================================

    wire                                s_I2C_IF_SCL                            ;//(s)[  1]
    wire                                s_I2C_SLAV0_SDA_OUT                     ;//(s)[  1]
    wire                                s_I2C_SLAV1_SDA_OUT                     ;//(s)[  1]
    wire                                s_I2C_MASTER_SDA_IN                     ;//(s)[  1]
    wire                                s_I2C_MASTER_SDA_OUT                    ;//(s)[  1]
    wire                                s_I2C_SLAV0_SDA_OE                      ;//(s)[  1]
    wire                                s_I2C_SLAV1_SDA_OE                      ;//(s)[  1]

// =============================================================================
// output
// =============================================================================

// =============================================================================
//                     rtl body
// =============================================================================

/*=============================================================================+/
||                                                                             ||
||                                    IIC_MASTER                               ||
||                                                                             ||
/+=============================================================================*/

    I2C_MASTER_IF U_I2C_MASTER_IF(
        // Global signals
        .SYS_CLK                        ( CLK                                   ),//(i)[  1]
        .SYS_RST                        ( RST                                   ),//(i)[  1]
        // I2C interface
        .I2C_IF_SCL                     ( s_I2C_IF_SCL                          ),//(o)[  1] I2C clocl

`ifdef SIM
        .I2C_IF_SDA_IN                  ( s_I2C_MASTER_SDA_IN                   ),//(i)[  1] I2C data in for sim
        .I2C_IF_SDA_OUT                 ( s_I2C_MASTER_SDA_OUT                  ),//(o)[  1] I2C data out for sim
`else
        .I2C_IF_SDA                     (                                       ),//(io)[  1] I2C data
`endif

        // User interface
        .I2C_WR_EN                      ( I2C_WR_EN                             ),//(i)[  1]
        .I2C_WR_DATA                    ( I2C_WR_DATA                           ),//(i)[  8]
        .I2C_WR_ACK                     ( I2C_WR_ACK                            ),//(o)[  1]
        .I2C_RD_EN                      ( I2C_RD_EN                             ),//(i)[  1]
        .I2C_RD_ACK                     ( I2C_RD_ACK                            ),//(o)[  1]
        .I2C_RD_DATA                    ( I2C_RD_DATA                           ),//(o)[  8]
        .I2C_SLV_ADDR                   ( I2C_SLV_ADDR                          ),//(i)[  8]
        .I2C_SUB_ADDR                   ( I2C_SUB_ADDR                          ),//(i)[  8]
        .I2C_ACK_ERR                    ( I2C_ACK_ERR                           ),//(o)[  1]
        .I2C_BUSY                       ( I2C_BUSY                              )//(o)[  1]
    ) ;

/*=============================================================================+/
||                                                                             ||
||                                    IIC_SLAVER                               ||
||                                                                             ||
/+=============================================================================*/

    assign s_I2C_MASTER_SDA_IN = s_I2C_SLAV0_SDA_OE ? s_I2C_SLAV0_SDA_OUT :
                                 s_I2C_SLAV1_SDA_OE ? s_I2C_SLAV1_SDA_OUT : 1'b1 ;

    I2C_SLAVE0_IF U0_I2C_SLAVE0_IF(
        // Global signals
        .CLK                            ( CLK                                   ),//(i)[  1]
        .RST                            ( RST                                   ),//(i)[  1]
        // I2C interface
        .I2C_IF_SCL                     ( s_I2C_IF_SCL                          ),//(i)[  1] I2C clocl

`ifdef SIM
        .I2C_IF_SDA_IN                  ( s_I2C_MASTER_SDA_OUT                  ),//(i)[  1]
        .I2C_IF_SDA_OUT                 ( s_I2C_SLAV0_SDA_OUT                   ),//(o)[  1]
        .I2C_IF_SDA_OE                  ( s_I2C_SLAV0_SDA_OE                    ),//(o)[  1]
`else
        .I2C_IF_SDA                     (                                       ),//(io)[  1] I2C data
`endif

        .I2C_WR_EN                      ( I2C_SLAV0_WR_EN                       ),//(o)[  1]
        .I2C_WR_DATA                    ( I2C_SLAV0_WR_DATA                     ),//(o)[  8]
        .I2C_OP_ADDR                    ( I2C_SLAV0_OP_ADDR                     ),//(o)[  8]
        .I2C_RD_EN                      ( I2C_SLAV0_RD_EN                       ),//(o)[  1]
        .I2C_RD_DATA                    ( I2C_SLAV0_RD_DATA                     ),//(i)[  8]
        .I2C_RD_ACK                     ( I2C_SLAV0_RD_ACK                      ) //(i)[  1]
    ) ;

    I2C_SLAVE1_IF U1_I2C_SLAVE1_IF(
        // Global signals
        .CLK                            ( CLK                                   ),//(i)[  1]
        .RST                            ( RST                                   ),//(i)[  1]
        // I2C interface
        .I2C_IF_SCL                     ( s_I2C_IF_SCL                          ),//(i)[  1]

`ifdef SIM
        .I2C_IF_SDA_IN                  ( s_I2C_MASTER_SDA_OUT                  ),//(i)[  1]
        .I2C_IF_SDA_OUT                 ( s_I2C_SLAV1_SDA_OUT                   ),//(o)[  1]
        .I2C_IF_SDA_OE                  ( s_I2C_SLAV1_SDA_OE                    ),//(o)[  1]
`else
        .I2C_IF_SDA                     (                                       ),//(io)[  1] I2C data
`endif

        .I2C_WR_EN                      ( I2C_SLAV1_WR_EN                       ),//(o)[  1]
        .I2C_WR_DATA                    ( I2C_SLAV1_WR_DATA                     ),//(o)[  8]
        .I2C_OP_ADDR                    ( I2C_SLAV1_OP_ADDR                     ),//(o)[  8]
        .I2C_RD_EN                      ( I2C_SLAV1_RD_EN                       ),//(o)[  1]
        .I2C_RD_DATA                    ( I2C_SLAV1_RD_DATA                     ),//(i)[  8]
        .I2C_RD_ACK                     ( I2C_SLAV1_RD_ACK                      ) //(i)[  1]
    ) ;

endmodule