// =================================================================================================
// File Name      : PCIE_DN_CPLD_IF.v
// Module         : PCIE_DN_CPLD_IF
// Function       : PCIE CPLD receive module
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

module PCIE_DN_CPLD_IF (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    //cpld
    input                               DN_CPLD_SOP                             ,//(i)  [  1]
    input                               DN_CPLD_EOP                             ,//(i)  [  1]
    input       [  63:0]                DN_CPLD_DATA                            ,//(i)  [ 64]
    input                               DN_CPLD_DVLD                            ,//(i)  [  1]
    input       [   7:0]                DN_CPLD_TAG                             ,//(i)  [  8]
    input       [  11:0]                DN_CPLD_DCNT                            ,//(i)  [ 12]
    //user if
    output                              DFK_C0_SOP                              ,//(i)  [  1]
    output                              DFK_C0_EOP                              ,//(i)  [  1]
    output      [  63:0]                DFK_C0_DATA                             ,//(i)  [ 64]
    output                              DFK_C0_DVLD                             ,//(i)  [  1]
    output      [   7:0]                DFK_C0_TAG                              ,//(i)  [  8]
    output      [  11:0]                DFK_C0_DCNT                             ,//(i)  [ 12]

    output                              DFK_C1_SOP                              ,//(i)  [  1]
    output                              DFK_C1_EOP                              ,//(i)  [  1]
    output      [  63:0]                DFK_C1_DATA                             ,//(i)  [ 64]
    output                              DFK_C1_DVLD                             ,//(i)  [  1]
    output      [   7:0]                DFK_C1_TAG                              ,//(i)  [  8]
    output      [  11:0]                DFK_C1_DCNT                             ,//(i)  [ 12]

    output                              UEK_C0_SOP                              ,//(i)  [  1]
    output                              UEK_C0_EOP                              ,//(i)  [  1]
    output      [  63:0]                UEK_C0_DATA                             ,//(i)  [ 64]
    output                              UEK_C0_DVLD                             ,//(i)  [  1]
    output      [   7:0]                UEK_C0_TAG                              ,//(i)  [  8]
    output      [  11:0]                UEK_C0_DCNT                             ,//(i)  [ 12]

    output                              UEK_C1_SOP                              ,//(i)  [  1]
    output                              UEK_C1_EOP                              ,//(i)  [  1]
    output      [  63:0]                UEK_C1_DATA                             ,//(i)  [ 64]
    output                              UEK_C1_DVLD                             ,//(i)  [  1]
    output      [   7:0]                UEK_C1_TAG                              ,//(i)  [  8]
    output      [  11:0]                UEK_C1_DCNT                             ,//(i)  [ 12]

    output                              DPK_C0_SOP                              ,//(i)  [  1]
    output                              DPK_C0_EOP                              ,//(i)  [  1]
    output      [  63:0]                DPK_C0_DATA                             ,//(i)  [ 64]
    output                              DPK_C0_DVLD                             ,//(i)  [  1]
    output      [   7:0]                DPK_C0_TAG                              ,//(i)  [  8]
    output      [  11:0]                DPK_C0_DCNT                             ,//(i)  [ 12]

    output                              DPK_C1_SOP                              ,//(i)  [  1]
    output                              DPK_C1_EOP                              ,//(i)  [  1]
    output      [  63:0]                DPK_C1_DATA                             ,//(i)  [ 64]
    output                              DPK_C1_DVLD                             ,//(i)  [  1]
    output      [   7:0]                DPK_C1_TAG                              ,//(i)  [  8]
    output      [  11:0]                DPK_C1_DCNT                              //(i)  [ 12]
    );

