// =================================================================================================
// File Name      : spi_ctrl.v
// Module         : SPI_CTRL
// Function       : SPI interface timing control
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date          Coded by                Contents
// 0.1.0      2018/8/20     Benson                  Create new
//
// =================================================================================================
// End Revision
// =================================================================================================

//mode0 idle 0 pos sample neg change

`timescale 1 ps/1 ps

module SPI_MASTER (
    // Global signals
    input                               RST                                     ,//(i) [  1]
    input                               CLK                                     ,//(i) [  1]
    // User interface
    input                               SPI_WR_REQ                              ,//(i) [  1]
    input           [ 7:0]              SPI_WR_ADDR                             ,//(i) [  8]
    input           [15:0]              SPI_WR_DATA                             ,//(i) [ 16]
    output                              SPI_WR_ACK                              ,//(o) [  1]
    input                               SPI_RD_REQ                              ,//(i) [  1]
    input           [ 7:0]              SPI_RD_ADDR                             ,//(i) [  8]
    output                              SPI_RD_ACK                              ,//(o) [ 16]
    output          [15:0]              SPI_RD_DATA                             ,//(o) [  1]
    input                               SPI_OP_SEL                              ,//(i) [  1]
    output                              SPI_OP_BUSY                             ,//(o) [  1]
    // SPI interface
    output                              SPI_GP_XRST                             ,//(o) [  1]
    output                              SPI_GP_CS                               ,//(o) [  1]
    output                              SPI_GP_CLK                              ,//(o) [  1]
    output                              SPI_GP_SDI                              ,//(o) [  1]
    input                               SPI_GP_SDO                              ,//(i) [  1]
    input                               SPI_GP_BUSY                              //(1) [  1]
    );

// =============================================================================
// Prameter define
// =============================================================================

    parameter                           p_CLK_DIV  = 5'h10                      ;//(p)[  5]
    parameter                           p_SPI_IDLE = 6'b00_0001                 ;//(p)[  6]
    parameter                           p_SPI_CONV = 6'b00_0010                 ;//(p)[  6]
    parameter                           p_SPI_ADDR = 6'b00_0100                 ;//(p)[  6]
    parameter                           p_SPI_CMD  = 6'b00_1000                 ;//(p)[  6]
    parameter                           p_SPI_WR   = 6'b01_0000                 ;//(p)[  6]
    parameter                           p_SPI_RD   = 6'b10_0000                 ;//(p)[  6]

// =============================================================================
// Internal signal define
// =============================================================================

    reg         [   5:0]                r_SPI_FSM                               ;//(r)[  6]
    reg                                 r_SPI_WR_FLAG                           ;//(r)[  1]
    reg                                 r_SPI_RD_FLAG                           ;//(r)[  1]
    reg         [   7:0]                r_SPI_OP_ADDR                           ;//(r)[  8]
    reg         [  15:0]                r_SPI_WR_DATA                           ;//(r)[ 16]
    reg                                 r_SPI_SOP                               ;//(r)[  1]
    wire                                s_SPI_IDLE                              ;//(s)[  1]
    wire                                s_SPI_CONV                              ;//(s)[  1]
    wire                                s_SPI_ADDR                              ;//(s)[  1]
    wire                                s_SPI_CMD                               ;//(s)[  1]
    wire                                s_SPI_WR                                ;//(s)[  1]
    wire                                s_SPI_RD                                ;//(s)[  1]
    reg         [   3:0]                r_SPI_CLK_DIV                           ;//(r)[  4]
    reg                                 r_SPI_CLK                               ;//(r)[  1]
    reg                                 r_SPI_CLK_DFF                           ;//(r)[  1]
    wire                                s_SPI_CLK_RISE                          ;//(s)[  1]
    wire                                s_SPI_CLK_FALL                          ;//(s)[  1]
    reg         [   4:0]                r_SPI_BIT_CNT                           ;//(r)[  5]
    wire                                s_SPI_ADDR_END                          ;//(s)[  1]
    wire                                s_SPI_CMD_END                           ;//(s)[  1]
    wire                                s_SPI_EOP                               ;//(s)[  1]
    reg         [  24:0]                r_SPI_SDI_SHFT                          ;//(r)[ 24]
    reg         [  15:0]                r_SPI_SDO_SHFT                          ;//(r)[ 16]
    reg                                 r_SPI_WR_ACK                            ;//(r)[  1]
    reg                                 r_SPI_RD_ACK                            ;//(r)[  1]

// =============================================================================
// output
// =============================================================================

    assign SPI_GP_CS                    = SPI_OP_SEL                            ;
    assign SPI_GP_XRST                  = RST                                   ;
    assign SPI_GP_CLK                   = r_SPI_CLK_DFF                         ;
    assign SPI_GP_SDI                   = r_SPI_SDI_SHFT[24]                    ;
    assign SPI_WR_ACK                   = r_SPI_WR_ACK                          ;
    assign SPI_RD_ACK                   = r_SPI_RD_ACK                          ;
    assign SPI_RD_DATA                  = r_SPI_SDO_SHFT                        ;
    assign SPI_OP_BUSY                  = ~s_SPI_IDLE                           ;

// =============================================================================
//                     rtl body
// =============================================================================

/*=============================================================================+/
||                                                                             ||
||                                    xxx                                      ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_FLAG               <= 1'b0 ;
            r_SPI_RD_FLAG               <= 1'b0 ;
        end else if(s_SPI_EOP) begin
            r_SPI_WR_FLAG               <= 1'b0 ;
            r_SPI_RD_FLAG               <= 1'b0 ;
        end else if(SPI_WR_REQ)begin
            r_SPI_WR_FLAG               <= 1'b1 ;
        end else if(SPI_RD_REQ)begin
            r_SPI_RD_FLAG               <= 1'b1 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_OP_ADDR               <= 'b0 ;
        end else if(SPI_WR_REQ) begin
            r_SPI_OP_ADDR               <= SPI_WR_ADDR  ;
        end else if(SPI_RD_REQ)begin
            r_SPI_OP_ADDR               <= SPI_RD_ADDR  ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_DATA               <= 'b0 ;
        end else if(SPI_WR_REQ) begin
            r_SPI_WR_DATA               <= SPI_WR_DATA ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_SOP                   <= 1'b0 ;
        end else if((SPI_WR_REQ | SPI_RD_REQ) & (~SPI_GP_BUSY)) begin
            r_SPI_SOP                   <= 1'b1 ;
        end else begin
            r_SPI_SOP                   <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_FSM                   <= p_SPI_IDLE ;
        end else begin
            case(r_SPI_FSM)
                p_SPI_IDLE : begin
                    if(SPI_OP_SEL) begin
                        r_SPI_FSM       <= p_SPI_CONV ;
                    end
                end
                p_SPI_CONV : begin
                    if(r_SPI_SOP)begin
                        r_SPI_FSM       <= p_SPI_ADDR ;
                    end
                end
                p_SPI_ADDR : begin
                    if(s_SPI_ADDR_END)begin
                        r_SPI_FSM       <= p_SPI_CMD ;
                    end
                end
                p_SPI_CMD  : begin
                    if(s_SPI_CMD_END & r_SPI_WR_FLAG)begin
                        r_SPI_FSM       <= p_SPI_WR ;
                    end else if(s_SPI_CMD_END & r_SPI_RD_FLAG)begin
                        r_SPI_FSM       <= p_SPI_RD ;
                    end
                end
                p_SPI_WR   : begin
                    if(s_SPI_EOP)begin
                        r_SPI_FSM       <= p_SPI_IDLE ;
                    end
                end
                p_SPI_RD   : begin
                    if(s_SPI_EOP)begin
                        r_SPI_FSM       <= p_SPI_IDLE ;
                    end
                end
            endcase
        end
    end

    assign s_SPI_IDLE                   = r_SPI_FSM[0]                          ;
    assign s_SPI_CONV                   = r_SPI_FSM[1]                          ;
    assign s_SPI_ADDR                   = r_SPI_FSM[2]                          ;
    assign s_SPI_CMD                    = r_SPI_FSM[3]                          ;
    assign s_SPI_WR                     = r_SPI_FSM[4]                          ;
    assign s_SPI_RD                     = r_SPI_FSM[5]                          ;

/*==============================================================================+/
||                                                                              ||
||                   SPI clock                                                  ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_CLK_DIV               <= 5'b0 ;
        end else if(s_SPI_ADDR | s_SPI_CMD | s_SPI_WR | s_SPI_RD) begin
            r_SPI_CLK_DIV               <= r_SPI_CLK_DIV + 1'b1 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_CLK                   <= 'b0 ;
            r_SPI_CLK_DFF               <= 'b0 ;
        end else begin
            case (p_CLK_DIV)
                5'h02   : r_SPI_CLK     <= r_SPI_CLK_DIV[0] ;
                5'h04   : r_SPI_CLK     <= r_SPI_CLK_DIV[1] ;
                5'h08   : r_SPI_CLK     <= r_SPI_CLK_DIV[2] ;
                5'h10   : r_SPI_CLK     <= r_SPI_CLK_DIV[3] ;
                default : r_SPI_CLK     <= r_SPI_CLK_DIV[0] ;
            endcase

            r_SPI_CLK_DFF               <= r_SPI_CLK ;
        end
    end

    assign s_SPI_CLK_RISE               =  r_SPI_CLK & ~r_SPI_CLK_DFF ;
    assign s_SPI_CLK_FALL               = ~r_SPI_CLK &  r_SPI_CLK_DFF ;

/*==============================================================================+/
||                                                                              ||
||                   SPI data                                                   ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_BIT_CNT               <= 'b0 ;
        end else if(s_SPI_EOP)begin
            r_SPI_BIT_CNT               <= 'b0 ;
        end else if((s_SPI_ADDR | s_SPI_CMD | s_SPI_WR | s_SPI_RD) & s_SPI_CLK_RISE) begin
            r_SPI_BIT_CNT               <= r_SPI_BIT_CNT + 5'd1 ;
        end
    end

    assign s_SPI_ADDR_END               = ((r_SPI_BIT_CNT == 5'd8) & s_SPI_CLK_FALL)   ;
    assign s_SPI_CMD_END                = ((r_SPI_BIT_CNT == 5'd9) & s_SPI_CLK_FALL)   ;
    assign s_SPI_EOP                    = ((r_SPI_BIT_CNT == 5'd25) & s_SPI_CLK_FALL)  ;


    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_SDI_SHFT                         <= 'b0 ;
        end else if(s_SPI_CONV & r_SPI_WR_FLAG) begin
            r_SPI_SDI_SHFT                         <= {r_SPI_OP_ADDR,1'b0,r_SPI_WR_DATA} ;
        end else if(s_SPI_CONV & r_SPI_RD_FLAG)begin
            r_SPI_SDI_SHFT                         <= {r_SPI_OP_ADDR,1'b1,16'hFFFF} ;
        end else if((s_SPI_ADDR | s_SPI_CMD | s_SPI_WR | s_SPI_RD) & s_SPI_CLK_FALL) begin
            r_SPI_SDI_SHFT              <= {r_SPI_SDI_SHFT[23:0], 1'b1};
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_SDO_SHFT              <= 'b0 ;
        end else if(s_SPI_RD & s_SPI_CLK_FALL) begin
            r_SPI_SDO_SHFT              <= {r_SPI_SDO_SHFT[14:0],SPI_GP_SDO} ;
        end
    end


    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_ACK                <= 1'b0 ;
        end else if(r_SPI_WR_FLAG & s_SPI_EOP) begin
            r_SPI_WR_ACK                <= 1'b1 ;
        end else begin
            r_SPI_WR_ACK                <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_RD_ACK                <= 1'b0 ;
        end else if(r_SPI_RD_FLAG & s_SPI_EOP) begin
            r_SPI_RD_ACK                <= 1'b1 ;
        end else begin
            r_SPI_RD_ACK                <= 1'b0 ;
        end
    end

endmodule