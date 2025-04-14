// =================================================================================================
// File Name    : PC_SIM.v
// Entity       : PC_SIM
// =================================================================================================
// Function     : PC_SIM
// -------------------------------------------------------------------------------------------------
// Updata History:
// -------------------------------------------------------------------------------------------------
// REV.Level    Date        Coded-by        Contents
// 0.1.0        2019/06/10
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

    //spi master
    output                              SPI_WR_REQ                              ,//(o)[  1] SPI write enable
    output      [ 7:0]                  SPI_WR_ADDR                             ,//(o)[  8] SPI write addr
    output      [15:0]                  SPI_WR_DATA                             ,//(o)[ 16] SPI write data
    input                               SPI_WR_ACK                              ,//(i)[  1] SPI Write ack
    output                              SPI_RD_REQ                              ,//(o)[  1] SPI read enable
    input                               SPI_RD_ACK                              ,//(i)[  1] SPI read ack
    output      [ 7:0]                  SPI_RD_ADDR                             ,//(i)[  8] SPI read addr
    input       [15:0]                  SPI_RD_DATA                             ,//(i)[ 16] SPI read data
    output                              SPI_OP_SEL                              ,//(o)[  1] SPI access busy
    input                               SPI_OP_BUSSY                            ,//(i)[  1] SPI access busy
    input                               SPI_OP_ERR                                 //(i)[  1] SPI access busy
    );

// =============================================================================
// Prameter define
// =============================================================================

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_REG_WR_REQ                            ;//(r)[  1]
    reg                                 r_REG_RD_REQ                            ;//(r)[  1]
    reg         [   7:0]                r_SPI_WR_ADDR                           ;//(r)[  8]
    reg         [   7:0]                r_SPI_RD_ADDR                           ;//(r)[  8]
    reg         [  15:0]                r_SPI_WR_DATA                           ;//(r)[ 32]


// =============================================================================
// output
// =============================================================================

    assign REG_WR_ACK                   = SPI_WR_ACK                            ;
    assign REG_RD_ACK                   = SPI_RD_ACK                            ;
    assign REG_RD_DATA                  = {16'h0000,SPI_RD_DATA}                ;

    assign SPI_WR_REQ                   = r_REG_WR_REQ                          ;
    assign SPI_WR_ADDR                  = r_SPI_WR_ADDR                         ;
    assign SPI_WR_DATA                  = r_SPI_WR_DATA                         ;

    assign SPI_RD_REQ                   = r_REG_RD_REQ                          ;
    assign SPI_RD_ADDR                  = r_SPI_RD_ADDR                         ;

    assign SPI_OP_SEL                   = 1'b1                                  ;

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
            r_REG_WR_REQ                <= 'b0 ;
            r_REG_RD_REQ                <= 'b0 ;
        end else begin
            r_REG_WR_REQ                <= REG_WR_REQ ;
            r_REG_RD_REQ                <= REG_RD_REQ ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_ADDR               <= 'b0 ;
            r_SPI_RD_ADDR               <= 'b0 ;
        end else if(REG_WR_REQ) begin
            r_SPI_WR_ADDR               <= REG_OP_ADDR[7:0] ;
        end else if(REG_RD_REQ) begin
            r_SPI_RD_ADDR               <= REG_OP_ADDR[7:0] ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_DATA               <= 'b0 ;
        end else if(REG_WR_REQ) begin
            r_SPI_WR_DATA               <= REG_WR_DATA[15:0] ;
        end
    end

endmodule