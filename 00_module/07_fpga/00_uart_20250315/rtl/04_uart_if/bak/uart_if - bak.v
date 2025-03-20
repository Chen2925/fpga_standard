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

`include   "sim_model/define/define.v"

`timescale 1ns/1ps

module UART_IF (
    input                               USER_CLK                                ,// (i) [   1]
    input                               USER_RST                                ,// (i) [   1]

`ifdef SIM
    input                               UART_RX_ERR                             ,//(i)[   1]
    input                               UART_RX_VLD                             ,//(i)[   1]
    input       [   7:0]                UART_RX_DAT                             ,//(i)[   8]

    output                              UART_TX_REQ                             ,//(o)[   1]
    input                               UART_TX_ACK                             ,//(i)[   1]
    output       [   7:0]               UART_TX_DAT                              //(o)[   8]

//  input                               UART_RXD                                ,// (i) [   1]
//  output                              UART_TXD                                ,// (o) [   1]
`else
    input                               UART_RXD                                ,// (i) [   1]
    output                              UART_TXD                                ,// (o) [   1]
`endif SIM

    output                              REG_WR_REQ                              ,// (o) [   1]
    input                               REG_WR_ACK                              ,// (i) [   1]
    output      [  31:0]                REG_WR_DATA                             ,// (o) [  32]
    output                              REG_RD_REQ                              ,// (o) [   1]
    input                               REG_RD_ACK                              ,// (i) [   1]
    input       [  31:0]                REG_RD_DATA                             ,// (i) [  32]
    output      [  15:0]                REG_OP_ADDR                              // (o) [   8]
    );

// =============================================================================
// Internal Parameter Declare
// =============================================================================

    parameter       real                p_CLK_FREQ          = 50e6              ;// (p) 50MHz
    parameter                           p_UART_BAUD         = 115200            ;// (p)

// =============================================================================
// Internal signals declaration
// =============================================================================

    wire                                s_BPS_RX_TRIG                           ;
    wire                                s_BPS_TX_TRIG                           ;

    wire                                s_UART_RX_BERR                          ;
    wire                                s_UART_RX_VLD                           ;
    wire        [   7:0]                s_UART_RX_DAT                           ;
    wire                                s_REG_WR_REQ                            ;
    wire        [  31:0]                s_REG_WR_DATA                           ;
    wire                                s_REG_RD_REQ                            ;
    wire        [  15:0]                s_REG_OP_ADDR                           ;

    wire                                s_UART_TX_REQ                           ;
    wire                                s_UART_TX_ACK                           ;
    wire        [   7:0]                s_UART_TX_DAT                           ;

// =================================================================================================
// RTL Body
// =================================================================================================


/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/

    assign REG_WR_REQ                    = s_REG_WR_REQ                         ;
    assign REG_WR_DATA                   = s_REG_WR_DATA                        ;
    assign REG_RD_REQ                    = s_REG_RD_REQ                         ;
    assign REG_OP_ADDR                   = s_REG_OP_ADDR                        ;

/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/

    BPS_GEN #(
        .p_CLK_FREQ                     ( p_CLK_FREQ            ),// (p) 156.25MHz
        .p_UART_BAUD                    ( p_UART_BAUD           ) // (p)
        )
    U_BPS_GEN (
        .USER_CLK                       ( USER_CLK              ),// (i) [   1]
        .USER_RST                       ( USER_RST              ),// (i) [   1]

        .BPS_RX_TRIG                    ( s_BPS_RX_TRIG         ),// (o) [   1]
        .BPS_TX_TRIG                    ( s_BPS_TX_TRIG         ) // (o) [   1]
        );

/*==============================================================================+/
||                                                                              ||
||                             UART RX Frame Decode                             ||
||                                                                              ||
/+==============================================================================*/
`ifdef SIM
//  UART_RX U_UART_RX (
//      .USER_CLK                       ( USER_CLK              ),// (i) [   1]
//      .USER_RST                       ( USER_RST              ),// (i) [   1]
//      .BPS_RX_TRIG                    ( s_BPS_RX_TRIG         ),// (i) [   1]

//      .UART_RX_BERR                   ( s_UART_RX_BERR        ),// (o) [   1]
//      .UART_RX_VLD                    ( s_UART_RX_VLD         ),// (o) [   1]
//      .UART_RX_DAT                    ( s_UART_RX_DAT         ),// (o) [   8]

//      .UART_RXD                       ( UART_RXD              ) // (i) [   1]
//  );

`else
    UART_RX U_UART_RX (
        .USER_CLK                       ( USER_CLK              ),// (i) [   1]
        .USER_RST                       ( USER_RST              ),// (i) [   1]
        .BPS_RX_TRIG                    ( s_BPS_RX_TRIG         ),// (i) [   1]

        .UART_RX_BERR                   ( s_UART_RX_BERR        ),// (o) [   1]
        .UART_RX_VLD                    ( s_UART_RX_VLD         ),// (o) [   1]
        .UART_RX_DAT                    ( s_UART_RX_DAT         ),// (o) [   8]

        .UART_RXD                       ( UART_RXD              ) // (i) [   1]
    );
`endif SIM

    RX_BUF U_RX_BUF(
        .USER_CLK                       ( USER_CLK              ),//(i)[   1]
        .USER_RST                       ( USER_RST              ),//(i)[   1]

`ifdef SIM
        .UART_RX_ERR                    ( UART_RX_ERR           ),//(i)[   1]
        .UART_RX_VLD                    ( UART_RX_VLD           ),//(i)[   1]
        .UART_RX_DAT                    ( UART_RX_DAT           ),//(i)[   8]
`else
        .UART_RX_ERR                    ( s_UART_RX_BERR        ),//(i)[   1]
        .UART_RX_VLD                    ( s_UART_RX_VLD         ),//(i)[   1]
        .UART_RX_DAT                    ( s_UART_RX_DAT         ),//(i)[   8]
`endif SIM


        .FRAME_TIMEOUT                  ( s_FRAME_TIMEOUT       ),//(o)[   1]
        .FRAME_DVLD                     ( s_FRAME_DVLD          ),//(o)[   1]
        .FRAME_DATA                     ( s_FRAME_DATA          ) //(o)[   8]
    );


    RX_DEC U_RX_DEC (
        .USER_CLK                       ( USER_CLK              ),//(i)[   1]
        .USER_RST                       ( USER_RST              ),//(i)[   1]

        // User Register Signal
        .UART_RX_BERR                   ( s_FRAME_TIMEOUT       ),//(i)[   1]
        .UART_RX_VLD                    ( s_FRAME_DVLD          ),//(i)[   1]
        .UART_RX_DAT                    ( s_FRAME_DATA          ),//(i)[   1]

        .REG_WR_REQ                     ( s_REG_WR_REQ          ),//(o)[   1]
        .REG_WR_DATA                    ( s_REG_WR_DATA         ),//(o)[   1]
        .REG_RD_REQ                     ( s_REG_RD_REQ          ),//(o)[  32]
        .REG_OP_ADDR                    ( s_REG_OP_ADDR         ) //(o)[   8]
         );

/*==============================================================================+/
||                                                                              ||
||                             UART TX Frame Packet                             ||
||                                                                              ||
/+==============================================================================*/

    TX_PAK U_TX_PAK (
        .USER_CLK                       ( USER_CLK              ),// (i) [   1]
        .USER_RST                       ( USER_RST              ),// (i) [   1]

        // User Register Signal
        .REG_WR_ACK                     ( REG_WR_ACK            ),// (i) [   1]
        .REG_RD_ACK                     ( REG_RD_ACK            ),// (i) [   1]
        .REG_RD_DATA                    ( REG_RD_DATA           ),// (i) [  32]
`ifdef SIM
        // Frame Buffer write
        .UART_TX_REQ                    ( UART_TX_REQ           ),// (o) [   1]
        .UART_TX_ACK                    ( UART_TX_ACK           ),// (i) [   1]
        .UART_TX_DAT                    ( UART_TX_DAT           ) // (o) [   8]
`else
        .UART_TX_REQ                    ( s_UART_TX_REQ         ),// (o) [   1]
        .UART_TX_ACK                    ( s_UART_TX_ACK         ),// (i) [   1]
        .UART_TX_DAT                    ( s_UART_TX_DAT         ) // (o) [   8]
`endif SIM
    );

`ifdef SIM

//  UART_TX U_UART_TX (
//      .USER_CLK                       ( USER_CLK              ),// (i) [   1]
//      .USER_RST                       ( USER_RST              ),// (i) [   1]
//      .BPS_TX_TRIG                    ( s_BPS_TX_TRIG         ),// (i) [   1]

//      .UART_TX_REQ                    ( s_UART_TX_REQ         ),// (i) [   1]
//      .UART_TX_ACK                    ( s_UART_TX_ACK         ),// (o) [   1]
//      .UART_TX_DAT                    ( s_UART_TX_DAT         ),// (i) [   8]

//      .UART_TXD                       ( UART_TXD              ) // (o) [   1]
//  );

`else

    UART_TX U_UART_TX (
        .USER_CLK                       ( USER_CLK              ),// (i) [   1]
        .USER_RST                       ( USER_RST              ),// (i) [   1]
        .BPS_TX_TRIG                    ( s_BPS_TX_TRIG         ),// (i) [   1]

        .UART_TX_REQ                    ( s_UART_TX_REQ         ),// (i) [   1]
        .UART_TX_ACK                    ( s_UART_TX_ACK         ),// (o) [   1]
        .UART_TX_DAT                    ( s_UART_TX_DAT         ),// (i) [   8]

        .UART_TXD                       ( UART_TXD              ) // (o) [   1]
    );

`endif SIM

endmodule
