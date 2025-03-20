// =================================================================================================
// File Name      : uart_if.v
// Module         : UART_IF
// Function       : UART_IF
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2018/12/26   Base.L            create new          speed-clouds
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ns/1ps


module FPGA_TOP(
    input                               USER_CLK                                ,// (i) [   1]
    input                               USER_RST                                ,// (i) [   1]

    input                               UART_RXD                                ,// (i) [   1]
    output                              UART_TXD                                 // (o) [   1]
    );
    
    
// =============================================================================
// Internal Parameter Declare
// =============================================================================


// =============================================================================
// Internal signals declaration
// =============================================================================

    wire                                s_REG_WR_REQ                             ;//(s)[   1]
    wire                                s_REG_WR_ACK                             ;//(s)[   1]
    wire        [  31:0]                s_REG_WR_DATA                            ;//(s)[  32]
    wire                                s_REG_RD_REQ                             ;//(s)[   1]
    wire                                s_REG_RD_ACK                             ;//(s)[   1]
    wire        [  31:0]                s_REG_RD_DATA                            ;//(s)[  32]
    wire        [  15:0]                s_REG_OP_ADDR                            ;//(s)[   8]

// =================================================================================================
// RTL Body
// =================================================================================================



/*==============================================================================+/
||                                                                              ||
||                             UART RX Frame Decode                             ||
||                                                                              ||
/+==============================================================================*/
    
    UART_IF U0_UART_IF(
        .USER_CLK                       ( USER_CLK              )         ,// (i) [   1]
        .USER_RST                       ( ~USER_RST              )         ,// (i) [   1]

        .REG_WR_REQ                     ( s_REG_WR_REQ          )         ,// (o) [   1]
        .REG_WR_ACK                     ( s_REG_WR_ACK          )         ,// (i) [   1]
        .REG_WR_DATA                    ( s_REG_WR_DATA         )         ,// (o) [  32]
        .REG_RD_REQ                     ( s_REG_RD_REQ          )         ,// (o) [   1]
        .REG_RD_ACK                     ( s_REG_RD_ACK          )         ,// (i) [   1]
        .REG_RD_DATA                    ( s_REG_RD_DATA         )         ,// (i) [  32]
        .REG_OP_ADDR                    ( s_REG_OP_ADDR         )         ,// (o) [   8]

        .UART_RXD                       ( UART_RXD              )         ,// (i) [   1]
        .UART_TXD                       ( UART_TXD              )          // (o) [   1]
    );


    REG_BIST U1_REG_BIST(
        //system signals
        .CLK                            ( USER_CLK              )         ,//(i)  [   1]
        .RST                            ( ~USER_RST              )         ,//(i)  [   1]
        //register if                      
        .REG_WR_REQ                     ( s_REG_WR_REQ          )         ,//(i)  [   1]
        .REG_RD_REQ                     ( s_REG_RD_REQ          )         ,//(i)  [   1]
        .REG_WR_ACK                     ( s_REG_WR_ACK          )         ,//(o)  [   1]
        .REG_RD_ACK                     ( s_REG_RD_ACK          )         ,//(o)  [   1]
        .REG_WR_DATA                    ( s_REG_WR_DATA         )         ,//(i)  [  32]
        .REG_RD_DATA                    ( s_REG_RD_DATA         )         ,//(o)  [  32]
        .REG_OP_ADDR                    ( s_REG_OP_ADDR         )         ,//(i)  [  16]

        .DEBUG_DI0                      ( 1'b0                  )         ,//(i)  [  32]
        .DEBUG_DI1                      ( 1'b0                  )         ,//(i)  [  32]
        .DEBUG_DI2                      ( 1'b0                  )         ,//(i)  [  32]
        .DEBUG_DI3                      ( 1'b0                  )         ,//(i)  [  32]
        .DEBUG_DI4                      ( 1'b0                  )         ,//(i)  [  32]
        .DEBUG_DI5                      ( 1'b0                  )         ,//(i)  [  32]
        .DEBUG_DI6                      ( 1'b0                  )         ,//(i)  [  32]
        .DEBUG_DI7                      ( 1'b0                  )         ,//(i)  [  32]

        .DEBUG_DO0                      (                       )         ,//(o)  [  32]
        .DEBUG_DO1                      (                       )         ,//(o)  [  32]
        .DEBUG_DO2                      (                       )         ,//(o)  [  32]
        .DEBUG_DO3                      (                       )         ,//(o)  [  32]
        .DEBUG_DO4                      (                       )         ,//(o)  [  32]
        .DEBUG_DO5                      (                       )         ,//(o)  [  32]
        .DEBUG_DO6                      (                       )         ,//(o)  [  32]
        .DEBUG_DO7                      (                       )         ,//(o)  [  32]

        .DEBUG_TRIG0                    (                       )         ,//(o)  [   1]
        .DEBUG_TRIG1                    (                       )         ,//(o)  [   1]
        .DEBUG_TRIG2                    (                       )         ,//(o)  [   1]
        .DEBUG_TRIG3                    (                       )         ,//(o)  [   1]
        .DEBUG_TRIG4                    (                       )         ,//(o)  [   1]
        .DEBUG_TRIG5                    (                       )         ,//(o)  [   1]
        .DEBUG_TRIG6                    (                       )         ,//(o)  [   1]
        .DEBUG_TRIG7                    (                       )          //(o)  [   1]
    );



endmodule