// =================================================================================================
// File Name      : pcie_dn_cpld_dfk.v
// Module         : PCIE_DN_CPLD_DFK
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

module PCIE_DN_CPLD_DFK (
     //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
     //cpld
    input                               DFK_CP_SOP                              ,//(i)  [  1]
    input                               DFK_CP_EOP                              ,//(i)  [  1]
    input       [  63:0]                DFK_CP_DATA                             ,//(i)  [ 64]
    input                               DFK_CP_DVLD                             ,//(i)  [  1]
    input       [   7:0]                DFK_CP_TAG                              ,//(i)  [  8]
    input       [  11:0]                DFK_CP_DCNT                             ,//(i)  [ 12]
     //user if
    output                              DN_FILE_SOF                             ,//(o)  [  1]
    output                              DN_FILE_EOF                             ,//(o)  [  1]
    output      [  15:0]                DN_FILE_FID                             ,//(o)  [ 16]
    output      [  15:0]                DN_FILE_SID                             ,//(o)  [ 16]
    output      [  15:0]                DN_FILE_VCH                             ,//(o)  [ 16]
    output      [  31:0]                DN_FILE_ADDR                            ,//(o)  [ 32]
    output      [  31:0]                DN_FILE_SIZE                            ,//(o)  [ 32]

    output                              DN_FBUF_RD_REQ                          ,//(o)  [  1]
    output                              DN_FBUF_RD_ACK                          ,//(o)  [  1]
    output                              DN_FBUF_WR_REQ                          ,//(o)  [  1]
    output      [  95:0]                DN_FBUF_WR_DATA                          //(o)  [ 96]
    );

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg         [ 255:0]                r_DFK_CP_DATA                           ;//(r)  [256]
    reg         [   1:0]                r_DFK_CP_DCNT                           ;//(r)  [  2]
    reg                                 r_DFK_CP_DVLD                           ;//(r)  [  1]
    reg         [ 255:0]                r_CPLD_DATA                             ;//(r)  [256]
    reg                                 r_CPLD_DVLD                             ;//(r)  [  1]
    reg                                 r_DN_FBUF_WR_REQ                        ;//(r)  [  1]
    reg         [  95:0]                r_DN_FBUF_WR_DATA                       ;//(r)  [ 96]
    reg         [   2:0]                r_DN_FBUF_WR_DCNT                       ;//(r)  [  3]
    reg                                 r_DN_FBUF_RD_REQ                        ;//(r)  [  1]
    reg                                 r_DN_FBUF_RD_ACK                        ;//(r)  [  1]
    reg         [   3:0]                r_DN_FBUF_RD_REQ_DFF                    ;//(r)  [  4]
    reg         [   3:0]                r_DN_FBUF_RD_ACK_DFF                    ;//(r)  [  4]

    reg                                 r_DN_FILE_SOF                           ;//(r)  [  1]
    reg                                 r_DN_FILE_EOF                           ;//(r)  [  1]
    reg         [  15:0]                r_DN_FILE_FID                           ;//(r)  [ 16]
    reg         [  15:0]                r_DN_FILE_SID                           ;//(r)  [ 16]
    reg         [  15:0]                r_DN_FILE_VCH                           ;//(r)  [ 16]
    reg         [  31:0]                r_DN_FILE_ADDR                          ;//(r)  [ 32]
    reg         [  31:0]                r_DN_FILE_SIZE                          ;//(r)  [ 32]

// ==================================================================================================
// RTL Body
// ==================================================================================================

/*=============================================================================+/
||                                                                             ||
||                                 Output ports                                ||
||                                                                             ||
/+=============================================================================*/

    assign  DN_FBUF_WR_REQ               = r_DN_FBUF_WR_REQ                     ;
    assign  DN_FBUF_WR_DATA              = r_DN_FBUF_WR_DATA                    ;
    assign  DN_FBUF_RD_REQ               = r_DN_FBUF_RD_REQ_DFF[3]              ;
    assign  DN_FBUF_RD_ACK               = r_DN_FBUF_RD_ACK_DFF[3]              ;

    assign  DN_FILE_SOF                  = r_DN_FILE_SOF                        ;
    assign  DN_FILE_EOF                  = r_DN_FILE_EOF                        ;
    assign  DN_FILE_FID                  = r_DN_FILE_FID                        ;
    assign  DN_FILE_SID                  = r_DN_FILE_SID                        ;
    assign  DN_FILE_VCH                  = r_DN_FILE_VCH                        ;
    assign  DN_FILE_ADDR                 = r_DN_FILE_ADDR                       ;
    assign  DN_FILE_SIZE                 = r_DN_FILE_SIZE                       ;

