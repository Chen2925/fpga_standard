// =================================================================================================
// File Name      : pcie_dn_lbuf.v
// Module         : PCIE_DN_LBUF
// Function       : download local buffer module
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

module PCIE_DN_LBUF (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    input                               USER_CLK                                ,//(i)  [  1]
    input                               USER_RST                                ,//(i)  [  1]
    //dma
    output                              DN_LBUF_WR_RDY                          ,//(o)  [  1]
    input                               DN_LBUF_WR_REQ                          ,//(i)  [  1]
    input       [  63:0]                DN_LBUF_WR_DATA                         ,//(i)  [ 64]
    input                               DN_LBUF_WR_DVLD                         ,//(i)  [  1]
    input                               DN_LBUF_WR_SOP                          ,//(i)  [  1]
    input                               DN_LBUF_WR_EOP                          ,//(i)  [  1]
    //user
    output                              DN_LBUF_RD_RDY                          ,//(o)  [  1]
    input                               DN_LBUF_RD_REQ                          ,//(i)  [  1]
    output      [  63:0]                DN_LBUF_RD_DATA                         ,//(o)  [ 64]
    output                              DN_LBUF_RD_DVLD                         ,//(o)  [  1]
    output                              DN_LBUF_RD_SOP                          ,//(o)  [  1]
    output                              DN_LBUF_RD_EOP                           //(o)  [  1]
    );

// ==============================================================================
// Internal Signal Declare
// ==============================================================================

    reg                                 r_DN_LBUF_WR_RDY                        ;//(r)  [  1]
    reg                                 r_DN_LBUF_RD_RDY                        ;//(r)  [  1]
    reg                                 r_DN_LBUF_WEN                           ;//(r)  [  1]
    reg         [  71:0]                r_DN_LBUF_WDT                           ;//(r)  [ 72]
    wire                                s_DN_LBUF_RST                           ;//(s)  [  1]
    wire                                s_DN_LBUF_REN                           ;//(s)  [  1]
    wire        [  71:0]                s_DN_LBUF_RDT                           ;//(s)  [ 72]
    wire        [  10:0]                s_DN_LBUF_WCNT                          ;//(s)  [ 11]
    wire        [  10:0]                s_DN_LBUF_RCNT                          ;//(s)  [ 11]

    reg         [   3:0]                r_DN_LBUF_WCNT                          ;//(r)  [  4]
    reg         [   7:0]                r_DN_LBUF_RCNT                          ;//(r)  [  8]
    reg                                 r_DN_LBUF_WTRIG                         ;//(r)  [  1]
    wire                                s_DN_LBUF_WTRIG                         ;//(s)  [  1]
    reg                                 r_DN_LBUF_WR_TRIG                       ;//(r)  [  1]

    reg         [  15:0]                r_RD_SHFT                               ;//(r)  [ 16]
    reg         [  63:0]                r_DN_LBUF_RD_DATA                       ;//(r)  [ 64]
    reg                                 r_DN_LBUF_RD_DVLD                       ;//(r)  [  1]
    reg                                 r_DN_LBUF_RD_SOP                        ;//(r)  [  1]
    reg                                 r_DN_LBUF_RD_EOP                        ;//(r)  [  1]

// =================================================================================================
// RTL Body
// =================================================================================================

/*==============================================================================+/
||                                                                              ||
||                              Output Ports                                    ||
||                                                                              ||
/+==============================================================================*/

    assign  DN_LBUF_WR_RDY              = r_DN_LBUF_WR_RDY                      ;
    assign  DN_LBUF_RD_RDY              = r_DN_LBUF_RD_RDY                      ;

    assign  DN_LBUF_RD_DATA             = r_DN_LBUF_RD_DATA                     ;
    assign  DN_LBUF_RD_DVLD             = r_DN_LBUF_RD_DVLD                     ;
    assign  DN_LBUF_RD_SOP              = r_DN_LBUF_RD_SOP                      ;
    assign  DN_LBUF_RD_EOP              = r_DN_LBUF_RD_EOP                      ;

