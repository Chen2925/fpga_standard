// =================================================================================================
// File Name        : pcie_dn_reg.v
// Module           : PCIE_DN_REG
// Function         : Dnload Manage Register control
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

module PCIE_DN_REG (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    //register interface
    input                               REG_WR_REQ                              ,//(i)  [  1]
    input                               REG_RD_REQ                              ,//(i)  [  1]
    output                              REG_WR_ACK                              ,//(o)  [  1]
    output                              REG_RD_ACK                              ,//(o)  [  1]
    input       [  31:0]                REG_WR_DATA                             ,//(i)  [ 32]
    output      [  31:0]                REG_RD_DATA                             ,//(o)  [ 32]
    input       [  15:0]                REG_OP_ADDR                             ,//(i)  [ 16]
    //full buffer
    output                              DN0_EBUF_WR_TRIG                        ,//(o)  [  1]
    output      [  63:0]                DN0_EBUF_WR_ADDR                        ,//(o)  [ 64]
    output      [  23:0]                DN0_EBUF_WR_SIZE                        ,//(o)  [ 24]

    output                              DN1_EBUF_WR_TRIG                        ,//(o)  [  1]
    output      [  63:0]                DN1_EBUF_WR_ADDR                        ,//(o)  [ 64]
    output      [  23:0]                DN1_EBUF_WR_SIZE                        ,//(o)  [ 24]
    //empty buffer
    output                              DN0_FBUF_RD_REQ                          ,//(o)  [  1]
    output                              DN0_FBUF_RD_TRIG                         ,//(o)  [  1]
    output      [  63:0]                DN0_FBUF_RD_ADDR                         ,//(o)  [ 64]
    output      [  23:0]                DN0_FBUF_RD_SIZE                         ,//(o)  [ 24]
    output                              DN0_FBUF_RD_AUTO                         ,//(o)  [  1]
    input       [   8:0]                DN0_FBUF_WR_DCNT                         ,//(i)  [  9]

    output                              DN1_FBUF_RD_REQ                          ,//(o)  [  1]
    output                              DN1_FBUF_RD_TRIG                         ,//(o)  [  1]
    output      [  63:0]                DN1_FBUF_RD_ADDR                         ,//(o)  [ 64]
    output      [  23:0]                DN1_FBUF_RD_SIZE                         ,//(o)  [ 24]
    output                              DN1_FBUF_RD_AUTO                         ,//(o)  [  1]
    input       [   8:0]                DN1_FBUF_WR_DCNT                          //(i)  [  9]
    );

// =============================================================================
// Prameter define
// =============================================================================

    localparam  p_GND                   = 32'h00000000                          ;//(p)  [ 32]
    localparam  p_PWR                   = 32'hFFFFFFFF                          ;//(p)  [ 32]

    localparam  p_ADD_DN0_FB0           = 16'h0000                              ;//(p)  [ 16]
    localparam  p_ADD_DN0_FB1           = 16'h0008                              ;//(p)  [ 16]
    localparam  p_ADD_DN0_FB2           = 16'h0010                              ;//(p)  [ 16]
    localparam  p_ADD_DN0_FB3           = 16'h0018                              ;//(p)  [ 16]
    localparam  p_ADD_DN0_EB0           = 16'h0100                              ;//(p)  [ 16]
    localparam  p_ADD_DN0_EB1           = 16'h0108                              ;//(p)  [ 16]
    localparam  p_ADD_DN0_EB2           = 16'h0110                              ;//(p)  [ 16]

    localparam  p_ADD_DN1_FB0           = 16'h1000                              ;//(p)  [ 16]
    localparam  p_ADD_DN1_FB1           = 16'h1008                              ;//(p)  [ 16]
    localparam  p_ADD_DN1_FB2           = 16'h1010                              ;//(p)  [ 16]
    localparam  p_ADD_DN1_FB3           = 16'h1018                              ;//(p)  [ 16]
    localparam  p_ADD_DN1_EB0           = 16'h1100                              ;//(p)  [ 16]
    localparam  p_ADD_DN1_EB1           = 16'h1108                              ;//(p)  [ 16]
    localparam  p_ADD_DN1_EB2           = 16'h1110                              ;//(p)  [ 16]

