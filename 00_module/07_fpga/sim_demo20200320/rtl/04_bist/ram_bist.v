// =================================================================================================
// File Name      : ram_bist.v
// Module         : RAM_BIST
// Function       : RAM_BIST module
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

module RAM_BIST (
    //system signals
    input                               USER_CLK                                ,//(i)  [  1]
    input                               USER_RST                                ,//(i)  [  1]
    //BRAM
    input                               RAM_RD_REQ                              ,//(i)  [  1]
    input       [  15:0]                RAM_RD_ADDR                             ,//(i)  [ 16]
    input       [  15:0]                RAM_RD_SIZE                             ,//(i)  [ 16]
    input       [  15:0]                RAM_RD_BSEL                             ,//(i)  [ 16]
    input                               RAM_RD_RDY                              ,//(i)  [  1]
    output                              RAM_RD_SOP                              ,//(o)  [  1]
    output                              RAM_RD_EOP                              ,//(o)  [  1]
    output                              RAM_RD_DVLD                             ,//(o)  [  1]
    output      [  63:0]                RAM_RD_DATA                             ,//(o)  [ 64]

    input                               RAM_WR_REQ                              ,//(i)  [  1]
    input       [  15:0]                RAM_WR_ADDR                             ,//(i)  [ 16]
    input       [  15:0]                RAM_WR_SIZE                             ,//(i)  [ 16]
    input       [  15:0]                RAM_WR_BSEL                             ,//(i)  [ 16]
    input       [  63:0]                RAM_WR_DATA                             ,//(i)  [ 64]
    input                               RAM_WR_DVLD                             ,//(i)  [  1]
    input                               RAM_WR_SOP                              ,//(i)  [  1]
    input                               RAM_WR_EOP                               //(i)  [  1]
    );

// ==============================================================================
// Internal Signal Declare
// ==============================================================================

    reg         [   7:0]                r_BRAM_WADR                             ;//(r)  [  8]
    reg                                 r_BRAM_WEN                              ;//(r)  [  1]
    reg         [  63:0]                r_BRAM_WDT                              ;//(r)  [ 64]
    wire        [  63:0]                s_BRAM_RDT                              ;//(s)  [ 64]
    reg         [   7:0]                r_BRAM_RCNT                             ;//(r)  [  8]
    wire                                s_BRAM_RSOP                             ;//(s)  [  1]
    wire                                s_BRAM_REOP                             ;//(s)  [  1]
    wire                                s_BRAM_REN                              ;//(s)  [  1]
    reg                                 r_BRAM_RSOP                             ;//(r)  [  1]
    reg                                 r_BRAM_REOP                             ;//(r)  [  1]
    reg                                 r_BRAM_REN                              ;//(r)  [  1]
    reg         [   7:0]                r_BRAM_RADR                             ;//(r)  [  8]

    reg                                 r_RAM_RD_SOP                            ;//(r)  [  1]
    reg                                 r_RAM_RD_EOP                            ;//(r)  [  1]
    reg                                 r_RAM_RD_DVLD                           ;//(r)  [  1]
    reg         [  63:0]                r_RAM_RD_DATA                           ;//(r)  [ 64]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Output Port                                    ||
||                                                                             ||
/+=============================================================================*/

    assign  RAM_RD_SOP                  = r_RAM_RD_SOP                          ;
    assign  RAM_RD_EOP                  = r_RAM_RD_EOP                          ;
    assign  RAM_RD_DVLD                 = r_RAM_RD_DVLD                         ;
    assign  RAM_RD_DATA                 = r_RAM_RD_DATA                         ;

/*=============================================================================+/
||                                                                             ||
||                            RAM Write Control                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_BRAM_WADR                 <= 'b0 ;
        end else begin
            if (RAM_WR_REQ & RAM_WR_BSEL[0]) begin
                r_BRAM_WADR             <= RAM_WR_ADDR[7:0] ;
            end else if (r_BRAM_WEN) begin
                r_BRAM_WADR             <= r_BRAM_WADR + 1'b1 ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_BRAM_WEN                  <= 'b0 ;
            r_BRAM_WDT                  <= 'b0 ;
        end else begin
            r_BRAM_WEN                  <= RAM_WR_DVLD & RAM_WR_BSEL[0] ;
            r_BRAM_WDT                  <= RAM_WR_DATA                  ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                                      BRAM                                   ||
||                                                                             ||
/+=============================================================================*/

    sram_i64o64_d256 U_BIST_BRAM (
        .clka                           ( USER_CLK          ),
        .wea                            ( r_BRAM_WEN        ),
        .addra                          ( r_BRAM_WADR       ),
        .dina                           ( r_BRAM_WDT        ),
        .clkb                           ( USER_CLK          ),
        .rstb                           ( USER_RST          ),
        .addrb                          ( r_BRAM_RADR       ),
        .doutb                          ( s_BRAM_RDT        )
        );

/*=============================================================================+/
||                                                                             ||
||                            RAM Write Control                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_BRAM_RCNT                 <= 'b0 ;
        end else begin
            if (RAM_RD_REQ & RAM_RD_BSEL[0]) begin
                r_BRAM_RCNT             <= RAM_RD_SIZE[10:3] ;
            end else if (r_BRAM_RCNT != 8'd0) begin
                r_BRAM_RCNT             <= r_BRAM_RCNT - 1'b1 ;
            end
        end
    end

    assign s_BRAM_REN                   = (r_BRAM_RCNT != 8'd0             ) ? 1'b1 : 1'b0 ;
    assign s_BRAM_RSOP                  = (r_BRAM_RCNT == RAM_RD_SIZE[10:3]) ? 1'b1 : 1'b0 ;
    assign s_BRAM_REOP                  = (r_BRAM_RCNT == 8'd1             ) ? 1'b1 : 1'b0 ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_BRAM_REN                  <= 'b0 ;
            r_BRAM_RSOP                 <= 'b0 ;
            r_BRAM_REOP                 <= 'b0 ;
        end else begin
            r_BRAM_REN                  <= s_BRAM_REN               ;
            r_BRAM_RSOP                 <= s_BRAM_REN & s_BRAM_RSOP ;
            r_BRAM_REOP                 <= s_BRAM_REN & s_BRAM_REOP ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_BRAM_RADR                 <= 'b0 ;
        end else begin
            if (RAM_RD_REQ & RAM_RD_BSEL[0]) begin
                r_BRAM_RADR             <= RAM_RD_ADDR[7:0] ;
            end else if (s_BRAM_REN) begin
                r_BRAM_RADR             <= r_BRAM_RADR + 1'b1 ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_RAM_RD_SOP                <= 'b0 ;
            r_RAM_RD_EOP                <= 'b0 ;
            r_RAM_RD_DVLD               <= 'b0 ;
            r_RAM_RD_DATA               <= 'b0 ;
        end else begin
            r_RAM_RD_SOP                <= r_BRAM_RSOP ;
            r_RAM_RD_EOP                <= r_BRAM_REOP ;
            r_RAM_RD_DVLD               <= r_BRAM_REN  ;
            r_RAM_RD_DATA               <= s_BRAM_RDT  ;
        end
    end

endmodule
