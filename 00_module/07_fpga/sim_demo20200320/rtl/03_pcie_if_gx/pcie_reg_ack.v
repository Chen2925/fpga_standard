// =================================================================================================
// File Name      : pcie_reg_ack.v
// Module         : PCIE_REG_ACK
// Function       : Memory read complement packet generate module
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

module PCIE_REG_ACK (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]  Systerm clock(125mhz)
    input                               PCIE_RST                                ,//(i)  [  1]  Async. reset(low active)
    //register control
    input                               REG_RD_REQ                              ,//(i)  [  1]  Register read request
    input                               REG_RD_ACK                              ,//(i)  [  1]  Register read data
    output                              REG_RD_OK                               ,//(o)  [  1]  Register read ok
    input       [  31:0]                REG_RD_DATA                             ,//(i)  [ 32]  Register read address
    input       [  63:0]                REG_OP_ADDR                             ,//(i)  [ 64]  Register read data valid
    //PCIE core
    input       [   6:0]                RX_FMT                                  ,//(i)  [  7]  Receive request packet FMT
    input       [   2:0]                RX_TC                                   ,//(i)  [  3]  Receive request packet TC
    input                               RX_TD                                   ,//(i)  [  1]  Receive request packet TD
    input                               RX_EP                                   ,//(i)  [  1]  Receive request packet EP
    input       [   1:0]                RX_ATTR                                 ,//(i)  [  2]  Receive request packet ATTR
    input       [   9:0]                RX_LEN                                  ,//(i)  [ 10]  Receive request packet length(DW)
    input       [  15:0]                RX_RID                                  ,//(i)  [ 16]  Receive requester ID
    input       [   7:0]                RX_RTAG                                 ,//(i)  [  8]  Receive requester tag
    input       [   7:0]                RX_BE                                   ,//(i)  [  8]  Receive request packet byte enable
    input       [  15:0]                COMPLETER_ID                            ,//(i)  [ 16]
    //completion tx
    output                              CPK_TX_REQ                              ,//(o)  [  1]  Completion packet TX request
    input                               CPK_TX_ACK                              ,//(i)  [  1]  Completion packet TX acknowledge
    output      [  63:0]                CPK_TX_DATA                             ,//(o)  [ 64]  Completion packet TX data
    output      [   1:0]                CPK_TX_MASK                             ,//(o)  [  2]
    output                              CPK_TX_DVLD                             ,//(o)  [  1]  Completion packet TX valid
    output                              CPK_TX_SOP                              ,//(o)  [  1]  Completion packet TX start
    output                              CPK_TX_EOP                               //(o)  [  1]  Completion packet TX end
    );

// ==============================================================================
// localparam Declare
// ==============================================================================

    //TLP Fmt&Type decede
    localparam                          p_MEM_RD32_FMT  = 7'b0000000            ;//(p)  [  7]  Memory read request with 32 bits address
    localparam                          p_MEM_WR32_FMT  = 7'b1000000            ;//(p)  [  7]  Memory write request with 32 bits address
    localparam                          p_MEM_RD64_FMT  = 7'b0100000            ;//(p)  [  7]  Memory read request with 64 bits address
    localparam                          p_MEM_WR64_FMT  = 7'b1100000            ;//(p)  [  7]  Memory write request with 64 bits address
    localparam                          p_CPLD_FMT      = 7'b1001010            ;//(p)  [  7]  Cpld decode

