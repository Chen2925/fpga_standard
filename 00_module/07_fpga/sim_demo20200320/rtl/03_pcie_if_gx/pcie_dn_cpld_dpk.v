// =================================================================================================
// File Name      : PCIE_DN_CPLD_DPK.v
// Module         : PCIE_DN_CPLD_DPK
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

module PCIE_DN_CPLD_DPK (
     //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
     //cpld
    input                               DPK_CX_SOP                              ,//(i)  [  1]
    input                               DPK_CX_EOP                              ,//(i)  [  1]
    input       [  63:0]                DPK_CX_DATA                             ,//(i)  [ 64]
    input                               DPK_CX_DVLD                             ,//(i)  [  1]
    input       [   7:0]                DPK_CX_TAG                              ,//(i)  [  8]
    input       [  11:0]                DPK_CX_DCNT                             ,//(i)  [ 12]
     //user if
    output                              DN_CX_SOP                               ,//(o)  [  1]
    output                              DN_CX_EOP                               ,//(o)  [  1]
    output      [  63:0]                DN_CX_DATA                              ,//(o)  [ 64]
    output                              DN_CX_DVLD                               //(o)  [  1]
    );

// =============================================================================
// Parameter Declare
// =============================================================================

    localparam                          P_IDLE   = 3'b001                       ;//(p)  [  3]
    localparam                          P_CHEK   = 3'b010                       ;//(p)  [  3]
    localparam                          P_READ   = 3'b100                       ;//(p)  [  3]

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg         [   7:0]                r_DPK_CX_TAG                            ;//(r)  [  8]
    reg         [  11:0]                r_DPK_CX_DCNT                           ;//(r)  [ 12]
    reg                                 r_DPK_CX_DVLD                           ;//(r)  [  1]
    reg         [  63:0]                r_DPK_CX_DATA                           ;//(r)  [ 64]
    reg                                 r_DPK_CX_SOP                            ;//(r)  [  1]
    wire        [   6:0]                s_PLD_DCNT                              ;//(s)  [  7]

    reg                                 r_DBUF_WEN                              ;//(r)  [  1]
    reg         [  63:0]                r_DBUF_WDT                              ;//(r)  [ 64]
    reg         [   9:0]                r_DBUF_WADR                             ;//(r)  [ 10]
    wire        [  63:0]                s_DBUF_RDT                              ;//(s)  [ 64]
    reg         [  63:0]                r_RD_SHFT                               ;//(r)  [ 64]

    wire        [  63:0]                s_DBUF_SEL                              ;//(s)  [ 64]
    reg         [  63:0]                r_DBUF_SEL                              ;//(r)  [ 64]
    reg         [   4:0]                r_DBUF_DCNT                [63:0]       ;//(r)  [  5]
    wire        [  63:0]                s_DBUF_RRDY                             ;//(s)  [ 64]
    reg         [   2:0]                r_FSM                                   ;//(r)  [  3]
    reg         [  63:0]                r_DBUF_SHFT                             ;//(r)  [ 64]

    wire                                s_FSM_CHEK                              ;//(s)  [  1]
    reg         [  63:0]                r_DBUF_RD                               ;//(r)  [ 64]

    reg         [  15:0]                r_RD_SHFT0                              ;//(r)  [ 16]
    reg         [  15:0]                r_RD_SHFT1                              ;//(r)  [ 16]
    reg         [  15:0]                r_RD_SHFT2                              ;//(r)  [ 16]

    reg         [   9:0]                r_DBUF_RADR                             ;//(r)  [  1]
    reg                                 r_DBUF_REN                              ;//(r)  [  1]
    reg                                 r_DBUF_RSOP                             ;//(r)  [  1]
    reg                                 r_DBUF_REOP                             ;//(r)  [  1]
    reg                                 r_DBUF_REN_DFF                          ;//(r)  [  1]
    reg                                 r_DBUF_RSOP_DFF                         ;//(r)  [  1]
    reg                                 r_DBUF_REOP_DFF                         ;//(r)  [  1]

    reg                                 r_DN_CX_SOP                             ;//(r)  [  1]
    reg                                 r_DN_CX_EOP                             ;//(r)  [  1]
    reg                                 r_DN_CX_DVLD                            ;//(r)  [  1]
    reg         [  63:0]                r_DN_CX_DATA                            ;//(r)  [ 64]

