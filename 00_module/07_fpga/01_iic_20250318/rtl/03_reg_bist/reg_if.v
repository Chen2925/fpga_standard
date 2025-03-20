// =================================================================================================
// File Name        : reg_if.v
// Module           : REG_IF
// Function         : REG_IF
// Type             : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.level  Date         Code by           Contents
// 0.1.0      2021/7/28
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ps / 1ps

module REG_IF (
    input                               CLK                                     ,//(i)  [   1]
    input                               RST                                     ,//(i)  [   1]
    //iic slaver0
    input                               I2C_SLAV0_WR_EN                         ,//(i)[  1] I2C slaver0 write enable
    input       [   7:0]                I2C_SLAV0_WR_DATA                       ,//(i)[  8] I2C slaver0 write data
    input       [   7:0]                I2C_SLAV0_OP_ADDR                       ,//(i)[  8] I2C slaver0 write address
    input                               I2C_SLAV0_RD_EN                         ,//(i)[  1] I2C slaver0 read  enable
    output      [   7:0]                I2C_SLAV0_RD_DATA                       ,//(o)[  8] I2C slaver0 read  data
    output                              I2C_SLAV0_RD_ACK                        ,//(o)[  1] I2C slaver0 read  data ACK

    input                               I2C_SLAV1_WR_EN                         ,//(i)[  1] I2C slaver1 write enable
    input       [   7:0]                I2C_SLAV1_WR_DATA                       ,//(i)[  8] I2C slaver1 write data
    input       [   7:0]                I2C_SLAV1_OP_ADDR                       ,//(i)[  8] I2C slaver1 write address
    input                               I2C_SLAV1_RD_EN                         ,//(i)[  1] I2C slaver1 read  enable
    output      [   7:0]                I2C_SLAV1_RD_DATA                       ,//(o)[  8] I2C slaver1 read  data
    output                              I2C_SLAV1_RD_ACK                        ,//(o)[  1] I2C slaver1 read  data ACK

    //reg bist
    output                              REG_WR_REQ                              ,//(o)  [  1]  Register write request
    input                               REG_WR_ACK                              ,//(i)  [  1]  Register write acknowledge
    output      [  31:0]                REG_WR_DATA                             ,//(o)  [ 32]  Register write data
    output                              REG_RD_REQ                              ,//(o)  [  1]  Register read request
    input                               REG_RD_ACK                              ,//(i)  [  1]  Register read acknowledge
    input       [  31:0]                REG_RD_DATA                             ,//(i)  [ 32]  Register read data
    output      [  15:0]                REG_OP_ADDR                              //(o)  [ 10]  Register operation address
    );

// =============================================================================
// Prameter define
// =============================================================================

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_REG_WR_REQ                            ;//(r)[  1]
    reg                                 r_REG_RD_REQ                            ;//(r)[  1]
    reg         [  31:0]                r_REG_WR_DATA                           ;//(r)[ 32]
    reg         [  15:0]                r_REG_OP_ADDR                           ;//(r)[ 10]
    reg                                 r_I2C_SLAV0_RD_ACK                      ;//(r)[  1]
    reg         [  31:0]                r_I2C_SLAV0_RD_DATA                     ;//(r)[ 32]
    reg                                 r_I2C_SLAV1_RD_ACK                      ;//(r)[  1]
    reg         [  31:0]                r_I2C_SLAV1_RD_DATA                     ;//(r)[ 32]

// =============================================================================
// output
// =============================================================================

    assign I2C_SLAV0_RD_DATA            = r_I2C_SLAV0_RD_DATA                   ;
    assign I2C_SLAV0_RD_ACK             = r_I2C_SLAV0_RD_ACK                    ;

    assign I2C_SLAV1_RD_DATA            = r_I2C_SLAV1_RD_DATA                   ;
    assign I2C_SLAV1_RD_ACK             = r_I2C_SLAV1_RD_ACK                    ;

    assign REG_WR_REQ                   = r_REG_WR_REQ                          ;
    assign REG_WR_DATA                  = r_REG_WR_DATA                         ;
    assign REG_RD_REQ                   = r_REG_RD_REQ                          ;
    assign REG_OP_ADDR                  = r_REG_OP_ADDR                         ;

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
            r_REG_WR_REQ               <= 1'b0 ;
        end else if(I2C_SLAV0_WR_EN | I2C_SLAV1_WR_EN) begin
            r_REG_WR_REQ               <= 1'b1 ;
        end else begin
            r_REG_WR_REQ               <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_REG_RD_REQ                <= 1'b0 ;
        end else if(I2C_SLAV0_RD_EN | I2C_SLAV1_RD_EN) begin
            r_REG_RD_REQ                <= 1'b1 ;
        end else begin
            r_REG_RD_REQ                <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_REG_WR_DATA               <= 'b0 ;
            r_REG_OP_ADDR               <= 'b0 ;
        end else if(I2C_SLAV0_WR_EN) begin
            r_REG_WR_DATA[7:0]          <= I2C_SLAV0_WR_DATA ;
            r_REG_OP_ADDR[7:0]          <= I2C_SLAV0_OP_ADDR ;
        end else if(I2C_SLAV1_WR_EN)begin
            r_REG_WR_DATA[7:0]          <= I2C_SLAV1_WR_DATA ;
            r_REG_OP_ADDR[7:0]          <= I2C_SLAV0_OP_ADDR ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_I2C_SLAV0_RD_ACK                          <= 'b0 ;
            r_I2C_SLAV0_RD_DATA                         <= 'b0 ;
            r_I2C_SLAV1_RD_ACK                          <= 'b0 ;
            r_I2C_SLAV1_RD_DATA                         <= 'b0 ;
        end else if(I2C_SLAV0_RD_EN | REG_RD_ACK) begin
            r_I2C_SLAV0_RD_ACK                          <= 1'b1 ;
            r_I2C_SLAV0_RD_DATA                         <= REG_RD_DATA[7:0] ;
        end else if(I2C_SLAV1_RD_EN | REG_RD_ACK)begin
            r_I2C_SLAV1_RD_ACK                          <= 1'b1 ;
            r_I2C_SLAV1_RD_DATA                         <= REG_RD_DATA[7:0] ;
        end else begin
            r_I2C_SLAV0_RD_ACK                          <= 'b0 ;
            r_I2C_SLAV0_RD_DATA                         <= 'b0 ;
            r_I2C_SLAV1_RD_ACK                          <= 'b0 ;
            r_I2C_SLAV1_RD_DATA                         <= 'b0 ;
        end
    end

endmodule