// ==============================================================================
// Internal Signal Declare
// ==============================================================================

    reg         [   2:0]                r_TX_TC                                 ;//(r)  [  3]  Transmit TC
    reg                                 r_TX_TD                                 ;//(r)  [  1]  Transmit TD
    reg                                 r_TX_EP                                 ;//(r)  [  1]  Transmit EP
    reg         [   1:0]                r_TX_ATTR                               ;//(r)  [  2]  Transmit ATTR
    reg         [   9:0]                r_TX_LEN                                ;//(r)  [ 10]  Transmit length(DW)
    reg         [  15:0]                r_TX_RID                                ;//(r)  [ 16]  Transmit ID
    reg         [   7:0]                r_TX_RTAG                               ;//(r)  [  8]  Transmit tag
    reg         [   7:0]                r_TX_BE                                 ;//(r)  [  8]  Transmit byte enable
    reg         [   4:0]                r_TX_ADR                                ;//(r)  [  5]  Transmit address

    reg         [  31:0]                r_TX_DATA                               ;//(r)  [  1]  Transmit data
    reg         [  11:0]                r_TX_BCNT                               ;//(r)  [ 12]  Byte count
    reg         [   6:0]                r_TX_LADR                               ;//(r)  [  7]  Low address
    wire        [  31:0]                s_CPK_HEAD0                             ;//(s)  [ 32]  Completer packet head0
    wire        [  31:0]                s_CPK_HEAD1                             ;//(s)  [ 32]  Completer packet head1
    wire        [  31:0]                s_CPK_HEAD2                             ;//(s)  [ 32]  Completer packet head1

    reg                                 r_REG_RD_ACK_DFF1                       ;//(r)  [  1]  Completer packet transmit request
    reg                                 r_REG_RD_ACK_DFF2                       ;//(r)  [  1]  Completer packet transmit request
    reg                                 r_REG_RD_OK                             ;//(r)  [  1]  register read ok

    reg                                 r_CPK_TX_ACK_DFF1                       ;//(r)  [  1]  Completer packet transmit request
    reg                                 r_CPK_TX_ACK_DFF2                       ;//(r)  [  1]  Completer packet transmit request
    reg                                 r_CPK_TX_REQ                            ;//(r)  [  1]  Completer packet transmit request
    reg         [  63:0]                r_CPK_TX_DATA                           ;//(r)  [ 64]  Completer packet transmit data
    reg                                 r_CPK_TX_DVLD                           ;//(r)  [  1]  register read ok
    reg                                 r_CPK_TX_SOP                            ;//(r)  [  1]  register read ok
    reg                                 r_CPK_TX_EOP                            ;//(r)  [  1]  register read ok
    reg         [   1:0]                r_CPK_TX_MASK                           ;//(r)  [  2]  register read ok

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Output Port                                    ||
||                                                                             ||
/+=============================================================================*/

    assign  REG_RD_OK                   = r_REG_RD_OK                           ;
    assign  CPK_TX_REQ                  = r_CPK_TX_REQ                          ;
    assign  CPK_TX_DVLD                 = r_CPK_TX_DVLD                         ;
    assign  CPK_TX_SOP                  = r_CPK_TX_SOP                          ;
    assign  CPK_TX_EOP                  = r_CPK_TX_EOP                          ;
    assign  CPK_TX_MASK                 = r_CPK_TX_MASK                         ;
    assign  CPK_TX_DATA                 = r_CPK_TX_DATA                         ;

