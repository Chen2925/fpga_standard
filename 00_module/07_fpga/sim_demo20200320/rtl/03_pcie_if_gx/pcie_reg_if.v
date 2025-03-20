// =================================================================================================
// File Name      : pcie_reg_if.v
// Module         : PCIE_REG_IF
// Function       : Register Interface
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2018/07/24   chen.y            create new          speed-clouds
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ps / 1ps

module PCIE_REG_IF (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]  Systerm clock(125mhz)
    input                               PCIE_RST                                ,//(i)  [  1]  Async. reset(low active)
    //PCIE RX interface
    input                               PCIE_WR_REQ                             ,//(i)  [  1]  PCIE register write request
    input                               PCIE_RD_REQ                             ,//(i)  [  1]  PCIE register read request
    input       [  31:0]                PCIE_WR_DATA                            ,//(i)  [ 32]  PCIE register write data
    input       [  63:0]                PCIE_OP_ADDR                            ,//(i)  [ 64]  PCIE register operation address
    output      [  31:0]                PCIE_RD_DATA                            ,//(o)  [ 32]  PCIE register read data
    output                              PCIE_WR_ACK                             ,//(o)  [  1]  PCIE register write acknowledge
    output                              PCIE_RD_ACK                             ,//(o)  [  1]  PCIE register read acknowledge
    //REG CTRL interface
    output                              REG0_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG0_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG0_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG0_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG0_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG0_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG0_OP_ADDR                            ,//(o)  [ 16]  Register operation address

    output                              REG1_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG1_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG1_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG1_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG1_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG1_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG1_OP_ADDR                            ,//(o)  [ 16]  Register operation address

    output                              REG2_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG2_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG2_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG2_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG2_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG2_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG2_OP_ADDR                            ,//(o)  [ 16]  Register operation address

    output                              REG3_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG3_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG3_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG3_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG3_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG3_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG3_OP_ADDR                            ,//(o)  [ 16]  Register operation address

    output                              REG4_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG4_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG4_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG4_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG4_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG4_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG4_OP_ADDR                            ,//(o)  [ 16]  Register operation address

    output                              REG5_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG5_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG5_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG5_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG5_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG5_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG5_OP_ADDR                            ,//(o)  [ 16]  Register operation address

    output                              REG6_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG6_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG6_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG6_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG6_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG6_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG6_OP_ADDR                            ,//(o)  [ 16]  Register operation address

    output                              REG7_WR_REQ                             ,//(o)  [  1]  Register write request
    input                               REG7_WR_ACK                             ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG7_WR_DATA                            ,//(o)  [ 32]  Register write data
    output                              REG7_RD_REQ                             ,//(o)  [  1]  Register read request
    input                               REG7_RD_ACK                             ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG7_RD_DATA                            ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG7_OP_ADDR                             //(o)  [ 16]  Register operation address
    );

