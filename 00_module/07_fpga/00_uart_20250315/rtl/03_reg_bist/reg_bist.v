// =================================================================================================
// File Name        : reg_bist.v
// Module           : REG_BIST
// Function         : BIST Register control
// Type             : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2018/07/24   xxxxxx            create new
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ps / 1ps

module REG_BIST (
    //system signals
    input                               CLK                                     ,//(i)  [   1]
    input                               RST                                     ,//(i)  [   1]
    //register if
    input                               REG_WR_REQ                              ,//(i)  [   1]
    input                               REG_RD_REQ                              ,//(i)  [   1]
    output                              REG_WR_ACK                              ,//(o)  [   1]
    output                              REG_RD_ACK                              ,//(o)  [   1]
    input       [  31:0]                REG_WR_DATA                             ,//(i)  [  32]
    output      [  31:0]                REG_RD_DATA                             ,//(o)  [  32]
    input       [  15:0]                REG_OP_ADDR                             ,//(i)  [  16]

    input       [  31:0]                DEBUG_DI0                               ,//(i)  [  32]
    input       [  31:0]                DEBUG_DI1                               ,//(i)  [  32]
    input       [  31:0]                DEBUG_DI2                               ,//(i)  [  32]
    input       [  31:0]                DEBUG_DI3                               ,//(i)  [  32]
    input       [  31:0]                DEBUG_DI4                               ,//(i)  [  32]
    input       [  31:0]                DEBUG_DI5                               ,//(i)  [  32]
    input       [  31:0]                DEBUG_DI6                               ,//(i)  [  32]
    input       [  31:0]                DEBUG_DI7                               ,//(i)  [  32]

    output      [  31:0]                DEBUG_DO0                               ,//(o)  [  32]
    output      [  31:0]                DEBUG_DO1                               ,//(o)  [  32]
    output      [  31:0]                DEBUG_DO2                               ,//(o)  [  32]
    output      [  31:0]                DEBUG_DO3                               ,//(o)  [  32]
    output      [  31:0]                DEBUG_DO4                               ,//(o)  [  32]
    output      [  31:0]                DEBUG_DO5                               ,//(o)  [  32]
    output      [  31:0]                DEBUG_DO6                               ,//(o)  [  32]
    output      [  31:0]                DEBUG_DO7                               ,//(o)  [  32]

    output                              DEBUG_TRIG0                             ,//(o)  [   1]
    output                              DEBUG_TRIG1                             ,//(o)  [   1]
    output                              DEBUG_TRIG2                             ,//(o)  [   1]
    output                              DEBUG_TRIG3                             ,//(o)  [   1]
    output                              DEBUG_TRIG4                             ,//(o)  [   1]
    output                              DEBUG_TRIG5                             ,//(o)  [   1]
    output                              DEBUG_TRIG6                             ,//(o)  [   1]
    output                              DEBUG_TRIG7                              //(o)  [   1]
    );

