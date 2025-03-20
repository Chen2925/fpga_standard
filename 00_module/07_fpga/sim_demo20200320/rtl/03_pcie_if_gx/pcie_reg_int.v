// =================================================================================================
// File Name        : pcie_reg_int.v
// Module           : PCIE_REG_INT
// Function         : Internal Register control
// Type             : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2018/07/24   chen.y            create new          speed-clouds
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ps / 1ps

module PCIE_REG_INT (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]  Systerm clock(125mhz)
    input                               PCIE_RST                                ,//(i)  [  1]  Async. reset(low active)
    //register if
    input                               REG_WR_REQ                              ,//(i)  [  1]  Register write request
    input                               REG_RD_REQ                              ,//(i)  [  1]  Register read request
    output                              REG_WR_ACK                              ,//(o)  [  1]  Register write acknowledge
    output                              REG_RD_ACK                              ,//(o)  [  1]  Register read acknowledge
    input       [  31:0]                REG_WR_DATA                             ,//(i)  [ 32]  Register write data
    output      [  31:0]                REG_RD_DATA                             ,//(o)  [ 32]  Register read data
    input       [  15:0]                REG_OP_ADDR                             ,//(i)  [ 16]  Register operation address
    //system
    output                              SOFT_RST                                ,//(o)  [  1]  Software reset
    input                               PCIE_INT_0                              ,//(i)  [  1]  System intterupt
    input                               PCIE_INT_1                              ,//(i)  [  1]  System intterupt
    input                               PCIE_INT_2                              ,//(i)  [  1]  System intterupt
    input                               PCIE_INT_3                              ,//(i)  [  1]  System intterupt
    input                               PCIE_INT_4                              ,//(i)  [  1]  System intterupt
    input                               PCIE_INT_5                              ,//(i)  [  1]  System intterupt
    input                               PCIE_INT_6                              ,//(i)  [  1]  System intterupt
    input                               PCIE_INT_7                              ,//(i)  [  1]  System intterupt
    output      [   7:0]                PCIE_INT_ACT                            ,//(o)  [  8]  Intterupt mask register
    output                              PCIE_INT_CLR                            ,//(o)  [  1]  System intterupt clear
    //debug
    input       [  31:0]                REG_DEBUG0                              ,//(i)  [ 32]  Debug register 0
    input       [  31:0]                REG_DEBUG1                              ,//(i)  [ 32]  Debug register 1
    output      [  31:0]                REG_DEBUG2                              ,//(o)  [ 32]  Debug register 2
    output      [  31:0]                REG_DEBUG3                               //(o)  [ 32]  Debug register 3
    );