// =============================================================================
// Internal signal define
// =============================================================================

    // Command load
    reg                                 r_REG_WEN                               ;//(r)  [  1]  PCIE register write enable
    reg                                 r_REG_REN                               ;//(r)  [  1]  PCIE register read enable
    reg         [  63:0]                r_REG_ADR                               ;//(r)  [ 16]  PCIE register operation address
    reg         [  31:0]                r_REG_WDT                               ;//(r)  [ 32]  PCIE register write data

    wire                                s_REG0_OP_SEL                           ;//(s)  [  1]  Register 0 select
    wire                                s_REG1_OP_SEL                           ;//(s)  [  1]  Register 0 select
    wire                                s_REG2_OP_SEL                           ;//(s)  [  1]  Register 0 select
    wire                                s_REG3_OP_SEL                           ;//(s)  [  1]  Register 0 select
    wire                                s_REG4_OP_SEL                           ;//(s)  [  1]  Register 0 select
    wire                                s_REG5_OP_SEL                           ;//(s)  [  1]  Register 0 select
    wire                                s_REG6_OP_SEL                           ;//(s)  [  1]  Register 0 select
    wire                                s_REG7_OP_SEL                           ;//(s)  [  1]  Register 0 select

    reg                                 r_REG0_WR_REQ                           ;//(o)  [  1]  Register write request
    reg         [  31:0]                r_REG0_WR_DATA                          ;//(o)  [ 32]  Register write data
    reg                                 r_REG0_RD_REQ                           ;//(o)  [  1]  Register read request
    reg         [  15:0]                r_REG0_OP_ADDR                          ;//(o)  [ 12]  Register operation address

    reg                                 r_REG1_WR_REQ                           ;//(o)  [  1]  Register write request
    reg         [  31:0]                r_REG1_WR_DATA                          ;//(o)  [ 32]  Register write data
    reg                                 r_REG1_RD_REQ                           ;//(o)  [  1]  Register read request
    reg         [  15:0]                r_REG1_OP_ADDR                          ;//(o)  [ 12]  Register operation address

    reg                                 r_REG2_WR_REQ                           ;//(o)  [  1]  Register write request
    reg         [  31:0]                r_REG2_WR_DATA                          ;//(o)  [ 32]  Register write data
    reg                                 r_REG2_RD_REQ                           ;//(o)  [  1]  Register read request
    reg         [  15:0]                r_REG2_OP_ADDR                          ;//(o)  [ 12]  Register operation address

    reg                                 r_REG3_WR_REQ                           ;//(o)  [  1]  Register write request
    reg         [  31:0]                r_REG3_WR_DATA                          ;//(o)  [ 32]  Register write data
    reg                                 r_REG3_RD_REQ                           ;//(o)  [  1]  Register read request
    reg         [  15:0]                r_REG3_OP_ADDR                          ;//(o)  [ 12]  Register operation address

    reg                                 r_REG4_WR_REQ                           ;//(o)  [  1]  Register write request
    reg         [  31:0]                r_REG4_WR_DATA                          ;//(o)  [ 32]  Register write data
    reg                                 r_REG4_RD_REQ                           ;//(o)  [  1]  Register read request
    reg         [  15:0]                r_REG4_OP_ADDR                          ;//(o)  [ 12]  Register operation address

    reg                                 r_REG5_WR_REQ                           ;//(o)  [  1]  Register write request
    reg         [  31:0]                r_REG5_WR_DATA                          ;//(o)  [ 32]  Register write data
    reg                                 r_REG5_RD_REQ                           ;//(o)  [  1]  Register read request
    reg         [  15:0]                r_REG5_OP_ADDR                          ;//(o)  [ 12]  Register operation address

    reg                                 r_REG6_WR_REQ                           ;//(o)  [  1]  Register write request
    reg         [  31:0]                r_REG6_WR_DATA                          ;//(o)  [ 32]  Register write data
    reg                                 r_REG6_RD_REQ                           ;//(o)  [  1]  Register read request
    reg         [  15:0]                r_REG6_OP_ADDR                          ;//(o)  [ 12]  Register operation address

    reg                                 r_REG7_WR_REQ                           ;//(o)  [  1]  Register write request
    reg         [  31:0]                r_REG7_WR_DATA                          ;//(o)  [ 32]  Register write data
    reg                                 r_REG7_RD_REQ                           ;//(o)  [  1]  Register read request
    reg         [  15:0]                r_REG7_OP_ADDR                          ;//(o)  [ 12]  Register operation address

    reg                                 r_PCIE_WR_ACK                           ;//(r)  [  1]  PCIE register write acknowledge
    reg                                 r_PCIE_RD_ACK                           ;//(r)  [  1]  PCIE register read acknowledge
    reg         [  31:0]                r_PCIE_RD_DATA                          ;//(r)  [ 32]  PCIE register read data

// =================================================================================================
// RTL Body
// =================================================================================================