/*=============================================================================+/
||                                                                             ||
||                                 Data Load                                   ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_CP_DATA               <= 'b0  ;
        end else begin
            if (DFK_CP_DVLD) begin
                r_DFK_CP_DATA           <= {DFK_CP_DATA , r_DFK_CP_DATA[255:64]} ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_CP_DCNT               <= 'b0 ;
        end else begin
            if (DFK_CP_SOP) begin
                r_DFK_CP_DCNT           <= 'b0 ;
            end else if (DFK_CP_DVLD) begin
                r_DFK_CP_DCNT           <= r_DFK_CP_DCNT + 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_CP_DVLD               <= 'b0 ;
        end else begin
            r_DFK_CP_DVLD               <= DFK_CP_DVLD & r_DFK_CP_DCNT[1] & r_DFK_CP_DCNT[0] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPLD_DATA                 <= 'b0 ;
            r_CPLD_DVLD                 <= 'b0 ;
        end else begin
            r_CPLD_DATA                 <= r_DFK_CP_DATA ;
            r_CPLD_DVLD                 <= r_DFK_CP_DVLD ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                           Information Extract                               ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_WR_REQ           <= 'b0 ;
        end else begin
            r_DN_FBUF_WR_REQ           <= r_CPLD_DVLD & r_CPLD_DATA[120] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_WR_DATA           <= 'b0 ;
        end else begin
            r_DN_FBUF_WR_DATA           <= {r_CPLD_DATA[111:96] , r_CPLD_DATA[79:64] , r_CPLD_DATA[63:0]} ; // Buffer ID[15:0] + Buffer Size[15:0] + Buffer Address[63:0]
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_WR_DCNT           <= 'b0 ;
        end else begin
            r_DN_FBUF_WR_DCNT           <= r_DN_FBUF_WR_DCNT + r_CPLD_DVLD ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_RD_REQ            <= 'b0 ;
            r_DN_FBUF_RD_ACK            <= 'b0 ;
        end else begin
            r_DN_FBUF_RD_REQ            <= r_DN_FBUF_WR_DCNT[0] & r_DN_FBUF_WR_DCNT[1] & r_DN_FBUF_WR_DCNT[2] & r_CPLD_DVLD & r_CPLD_DATA[121]  ;
            r_DN_FBUF_RD_ACK            <= r_DN_FBUF_WR_DCNT[0] & r_DN_FBUF_WR_DCNT[1] & r_DN_FBUF_WR_DCNT[2] & r_CPLD_DVLD                     ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_RD_REQ_DFF        <= 'b0 ;
            r_DN_FBUF_RD_ACK_DFF        <= 'b0 ;
        end else begin
            r_DN_FBUF_RD_REQ_DFF        <= { r_DN_FBUF_RD_REQ_DFF[2:0] , r_DN_FBUF_RD_REQ } ;
            r_DN_FBUF_RD_ACK_DFF        <= { r_DN_FBUF_RD_ACK_DFF[2:0] , r_DN_FBUF_RD_ACK } ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FILE_SOF               <= 'b0 ;
            r_DN_FILE_EOF               <= 'b0 ;
            r_DN_FILE_FID               <= 'b0 ;
            r_DN_FILE_SID               <= 'b0 ;
            r_DN_FILE_VCH               <= 'b0 ;
            r_DN_FILE_ADDR              <= 'b0 ;
            r_DN_FILE_SIZE              <= 'b0 ;
        end else begin
            r_DN_FILE_SOF               <= r_CPLD_DATA[127]   & r_CPLD_DVLD ;
            r_DN_FILE_EOF               <= r_CPLD_DATA[126]   & r_CPLD_DVLD ;
            r_DN_FILE_FID               <= r_CPLD_DATA[159:144]             ;
            r_DN_FILE_SID               <= r_CPLD_DATA[143:128]             ;
            r_DN_FILE_VCH               <= r_CPLD_DATA[ 95: 80]             ;
            r_DN_FILE_ADDR              <= r_CPLD_DATA[223:192]             ;
            r_DN_FILE_SIZE              <= r_CPLD_DATA[191:160]             ;
        end
    end

/*===================================================================================================
||          |  8bit     |   8bit   |    8bit   |   8bit   |   32bit   |   56bit          |   8bit   ||
||          |           |          |           |          |           |                  |          ||
|| DN_FBUF  |  valid    |     -    |      -    |     -    |   size    |   address[63:8]  |   buf_id ||
||          |           |          |           |          |           |                  |          ||
|| DN_FBUF  |  valid    |   chid   |    fid    |   sid    |   dcnt    |        -         |   buf_id ||
||          |           |          |           |          |           |                  |          ||
|| DN_FBUF  |  valid    |   chid   |      -    |     -    |    -      |        -         |   buf_id ||
||          |           |          |           |          |           |                  |          ||
|| DN_FBUF  |  valid    |   chid   |    fid    |   sid    |   dcnt    |   address[63:8]  |   buf_id ||
====================================================================================================*/

endmodule