// =============================================================================
// Internal signal define
// =============================================================================

    //command signals
    reg                                 r_REG_WEN                               ;//(r)  [  1]
    reg                                 r_REG_REN                               ;//(r)  [  1]
    reg         [  15:0]                r_REG_ADR                               ;//(r)  [ 16]
    reg         [  31:0]                r_REG_WDT                               ;//(r)  [ 32]
    //register
    reg                                 r_DN0_FBUF_RD_REQ                       ;//(r)  [  1]
    reg                                 r_DN0_FBUF_RD_TRIG                      ;//(r)  [  1]
    reg         [  63:0]                r_DN0_FBUF_RD_ADDR                      ;//(r)  [ 64]
    reg         [  23:0]                r_DN0_FBUF_RD_SIZE                      ;//(r)  [ 24]
    reg                                 r_DN0_FBUF_RD_AUTO                      ;//(r)  [  1]
    reg         [   8:0]                r_DN0_FBUF_WR_DCNT                      ;//(r)  [  9]

    reg                                 r_DN1_FBUF_RD_REQ                       ;//(r)  [  1]
    reg                                 r_DN1_FBUF_RD_TRIG                      ;//(r)  [  1]
    reg         [  63:0]                r_DN1_FBUF_RD_ADDR                      ;//(r)  [ 64]
    reg         [  23:0]                r_DN1_FBUF_RD_SIZE                      ;//(r)  [ 24]
    reg                                 r_DN1_FBUF_RD_AUTO                      ;//(r)  [  1]
    reg         [   8:0]                r_DN1_FBUF_WR_DCNT                      ;//(r)  [  9]

    reg                                 r_DN0_EBUF_WR_TRIG                      ;//(r)  [  1]
    reg         [  63:0]                r_DN0_EBUF_WR_ADDR                      ;//(r)  [ 64]
    reg         [  23:0]                r_DN0_EBUF_WR_SIZE                      ;//(r)  [ 24]

    reg                                 r_DN1_EBUF_WR_TRIG                      ;//(r)  [  1]
    reg         [  63:0]                r_DN1_EBUF_WR_ADDR                      ;//(r)  [ 64]
    reg         [  23:0]                r_DN1_EBUF_WR_SIZE                      ;//(r)  [ 24]
    //register select
    wire                                s_REG_DN0_FB0_EN                        ;//(s)  [  1]
    wire                                s_REG_DN0_FB1_EN                        ;//(s)  [  1]
    wire                                s_REG_DN0_FB2_EN                        ;//(s)  [  1]
    wire                                s_REG_DN0_FB3_EN                        ;//(s)  [  1]
    wire                                s_REG_DN0_EB0_EN                        ;//(s)  [  1]
    wire                                s_REG_DN0_EB1_EN                        ;//(s)  [  1]
    wire                                s_REG_DN0_EB2_EN                        ;//(s)  [  1]

    wire                                s_REG_DN1_FB0_EN                        ;//(s)  [  1]
    wire                                s_REG_DN1_FB1_EN                        ;//(s)  [  1]
    wire                                s_REG_DN1_FB2_EN                        ;//(s)  [  1]
    wire                                s_REG_DN1_FB3_EN                        ;//(s)  [  1]
    wire                                s_REG_DN1_EB0_EN                        ;//(s)  [  1]
    wire                                s_REG_DN1_EB1_EN                        ;//(s)  [  1]
    wire                                s_REG_DN1_EB2_EN                        ;//(s)  [  1]
    //register read control
    reg         [   3:0]                r_REG_REN_SHFT                          ;//(r)  [  4]
    wire        [  31:0]                s_REG_RD_DATA                           ;//(s)  [ 32]
    reg         [  31:0]                r_REG_RD_DATA                           ;//(r)  [ 32]
    reg                                 r_REG_WR_ACK                            ;//(r)  [  1]
    reg                                 r_REG_RD_ACK                            ;//(r)  [  1]

// =================================================================================================
// RTL Body
// =================================================================================================