/*============================================================================+/
||                                                                            ||
||                            Output                                          ||
||                                                                            ||
/+============================================================================*/

    assign  PCIE_RD_ACK                 = r_PCIE_RD_ACK                         ;
    assign  PCIE_WR_ACK                 = r_PCIE_WR_ACK                         ;
    assign  PCIE_RD_DATA                = r_PCIE_RD_DATA                        ;

    assign  REG0_WR_REQ                 = r_REG0_WR_REQ                         ;
    assign  REG0_WR_DATA                = r_REG0_WR_DATA                        ;
    assign  REG0_RD_REQ                 = r_REG0_RD_REQ                         ;
    assign  REG0_OP_ADDR                = r_REG0_OP_ADDR                        ;

    assign  REG1_WR_REQ                 = r_REG1_WR_REQ                         ;
    assign  REG1_WR_DATA                = r_REG1_WR_DATA                        ;
    assign  REG1_RD_REQ                 = r_REG1_RD_REQ                         ;
    assign  REG1_OP_ADDR                = r_REG1_OP_ADDR                        ;

    assign  REG2_WR_REQ                 = r_REG2_WR_REQ                         ;
    assign  REG2_WR_DATA                = r_REG2_WR_DATA                        ;
    assign  REG2_RD_REQ                 = r_REG2_RD_REQ                         ;
    assign  REG2_OP_ADDR                = r_REG2_OP_ADDR                        ;

    assign  REG3_WR_REQ                 = r_REG3_WR_REQ                         ;
    assign  REG3_WR_DATA                = r_REG3_WR_DATA                        ;
    assign  REG3_RD_REQ                 = r_REG3_RD_REQ                         ;
    assign  REG3_OP_ADDR                = r_REG3_OP_ADDR                        ;

    assign  REG4_WR_REQ                 = r_REG4_WR_REQ                         ;
    assign  REG4_WR_DATA                = r_REG4_WR_DATA                        ;
    assign  REG4_RD_REQ                 = r_REG4_RD_REQ                         ;
    assign  REG4_OP_ADDR                = r_REG4_OP_ADDR                        ;

    assign  REG5_WR_REQ                 = r_REG5_WR_REQ                         ;
    assign  REG5_WR_DATA                = r_REG5_WR_DATA                        ;
    assign  REG5_RD_REQ                 = r_REG5_RD_REQ                         ;
    assign  REG5_OP_ADDR                = r_REG5_OP_ADDR                        ;

    assign  REG6_WR_REQ                 = r_REG6_WR_REQ                         ;
    assign  REG6_WR_DATA                = r_REG6_WR_DATA                        ;
    assign  REG6_RD_REQ                 = r_REG6_RD_REQ                         ;
    assign  REG6_OP_ADDR                = r_REG6_OP_ADDR                        ;

    assign  REG7_WR_REQ                 = r_REG7_WR_REQ                         ;
    assign  REG7_WR_DATA                = r_REG7_WR_DATA                        ;
    assign  REG7_RD_REQ                 = r_REG7_RD_REQ                         ;
    assign  REG7_OP_ADDR                = r_REG7_OP_ADDR                        ;

