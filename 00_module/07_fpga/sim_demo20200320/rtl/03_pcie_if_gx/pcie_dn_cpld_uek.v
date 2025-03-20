// =================================================================================================
// File Name      : pcie_UP_cpld_uek.v
// Module         : PCIE_UP_CPLD_UEK
// Function       :
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

module PCIE_DN_CPLD_UEK (
     //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
     //cpld
    input                               UEK_CP_SOP                              ,//(i)  [  1]
    input                               UEK_CP_EOP                              ,//(i)  [  1]
    input       [  63:0]                UEK_CP_DATA                             ,//(i)  [ 64]
    input                               UEK_CP_DVLD                             ,//(i)  [  1]
    input       [   7:0]                UEK_CP_TAG                              ,//(i)  [  8]
    input       [  11:0]                UEK_CP_DCNT                             ,//(i)  [ 12]
     //user if
    output                              UP_EBUF_RD_REQ                          ,//(o)  [  1]
    output                              UP_EBUF_RD_ACK                          ,//(o)  [  1]
    output                              UP_EBUF_WR_REQ                          ,//(o)  [  1]
    output      [  95:0]                UP_EBUF_WR_DATA                          //(o)  [ 96]
    );

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg         [ 255:0]                r_UEK_CP_DATA                           ;//(r)  [256]
    reg         [   1:0]                r_UEK_CP_DCNT                           ;//(r)  [  2]
    reg                                 r_UEK_CP_DVLD                           ;//(r)  [  1]
    reg         [ 255:0]                r_CPLD_DATA                             ;//(r)  [256]
    reg                                 r_CPLD_DVLD                             ;//(r)  [  1]
    reg                                 r_UP_EBUF_WR_REQ                        ;//(r)  [  1]
    reg         [  95:0]                r_UP_EBUF_WR_DATA                       ;//(r)  [ 96]
    reg         [   2:0]                r_UP_EBUF_WR_DCNT                       ;//(r)  [  3]
    reg                                 r_UP_EBUF_RD_REQ                        ;//(r)  [  1]
    reg                                 r_UP_EBUF_RD_ACK                        ;//(r)  [  1]
    reg         [   3:0]                r_UP_EBUF_RD_REQ_DFF                    ;//(r)  [  4]
    reg         [   3:0]                r_UP_EBUF_RD_ACK_DFF                    ;//(r)  [  4]

// ==================================================================================================
// RTL Body
// ==================================================================================================

/*=============================================================================+/
||                                                                             ||
||                                 Output ports                                ||
||                                                                             ||
/+=============================================================================*/

    assign  UP_EBUF_WR_REQ              = r_UP_EBUF_WR_REQ                    ;
    assign  UP_EBUF_WR_DATA             = r_UP_EBUF_WR_DATA                   ;
    assign  UP_EBUF_RD_REQ              = r_UP_EBUF_RD_REQ_DFF[3]             ;
    assign  UP_EBUF_RD_ACK              = r_UP_EBUF_RD_ACK_DFF[3]             ;

/*=============================================================================+/
||                                                                             ||
||                                 Data Load                                   ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UEK_CP_DATA               <= 'b0  ;
        end else begin
            if (UEK_CP_DVLD) begin
                r_UEK_CP_DATA           <= {UEK_CP_DATA , r_UEK_CP_DATA[255:64]} ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UEK_CP_DCNT               <= 'b0 ;
        end else begin
            if (UEK_CP_SOP) begin
                r_UEK_CP_DCNT           <= 'b0 ;
            end else if (UEK_CP_DVLD) begin
                r_UEK_CP_DCNT           <= r_UEK_CP_DCNT + 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UEK_CP_DVLD               <= 'b0 ;
        end else begin
            r_UEK_CP_DVLD               <= UEK_CP_DVLD & r_UEK_CP_DCNT[1] & r_UEK_CP_DCNT[0] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPLD_DATA                 <= 'b0 ;
            r_CPLD_DVLD                 <= 'b0 ;
        end else begin
            r_CPLD_DATA                 <= r_UEK_CP_DATA ;
            r_CPLD_DVLD                 <= r_UEK_CP_DVLD ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                           Information Extract                               ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_WR_REQ            <= 'b0 ;
        end else begin
            r_UP_EBUF_WR_REQ            <= r_CPLD_DVLD & r_CPLD_DATA[120] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_WR_DATA           <= 'b0 ;
        end else begin
            r_UP_EBUF_WR_DATA           <= {r_CPLD_DATA[111:96] , r_CPLD_DATA[79:64] , r_CPLD_DATA[63:0] } ; // Buffer ID[15:0] + Buffer Size[15:0] + Buffer Address[63:0]
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_WR_DCNT           <= 'b0 ;
        end else begin
            r_UP_EBUF_WR_DCNT           <= r_UP_EBUF_WR_DCNT + r_CPLD_DVLD ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_RD_REQ            <= 'b0 ;
            r_UP_EBUF_RD_ACK            <= 'b0 ;
        end else begin
            r_UP_EBUF_RD_REQ            <= r_UP_EBUF_WR_DCNT[0] & r_UP_EBUF_WR_DCNT[1] & r_UP_EBUF_WR_DCNT[2] & r_CPLD_DVLD & r_CPLD_DATA[121]   ;
            r_UP_EBUF_RD_ACK            <= r_UP_EBUF_WR_DCNT[0] & r_UP_EBUF_WR_DCNT[1] & r_UP_EBUF_WR_DCNT[2] & r_CPLD_DVLD                      ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_RD_REQ_DFF        <= 'b0 ;
            r_UP_EBUF_RD_ACK_DFF        <= 'b0 ;
        end else begin
            r_UP_EBUF_RD_REQ_DFF        <= { r_UP_EBUF_RD_REQ_DFF[2:0] , r_UP_EBUF_RD_REQ } ;
            r_UP_EBUF_RD_ACK_DFF        <= { r_UP_EBUF_RD_ACK_DFF[2:0] , r_UP_EBUF_RD_ACK } ;
        end
    end

endmodule