// =============================================================================
// Prameter define
// =============================================================================

    localparam                          p_FPGA_REV0         = 32'h20180901      ;//(p)  [ 32]  FPGA version register
    localparam                          p_FPGA_REV1         = 32'h01234567      ;//(p)  [ 32]  FPGA version register
    localparam                          p_FPGA_REV2         = 32'h89ABCDEF      ;//(p)  [ 32]  FPGA version register
    localparam                          p_FPGA_REV3         = 32'h76543210      ;//(p)  [ 32]  FPGA version register
    localparam                          p_GND               = 32'h00000000      ;//(p)  [ 32]  Ground
    localparam                          p_PWR               = 32'hFFFFFFFF      ;//(p)  [ 32]  Power

    localparam                          p_ADD_FPGA_REV0     = 16'h0000          ;//(p)  [ 16]  FPGA version register address
    localparam                          p_ADD_FPGA_REV1     = 16'h0008          ;//(p)  [ 16]  FPGA version register address
    localparam                          p_ADD_FPGA_REV2     = 16'h0010          ;//(p)  [ 16]  FPGA version register address
    localparam                          p_ADD_FPGA_REV3     = 16'h0018          ;//(p)  [ 16]  FPGA version register address
    localparam                          p_ADD_SOFT_RST      = 16'h0020          ;//(p)  [ 16]  softwart reset register address
    localparam                          p_ADD_INT_STA       = 16'h0100          ;//(p)  [ 16]  intterupt request register address
    localparam                          p_ADD_INT_MSK       = 16'h0108          ;//(p)  [ 16]  intterupt mask register address
    localparam                          p_ADD_INT_ACT       = 16'h0110          ;//(p)  [ 16]  intterupt request register address

    localparam                          p_ADD_DEBUG0        = 16'h0200          ;//(p)  [ 16]  debug register 0 address
    localparam                          p_ADD_DEBUG1        = 16'h0208          ;//(p)  [ 16]  debug register 1 address
    localparam                          p_ADD_DEBUG2        = 16'h0210          ;//(p)  [ 16]  debug register 2 address
    localparam                          p_ADD_DEBUG3        = 16'h0218          ;//(p)  [ 16]  debug register 3 address

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_REG_WEN                               ;//(r)  [  1]  PCIE register write enable
    reg                                 r_REG_REN                               ;//(r)  [  1]  PCIE register read enable
    reg         [  31:0]                r_REG_WDT                               ;//(r)  [ 32]  Register write data
    reg         [  15:0]                r_REG_ADR                               ;//(r)  [ 16]  Register address
    reg         [   3:0]                r_PCIE_INT_0                            ;//(r)  [  4]  Intterupt
    reg         [   3:0]                r_PCIE_INT_1                            ;//(r)  [  4]  Intterupt
    reg         [   3:0]                r_PCIE_INT_2                            ;//(r)  [  4]  Intterupt
    reg         [   3:0]                r_PCIE_INT_3                            ;//(r)  [  4]  Intterupt
    reg         [   3:0]                r_PCIE_INT_4                            ;//(r)  [  4]  Intterupt
    reg         [   3:0]                r_PCIE_INT_5                            ;//(r)  [  4]  Intterupt
    reg         [   3:0]                r_PCIE_INT_6                            ;//(r)  [  4]  Intterupt
    reg         [   3:0]                r_PCIE_INT_7                            ;//(r)  [  4]  Intterupt
    reg         [   7:0]                r_PCIE_INT                              ;//(r)  [  8]  Intterupt

    reg         [  31:0]                r_SOFT_RST_SHFT                         ;//(r)  [ 32]  Softwart reset
    reg                                 r_REG_SOFT_RST                          ;//(r)  [  1]  Softwart reset
    reg         [   7:0]                r_REG_SOFT_INT                          ;//(r)  [  8]  Softwart Intterupt
    reg         [   7:0]                r_REG_INT_STA                           ;//(r)  [  8]  Intterupt request register
    reg         [   7:0]                r_REG_INT_MSK                           ;//(r)  [  8]  Intterupt mask register
    reg         [   7:0]                r_REG_INT_ACT                           ;//(r)  [  8]  Intterupt mask register
    reg                                 r_REG_INT_CLR                           ;//(r)  [  1]  Intterupt mask register
    reg         [  31:0]                r_REG_DEBUG0                            ;//(r)  [ 32]  Debug register 0
    reg         [  31:0]                r_REG_DEBUG1                            ;//(r)  [ 32]  Debug register 1
    reg         [  31:0]                r_REG_DEBUG2                            ;//(r)  [ 32]  Debug register 2
    reg         [  31:0]                r_REG_DEBUG3                            ;//(r)  [ 32]  Debug register 3

    wire                                s_REG_FPGA_REV0_EN                      ;//(s)  [  1]  Revesion register enable
    wire                                s_REG_FPGA_REV1_EN                      ;//(s)  [  1]  Revesion register enable
    wire                                s_REG_FPGA_REV2_EN                      ;//(s)  [  1]  Revesion register enable
    wire                                s_REG_FPGA_REV3_EN                      ;//(s)  [  1]  Revesion register enable
    wire                                s_REG_SOFT_RST_EN                       ;//(s)  [  1]  Softwart reset register enable
    wire                                s_REG_INT_STA_EN                        ;//(s)  [  1]  Intterupt statu register enable
    wire                                s_REG_INT_MSK_EN                        ;//(s)  [  1]  Intterupt mask register enable
    wire                                s_REG_INT_ACT_EN                        ;//(s)  [  1]  Intterupt mask register enable
    wire                                s_REG_DEBUG0_EN                         ;//(s)  [  1]  Debug register 0 enable
    wire                                s_REG_DEBUG1_EN                         ;//(s)  [  1]  Debug register 1 enable
    wire                                s_REG_DEBUG2_EN                         ;//(s)  [  1]  Debug register 2 enable
    wire                                s_REG_DEBUG3_EN                         ;//(s)  [  1]  Debug register 3 enable

    reg                                 r_REG_WR_ACK                            ;//(r)  [  1]  Register write acknowledge
    reg                                 r_REG_RD_ACK                            ;//(r)  [  5]  Register read acknowledge
    wire        [  31:0]                s_REG_RDT                               ;//(s)  [ 32]  Register read data
    reg         [  31:0]                r_REG_RDT                               ;//(r)  [ 32]  Register read data
    reg         [   3:0]                r_REG_REN_SHFT                          ;//(r)  [  5]  Register read enable shift