/*==============================================================================+/
||                                                                              ||
||                Download local buffer Control                                 ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_LBUF_WR_RDY            <= 1'b1 ;
        end else begin
            r_DN_LBUF_WR_RDY            <= ~ (s_DN_LBUF_WCNT[10] & s_DN_LBUF_WCNT[9] );
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_LBUF_WEN               <= 'b0 ;
            r_DN_LBUF_WDT               <= 'b0 ;
        end else begin
            r_DN_LBUF_WEN               <= DN_LBUF_WR_DVLD  ;
            r_DN_LBUF_WDT[63:0]         <= DN_LBUF_WR_DATA  ;
            r_DN_LBUF_WDT[64]           <= DN_LBUF_WR_DVLD  ;
            r_DN_LBUF_WDT[65]           <= DN_LBUF_WR_SOP   ;
            r_DN_LBUF_WDT[66]           <= DN_LBUF_WR_EOP   ;
            r_DN_LBUF_WDT[71:67]        <= 8'b0             ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_LBUF_WCNT              <= 'b0 ;
        end else begin
            r_DN_LBUF_WCNT              <= r_DN_LBUF_WCNT + r_DN_LBUF_WEN ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_LBUF_WTRIG             <= 'b0 ;
        end else begin
            r_DN_LBUF_WTRIG             <= (& r_DN_LBUF_WCNT[3:0]) & r_DN_LBUF_WEN ;
        end
    end

    assign s_DN_LBUF_RST                = USER_RST | PCIE_RST ;

    afifo_i72o72_d2048 U_DN_LBUF (
        .wr_clk                         ( PCIE_CLK              ),
        .rd_clk                         ( USER_CLK              ),
        .rst                            ( s_DN_LBUF_RST         ),
        .wr_en                          ( r_DN_LBUF_WEN         ),
        .din                            ( r_DN_LBUF_WDT         ),
        .rd_en                          ( s_DN_LBUF_REN         ),
        .dout                           ( s_DN_LBUF_RDT         ),
        .full                           (                       ),
        .almost_full                    (                       ),
        .empty                          (                       ),
        .almost_empty                   (                       ),
        .rd_data_count                  ( s_DN_LBUF_RCNT        ),
        .wr_data_count                  ( s_DN_LBUF_WCNT        )
        );

    PULSE_GEN U_DN_LBUF_WTRIG (
        .RST                            ( s_DN_LBUF_RST         ),
        .CLK_I                          ( PCIE_CLK              ),
        .CLK_O                          ( USER_CLK              ),
        .PULSE_I                        ( r_DN_LBUF_WTRIG       ),
        .PULSE_O                        ( s_DN_LBUF_WTRIG       )
        );

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_LBUF_WR_TRIG           <= 'b0 ;
        end else begin
            r_DN_LBUF_WR_TRIG           <= s_DN_LBUF_WTRIG ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_LBUF_RCNT              <= 'b0 ;
        end else begin
            if (r_DN_LBUF_WR_TRIG == 1'b1 && DN_LBUF_RD_REQ == 1'b0) begin
                r_DN_LBUF_RCNT          <= r_DN_LBUF_RCNT + 1'b1 ;
            end else if (r_DN_LBUF_WR_TRIG == 1'b0 && DN_LBUF_RD_REQ == 1'b1) begin
                r_DN_LBUF_RCNT          <= r_DN_LBUF_RCNT - 1'b1 ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_LBUF_RD_RDY            <= 1'b0 ;
        end else begin
            r_DN_LBUF_RD_RDY            <= | r_DN_LBUF_RCNT[7:0] ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_RD_SHFT                   <= 'b0 ;
        end else begin
            if (DN_LBUF_RD_REQ) begin
                r_RD_SHFT               <= 16'hFFFF ;
            end else begin
                r_RD_SHFT               <= {r_RD_SHFT[14:0] , 1'b0} ;
            end
        end
    end

    assign s_DN_LBUF_REN                = r_RD_SHFT[15] ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_LBUF_RD_DATA           <= 'b0 ;
            r_DN_LBUF_RD_DVLD           <= 'b0 ;
            r_DN_LBUF_RD_SOP            <= 'b0 ;
            r_DN_LBUF_RD_EOP            <= 'b0 ;
        end else begin
            r_DN_LBUF_RD_DATA           <= s_DN_LBUF_RDT[63:0]                 ;
            r_DN_LBUF_RD_DVLD           <= s_DN_LBUF_RDT[64]   & s_DN_LBUF_REN ;
            r_DN_LBUF_RD_SOP            <= s_DN_LBUF_RDT[65]   & s_DN_LBUF_REN ;
            r_DN_LBUF_RD_EOP            <= s_DN_LBUF_RDT[66]   & s_DN_LBUF_REN ;
        end
    end

endmodule