/*=============================================================================+/
||                                                                             ||
||                      CPLD Packet Generete                                   ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
                r_TX_TC                 <= { 3{1'b0}} ;
                r_TX_TD                 <= { 1{1'b0}} ;
                r_TX_EP                 <= { 1{1'b0}} ;
                r_TX_ATTR               <= { 2{1'b0}} ;
                r_TX_LEN                <= {10{1'b0}} ;
                r_TX_RID                <= {16{1'b0}} ;
                r_TX_RTAG               <= { 8{1'b0}} ;
                r_TX_BE                 <= { 8{1'b0}} ;
                r_TX_ADR                <= { 5{1'b0}} ;
        end else begin
            if (REG_RD_REQ) begin
                r_TX_TC                 <= RX_TC            ;
                r_TX_TD                 <= RX_TD            ;
                r_TX_EP                 <= RX_EP            ;
                r_TX_ATTR               <= RX_ATTR          ;
                r_TX_LEN                <= RX_LEN           ;
                r_TX_RID                <= RX_RID           ;
                r_TX_RTAG               <= RX_RTAG          ;
                r_TX_BE                 <= RX_BE            ;
                r_TX_ADR                <= REG_OP_ADDR[6:2] ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_TX_DATA                   <= {32{1'b0}} ;
        end else begin
            if (REG_RD_ACK) begin
                r_TX_DATA[31:24]        <= REG_RD_DATA[ 7: 0] ;
                r_TX_DATA[23:16]        <= REG_RD_DATA[15: 8] ;
                r_TX_DATA[15: 8]        <= REG_RD_DATA[23:16] ;
                r_TX_DATA[ 7: 0]        <= REG_RD_DATA[31:24] ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_TX_BCNT                   <= {12{1'b0}} ;
        end else begin
            r_TX_BCNT[11:3]             <= {9{1'b0}} ;

            if ((r_TX_BE[3] == 1'b1) && (r_TX_BE[0] == 1'b1)) begin
                r_TX_BCNT[2:0]          <= 3'b100 ; //1xx1
            end else if ((r_TX_BE[3:2] == 2'b01) && (r_TX_BE[0] == 1'b1)) begin
                r_TX_BCNT[2:0]          <= 3'b011 ; //01x1
            end else if ((r_TX_BE[3] == 1'b1) && (r_TX_BE[1:0] == 2'b10)) begin
                r_TX_BCNT[2:0]          <= 3'b011 ; //1x10
            end else if (r_TX_BE[3:0] == 4'b0011) begin
                r_TX_BCNT[2:0]          <= 3'b010 ; //0011
            end else if (r_TX_BE[3:0] == 4'b0110) begin
                r_TX_BCNT[2:0]          <= 3'b010 ; //0110
            end else if (r_TX_BE[3:0] == 4'b1100) begin
                r_TX_BCNT[2:0]          <= 3'b010 ; //1100
            end else begin
                r_TX_BCNT[2:0]          <= 3'b001 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_TX_LADR                   <= {7{1'b0}} ;
        end else begin
            r_TX_LADR[6:2]              <= r_TX_ADR[4:0] ;

            if (r_TX_BE[3:0] == 4'b0000) begin
                r_TX_LADR[1:0]          <= 2'b00 ;      //0000
            end else if (r_TX_BE[0] == 1'b1) begin
                r_TX_LADR[1:0]          <= 2'b00 ;      //xxx1
            end else if (r_TX_BE[1:0] == 2'b10) begin
                r_TX_LADR[1:0]          <= 2'b01 ;      //xx10
            end else if (r_TX_BE[2:0] == 3'b100) begin
                r_TX_LADR[1:0]          <= 2'b10 ;      //x100
            end else begin
                r_TX_LADR[1:0]          <= 2'b11 ;      //1000
            end
        end
    end

    assign s_CPK_HEAD0                  = {
                                           1'b0         ,//reserve
                                           p_CPLD_FMT   ,//fmt & type
                                           1'b0         ,//R
                                           r_TX_TC      ,//TC
                                           4'b0         ,//R
                                           r_TX_TD      ,//TD
                                           r_TX_EP      ,//EP
                                           r_TX_ATTR    ,//ATTR
                                           2'b0         ,//R
                                           r_TX_LEN      //length
                                          };


    assign s_CPK_HEAD1                  = {
                                           COMPLETER_ID ,//
                                           3'b0         ,//completer status
                                           1'b0         ,//bcm
                                           r_TX_BCNT     //byte count
                                          };


    assign s_CPK_HEAD2                  = {
                                           r_TX_RID     ,//request id
                                           r_TX_RTAG    ,//tag
                                           1'b0         ,//R
                                           r_TX_LADR     //low address
                                          };

/*==========================================================================+/
||                                                                          ||
||                     Register CPLD Transmit Generete                      ||
||                                                                          ||
/+==========================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_RD_ACK_DFF1           <= 1'b0 ;
            r_REG_RD_ACK_DFF2           <= 1'b0 ;
        end else begin
            r_REG_RD_ACK_DFF1           <= REG_RD_ACK        ;
            r_REG_RD_ACK_DFF2           <= r_REG_RD_ACK_DFF1 ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPK_TX_REQ                <= 1'b0 ;
        end else begin
            if (r_REG_RD_ACK_DFF2) begin
                r_CPK_TX_REQ            <= 1'b1 ;
            end else if (r_CPK_TX_ACK_DFF2) begin
                r_CPK_TX_REQ            <= 1'b0 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPK_TX_ACK_DFF1           <= 'b0 ;
            r_CPK_TX_ACK_DFF2           <= 'b0 ;
        end else begin
            r_CPK_TX_ACK_DFF1           <= CPK_TX_ACK ;
            r_CPK_TX_ACK_DFF2           <= r_CPK_TX_ACK_DFF1 ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPK_TX_DVLD               <= 'b0 ;
            r_CPK_TX_SOP                <= 'b0 ;
            r_CPK_TX_EOP                <= 'b0 ;
            r_CPK_TX_MASK               <= 'b0 ;
            r_CPK_TX_DATA               <= 'b0 ;
        end else begin
            if (r_CPK_TX_ACK_DFF1) begin
                r_CPK_TX_DVLD           <= 1'b1         ;
                r_CPK_TX_SOP            <= 1'b1         ;
                r_CPK_TX_EOP            <= 1'b0         ;
                r_CPK_TX_MASK           <= 2'b11        ;
                r_CPK_TX_DATA[63:32]    <= s_CPK_HEAD1  ;
                r_CPK_TX_DATA[31:0]     <= s_CPK_HEAD0  ;
            end else if (r_CPK_TX_ACK_DFF2) begin
                r_CPK_TX_DVLD           <= 1'b1         ;
                r_CPK_TX_SOP            <= 1'b0         ;
                r_CPK_TX_EOP            <= 1'b1         ;
                r_CPK_TX_MASK           <= 2'b11        ;
                r_CPK_TX_DATA[63:32]    <= r_TX_DATA    ;
                r_CPK_TX_DATA[31:0]     <= s_CPK_HEAD2  ;
            end else begin
                r_CPK_TX_DVLD           <= 'b0 ;
                r_CPK_TX_SOP            <= 'b0 ;
                r_CPK_TX_EOP            <= 'b0 ;
                r_CPK_TX_MASK           <= 'b0 ;
                r_CPK_TX_DATA           <= 'b0 ;
            end

        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_RD_OK                 <= 'b0 ;
        end else begin
            r_REG_RD_OK                 <= r_CPK_TX_ACK_DFF2 ;
        end
    end

endmodule


/*========================================================================================

    -- 64bit address memory read/write packet heard:
                 ------------------------------------------------------------------
                |      0        ||       1       ||       2       ||       3       |
                |7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0|
                |------------------------------------------------------------------|
     Byte 0-3   |R|fmt|   type  ||R| TC  |   R   ||0 0|att| R |      length        |
                |------------------------------------------------------------------|
     Byte 4-7   |          requester ID          ||     tag       || L BE  |  F BE |
                |------------------------------------------------------------------|
     Byte 8-11  |                      Address[63:32]                              |
                |------------------------------------------------------------------|
     Byte 12-15 |            Address[31:2]                                     |00 |
                 ------------------------------------------------------------------

    -- 32bit address memory read/write packet heard:
                 ------------------------------------------------------------------
                |      0        ||       1       ||       2       ||       3       |
                |7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0|
                |------------------------------------------------------------------|
     Byte 0-3   |R|fmt|   type  ||R| TC  |   R   ||0 0|att| R |      length        |
                |------------------------------------------------------------------|
     Byte 4-7   |          requester ID          ||     tag       || L BE  |  F BE |
                |------------------------------------------------------------------|
     Byte 8-11  |            Address[31:2]                                     |00 |
                |------------------------------------------------------------------|
     Byte 12-15 |                                 Reseave                          |
                 ------------------------------------------------------------------

    --  request completion packet heard:
                 ------------------------------------------------------------------
                |      0        ||       1       ||       2       ||       3       |
                |7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0|
                |------------------------------------------------------------------|
     Byte 0-3   |R|fmt|   type  ||R| TC  |   R   ||T|E|att| R |      length        |
                |------------------------------------------------------------------|
     Byte 4-7   |          completer ID          || cs  |0|      byte count        |
                |------------------------------------------------------------------|
     Byte 8-11  |          requester ID          ||     tag       ||R| low address |
                |------------------------------------------------------------------|
     Byte 12-15 |                           completer data                         |
                 ------------------------------------------------------------------

========================================================================================*/