// =================================================================================================
// RTL Body
// =================================================================================================

/*============================================================================+/
||                                                                            ||
||                              Output                                        ||
||                                                                            ||
/+============================================================================*/

    assign  REG_WR_ACK                  = r_REG_WR_ACK                          ;
    assign  REG_RD_ACK                  = r_REG_RD_ACK                          ;
    assign  REG_RD_DATA                 = r_REG_RDT                             ;

    assign  SOFT_RST                    = r_SOFT_RST_SHFT[0]                    ;
    assign  PCIE_INT_CLR                = r_REG_INT_CLR                         ;
    assign  PCIE_INT_ACT                = r_REG_INT_ACT                         ;
    assign  REG_DEBUG2                  = r_REG_DEBUG2                          ;
    assign  REG_DEBUG3                  = r_REG_DEBUG3                          ;

/*============================================================================+/
||                                                                            ||
||                              IFF                                           ||
||                                                                            ||
/+============================================================================*/

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_WEN                   <= 'b0 ;
            r_REG_REN                   <= 'b0 ;
        end else begin
            r_REG_WEN                   <= REG_WR_REQ ;
            r_REG_REN                   <= REG_RD_REQ ;
        end
    end

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
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

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_PCIE_INT_0                <= 'b0 ;
            r_PCIE_INT_1                <= 'b0 ;
            r_PCIE_INT_2                <= 'b0 ;
            r_PCIE_INT_3                <= 'b0 ;
            r_PCIE_INT_4                <= 'b0 ;
            r_PCIE_INT_5                <= 'b0 ;
            r_PCIE_INT_6                <= 'b0 ;
            r_PCIE_INT_7                <= 'b0 ;
        end else begin
            r_PCIE_INT_0                <= {r_PCIE_INT_0[2:0] , PCIE_INT_0} ;
            r_PCIE_INT_1                <= {r_PCIE_INT_1[2:0] , PCIE_INT_1} ;
            r_PCIE_INT_2                <= {r_PCIE_INT_2[2:0] , PCIE_INT_2} ;
            r_PCIE_INT_3                <= {r_PCIE_INT_3[2:0] , PCIE_INT_3} ;
            r_PCIE_INT_4                <= {r_PCIE_INT_4[2:0] , PCIE_INT_4} ;
            r_PCIE_INT_5                <= {r_PCIE_INT_5[2:0] , PCIE_INT_5} ;
            r_PCIE_INT_6                <= {r_PCIE_INT_6[2:0] , PCIE_INT_6} ;
            r_PCIE_INT_7                <= {r_PCIE_INT_7[2:0] , PCIE_INT_7} ;
        end
    end

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_PCIE_INT                  <= 'b0 ;
        end else begin
            r_PCIE_INT[0]               <= r_PCIE_INT_0[3] ^ r_PCIE_INT_0[2] ;
            r_PCIE_INT[1]               <= r_PCIE_INT_1[3] ^ r_PCIE_INT_1[2] ;
            r_PCIE_INT[2]               <= r_PCIE_INT_2[3] ^ r_PCIE_INT_2[2] ;
            r_PCIE_INT[3]               <= r_PCIE_INT_3[3] ^ r_PCIE_INT_3[2] ;
            r_PCIE_INT[4]               <= r_PCIE_INT_4[3] ^ r_PCIE_INT_4[2] ;
            r_PCIE_INT[5]               <= r_PCIE_INT_5[3] ^ r_PCIE_INT_5[2] ;
            r_PCIE_INT[6]               <= r_PCIE_INT_6[3] ^ r_PCIE_INT_6[2] ;
            r_PCIE_INT[7]               <= r_PCIE_INT_7[3] ^ r_PCIE_INT_7[2] ;
        end
    end