// =============================================================================
// Prameter define
// =============================================================================

    parameter   p_GND                   = 32'h00000000                          ;//(p)  [ 32]
    parameter   p_FPGA_VER0             = 32'h01234567                          ;//(p)  [ 32]
    parameter   p_FPGA_VER1             = 32'h89ABCDEF                          ;//(p)  [ 32]
    parameter   p_FPGA_VER2             = 32'h5A5A5A5A                          ;//(p)  [ 32]
    parameter   p_FPGA_VER3             = 32'hA5A5A5A5                          ;//(p)  [ 32]
    parameter   p_BORD_VER0             = 32'h00000000                          ;//(p)  [ 32]
    parameter   p_BORD_VER1             = 32'hFFFFFFFF                          ;//(p)  [ 32]

    parameter   p_ADD_FPGA_VER0         = 16'h000                               ;//(p)  [ 10]
    parameter   p_ADD_FPGA_VER1         = 16'h001                               ;//(p)  [ 10]
    parameter   p_ADD_FPGA_VER2         = 16'h002                               ;//(p)  [ 10]
    parameter   p_ADD_FPGA_VER3         = 16'h003                               ;//(p)  [ 10]
    parameter   p_ADD_BORD_VER0         = 16'h004                               ;//(p)  [ 10]
    parameter   p_ADD_BORD_VER1         = 16'h005                               ;//(p)  [ 10]

    parameter   p_ADD_DEBUG_DI0         = 16'h010                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DI1         = 16'h011                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DI2         = 16'h012                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DI3         = 16'h013                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DI4         = 16'h014                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DI5         = 16'h015                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DI6         = 16'h016                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DI7         = 16'h017                               ;//(p)  [ 10]

    parameter   p_ADD_DEBUG_DO0         = 16'h020                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DO1         = 16'h021                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DO2         = 16'h022                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DO3         = 16'h023                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DO4         = 16'h024                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DO5         = 16'h025                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DO6         = 16'h026                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_DO7         = 16'h027                               ;//(p)  [ 10]

    parameter   p_ADD_DEBUG_TRIG0       = 16'h030                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_TRIG1       = 16'h031                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_TRIG2       = 16'h032                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_TRIG3       = 16'h033                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_TRIG4       = 16'h034                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_TRIG5       = 16'h035                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_TRIG6       = 16'h036                               ;//(p)  [ 10]
    parameter   p_ADD_DEBUG_TRIG7       = 16'h037                               ;//(p)  [ 10]

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_REG_WEN                               ;//(r)  [  1]
    reg                                 r_REG_REN                               ;//(r)  [  1]
    reg         [  31:0]                r_REG_WDT                               ;//(r)  [ 32]
    reg         [  15:0]                r_REG_ADR                               ;//(r)  [ 10]

    reg                                 r_REG_WR_ACK                            ;//(r)  [  1]
    reg                                 r_REG_RD_ACK                            ;//(r)  [  5]
    wire        [  31:0]                s_REG_RDT                               ;//(s)  [ 32]
    reg         [  31:0]                r_REG_RDT                               ;//(r)  [ 32]
    reg         [   3:0]                r_REG_REN_SHFT                          ;//(r)  [  5]

    reg         [  31:0]                r_REG_DEBUG_DI0                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DI1                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DI2                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DI3                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DI4                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DI5                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DI6                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DI7                         ;//(r)  [ 31]

    reg         [  31:0]                r_REG_DEBUG_DO0                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DO1                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DO2                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DO3                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DO4                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DO5                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DO6                         ;//(r)  [ 31]
    reg         [  31:0]                r_REG_DEBUG_DO7                         ;//(r)  [ 31]

    reg                                 r_REG_DEBUG_TRIG0                       ;//(r)  [  5]
    reg                                 r_REG_DEBUG_TRIG1                       ;//(r)  [  5]
    reg                                 r_REG_DEBUG_TRIG2                       ;//(r)  [  5]
    reg                                 r_REG_DEBUG_TRIG3                       ;//(r)  [  5]
    reg                                 r_REG_DEBUG_TRIG4                       ;//(r)  [  5]
    reg                                 r_REG_DEBUG_TRIG5                       ;//(r)  [  5]
    reg                                 r_REG_DEBUG_TRIG6                       ;//(r)  [  5]
    reg                                 r_REG_DEBUG_TRIG7                       ;//(r)  [  5]

    wire                                s_REG_FPGA_VER0_EN                      ;//(s)  [  1]
    wire                                s_REG_FPGA_VER1_EN                      ;//(s)  [  1]
    wire                                s_REG_FPGA_VER2_EN                      ;//(s)  [  1]
    wire                                s_REG_FPGA_VER3_EN                      ;//(s)  [  1]
    wire                                s_REG_BORD_VER0_EN                      ;//(s)  [  1]
    wire                                s_REG_BORD_VER1_EN                      ;//(s)  [  1]

    wire                                s_REG_DEBUG_DI0_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DI1_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DI2_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DI3_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DI4_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DI5_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DI6_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DI7_EN                      ;//(s)  [  1]

    wire                                s_REG_DEBUG_DO0_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DO1_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DO2_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DO3_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DO4_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DO5_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DO6_EN                      ;//(s)  [  1]
    wire                                s_REG_DEBUG_DO7_EN                      ;//(s)  [  1]

    wire                                s_REG_DEBUG_TRIG0_EN                    ;//(s)  [  1]
    wire                                s_REG_DEBUG_TRIG1_EN                    ;//(s)  [  1]
    wire                                s_REG_DEBUG_TRIG2_EN                    ;//(s)  [  1]
    wire                                s_REG_DEBUG_TRIG3_EN                    ;//(s)  [  1]
    wire                                s_REG_DEBUG_TRIG4_EN                    ;//(s)  [  1]
    wire                                s_REG_DEBUG_TRIG5_EN                    ;//(s)  [  1]
    wire                                s_REG_DEBUG_TRIG6_EN                    ;//(s)  [  1]
    wire                                s_REG_DEBUG_TRIG7_EN                    ;//(s)  [  1]

