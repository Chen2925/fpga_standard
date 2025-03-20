// =================================================================================================
// File Name    : PC_SIM.v
// Entity       : PC_SIM
// =================================================================================================
// Function     : PC_SIM
// -------------------------------------------------------------------------------------------------
// Updata History:
// -------------------------------------------------------------------------------------------------
// REV.Level    Date        Coded-by        Contents
// v0.1.0       2019/06/10
// -------------------------------------------------------------------------------------------------
// End Revision
// =================================================================================================

module PC_SIM(
    input                               CLK                                     ,//(i)[1] System clock  200M
    input                               RST                                     ,//(i)[1] System reset
    //sim model
    input                               REG_WR_REQ                              ,//(i)[  1]
    output                              REG_WR_ACK                              ,//(o)[  1]
    input       [  31:0]                REG_WR_DATA                             ,//(i)[ 32]
    input                               REG_RD_REQ                              ,//(i)[  1]
    output                              REG_RD_ACK                              ,//(o)[  1]
    output      [  31:0]                REG_RD_DATA                             ,//(o)[ 32]
    input       [   9:0]                REG_OP_ADDR                             ,//(i)[ 10]

    //iic master
    output                              I2C_WR_EN                               ,//(o)[  1] I2C write enable
    output      [ 7:0]                  I2C_WR_DATA                             ,//(o)[  8] I2C write data
    input                               I2C_WR_ACK                              ,//(i)[  1] I2C Write ack
    output                              I2C_RD_EN                               ,//(o)[  1] I2C read enable
    input                               I2C_RD_ACK                              ,//(i)[  1] I2C read ack
    input       [ 7:0]                  I2C_RD_DATA                             ,//(i)[  8] I2C read data

    output      [ 7:0]                  I2C_SLV_ADDR                            ,//(o)[  8] I2C slaver address
    output      [ 7:0]                  I2C_SUB_ADDR                            ,//(o)[  8] I2C sub address
    input                               I2C_ACK_ERR                             ,//(i)[  1] I2C access error
    input                               I2C_BUSY                                 //(i)[  1] I2C access busy
    );

// =============================================================================
// Prameter define
// =============================================================================

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_I2C_WR_EN                             ;//(r)[  1]
    reg                                 r_I2C_RD_EN                             ;//(r)[  1]
    reg         [   7:0]                r_I2C_SLV_ADDR                          ;//(r)[  8]
    reg         [   7:0]                r_I2C_SUB_ADDR                          ;//(r)[  8]
    reg         [   7:0]                r_I2C_WR_DATA                           ;//(r)[  8]

// =============================================================================
// output
// =============================================================================

    assign REG_WR_ACK                   = I2C_WR_ACK                            ;
    assign REG_RD_ACK                   = I2C_RD_ACK                            ;
    assign REG_RD_DATA                  = {24'h000000,I2C_RD_DATA}              ;

    assign I2C_WR_EN                    = r_I2C_WR_EN                           ;
    assign I2C_WR_DATA                  = r_I2C_WR_DATA                         ;
    assign I2C_RD_EN                    = r_I2C_RD_EN                           ;
    assign I2C_SLV_ADDR                 = r_I2C_SLV_ADDR                        ;
    assign I2C_SUB_ADDR                 = r_I2C_SUB_ADDR                        ;

// =============================================================================
//                     rtl body
// =============================================================================

/*=============================================================================+/
||                                                                             ||
||                                    PC_SIM                                   ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_I2C_WR_EN                 <= 1'b0 ;
            r_I2C_RD_EN                 <= 1'b0 ;
        end else if(REG_WR_REQ) begin
            r_I2C_WR_EN                 <= 1'b1 ;
        end else if(REG_RD_REQ) begin
            r_I2C_RD_EN                 <= 1'b1 ;
        end else begin
            r_I2C_WR_EN                 <= 1'b0 ;
            r_I2C_RD_EN                 <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_I2C_SLV_ADDR              <= 'b0 ;
            r_I2C_SUB_ADDR              <= 'b0 ;
        end else if(REG_WR_REQ | REG_RD_REQ) begin
            r_I2C_SLV_ADDR[1:0]         <= REG_OP_ADDR[ 9: 8] ;
            r_I2C_SUB_ADDR              <= REG_OP_ADDR[ 7: 0] ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_I2C_WR_DATA               <= 'b0 ;
        end else if(REG_WR_REQ) begin
            r_I2C_WR_DATA               <= REG_WR_DATA[7:0] ;
        end
    end

endmodule