/*============================================================================+/
||                                                                            ||
||                    Register Address Decode                                 ||
||                                                                            ||
/+============================================================================*/

    assign  s_REG_FPGA_REV0_EN          = ( r_REG_ADR == p_ADD_FPGA_REV0 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_FPGA_REV1_EN          = ( r_REG_ADR == p_ADD_FPGA_REV1 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_FPGA_REV2_EN          = ( r_REG_ADR == p_ADD_FPGA_REV2 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_FPGA_REV3_EN          = ( r_REG_ADR == p_ADD_FPGA_REV3 ) ? 1'b1 : 1'b0 ;
    assign  s_REG_SOFT_RST_EN           = ( r_REG_ADR == p_ADD_SOFT_RST  ) ? 1'b1 : 1'b0 ;
    assign  s_REG_INT_STA_EN            = ( r_REG_ADR == p_ADD_INT_STA   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_INT_MSK_EN            = ( r_REG_ADR == p_ADD_INT_MSK   ) ? 1'b1 : 1'b0 ;
    assign  s_REG_INT_ACT_EN            = ( r_REG_ADR == p_ADD_INT_ACT   ) ? 1'b1 : 1'b0 ;

    assign  s_REG_DEBUG0_EN             = ( r_REG_ADR == p_ADD_DEBUG0    ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG1_EN             = ( r_REG_ADR == p_ADD_DEBUG1    ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG2_EN             = ( r_REG_ADR == p_ADD_DEBUG2    ) ? 1'b1 : 1'b0 ;
    assign  s_REG_DEBUG3_EN             = ( r_REG_ADR == p_ADD_DEBUG3    ) ? 1'b1 : 1'b0 ;

/*============================================================================+/
||                                                                            ||
||                      Register Write Control                                ||
||                                                                            ||
/+============================================================================*/

    /*--------------------------------------------------+/
    ||               Software Reset Register
    ||  [31:01] ---- reserve
    ||  [00:00] ---- software reset
    ||               [add:0x 0004] [R/W]
    /+--------------------------------------------------*/
    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_SOFT_RST              <= 1'b0 ;
            r_REG_SOFT_INT              <= 1'b0 ;
        end else begin
            if (r_REG_WEN & s_REG_SOFT_RST_EN) begin
                r_REG_SOFT_RST          <= r_REG_WDT[0] ;
                r_REG_SOFT_INT          <= r_REG_WDT[8:1] ;
            end else begin
                r_REG_SOFT_RST          <= 1'b0 ;
                r_REG_SOFT_INT          <= 8'b0 ;
            end
        end
    end

    always @(posedge PCIE_CLK) begin
        if (r_REG_SOFT_RST) begin
            r_SOFT_RST_SHFT             <= 32'hFFFF0000 ;
        end else begin
            r_SOFT_RST_SHFT             <= {1'b0 , r_SOFT_RST_SHFT[31:1]} ;
        end
    end

    /*--------------------------------------------------+/
    ||               Intterupt status register
    ||  [31:08] ---- reserve
    ||  [07:00] ---- system intterupt statu
    ||               [add:0x 0008] [R]
    /+--------------------------------------------------*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_INT_STA               <= 8'h00 ;
        end else begin
            if (r_REG_RD_ACK & s_REG_INT_STA_EN)    r_REG_INT_STA[0] <= 1'b0 ;  else if (r_PCIE_INT[0] | r_REG_SOFT_INT[0] )    r_REG_INT_STA[0] <= 1'b1 ;
            if (r_REG_RD_ACK & s_REG_INT_STA_EN)    r_REG_INT_STA[1] <= 1'b0 ;  else if (r_PCIE_INT[1] | r_REG_SOFT_INT[1] )    r_REG_INT_STA[1] <= 1'b1 ;
            if (r_REG_RD_ACK & s_REG_INT_STA_EN)    r_REG_INT_STA[2] <= 1'b0 ;  else if (r_PCIE_INT[2] | r_REG_SOFT_INT[2] )    r_REG_INT_STA[2] <= 1'b1 ;
            if (r_REG_RD_ACK & s_REG_INT_STA_EN)    r_REG_INT_STA[3] <= 1'b0 ;  else if (r_PCIE_INT[3] | r_REG_SOFT_INT[3] )    r_REG_INT_STA[3] <= 1'b1 ;
            if (r_REG_RD_ACK & s_REG_INT_STA_EN)    r_REG_INT_STA[4] <= 1'b0 ;  else if (r_PCIE_INT[4] | r_REG_SOFT_INT[4] )    r_REG_INT_STA[4] <= 1'b1 ;
            if (r_REG_RD_ACK & s_REG_INT_STA_EN)    r_REG_INT_STA[5] <= 1'b0 ;  else if (r_PCIE_INT[5] | r_REG_SOFT_INT[5] )    r_REG_INT_STA[5] <= 1'b1 ;
            if (r_REG_RD_ACK & s_REG_INT_STA_EN)    r_REG_INT_STA[6] <= 1'b0 ;  else if (r_PCIE_INT[6] | r_REG_SOFT_INT[6] )    r_REG_INT_STA[6] <= 1'b1 ;
            if (r_REG_RD_ACK & s_REG_INT_STA_EN)    r_REG_INT_STA[7] <= 1'b0 ;  else if (r_PCIE_INT[7] | r_REG_SOFT_INT[7] )    r_REG_INT_STA[7] <= 1'b1 ;
        end
    end


    /*--------------------------------------------------+/
    ||               Intterupt mask register
    ||  [31:08] ---- reserve
    ||  [07:00] ---- system intterupt mask
    ||               [add:0x 000C] [R/W]
    /+--------------------------------------------------*/
    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_INT_MSK               <= 8'hFF ;
        end else begin
            if (r_REG_WEN & s_REG_INT_MSK_EN) begin
                r_REG_INT_MSK           <= r_REG_WDT[7:0] ;
            end
        end
    end

    /*--------------------------------------------------+/
    ||               Intterupt status register
    ||  [31:08] ---- reserve
    ||  [07:00] ---- system intterupt statu
    ||               [add:0x 0008] [R]
    /+--------------------------------------------------*/

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_INT_ACT               <= 'b0 ;
        end else begin
            r_REG_INT_ACT[0]            <= r_REG_INT_STA[0] & (~r_REG_INT_MSK[0]) ;
            r_REG_INT_ACT[1]            <= r_REG_INT_STA[1] & (~r_REG_INT_MSK[1]) ;
            r_REG_INT_ACT[2]            <= r_REG_INT_STA[2] & (~r_REG_INT_MSK[2]) ;
            r_REG_INT_ACT[3]            <= r_REG_INT_STA[3] & (~r_REG_INT_MSK[3]) ;
            r_REG_INT_ACT[4]            <= r_REG_INT_STA[4] & (~r_REG_INT_MSK[4]) ;
            r_REG_INT_ACT[5]            <= r_REG_INT_STA[5] & (~r_REG_INT_MSK[5]) ;
            r_REG_INT_ACT[6]            <= r_REG_INT_STA[6] & (~r_REG_INT_MSK[6]) ;
            r_REG_INT_ACT[7]            <= r_REG_INT_STA[7] & (~r_REG_INT_MSK[7]) ;
        end
    end

    /*--------------------------------------------------+/
    ||               Intterupt mask register
    ||  [31:01] ---- reserve
    ||  [00:00] ---- system intterupt clear
    ||               [add:0x 000C] [R/W]
    /+--------------------------------------------------*/
    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_INT_CLR               <= 1'b0 ;
        end else begin
            r_REG_INT_CLR               <= r_REG_RD_ACK & s_REG_INT_STA_EN ;
        end
    end

    /*--------------------------------------------------+/
    ||               Debug Register 0
    ||  [31:00] ---- debug used register
    ||               [add:0x 0010-001C] [R]
    /+--------------------------------------------------*/
    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_DEBUG0                <= 1'b0 ;
            r_REG_DEBUG1                <= 1'b0 ;
            r_REG_DEBUG2                <= 1'b0 ;
            r_REG_DEBUG3                <= 1'b0 ;
        end else begin
            r_REG_DEBUG0                <= REG_DEBUG0 ;
            r_REG_DEBUG1                <= REG_DEBUG1 ;

            if (r_REG_WEN & s_REG_DEBUG2_EN ) begin r_REG_DEBUG2 <= r_REG_WDT ; end
            if (r_REG_WEN & s_REG_DEBUG3_EN ) begin r_REG_DEBUG3 <= r_REG_WDT ; end
         end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_WR_ACK                <= 'b0;
        end else begin
            r_REG_WR_ACK                <= r_REG_WEN ;
        end
    end

/*============================================================================+/
||                                                                            ||
||                      Register Read Enable                                  ||
||                                                                            ||
/+============================================================================*/

    assign s_REG_RDT                    = ( s_REG_FPGA_REV0_EN     == 1'b1) ? {               p_FPGA_REV0     } :
                                          ( s_REG_FPGA_REV1_EN     == 1'b1) ? {               p_FPGA_REV1     } :
                                          ( s_REG_FPGA_REV2_EN     == 1'b1) ? {               p_FPGA_REV2     } :
                                          ( s_REG_FPGA_REV3_EN     == 1'b1) ? {               p_FPGA_REV3     } :
                                          ( s_REG_SOFT_RST_EN      == 1'b1) ? { p_GND[31:9] , r_REG_SOFT_INT  ,
                                                                                              r_REG_SOFT_RST  } :
                                          ( s_REG_INT_STA_EN       == 1'b1) ? { p_GND[31:8] , r_REG_INT_STA   } :
                                          ( s_REG_INT_MSK_EN       == 1'b1) ? { p_GND[31:8] , r_REG_INT_MSK   } :
                                          ( s_REG_INT_ACT_EN       == 1'b1) ? { p_GND[31:8] , r_REG_INT_ACT   } :
                                          ( s_REG_DEBUG0_EN        == 1'b1) ? {               r_REG_DEBUG0    } :
                                          ( s_REG_DEBUG1_EN        == 1'b1) ? {               r_REG_DEBUG1    } :
                                          ( s_REG_DEBUG2_EN        == 1'b1) ? {               r_REG_DEBUG2    } :
                                          ( s_REG_DEBUG3_EN        == 1'b1) ? {               r_REG_DEBUG3    } :
                                                                              { p_GND[31:0]                   } ;

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_RDT                   <= 'b0 ;
        end else begin
            r_REG_RDT                   <= s_REG_RDT ;
        end
    end

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_REN_SHFT              <= 'b0 ;
        end else begin
            r_REG_REN_SHFT              <= {r_REG_REN_SHFT[2:0] , r_REG_REN} ;
        end
    end

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_RD_ACK                <= 'b0 ;
        end else begin
            r_REG_RD_ACK                <= r_REG_REN_SHFT[3] ;
        end
    end

endmodule