// ==========================================================================================
// RTL Body
// ==========================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Output                                         ||
||                                                                             ||
/+=============================================================================*/

    assign  REG_WR_ACK                  = r_REG_WR_ACK                          ;
    assign  REG_RD_ACK                  = r_REG_RD_ACK                          ;
    assign  REG_RD_DATA                 = r_REG_RDT                             ;

    assign  DEBUG_DO0                   = r_REG_DEBUG_DO0                       ;
    assign  DEBUG_DO1                   = r_REG_DEBUG_DO1                       ;
    assign  DEBUG_DO2                   = r_REG_DEBUG_DO2                       ;
    assign  DEBUG_DO3                   = r_REG_DEBUG_DO3                       ;
    assign  DEBUG_DO4                   = r_REG_DEBUG_DO4                       ;
    assign  DEBUG_DO5                   = r_REG_DEBUG_DO5                       ;
    assign  DEBUG_DO6                   = r_REG_DEBUG_DO6                       ;
    assign  DEBUG_DO7                   = r_REG_DEBUG_DO7                       ;

    assign  DEBUG_TRIG0                 = r_REG_DEBUG_TRIG0                     ;
    assign  DEBUG_TRIG1                 = r_REG_DEBUG_TRIG1                     ;
    assign  DEBUG_TRIG2                 = r_REG_DEBUG_TRIG2                     ;
    assign  DEBUG_TRIG3                 = r_REG_DEBUG_TRIG3                     ;
    assign  DEBUG_TRIG4                 = r_REG_DEBUG_TRIG4                     ;
    assign  DEBUG_TRIG5                 = r_REG_DEBUG_TRIG5                     ;
    assign  DEBUG_TRIG6                 = r_REG_DEBUG_TRIG6                     ;
    assign  DEBUG_TRIG7                 = r_REG_DEBUG_TRIG7                     ;

/*=============================================================================+/
||                                                                             ||
||                              IFF                                            ||
||                                                                             ||
/+=============================================================================*/

    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_WEN                   <= 'b0 ;
            r_REG_REN                   <= 'b0 ;
        end else begin
            r_REG_WEN                   <= REG_WR_REQ ;
            r_REG_REN                   <= REG_RD_REQ ;
        end
    end

    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_WDT                   <= 'b0 ;
            r_REG_ADR                   <= 'b0 ;
        end else begin
            if (REG_WR_REQ | REG_RD_REQ) begin
                r_REG_ADR               <= REG_OP_ADDR ;
            end
            if (REG_WR_REQ) begin
                r_REG_WDT               <= REG_WR_DATA ;
            end
        end
    end

    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_DEBUG_DI0             <= 'b0 ;
            r_REG_DEBUG_DI1             <= 'b0 ;
            r_REG_DEBUG_DI2             <= 'b0 ;
            r_REG_DEBUG_DI3             <= 'b0 ;
            r_REG_DEBUG_DI4             <= 'b0 ;
            r_REG_DEBUG_DI5             <= 'b0 ;
            r_REG_DEBUG_DI6             <= 'b0 ;
            r_REG_DEBUG_DI7             <= 'b0 ;
        end else begin
            r_REG_DEBUG_DI0             <= DEBUG_DI0 ;
            r_REG_DEBUG_DI1             <= DEBUG_DI1 ;
            r_REG_DEBUG_DI2             <= DEBUG_DI2 ;
            r_REG_DEBUG_DI3             <= DEBUG_DI3 ;
            r_REG_DEBUG_DI4             <= DEBUG_DI4 ;
            r_REG_DEBUG_DI5             <= DEBUG_DI5 ;
            r_REG_DEBUG_DI6             <= DEBUG_DI6 ;
            r_REG_DEBUG_DI7             <= DEBUG_DI7 ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                    Register Address Decode                                  ||