// ==================================================================================================
// RTL Body
// ==================================================================================================

/*============================================================================+/
||                                                                            ||
||                                Output ports                                ||
||                                                                            ||
/+============================================================================*/

    assign  DN_CX_SOP                   = r_DN_CX_SOP                           ;
    assign  DN_CX_EOP                   = r_DN_CX_EOP                           ;
    assign  DN_CX_DATA                  = r_DN_CX_DATA                          ;
    assign  DN_CX_DVLD                  = r_DN_CX_DVLD                          ;

/*=============================================================================+/
||                                                                             ||
||                            Data Buffer Write                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DPK_CX_TAG                <= 'b0 ;
            r_DPK_CX_DCNT               <= 'b0 ;
        end else begin
            if (DPK_CX_SOP) begin
                r_DPK_CX_TAG            <= DPK_CX_TAG  ;
                r_DPK_CX_DCNT           <= DPK_CX_DCNT ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DPK_CX_DVLD               <= 'b0 ;
            r_DPK_CX_DATA               <= 'b0 ;
            r_DPK_CX_SOP                <= 'b0 ;
        end else begin
            r_DPK_CX_DVLD               <= DPK_CX_DVLD ;
            r_DPK_CX_DATA               <= DPK_CX_DATA ;
            r_DPK_CX_SOP                <= DPK_CX_SOP  ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_WEN                  <= 'b0 ;
            r_DBUF_WDT                  <= 'b0 ;
        end else begin
            r_DBUF_WEN                  <= r_DPK_CX_DVLD ;
            r_DBUF_WDT                  <= r_DPK_CX_DATA ;
        end
    end

    assign s_PLD_DCNT                   = 7'h10 - r_DPK_CX_DCNT[9:3] ;  //16*8byte=128byte

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_WADR                 <= 'b0 ;
        end else begin
            if (r_DPK_CX_SOP) begin
                r_DBUF_WADR[9:4]        <= r_DPK_CX_TAG[5:0] ;
                r_DBUF_WADR[3:0]        <= s_PLD_DCNT[3:0]   ;
            end else if (r_DBUF_WEN) begin
                r_DBUF_WADR[3:0]        <= r_DBUF_WADR[3:0] + 1'b1 ;
            end
        end
    end

    //i64o64_d1024
    sram_i64o64_d256 U_DBUF (
        .clka                           ( PCIE_CLK      ),
        .clkb                           ( PCIE_CLK      ),
        .rstb                           ( PCIE_RST      ),
        .wea                            ( r_DBUF_WEN    ),
        .addra                          ( r_DBUF_WADR   ),
        .dina                           ( r_DBUF_WDT    ),

        .addrb                          ( r_DBUF_RADR   ),
        .doutb                          ( s_DBUF_RDT    ),

        .rsta_busy                      ( s_DBUF_RDT    ),
        .rstb_busy                      ( s_DBUF_RDT    )
        );


    genvar i ;
    generate
        for (i=0 ; i<=63 ; i=i+1) begin : GROUP_DBUF

        assign  s_DBUF_SEL[i]           = (r_DPK_CX_TAG[5:0] == i[5:0] ) ? 1'b1 : 1'b0 ;

        always @(posedge PCIE_CLK or posedge PCIE_RST) begin
            if (PCIE_RST) begin
                r_DBUF_SEL[i]           <= 'd0 ;
            end else begin
                r_DBUF_SEL[i]           <= s_DBUF_SEL[i] ;
            end
        end

        always @(posedge PCIE_CLK or posedge PCIE_RST) begin
            if (PCIE_RST) begin
                r_DBUF_DCNT[i]          <= 5'd0 ;
            end else begin
                if (r_DBUF_RD[i] ) begin
                    r_DBUF_DCNT[i]      <= 5'd0 ;
                end else if (r_DBUF_WEN & r_DBUF_SEL[i] ) begin
                    r_DBUF_DCNT[i]      <= r_DBUF_DCNT[i]  + 1'b1 ;
                end
            end
        end

        assign s_DBUF_RRDY[i]           = r_DBUF_SHFT[i] & r_DBUF_DCNT[i][4]  ;

        always @(posedge PCIE_CLK or posedge PCIE_RST) begin
            if (PCIE_RST) begin
                r_DBUF_RD[i]            <= 'b0 ;
            end else begin
                r_DBUF_RD[i]            <= s_DBUF_RRDY[i] & s_FSM_CHEK ;
            end
        end

    end
    endgenerate

/*=============================================================================+/
||                                                                             ||
||                                         FSM                                 ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FSM                       <= P_IDLE ;
        end else begin
            case (r_FSM)
                P_IDLE  :
                    begin
                        r_FSM           <= P_CHEK ;
                    end
                P_CHEK   :
                    begin
                        if (| s_DBUF_RRDY) begin
                            r_FSM       <= P_READ ;
                        end else begin
                            r_FSM       <= P_CHEK ;
                        end
                    end
                P_READ   :
                    begin
                        if (r_DBUF_REOP) begin
                            r_FSM       <= P_CHEK ;
                        end else begin
                            r_FSM       <= P_READ ;
                        end
                    end
                default :
                    begin
                        r_FSM           <= P_IDLE ;
                    end
            endcase
        end
    end

    assign  s_FSM_CHEK                  = r_FSM[1] ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_SHFT                 <= 64'h0000_0000_0000_0001 ;
        end else begin
            if (r_DBUF_REOP) begin
                r_DBUF_SHFT             <= {r_DBUF_SHFT[62:0] , r_DBUF_SHFT[63]} ;
            end
        end
    end

/*=============================================================================+/
||                                                                             ||
||                            Data Buffer Read                                 ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_RD_SHFT0                  <= 'b0 ;
            r_RD_SHFT1                  <= 'b0 ;
            r_RD_SHFT2                  <= 'b0 ;
        end else begin
            if (| r_DBUF_RD) begin
                r_RD_SHFT0              <= 16'hFFFF ;
                r_RD_SHFT1              <= 16'h0001 ;
                r_RD_SHFT2              <= 16'h8000 ;
            end else begin
                r_RD_SHFT0              <= {1'b0 , r_RD_SHFT0[15:1]} ;
                r_RD_SHFT1              <= {1'b0 , r_RD_SHFT1[15:1]} ;
                r_RD_SHFT2              <= {1'b0 , r_RD_SHFT2[15:1]} ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_REN                  <= 'b0 ;
            r_DBUF_RSOP                 <= 'b0 ;
            r_DBUF_REOP                 <= 'b0 ;
        end else begin
            r_DBUF_REN                  <= r_RD_SHFT0[0] ;
            r_DBUF_RSOP                 <= r_RD_SHFT1[0] ;
            r_DBUF_REOP                 <= r_RD_SHFT2[0] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_RADR                 <= 'b0 ;
        end else begin
            r_DBUF_RADR                 <= r_DBUF_RADR + r_DBUF_REN ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_REN_DFF              <= 'b0 ;
            r_DBUF_RSOP_DFF             <= 'b0 ;
            r_DBUF_REOP_DFF             <= 'b0 ;
        end else begin
            r_DBUF_REN_DFF              <= r_DBUF_REN  ;
            r_DBUF_RSOP_DFF             <= r_DBUF_RSOP ;
            r_DBUF_REOP_DFF             <= r_DBUF_REOP ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_CX_SOP                 <= 'b0 ;
            r_DN_CX_EOP                 <= 'b0 ;
            r_DN_CX_DVLD                <= 'b0 ;
            r_DN_CX_DATA                <= 'b0 ;
        end else begin
            r_DN_CX_SOP                 <= r_DBUF_RSOP_DFF ;
            r_DN_CX_EOP                 <= r_DBUF_REOP_DFF ;
            r_DN_CX_DVLD                <= r_DBUF_REN_DFF  ;
            r_DN_CX_DATA                <= s_DBUF_RDT      ;
        end
    end

endmodule