/*============================================================================+/
||                                                                            ||
||                              Output Ports                                  ||
||                                                                            ||
/+============================================================================*/

     assign  REG_WR_ACK                 = r_REG_WR_ACK                          ;
     assign  REG_RD_ACK                 = r_REG_RD_ACK                          ;
     assign  REG_RD_DATA                = r_REG_RD_DATA                         ;

     assign  DN0_FBUF_RD_REQ            = r_DN0_FBUF_RD_REQ                     ;
     assign  DN0_FBUF_RD_TRIG           = r_DN0_FBUF_RD_TRIG                    ;
     assign  DN0_FBUF_RD_ADDR           = r_DN0_FBUF_RD_ADDR                    ;
     assign  DN0_FBUF_RD_SIZE           = r_DN0_FBUF_RD_SIZE                    ;
     assign  DN0_FBUF_RD_AUTO           = r_DN0_FBUF_RD_AUTO                    ;

     assign  DN1_FBUF_RD_REQ            = r_DN1_FBUF_RD_REQ                     ;
     assign  DN1_FBUF_RD_TRIG           = r_DN1_FBUF_RD_TRIG                    ;
     assign  DN1_FBUF_RD_ADDR           = r_DN1_FBUF_RD_ADDR                    ;
     assign  DN1_FBUF_RD_SIZE           = r_DN1_FBUF_RD_SIZE                    ;
     assign  DN1_FBUF_RD_AUTO           = r_DN1_FBUF_RD_AUTO                    ;

     assign  DN0_EBUF_WR_TRIG           = r_DN0_EBUF_WR_TRIG                    ;
     assign  DN0_EBUF_WR_ADDR           = r_DN0_EBUF_WR_ADDR                    ;
     assign  DN0_EBUF_WR_SIZE           = r_DN0_EBUF_WR_SIZE                    ;

     assign  DN1_EBUF_WR_TRIG           = r_DN1_EBUF_WR_TRIG                    ;
     assign  DN1_EBUF_WR_ADDR           = r_DN1_EBUF_WR_ADDR                    ;
     assign  DN1_EBUF_WR_SIZE           = r_DN1_EBUF_WR_SIZE                    ;