// ==============================================================================
// Internal Signal Declare
// ==============================================================================

    reg                                 r_DN_CPLD_SOP                           ;//(r)  [  1]
    reg                                 r_DN_CPLD_EOP                           ;//(r)  [  1]
    reg         [  63:0]                r_DN_CPLD_DATA                          ;//(r)  [ 64]
    reg                                 r_DN_CPLD_DVLD                          ;//(r)  [  1]
    reg         [   7:0]                r_DN_CPLD_TAG                           ;//(r)  [  1]
    reg         [  11:0]                r_DN_CPLD_DCNT                          ;//(r)  [  1]

    reg                                 r_DFK_C0_SEL                            ;//(r)  [  1]
    reg                                 r_DFK_C1_SEL                            ;//(r)  [  1]
    reg                                 r_UEK_C0_SEL                            ;//(r)  [  1]
    reg                                 r_UEK_C1_SEL                            ;//(r)  [  1]
    reg                                 r_DPK_C0_SEL                            ;//(r)  [  1]
    reg                                 r_DPK_C1_SEL                            ;//(r)  [  1]

    reg                                 r_DFK_C0_SOP                            ;//(r)  [  1]
    reg                                 r_DFK_C0_EOP                            ;//(r)  [  1]
    reg         [  63:0]                r_DFK_C0_DATA                           ;//(r)  [ 64]
    reg                                 r_DFK_C0_DVLD                           ;//(r)  [  1]
    reg         [   7:0]                r_DFK_C0_TAG                            ;//(r)  [  1]
    reg         [  11:0]                r_DFK_C0_DCNT                           ;//(r)  [  1]

    reg                                 r_DFK_C1_SOP                            ;//(r)  [  1]
    reg                                 r_DFK_C1_EOP                            ;//(r)  [  1]
    reg         [  63:0]                r_DFK_C1_DATA                           ;//(r)  [ 64]
    reg                                 r_DFK_C1_DVLD                           ;//(r)  [  1]
    reg         [   7:0]                r_DFK_C1_TAG                            ;//(r)  [  1]
    reg         [  11:0]                r_DFK_C1_DCNT                           ;//(r)  [  1]

    reg                                 r_UEK_C0_SOP                            ;//(r)  [  1]
    reg                                 r_UEK_C0_EOP                            ;//(r)  [  1]
    reg         [  63:0]                r_UEK_C0_DATA                           ;//(r)  [ 64]
    reg                                 r_UEK_C0_DVLD                           ;//(r)  [  1]
    reg         [   7:0]                r_UEK_C0_TAG                            ;//(r)  [  1]
    reg         [  11:0]                r_UEK_C0_DCNT                           ;//(r)  [  1]

    reg                                 r_UEK_C1_SOP                            ;//(r)  [  1]
    reg                                 r_UEK_C1_EOP                            ;//(r)  [  1]
    reg         [  63:0]                r_UEK_C1_DATA                           ;//(r)  [ 64]
    reg                                 r_UEK_C1_DVLD                           ;//(r)  [  1]
    reg         [   7:0]                r_UEK_C1_TAG                            ;//(r)  [  1]
    reg         [  11:0]                r_UEK_C1_DCNT                           ;//(r)  [  1]

    reg                                 r_DPK_C0_SOP                            ;//(r)  [  1]
    reg                                 r_DPK_C0_EOP                            ;//(r)  [  1]
    reg         [  63:0]                r_DPK_C0_DATA                           ;//(r)  [ 64]
    reg                                 r_DPK_C0_DVLD                           ;//(r)  [  1]
    reg         [   7:0]                r_DPK_C0_TAG                            ;//(r)  [  1]
    reg         [  11:0]                r_DPK_C0_DCNT                           ;//(r)  [  1]

    reg                                 r_DPK_C1_SOP                            ;//(r)  [  1]
    reg                                 r_DPK_C1_EOP                            ;//(r)  [  1]
    reg         [  63:0]                r_DPK_C1_DATA                           ;//(r)  [ 64]
    reg                                 r_DPK_C1_DVLD                           ;//(r)  [  1]
    reg         [   7:0]                r_DPK_C1_TAG                            ;//(r)  [  1]
    reg         [  11:0]                r_DPK_C1_DCNT                           ;//(r)  [  1]

// ==================================================================================================
// RTL Body
// ==================================================================================================

