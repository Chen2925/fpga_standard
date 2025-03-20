// =================================================================================================
// File Name      : pcie_up_DFK.v
// Module         : PCIE_UP_DFK
// Function       : Upload Empty buffer load module
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

module PCIE_DN_DFK # (
    parameter                           p_CH_ID        = 1'b0                    //(p)  [  2]
    )(
    //system
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    //register
    input       [  15:0]                COMPLETER_ID                            ,//(i)  [ 16]
    input                               DN_FBUF_WR_RDY                          ,//(i)  [  1]
    input                               DN_FBUF_RD_REQ0                         ,//(i)  [  1]
    input                               DN_FBUF_RD_REQ1                         ,//(i)  [  1]
    input                               DN_FBUF_RD_ACK1                         ,//(i)  [  1]
    input                               DN_FBUF_RD_TRIG                         ,//(i)  [  1]
    input       [  63:0]                DN_FBUF_RD_ADDR                         ,//(i)  [ 64]
    input       [  23:0]                DN_FBUF_RD_SIZE                         ,//(i)  [ 24]
    input                               DN_FBUF_RD_AUTO                         ,//(i)  [  1]
    //pcie tx
    output                              DFK_TX_REQ                              ,//(o)  [  1]
    input                               DFK_TX_ACK                              ,//(i)  [  1]
    output                              DFK_TX_DVLD                             ,//(o)  [  1]
    output      [  63:0]                DFK_TX_DATA                             ,//(o)  [ 64]
    output      [   1:0]                DFK_TX_MASK                             ,//(o)  [  2]
    output                              DFK_TX_SOP                              ,//(o)  [  1]
    output                              DFK_TX_EOP                               //(o)  [  1]
    );

// =============================================================================
// Parameter Declare
// =============================================================================

    localparam                          p_MEM_RD32_FMT  = 7'b0000000            ;//(p)  [  7]
    localparam                          p_MEM_WR32_FMT  = 7'b1000000            ;//(p)  [  7]
    localparam                          p_MEM_RD64_FMT  = 7'b0100000            ;//(p)  [  7]
    localparam                          p_MEM_WR64_FMT  = 7'b1100000            ;//(p)  [  7]

// =============================================================================
// Internal signal define
// =============================================================================

    reg         [  63:0]                r_DN_FBUF_RD_ADDR                       ;//(r)  [ 64]
    reg         [  23:0]                r_DN_FBUF_RD_SIZE                       ;//(r)  [ 24]
    reg                                 r_DN_FBUF_RD_AUTO                       ;//(r)  [  1]
    reg         [  63:0]                r_DMA_ADDR                              ;//(r)  [ 64]
    reg                                 r_RD64_FLAG                             ;//(r)  [  1]
    reg         [  21:0]                r_OFT_ADDR                              ;//(r)  [ 22]

    reg                                 r_DFK_TX_ACK_DFF1                       ;//(r)  [  1]
    reg                                 r_DFK_TX_ACK_DFF2                       ;//(r)  [  1]
    reg                                 r_DFK_TX_REQ                            ;//(r)  [  1]
    reg                                 r_DFK_TX_DVLD                           ;//(r)  [  5]
    reg         [   1:0]                r_DFK_TX_MASK                           ;//(r)  [  2]
    reg         [  63:0]                r_DFK_TX_DATA                           ;//(r)  [ 64]
    reg                                 r_DFK_TX_SOP                            ;//(r)  [  1]
    reg                                 r_DFK_TX_EOP                            ;//(r)  [  1]
    wire                                s_DN_FBUF_RD_REQ                        ;//(s)  [  1]
    reg                                 r_DFK_TX_RDY                            ;//(r)  [  1]
    reg         [  16:0]                r_DFK_TX_CNT                            ;//(r)  [ 17]

// ================================================================================================
// RTL Body
// ================================================================================================

/*============================================================================+/
||                                                                            ||
||                                Output Port                                 ||
||                                                                            ||
/+============================================================================*/

    assign  DFK_TX_REQ                  = r_DFK_TX_REQ                          ;
    assign  DFK_TX_DVLD                 = r_DFK_TX_DVLD                         ;
    assign  DFK_TX_DATA                 = r_DFK_TX_DATA                         ;
    assign  DFK_TX_MASK                 = r_DFK_TX_MASK                         ;
    assign  DFK_TX_SOP                  = r_DFK_TX_SOP                          ;
    assign  DFK_TX_EOP                  = r_DFK_TX_EOP                          ;