||                                                                             ||
/+=============================================================================*/

    assign  s_REG_FPGA_VER0_EN          = ( r_REG_ADR == p_ADD_FPGA_VER0   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_FPGA_VER1_EN          = ( r_REG_ADR == p_ADD_FPGA_VER1   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_FPGA_VER2_EN          = ( r_REG_ADR == p_ADD_FPGA_VER2   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_FPGA_VER3_EN          = ( r_REG_ADR == p_ADD_FPGA_VER3   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_BORD_VER0_EN          = ( r_REG_ADR == p_ADD_BORD_VER0   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_BORD_VER1_EN          = ( r_REG_ADR == p_ADD_BORD_VER1   ) ? 1'b1 : 1'b0 ;

    assign  s_REG_DEBUG_DI0_EN          = ( r_REG_ADR == p_ADD_DEBUG_DI0   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DI1_EN          = ( r_REG_ADR == p_ADD_DEBUG_DI1   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DI2_EN          = ( r_REG_ADR == p_ADD_DEBUG_DI2   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DI3_EN          = ( r_REG_ADR == p_ADD_DEBUG_DI3   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DI4_EN          = ( r_REG_ADR == p_ADD_DEBUG_DI4   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DI5_EN          = ( r_REG_ADR == p_ADD_DEBUG_DI5   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DI6_EN          = ( r_REG_ADR == p_ADD_DEBUG_DI6   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DI7_EN          = ( r_REG_ADR == p_ADD_DEBUG_DI7   ) ? 1'b1 : 1'b0 ;

    assign  s_REG_DEBUG_DO0_EN          = ( r_REG_ADR == p_ADD_DEBUG_DO0   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DO1_EN          = ( r_REG_ADR == p_ADD_DEBUG_DO1   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DO2_EN          = ( r_REG_ADR == p_ADD_DEBUG_DO2   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DO3_EN          = ( r_REG_ADR == p_ADD_DEBUG_DO3   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DO4_EN          = ( r_REG_ADR == p_ADD_DEBUG_DO4   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DO5_EN          = ( r_REG_ADR == p_ADD_DEBUG_DO5   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DO6_EN          = ( r_REG_ADR == p_ADD_DEBUG_DO6   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_DO7_EN          = ( r_REG_ADR == p_ADD_DEBUG_DO7   ) ? 1'b1 : 1'b0 ;

    assign  s_REG_DEBUG_TRIG0_EN        = ( r_REG_ADR == p_ADD_DEBUG_TRIG0 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_TRIG1_EN        = ( r_REG_ADR == p_ADD_DEBUG_TRIG1 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_TRIG2_EN        = ( r_REG_ADR == p_ADD_DEBUG_TRIG2 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_TRIG3_EN        = ( r_REG_ADR == p_ADD_DEBUG_TRIG3 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_TRIG4_EN        = ( r_REG_ADR == p_ADD_DEBUG_TRIG4 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_TRIG5_EN        = ( r_REG_ADR == p_ADD_DEBUG_TRIG5 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_TRIG6_EN        = ( r_REG_ADR == p_ADD_DEBUG_TRIG6 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG_TRIG7_EN        = ( r_REG_ADR == p_ADD_DEBUG_TRIG7 ) ? 1'b1 : 1'b0 ;

/*=============================================================================+/
||                                                                             ||
||                      Register Write Control                                 ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_DEBUG_DO0             <= 'b0 ;
            r_REG_DEBUG_DO1             <= 'b0 ;
            r_REG_DEBUG_DO2             <= 'b0 ;
            r_REG_DEBUG_DO3             <= 'b0 ;
            r_REG_DEBUG_DO4             <= 'b0 ;
            r_REG_DEBUG_DO5             <= 'b0 ;
            r_REG_DEBUG_DO6             <= 'b0 ;
            r_REG_DEBUG_DO7             <= 'b0 ;
        end else begin
            if (r_REG_WEN & s_REG_DEBUG_DO0_EN) begin r_REG_DEBUG_DO0   <= r_REG_WDT ; end
            if (r_REG_WEN & s_REG_DEBUG_DO1_EN) begin r_REG_DEBUG_DO1   <= r_REG_WDT ; end
            if (r_REG_WEN & s_REG_DEBUG_DO2_EN) begin r_REG_DEBUG_DO2   <= r_REG_WDT ; end
            if (r_REG_WEN & s_REG_DEBUG_DO3_EN) begin r_REG_DEBUG_DO3   <= r_REG_WDT ; end
            if (r_REG_WEN & s_REG_DEBUG_DO4_EN) begin r_REG_DEBUG_DO4   <= r_REG_WDT ; end
            if (r_REG_WEN & s_REG_DEBUG_DO5_EN) begin r_REG_DEBUG_DO5   <= r_REG_WDT ; end
            if (r_REG_WEN & s_REG_DEBUG_DO6_EN) begin r_REG_DEBUG_DO6   <= r_REG_WDT ; end
            if (r_REG_WEN & s_REG_DEBUG_DO7_EN) begin r_REG_DEBUG_DO7   <= r_REG_WDT ; end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_DEBUG_TRIG0           <= 'b0 ;
            r_REG_DEBUG_TRIG1           <= 'b0 ;
            r_REG_DEBUG_TRIG2           <= 'b0 ;
            r_REG_DEBUG_TRIG3           <= 'b0 ;
            r_REG_DEBUG_TRIG4           <= 'b0 ;
            r_REG_DEBUG_TRIG5           <= 'b0 ;
            r_REG_DEBUG_TRIG6           <= 'b0 ;
            r_REG_DEBUG_TRIG7           <= 'b0 ;
        end else begin
            r_REG_DEBUG_TRIG0           <= r_REG_WEN & s_REG_DEBUG_TRIG0_EN & r_REG_WDT[0] ;
            r_REG_DEBUG_TRIG1           <= r_REG_WEN & s_REG_DEBUG_TRIG1_EN & r_REG_WDT[0] ;
            r_REG_DEBUG_TRIG2           <= r_REG_WEN & s_REG_DEBUG_TRIG2_EN & r_REG_WDT[0] ;
            r_REG_DEBUG_TRIG3           <= r_REG_WEN & s_REG_DEBUG_TRIG3_EN & r_REG_WDT[0] ;
            r_REG_DEBUG_TRIG4           <= r_REG_WEN & s_REG_DEBUG_TRIG4_EN & r_REG_WDT[0] ;
            r_REG_DEBUG_TRIG5           <= r_REG_WEN & s_REG_DEBUG_TRIG5_EN & r_REG_WDT[0] ;
            r_REG_DEBUG_TRIG6           <= r_REG_WEN & s_REG_DEBUG_TRIG6_EN & r_REG_WDT[0] ;
            r_REG_DEBUG_TRIG7           <= r_REG_WEN & s_REG_DEBUG_TRIG7_EN & r_REG_WDT[0] ;
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_WR_ACK                <= 'b0;
        end else begin
            r_REG_WR_ACK                <= r_REG_WEN ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                      Register Read Enable                                   ||
||                                                                             ||
/+=============================================================================*/

    assign s_REG_RDT                    = ( s_REG_FPGA_VER0_EN     == 1'b1) ? {               p_FPGA_VER0       } :
                                          ( s_REG_FPGA_VER1_EN     == 1'b1) ? {               p_FPGA_VER1       } :
                                          ( s_REG_FPGA_VER2_EN     == 1'b1) ? {               p_FPGA_VER2       } :
                                          ( s_REG_FPGA_VER3_EN     == 1'b1) ? {               p_FPGA_VER3       } :
                                          ( s_REG_BORD_VER0_EN     == 1'b1) ? {               p_BORD_VER0       } :
                                          ( s_REG_BORD_VER1_EN     == 1'b1) ? {               p_BORD_VER1       } :

                                          ( s_REG_DEBUG_DI0_EN     == 1'b1) ? {               r_REG_DEBUG_DI0   } :
                                          ( s_REG_DEBUG_DI1_EN     == 1'b1) ? {               r_REG_DEBUG_DI1   } :
                                          ( s_REG_DEBUG_DI2_EN     == 1'b1) ? {               r_REG_DEBUG_DI2   } :
                                          ( s_REG_DEBUG_DI3_EN     == 1'b1) ? {               r_REG_DEBUG_DI3   } :
                                          ( s_REG_DEBUG_DI4_EN     == 1'b1) ? {               r_REG_DEBUG_DI4   } :
                                          ( s_REG_DEBUG_DI5_EN     == 1'b1) ? {               r_REG_DEBUG_DI5   } :
                                          ( s_REG_DEBUG_DI6_EN     == 1'b1) ? {               r_REG_DEBUG_DI6   } :
                                          ( s_REG_DEBUG_DI7_EN     == 1'b1) ? {               r_REG_DEBUG_DI7   } :

                                          ( s_REG_DEBUG_DO0_EN     == 1'b1) ? {               r_REG_DEBUG_DO0   } :
                                          ( s_REG_DEBUG_DO1_EN     == 1'b1) ? {               r_REG_DEBUG_DO1   } :
                                          ( s_REG_DEBUG_DO2_EN     == 1'b1) ? {               r_REG_DEBUG_DO2   } :
                                          ( s_REG_DEBUG_DO3_EN     == 1'b1) ? {               r_REG_DEBUG_DO3   } :
                                          ( s_REG_DEBUG_DO4_EN     == 1'b1) ? {               r_REG_DEBUG_DO4   } :
                                          ( s_REG_DEBUG_DO5_EN     == 1'b1) ? {               r_REG_DEBUG_DO5   } :
                                          ( s_REG_DEBUG_DO6_EN     == 1'b1) ? {               r_REG_DEBUG_DO6   } :
                                          ( s_REG_DEBUG_DO7_EN     == 1'b1) ? {               r_REG_DEBUG_DO7   } :

                                          ( s_REG_DEBUG_TRIG0_EN   == 1'b1) ? { p_GND[31:1] , r_REG_DEBUG_TRIG0 } :
                                          ( s_REG_DEBUG_TRIG1_EN   == 1'b1) ? { p_GND[31:1] , r_REG_DEBUG_TRIG1 } :
                                          ( s_REG_DEBUG_TRIG2_EN   == 1'b1) ? { p_GND[31:1] , r_REG_DEBUG_TRIG2 } :
                                          ( s_REG_DEBUG_TRIG3_EN   == 1'b1) ? { p_GND[31:1] , r_REG_DEBUG_TRIG3 } :
                                          ( s_REG_DEBUG_TRIG4_EN   == 1'b1) ? { p_GND[31:1] , r_REG_DEBUG_TRIG4 } :
                                          ( s_REG_DEBUG_TRIG5_EN   == 1'b1) ? { p_GND[31:1] , r_REG_DEBUG_TRIG5 } :
                                          ( s_REG_DEBUG_TRIG6_EN   == 1'b1) ? { p_GND[31:1] , r_REG_DEBUG_TRIG6 } :
                                          ( s_REG_DEBUG_TRIG7_EN   == 1'b1) ? { p_GND[31:1] , r_REG_DEBUG_TRIG7 } :
                                                                              { p_GND[31:0]                     } ;

    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_RDT                   <= 'b0 ;
        end else begin
            r_REG_RDT                   <= s_REG_RDT ;
        end
    end

    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_REN_SHFT              <= 'b0 ;
        end else begin
            r_REG_REN_SHFT              <= {r_REG_REN_SHFT[2:0] , r_REG_REN} ;
        end
    end

    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            r_REG_RD_ACK                <= 'b0 ;
        end else begin
            r_REG_RD_ACK                <= r_REG_REN_SHFT[3] ;
        end
    end

endmodule