/*=============================================================================+/
||                                                                             ||
||                                 Output ports                                ||
||                                                                             ||
/+=============================================================================*/

    assign  DFK_C0_SOP                  = r_DFK_C0_SOP                          ;
    assign  DFK_C0_EOP                  = r_DFK_C0_EOP                          ;
    assign  DFK_C0_DATA                 = r_DFK_C0_DATA                         ;
    assign  DFK_C0_DVLD                 = r_DFK_C0_DVLD                         ;
    assign  DFK_C0_TAG                  = r_DFK_C0_TAG                          ;
    assign  DFK_C0_DCNT                 = r_DFK_C0_DCNT                         ;

    assign  DFK_C1_SOP                  = r_DFK_C1_SOP                          ;
    assign  DFK_C1_EOP                  = r_DFK_C1_EOP                          ;
    assign  DFK_C1_DATA                 = r_DFK_C1_DATA                         ;
    assign  DFK_C1_DVLD                 = r_DFK_C1_DVLD                         ;
    assign  DFK_C1_TAG                  = r_DFK_C1_TAG                          ;
    assign  DFK_C1_DCNT                 = r_DFK_C1_DCNT                         ;

    assign  UEK_C0_SOP                  = r_UEK_C0_SOP                          ;
    assign  UEK_C0_EOP                  = r_UEK_C0_EOP                          ;
    assign  UEK_C0_DATA                 = r_UEK_C0_DATA                         ;
    assign  UEK_C0_DVLD                 = r_UEK_C0_DVLD                         ;
    assign  UEK_C0_TAG                  = r_UEK_C0_TAG                          ;
    assign  UEK_C0_DCNT                 = r_UEK_C0_DCNT                         ;

    assign  UEK_C1_SOP                  = r_UEK_C1_SOP                          ;
    assign  UEK_C1_EOP                  = r_UEK_C1_EOP                          ;
    assign  UEK_C1_DATA                 = r_UEK_C1_DATA                         ;
    assign  UEK_C1_DVLD                 = r_UEK_C1_DVLD                         ;
    assign  UEK_C1_TAG                  = r_UEK_C1_TAG                          ;
    assign  UEK_C1_DCNT                 = r_UEK_C1_DCNT                         ;

    assign  DPK_C0_SOP                  = r_DPK_C0_SOP                          ;
    assign  DPK_C0_EOP                  = r_DPK_C0_EOP                          ;
    assign  DPK_C0_DATA                 = r_DPK_C0_DATA                         ;
    assign  DPK_C0_DVLD                 = r_DPK_C0_DVLD                         ;
    assign  DPK_C0_TAG                  = r_DPK_C0_TAG                          ;
    assign  DPK_C0_DCNT                 = r_DPK_C0_DCNT                         ;

    assign  DPK_C1_SOP                  = r_DPK_C1_SOP                          ;
    assign  DPK_C1_EOP                  = r_DPK_C1_EOP                          ;
    assign  DPK_C1_DATA                 = r_DPK_C1_DATA                         ;
    assign  DPK_C1_DVLD                 = r_DPK_C1_DVLD                         ;
    assign  DPK_C1_TAG                  = r_DPK_C1_TAG                          ;
    assign  DPK_C1_DCNT                 = r_DPK_C1_DCNT                         ;