/*============================================================================+/
||                                                                            ||
||                              IFF                                           ||
||                                                                            ||
/+============================================================================*/

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_WEN               <= 'b0 ;
            r_REG_REN               <= 'b0 ;
            r_REG_WDT               <= 'b0 ;
            r_REG_ADR               <= 'b0 ;
        end else begin
            r_REG_WEN               <= PCIE_WR_REQ ;
            r_REG_REN               <= PCIE_RD_REQ ;

            if (PCIE_WR_REQ | PCIE_RD_REQ) begin
                r_REG_ADR           <= PCIE_OP_ADDR ;
            end

            if (PCIE_WR_REQ) begin
                r_REG_WDT           <= PCIE_WR_DATA ;
            end
        end
    end

    assign s_REG0_OP_SEL    = (r_REG_ADR[18:16] == 3'd0) ? 1'b1 : 1'b0 ;
    assign s_REG1_OP_SEL    = (r_REG_ADR[18:16] == 3'd1) ? 1'b1 : 1'b0 ;
    assign s_REG2_OP_SEL    = (r_REG_ADR[18:16] == 3'd2) ? 1'b1 : 1'b0 ;
    assign s_REG3_OP_SEL    = (r_REG_ADR[18:16] == 3'd3) ? 1'b1 : 1'b0 ;
    assign s_REG4_OP_SEL    = (r_REG_ADR[18:16] == 3'd4) ? 1'b1 : 1'b0 ;
    assign s_REG5_OP_SEL    = (r_REG_ADR[18:16] == 3'd5) ? 1'b1 : 1'b0 ;
    assign s_REG6_OP_SEL    = (r_REG_ADR[18:16] == 3'd6) ? 1'b1 : 1'b0 ;
    assign s_REG7_OP_SEL    = (r_REG_ADR[18:16] == 3'd7) ? 1'b1 : 1'b0 ;

/*============================================================================+/
||                                                                            ||
||                     Register Operation control                             ||
||                                                                            ||
/+============================================================================*/

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG0_WR_REQ           <= 'b0 ;
            r_REG0_RD_REQ           <= 'b0 ;
            r_REG0_WR_DATA          <= 'b0 ;
            r_REG0_OP_ADDR          <= 'b0 ;

            r_REG1_WR_REQ           <= 'b0 ;
            r_REG1_RD_REQ           <= 'b0 ;
            r_REG1_WR_DATA          <= 'b0 ;
            r_REG1_OP_ADDR          <= 'b0 ;

            r_REG2_WR_REQ           <= 'b0 ;
            r_REG2_RD_REQ           <= 'b0 ;
            r_REG2_WR_DATA          <= 'b0 ;
            r_REG2_OP_ADDR          <= 'b0 ;

            r_REG3_WR_REQ           <= 'b0 ;
            r_REG3_RD_REQ           <= 'b0 ;
            r_REG3_WR_DATA          <= 'b0 ;
            r_REG3_OP_ADDR          <= 'b0 ;

            r_REG4_WR_REQ           <= 'b0 ;
            r_REG4_RD_REQ           <= 'b0 ;
            r_REG4_WR_DATA          <= 'b0 ;
            r_REG4_OP_ADDR          <= 'b0 ;

            r_REG5_WR_REQ           <= 'b0 ;
            r_REG5_RD_REQ           <= 'b0 ;
            r_REG5_WR_DATA          <= 'b0 ;
            r_REG5_OP_ADDR          <= 'b0 ;

            r_REG6_WR_REQ           <= 'b0 ;
            r_REG6_RD_REQ           <= 'b0 ;
            r_REG6_WR_DATA          <= 'b0 ;
            r_REG6_OP_ADDR          <= 'b0 ;

            r_REG7_WR_REQ           <= 'b0 ;
            r_REG7_RD_REQ           <= 'b0 ;
            r_REG7_WR_DATA          <= 'b0 ;
            r_REG7_OP_ADDR          <= 'b0 ;
        end else begin
            r_REG0_WR_REQ           <= r_REG_WEN & s_REG0_OP_SEL  ;
            r_REG0_RD_REQ           <= r_REG_REN & s_REG0_OP_SEL  ;
            r_REG0_WR_DATA          <= r_REG_WDT                  ;
            r_REG0_OP_ADDR          <= r_REG_ADR[15:0]            ;

            r_REG1_WR_REQ           <= r_REG_WEN & s_REG1_OP_SEL  ;
            r_REG1_RD_REQ           <= r_REG_REN & s_REG1_OP_SEL  ;
            r_REG1_WR_DATA          <= r_REG_WDT                  ;
            r_REG1_OP_ADDR          <= r_REG_ADR[15:0]            ;

            r_REG2_WR_REQ           <= r_REG_WEN & s_REG2_OP_SEL  ;
            r_REG2_RD_REQ           <= r_REG_REN & s_REG2_OP_SEL  ;
            r_REG2_WR_DATA          <= r_REG_WDT                  ;
            r_REG2_OP_ADDR          <= r_REG_ADR[15:0]            ;

            r_REG3_WR_REQ           <= r_REG_WEN & s_REG3_OP_SEL  ;
            r_REG3_RD_REQ           <= r_REG_REN & s_REG3_OP_SEL  ;
            r_REG3_WR_DATA          <= r_REG_WDT                  ;
            r_REG3_OP_ADDR          <= r_REG_ADR[15:0]            ;

            r_REG4_WR_REQ           <= r_REG_WEN & s_REG4_OP_SEL  ;
            r_REG4_RD_REQ           <= r_REG_REN & s_REG4_OP_SEL  ;
            r_REG4_WR_DATA          <= r_REG_WDT                  ;
            r_REG4_OP_ADDR          <= r_REG_ADR[15:0]            ;

            r_REG5_WR_REQ           <= r_REG_WEN & s_REG5_OP_SEL  ;
            r_REG5_RD_REQ           <= r_REG_REN & s_REG5_OP_SEL  ;
            r_REG5_WR_DATA          <= r_REG_WDT                  ;
            r_REG5_OP_ADDR          <= r_REG_ADR[15:0]            ;

            r_REG6_WR_REQ           <= r_REG_WEN & s_REG6_OP_SEL  ;
            r_REG6_RD_REQ           <= r_REG_REN & s_REG6_OP_SEL  ;
            r_REG6_WR_DATA          <= r_REG_WDT                  ;
            r_REG6_OP_ADDR          <= r_REG_ADR[15:0]            ;

            r_REG7_WR_REQ           <= r_REG_WEN & s_REG7_OP_SEL  ;
            r_REG7_RD_REQ           <= r_REG_REN & s_REG7_OP_SEL  ;
            r_REG7_WR_DATA          <= r_REG_WDT                  ;
            r_REG7_OP_ADDR          <= r_REG_ADR[15:0]            ;
        end
    end

/*============================================================================+/
||                                                                            ||
||                       PCIE Interface Control                               ||
||                                                                            ||
/+============================================================================*/

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_PCIE_RD_ACK           <= 1'b0 ;
            r_PCIE_WR_ACK           <= 1'b0 ;
        end else begin
            r_PCIE_RD_ACK           <=  REG0_RD_ACK |
                                        REG1_RD_ACK |
                                        REG2_RD_ACK |
                                        REG3_RD_ACK |
                                        REG4_RD_ACK |
                                        REG5_RD_ACK |
                                        REG6_RD_ACK |
                                        REG7_RD_ACK ;

            r_PCIE_WR_ACK           <=  REG0_WR_ACK |
                                        REG1_WR_ACK |
                                        REG2_WR_ACK |
                                        REG3_WR_ACK |
                                        REG4_WR_ACK |
                                        REG5_WR_ACK |
                                        REG6_WR_ACK |
                                        REG7_WR_ACK ;
        end
    end

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_PCIE_RD_DATA          <= 'b0 ;
        end else begin
            if (REG0_RD_ACK) begin
                r_PCIE_RD_DATA      <= REG0_RD_DATA ;
            end else if (REG1_RD_ACK) begin
                r_PCIE_RD_DATA      <= REG1_RD_DATA ;
            end else if (REG2_RD_ACK) begin
                r_PCIE_RD_DATA      <= REG2_RD_DATA ;
            end else if (REG3_RD_ACK) begin
                r_PCIE_RD_DATA      <= REG3_RD_DATA ;
            end else if (REG4_RD_ACK) begin
                r_PCIE_RD_DATA      <= REG4_RD_DATA ;
            end else if (REG5_RD_ACK) begin
                r_PCIE_RD_DATA      <= REG5_RD_DATA ;
            end else if (REG6_RD_ACK) begin
                r_PCIE_RD_DATA      <= REG6_RD_DATA ;
            end else if (REG7_RD_ACK) begin
                r_PCIE_RD_DATA      <= REG7_RD_DATA ;
            end
        end
    end

endmodule