/*============================================================================+/
||                                                                            ||
||                                  IFF                                       ||
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

    assign s_REG_DN0_FB0_EN             = (r_REG_ADR == p_ADD_DN0_FB0) ? 1'b1 : 1'b0 ;
    assign s_REG_DN0_FB1_EN             = (r_REG_ADR == p_ADD_DN0_FB1) ? 1'b1 : 1'b0 ;
    assign s_REG_DN0_FB2_EN             = (r_REG_ADR == p_ADD_DN0_FB2) ? 1'b1 : 1'b0 ;
    assign s_REG_DN0_FB3_EN             = (r_REG_ADR == p_ADD_DN0_FB3) ? 1'b1 : 1'b0 ;
    assign s_REG_DN0_EB0_EN             = (r_REG_ADR == p_ADD_DN0_EB0) ? 1'b1 : 1'b0 ;
    assign s_REG_DN0_EB1_EN             = (r_REG_ADR == p_ADD_DN0_EB1) ? 1'b1 : 1'b0 ;
    assign s_REG_DN0_EB2_EN             = (r_REG_ADR == p_ADD_DN0_EB2) ? 1'b1 : 1'b0 ;

    assign s_REG_DN1_FB0_EN             = (r_REG_ADR == p_ADD_DN1_FB0) ? 1'b1 : 1'b0 ;
    assign s_REG_DN1_FB1_EN             = (r_REG_ADR == p_ADD_DN1_FB1) ? 1'b1 : 1'b0 ;
    assign s_REG_DN1_FB2_EN             = (r_REG_ADR == p_ADD_DN1_FB2) ? 1'b1 : 1'b0 ;
    assign s_REG_DN1_FB3_EN             = (r_REG_ADR == p_ADD_DN1_FB3) ? 1'b1 : 1'b0 ;
    assign s_REG_DN1_EB0_EN             = (r_REG_ADR == p_ADD_DN1_EB0) ? 1'b1 : 1'b0 ;
    assign s_REG_DN1_EB1_EN             = (r_REG_ADR == p_ADD_DN1_EB1) ? 1'b1 : 1'b0 ;
    assign s_REG_DN1_EB2_EN             = (r_REG_ADR == p_ADD_DN1_EB2) ? 1'b1 : 1'b0 ;

/*============================================================================+/
||                                                                            ||
||                        Register Write Control                              ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN0_FBUF_RD_ADDR          <= 'b0 ;
            r_DN0_FBUF_RD_SIZE          <= 'b0 ;
            r_DN0_FBUF_RD_AUTO          <= 'b0 ;

            r_DN1_FBUF_RD_ADDR          <= 'b0 ;
            r_DN1_FBUF_RD_SIZE          <= 'b0 ;
            r_DN1_FBUF_RD_AUTO          <= 'b0 ;
        end else begin
            if (r_REG_WEN & s_REG_DN0_FB0_EN)     begin  r_DN0_FBUF_RD_ADDR[31: 0]  <= r_REG_WDT[31:0] ; end
            if (r_REG_WEN & s_REG_DN0_FB1_EN)     begin  r_DN0_FBUF_RD_ADDR[63:32]  <= r_REG_WDT[31:0] ; end
            if (r_REG_WEN & s_REG_DN0_FB2_EN)     begin  r_DN0_FBUF_RD_SIZE[23: 0]  <= r_REG_WDT[23:0] ; end
            if (r_REG_WEN & s_REG_DN0_FB2_EN)     begin  r_DN0_FBUF_RD_AUTO         <= r_REG_WDT[26]   ; end

            if (r_REG_WEN & s_REG_DN1_FB0_EN)     begin  r_DN1_FBUF_RD_ADDR[31: 0]  <= r_REG_WDT[31:0] ; end
            if (r_REG_WEN & s_REG_DN1_FB1_EN)     begin  r_DN1_FBUF_RD_ADDR[63:32]  <= r_REG_WDT[31:0] ; end
            if (r_REG_WEN & s_REG_DN1_FB2_EN)     begin  r_DN1_FBUF_RD_SIZE[23: 0]  <= r_REG_WDT[23:0] ; end
            if (r_REG_WEN & s_REG_DN1_FB2_EN)     begin  r_DN1_FBUF_RD_AUTO         <= r_REG_WDT[26]   ; end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN0_FBUF_RD_REQ           <= 'b0 ;
            r_DN0_FBUF_RD_TRIG          <= 'b0 ;

            r_DN1_FBUF_RD_REQ           <= 'b0 ;
            r_DN1_FBUF_RD_TRIG          <= 'b0 ;
        end else begin
            r_DN0_FBUF_RD_REQ           <= r_REG_WEN & s_REG_DN0_FB2_EN & r_REG_WDT[25] ;
            r_DN0_FBUF_RD_TRIG          <= r_REG_WEN & s_REG_DN0_FB2_EN & r_REG_WDT[24] ;

            r_DN1_FBUF_RD_REQ           <= r_REG_WEN & s_REG_DN1_FB2_EN & r_REG_WDT[25] ;
            r_DN1_FBUF_RD_TRIG          <= r_REG_WEN & s_REG_DN1_FB2_EN & r_REG_WDT[24] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN0_FBUF_WR_DCNT          <= 'b0 ;
            r_DN1_FBUF_WR_DCNT          <= 'b0 ;
        end else begin
            r_DN0_FBUF_WR_DCNT          <= DN0_FBUF_WR_DCNT ;
            r_DN1_FBUF_WR_DCNT          <= DN1_FBUF_WR_DCNT ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN0_EBUF_WR_ADDR           <= 'b0 ;
            r_DN0_EBUF_WR_SIZE           <= 'b0 ;

            r_DN1_EBUF_WR_ADDR           <= 'b0 ;
            r_DN1_EBUF_WR_SIZE           <= 'b0 ;
        end else begin
            if (r_REG_WEN & s_REG_DN0_EB0_EN)     begin  r_DN0_EBUF_WR_ADDR[31: 0]  <= r_REG_WDT[31:0] ; end
            if (r_REG_WEN & s_REG_DN0_EB1_EN)     begin  r_DN0_EBUF_WR_ADDR[63:32]  <= r_REG_WDT[31:0] ; end
            if (r_REG_WEN & s_REG_DN0_EB2_EN)     begin  r_DN0_EBUF_WR_SIZE[23: 0]  <= r_REG_WDT[23:0] ; end

            if (r_REG_WEN & s_REG_DN1_EB0_EN)     begin  r_DN1_EBUF_WR_ADDR[31: 0]  <= r_REG_WDT[31:0] ; end
            if (r_REG_WEN & s_REG_DN1_EB1_EN)     begin  r_DN1_EBUF_WR_ADDR[63:32]  <= r_REG_WDT[31:0] ; end
            if (r_REG_WEN & s_REG_DN1_EB2_EN)     begin  r_DN1_EBUF_WR_SIZE[23: 0]  <= r_REG_WDT[23:0] ; end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN0_EBUF_WR_TRIG          <= 'b0 ;
            r_DN1_EBUF_WR_TRIG          <= 'b0 ;
        end else begin
            r_DN0_EBUF_WR_TRIG          <= r_REG_WEN & s_REG_DN0_EB2_EN & r_REG_WDT[24] ;
            r_DN1_EBUF_WR_TRIG          <= r_REG_WEN & s_REG_DN1_EB2_EN & r_REG_WDT[24] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_WR_ACK                <= 'b0 ;
        end else begin
            r_REG_WR_ACK                <= r_REG_WEN ;
        end
    end

/*============================================================================+/
||                                                                            ||
||                           Register Read Control                            ||
||                                                                            ||
/+============================================================================*/

    assign s_REG_RD_DATA                =
                                            (s_REG_DN0_FB0_EN  == 1'b1) ? {               r_DN0_FBUF_RD_ADDR[31: 0] } :
                                            (s_REG_DN0_FB1_EN  == 1'b1) ? {               r_DN0_FBUF_RD_ADDR[63:32] } :
                                            (s_REG_DN0_FB2_EN  == 1'b1) ? { p_GND[ 6:0] , r_DN0_FBUF_RD_AUTO        ,
                                                                                          r_DN0_FBUF_RD_SIZE[23: 0] } :
                                            (s_REG_DN0_FB3_EN  == 1'b1) ? { p_GND[22:0] , r_DN0_FBUF_WR_DCNT[ 8: 0] } :
                                            (s_REG_DN0_EB0_EN  == 1'b1) ? {               r_DN0_EBUF_WR_ADDR[31: 0] } :
                                            (s_REG_DN0_EB1_EN  == 1'b1) ? {               r_DN0_EBUF_WR_ADDR[63:32] } :
                                            (s_REG_DN0_EB2_EN  == 1'b1) ? { p_GND[ 7:0] , r_DN0_EBUF_WR_SIZE[23: 0] } :

                                            (s_REG_DN1_FB0_EN  == 1'b1) ? {               r_DN1_FBUF_RD_ADDR[31: 0] } :
                                            (s_REG_DN1_FB1_EN  == 1'b1) ? {               r_DN1_FBUF_RD_ADDR[63:32] } :
                                            (s_REG_DN1_FB2_EN  == 1'b1) ? { p_GND[ 6:0] , r_DN1_FBUF_RD_AUTO        ,
                                                                                          r_DN1_FBUF_RD_SIZE[23: 0] } :
                                            (s_REG_DN1_FB3_EN  == 1'b1) ? { p_GND[22:0] , r_DN1_FBUF_WR_DCNT[ 8: 0] } :
                                            (s_REG_DN1_EB0_EN  == 1'b1) ? {               r_DN1_EBUF_WR_ADDR[31: 0] } :
                                            (s_REG_DN1_EB1_EN  == 1'b1) ? {               r_DN1_EBUF_WR_ADDR[63:32] } :
                                            (s_REG_DN1_EB2_EN  == 1'b1) ? { p_GND[ 7:0] , r_DN1_EBUF_WR_SIZE[23: 0] } :
                                            p_GND[31:0] ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_RD_DATA               <= 'b0 ;
        end else begin
            r_REG_RD_DATA               <= s_REG_RD_DATA ;
        end
    end

    always @ (posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_REN_SHFT              <= 'b0 ;
        end else begin
            r_REG_REN_SHFT              <= {r_REG_REN_SHFT[2:0],r_REG_REN} ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_REG_RD_ACK                <= 'b0 ;
        end else begin
            r_REG_RD_ACK                <= r_REG_REN_SHFT[3] ;
        end
    end

endmodule