/*=============================================================================+/
||                                                                             ||
||                            Channel Data Select                              ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_CPLD_SOP               <= 'b0 ;
            r_DN_CPLD_EOP               <= 'b0 ;
            r_DN_CPLD_DATA              <= 'b0 ;
            r_DN_CPLD_DVLD              <= 'b0 ;
            r_DN_CPLD_TAG               <= 'b0 ;
            r_DN_CPLD_DCNT              <= 'b0 ;
        end else begin
            r_DN_CPLD_SOP               <= DN_CPLD_SOP  ;
            r_DN_CPLD_EOP               <= DN_CPLD_EOP  ;

            r_DN_CPLD_DATA[63:56]       <= DN_CPLD_DATA[39:32] ;
            r_DN_CPLD_DATA[55:48]       <= DN_CPLD_DATA[47:40] ;
            r_DN_CPLD_DATA[47:40]       <= DN_CPLD_DATA[55:48] ;
            r_DN_CPLD_DATA[39:32]       <= DN_CPLD_DATA[63:56] ;

            r_DN_CPLD_DATA[31:24]       <= DN_CPLD_DATA[ 7: 0] ;
            r_DN_CPLD_DATA[23:16]       <= DN_CPLD_DATA[15: 8] ;
            r_DN_CPLD_DATA[15: 8]       <= DN_CPLD_DATA[23:16] ;
            r_DN_CPLD_DATA[ 7: 0]       <= DN_CPLD_DATA[31:24] ;

            r_DN_CPLD_DVLD              <= DN_CPLD_DVLD ;
            r_DN_CPLD_TAG               <= DN_CPLD_TAG  ;
            r_DN_CPLD_DCNT              <= DN_CPLD_DCNT ;
        end
    end

    // UEK  RD_REQ  TAG = 0Y100XXX
    // UFK  WR_REQ  TAG = 0Y101XXX
    // DEK  WR_REQ  TAG = 0Y110XXX
    // DFK  RD_REQ  TAG = 0Y111XXX
    // UPK  WR_REQ  TAG = 0Y0XXXXX
    // DPK  RD_REQ  TAG = 1YXXXXXX

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_C0_SEL                <= 'b0 ;
            r_DFK_C1_SEL                <= 'b0 ;
            r_UEK_C0_SEL                <= 'b0 ;
            r_UEK_C1_SEL                <= 'b0 ;
            r_DPK_C0_SEL                <= 'b0 ;
            r_DPK_C1_SEL                <= 'b0 ;
        end else begin
            if (DN_CPLD_SOP)            r_DFK_C0_SEL <= (~DN_CPLD_TAG[7]) & (~DN_CPLD_TAG[6]) & ( DN_CPLD_TAG[4]) ; // TAG[7:0] == 8'b0011XXXX
            if (DN_CPLD_SOP)            r_DFK_C1_SEL <= (~DN_CPLD_TAG[7]) & ( DN_CPLD_TAG[6]) & ( DN_CPLD_TAG[4]) ; // TAG[7:0] == 8'b0111XXXX
            if (DN_CPLD_SOP)            r_UEK_C0_SEL <= (~DN_CPLD_TAG[7]) & (~DN_CPLD_TAG[6]) & (~DN_CPLD_TAG[4]) ; // TAG[7:0] == 8'b0010XXXX
            if (DN_CPLD_SOP)            r_UEK_C1_SEL <= (~DN_CPLD_TAG[7]) & ( DN_CPLD_TAG[6]) & (~DN_CPLD_TAG[4]) ; // TAG[7:0] == 8'b0110XXXX
            if (DN_CPLD_SOP)            r_DPK_C0_SEL <= ( DN_CPLD_TAG[7]) & (~DN_CPLD_TAG[6])                     ; // TAG[7:0] == 8'b10XXXXXX
            if (DN_CPLD_SOP)            r_DPK_C1_SEL <= ( DN_CPLD_TAG[7]) & ( DN_CPLD_TAG[6])                     ; // TAG[7:0] == 8'b11XXXXXX
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_C0_SOP                <= 'b0 ;
            r_DFK_C0_EOP                <= 'b0 ;
            r_DFK_C0_DATA               <= 'b0 ;
            r_DFK_C0_DVLD               <= 'b0 ;
            r_DFK_C0_TAG                <= 'b0 ;
            r_DFK_C0_DCNT               <= 'b0 ;

            r_DFK_C1_SOP                <= 'b0 ;
            r_DFK_C1_EOP                <= 'b0 ;
            r_DFK_C1_DATA               <= 'b0 ;
            r_DFK_C1_DVLD               <= 'b0 ;
            r_DFK_C1_TAG                <= 'b0 ;
            r_DFK_C1_DCNT               <= 'b0 ;

            r_UEK_C0_SOP                <= 'b0 ;
            r_UEK_C0_EOP                <= 'b0 ;
            r_UEK_C0_DATA               <= 'b0 ;
            r_UEK_C0_DVLD               <= 'b0 ;
            r_UEK_C0_TAG                <= 'b0 ;
            r_UEK_C0_DCNT               <= 'b0 ;

            r_UEK_C1_SOP                <= 'b0 ;
            r_UEK_C1_EOP                <= 'b0 ;
            r_UEK_C1_DATA               <= 'b0 ;
            r_UEK_C1_DVLD               <= 'b0 ;
            r_UEK_C1_TAG                <= 'b0 ;
            r_UEK_C1_DCNT               <= 'b0 ;

            r_DPK_C0_SOP                <= 'b0 ;
            r_DPK_C0_EOP                <= 'b0 ;
            r_DPK_C0_DATA               <= 'b0 ;
            r_DPK_C0_DVLD               <= 'b0 ;
            r_DPK_C0_TAG                <= 'b0 ;
            r_DPK_C0_DCNT               <= 'b0 ;

            r_DPK_C1_SOP                <= 'b0 ;
            r_DPK_C1_EOP                <= 'b0 ;
            r_DPK_C1_DATA               <= 'b0 ;
            r_DPK_C1_DVLD               <= 'b0 ;
            r_DPK_C1_TAG                <= 'b0 ;
            r_DPK_C1_DCNT               <= 'b0 ;
        end else begin
            r_DFK_C0_SOP                <= r_DN_CPLD_SOP   & r_DFK_C0_SEL ;
            r_DFK_C0_EOP                <= r_DN_CPLD_EOP   & r_DFK_C0_SEL ;
            r_DFK_C0_DATA               <= r_DN_CPLD_DATA                 ;
            r_DFK_C0_DVLD               <= r_DN_CPLD_DVLD  & r_DFK_C0_SEL ;
            r_DFK_C0_TAG                <= r_DN_CPLD_TAG                  ;
            r_DFK_C0_DCNT               <= r_DN_CPLD_DCNT                 ;

            r_DFK_C1_SOP                <= r_DN_CPLD_SOP   & r_DFK_C1_SEL ;
            r_DFK_C1_EOP                <= r_DN_CPLD_EOP   & r_DFK_C1_SEL ;
            r_DFK_C1_DATA               <= r_DN_CPLD_DATA                 ;
            r_DFK_C1_DVLD               <= r_DN_CPLD_DVLD  & r_DFK_C1_SEL ;
            r_DFK_C1_TAG                <= r_DN_CPLD_TAG                  ;
            r_DFK_C1_DCNT               <= r_DN_CPLD_DCNT                 ;

            r_UEK_C0_SOP                <= r_DN_CPLD_SOP   & r_UEK_C0_SEL ;
            r_UEK_C0_EOP                <= r_DN_CPLD_EOP   & r_UEK_C0_SEL ;
            r_UEK_C0_DATA               <= r_DN_CPLD_DATA                 ;
            r_UEK_C0_DVLD               <= r_DN_CPLD_DVLD  & r_UEK_C0_SEL ;
            r_UEK_C0_TAG                <= r_DN_CPLD_TAG                  ;
            r_UEK_C0_DCNT               <= r_DN_CPLD_DCNT                 ;

            r_UEK_C1_SOP                <= r_DN_CPLD_SOP   & r_UEK_C1_SEL ;
            r_UEK_C1_EOP                <= r_DN_CPLD_EOP   & r_UEK_C1_SEL ;
            r_UEK_C1_DATA               <= r_DN_CPLD_DATA                 ;
            r_UEK_C1_DVLD               <= r_DN_CPLD_DVLD  & r_UEK_C1_SEL ;
            r_UEK_C1_TAG                <= r_DN_CPLD_TAG                  ;
            r_UEK_C1_DCNT               <= r_DN_CPLD_DCNT                 ;

            r_DPK_C0_SOP                <= r_DN_CPLD_SOP   & r_DPK_C0_SEL ;
            r_DPK_C0_EOP                <= r_DN_CPLD_EOP   & r_DPK_C0_SEL ;
            r_DPK_C0_DATA               <= r_DN_CPLD_DATA                 ;
            r_DPK_C0_DVLD               <= r_DN_CPLD_DVLD  & r_DPK_C0_SEL ;
            r_DPK_C0_TAG                <= r_DN_CPLD_TAG                  ;
            r_DPK_C0_DCNT               <= r_DN_CPLD_DCNT                 ;

            r_DPK_C1_SOP                <= r_DN_CPLD_SOP   & r_DPK_C1_SEL ;
            r_DPK_C1_EOP                <= r_DN_CPLD_EOP   & r_DPK_C1_SEL ;
            r_DPK_C1_DATA               <= r_DN_CPLD_DATA                 ;
            r_DPK_C1_DVLD               <= r_DN_CPLD_DVLD  & r_DPK_C1_SEL ;
            r_DPK_C1_TAG                <= r_DN_CPLD_TAG                  ;
            r_DPK_C1_DCNT               <= r_DN_CPLD_DCNT                 ;
        end
    end

endmodule
