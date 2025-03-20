// =================================================================================================
// File Name      : pcie_dn_fbuf.v
// Module         : PCIE_DN_FBUF
// Function       : Upload empty buffer control module
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

module PCIE_DN_FBUF (
    //system
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    //register
    output                              DN_FBUF_WR_RDY                          ,//(o)  [  1]
    input                               DN_FBUF_WR_REQ                          ,//(i)  [  1]
    input       [  95:0]                DN_FBUF_WR_DATA                         ,//(i)  [ 96]
    output      [   8:0]                DN_FBUF_WR_DCNT                         ,//(o)  [  9]
    //upload dma
    output                              DN_FBUF_RD_RDY                          ,//(o)  [  1]
    input                               DN_FBUF_RD_REQ                          ,//(i)  [  1]
    output      [  95:0]                DN_FBUF_RD_DATA                          //(o)  [ 96]
    );

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_DN_FBUF_WEN                           ;//(r)  [  1]
    reg         [  95:0]                r_DN_FBUF_WDT                           ;//(r)  [ 96]
    reg                                 r_DN_FBUF_REN                           ;//(r)  [  1]
    wire        [ 107:0]                s_DN_FBUF_WDT                           ;//(s)  [108]
    wire        [ 107:0]                s_DN_FBUF_RDT                           ;//(s)  [108]
    reg         [  95:0]                r_DN_FBUF_RD_DATA                       ;//(r)  [ 96]
    reg                                 r_DN_FBUF_RD_RDY                        ;//(r)  [  1]
    reg                                 r_DN_FBUF_WR_RDY                        ;//(r)  [  1]
    wire                                s_DN_FBUF_AFULL                         ;//(s)  [  1]
    wire                                s_DN_FBUF_EMPTY                         ;//(s)  [  1]
    wire        [   9:0]                s_DN_FBUF_DCNT                          ;//(s)  [ 10]
    reg         [   8:0]                r_DN_FBUF_DCNT                          ;//(r)  [ 10]

// ================================================================================================
// RTL Body
// ================================================================================================

/*=============================================================================+/
||                                                                             ||
||                             Output Port                                     ||
||                                                                             ||
/+=============================================================================*/

    assign  DN_FBUF_WR_RDY              = r_DN_FBUF_WR_RDY                      ;
    assign  DN_FBUF_WR_DCNT             = r_DN_FBUF_DCNT                        ;
    assign  DN_FBUF_RD_RDY              = r_DN_FBUF_RD_RDY                      ;
    assign  DN_FBUF_RD_DATA             = r_DN_FBUF_RD_DATA                     ;

/*=============================================================================+/
||                                                                             ||
||                     Empty Buffer Queue Control                              ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_WEN               <= 'b0 ;
            r_DN_FBUF_WDT               <= 'b0 ;
        end else begin
            r_DN_FBUF_WEN               <= DN_FBUF_WR_REQ  ;
            r_DN_FBUF_WDT               <= DN_FBUF_WR_DATA ;
        end
    end

    assign  s_DN_FBUF_WDT               = {12'd0 , r_DN_FBUF_WDT} ;

    sfifo_i108o108_d512 U_DN_FBUF (
        .srst                           ( PCIE_RST          ),//(i)
        .clk                            ( PCIE_CLK          ),//(i)
        .wr_en                          ( r_DN_FBUF_WEN     ),//(i)
        .din                            ( s_DN_FBUF_WDT     ),//(i)
        .rd_en                          ( r_DN_FBUF_REN     ),//(o)
        .dout                           ( s_DN_FBUF_RDT     ),//(o)
        .almost_empty                   (                   ),//(o)
        .almost_full                    ( s_DN_FBUF_AFULL   ),//(o)
        .empty                          ( s_DN_FBUF_EMPTY   ),//(o)
        .full                           (                   ),//(o)
        .data_count                     ( s_DN_FBUF_DCNT    ) //(o)
        ) ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_REN               <= 'b0 ;
        end else begin
            r_DN_FBUF_REN               <= DN_FBUF_RD_REQ ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_RD_DATA           <= 'b0 ;
        end else begin
            r_DN_FBUF_RD_DATA           <= s_DN_FBUF_RDT[95:0] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_DCNT              <= 'b0 ;
        end else begin
            r_DN_FBUF_DCNT              <= s_DN_FBUF_DCNT[8:0] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_RD_RDY            <= 1'b0 ;
        end else begin
            r_DN_FBUF_RD_RDY            <= ~ s_DN_FBUF_EMPTY ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_WR_RDY            <= 1'b1 ;
        end else begin
            r_DN_FBUF_WR_RDY            <= ~ r_DN_FBUF_DCNT[8] ;
        end
    end

endmodule