/*============================================================================+/
||                                                                            ||
||              Download request packet generate control                      ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_RD_ADDR           <= 1'b0 ;
            r_DN_FBUF_RD_SIZE           <= 1'b0 ;
            r_DN_FBUF_RD_AUTO           <= 1'b0 ;
        end else begin
            if (DN_FBUF_RD_TRIG) begin
                r_DN_FBUF_RD_ADDR       <= DN_FBUF_RD_ADDR ;
                r_DN_FBUF_RD_SIZE       <= DN_FBUF_RD_SIZE ;
                r_DN_FBUF_RD_AUTO       <= DN_FBUF_RD_AUTO ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_TX_ACK_DFF1           <= 1'b0 ;
            r_DFK_TX_ACK_DFF2           <= 1'b0 ;
        end else begin
            r_DFK_TX_ACK_DFF1           <= DFK_TX_ACK        ;
            r_DFK_TX_ACK_DFF2           <= r_DFK_TX_ACK_DFF1 ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_TX_RDY                <= 1'b1 ;
        end else begin
            if (r_DFK_TX_ACK_DFF2) begin
                r_DFK_TX_RDY            <= 1'b0 ;
            end else if (DN_FBUF_RD_ACK1) begin
                r_DFK_TX_RDY            <= 1'b1 ;
            end
        end
    end

    assign s_DN_FBUF_RD_REQ             = DN_FBUF_RD_REQ0 | (DN_FBUF_RD_REQ1 & r_DN_FBUF_RD_AUTO) ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_TX_CNT                <= 17'd0 ;
        end else begin
            if (r_DFK_TX_ACK_DFF2 & (~s_DN_FBUF_RD_REQ)) begin
                r_DFK_TX_CNT            <= r_DFK_TX_CNT - 1'b1 ;
            end else if ((~r_DFK_TX_ACK_DFF2) & s_DN_FBUF_RD_REQ) begin
                r_DFK_TX_CNT            <= r_DFK_TX_CNT + 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_TX_REQ                <= 1'b0 ;
        end else begin
            r_DFK_TX_REQ                <= DN_FBUF_WR_RDY & r_DFK_TX_RDY & (|r_DFK_TX_CNT) ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_OFT_ADDR                  <= 22'd0 ;
        end else begin
            if (DN_FBUF_RD_TRIG) begin
                r_OFT_ADDR              <= 22'd0 ;
            end else if (r_DFK_TX_ACK_DFF2) begin
                r_OFT_ADDR              <= r_OFT_ADDR + 9'd256 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DMA_ADDR                  <= 'b0 ;
        end else begin
            r_DMA_ADDR                  <= r_DN_FBUF_RD_ADDR + r_OFT_ADDR ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_RD64_FLAG                 <= 1'b0 ;
        end else begin
            r_RD64_FLAG                 <= | r_DMA_ADDR[63:32] ;
        end
    end

/*============================================================================+/
||                                                                            ||
||              Download request packet generate control                      ||
||                                                                            ||
/+============================================================================*/

    // UEK  RD_REQ  TAG = 0Y100XXX
    // UFK  WR_REQ  TAG = 0Y101XXX
    // DEK  WR_REQ  TAG = 0Y110XXX
    // DFK  RD_REQ  TAG = 0Y111XXX
    // UPK  WR_REQ  TAG = 0Y0XXXXX
    // DPK  RD_REQ  TAG = 1YXXXXXX

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DFK_TX_DVLD                   <=  'b0 ;
            r_DFK_TX_SOP                    <=  'b0 ;
            r_DFK_TX_EOP                    <=  'b0 ;
            r_DFK_TX_MASK                   <=  'b0 ;
            r_DFK_TX_DATA                   <=  'b0 ;
        end else begin
            if (r_DFK_TX_ACK_DFF1) begin
                r_DFK_TX_DVLD               <=  1'b1                    ;
                r_DFK_TX_SOP                <=  1'b1                    ;
                r_DFK_TX_EOP                <=  1'b0                    ;
                r_DFK_TX_MASK               <=  2'b11                   ;

                r_DFK_TX_DATA[63:32]        <=  {
                                                COMPLETER_ID            ,// |heard1| --packet head
                                               {1'b0,p_CH_ID,6'b111000} ,// |      | --packet head TAG
                                                {4'b1111}               ,// |      | --packet head Last BE
                                                {4'b1111}                // |      | --packet head Frist BE
                                                } ;

                r_DFK_TX_DATA[31:00]        <=  {
                                                {1'b0}                  ,// |heard0| --packet head R
                                                {1'b0}                  ,// |      | --packet head FMT*TYPE[6]
                                                r_RD64_FLAG             ,// |      | --packet head FMT*TYPE[5]
                                                {5'b0}                  ,// |      | --packet head FMT*TYPE[4:3]
                                                {1'b0}                  ,// |      | --packet head R
                                                {3'b0}                  ,// |      | --packet head TC
                                                {4'b0}                  ,// |      | --packet head R
                                                {1'b0}                  ,// |      | --packet head TC
                                                {1'b0}                  ,// |      | --packet head EP
                                                {2'b0}                  ,// |      | --packet head ATTR
                                                {2'b0}                  ,// |      | --packet head R
                                                {10'h40}                 // |      | --packet head payload length 256 byte = 64DW = 0x40 DW (Number in DW)
                                                } ;

            end else if (r_DFK_TX_ACK_DFF2) begin
                r_DFK_TX_DVLD               <=  1'b1                    ;
                r_DFK_TX_SOP                <=  1'b0                    ;
                r_DFK_TX_EOP                <=  1'b1                    ;

                if (r_RD64_FLAG) begin
                    r_DFK_TX_MASK           <=  2'b11                   ;
                    r_DFK_TX_DATA[63:32]    <=  r_DMA_ADDR[31:00]       ; // |heard3| --address low 3 bit must be 0 with QWord address
                    r_DFK_TX_DATA[31:00]    <=  r_DMA_ADDR[63:32]       ; // |heard2| --address low 3 bit must be 0 with QWord address
                end else begin
                    r_DFK_TX_MASK           <=  2'b01                   ;
                    r_DFK_TX_DATA[63:32]    <=  32'd0                   ; // |Unused|
                    r_DFK_TX_DATA[31:00]    <=  r_DMA_ADDR[31:00]       ; // |heard2| --address low 3 bit must be 0 with QWord address
                end

            end else begin
                r_DFK_TX_DVLD               <=  'b0                     ;
                r_DFK_TX_SOP                <=  'b0                     ;
                r_DFK_TX_EOP                <=  'b0                     ;
                r_DFK_TX_MASK               <=  'b0                     ;
                r_DFK_TX_DATA               <=  'b0                     ;
            end
        end
    end

endmodule

/*
-- 64bit address :
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

-- 32bit address :
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
*/
