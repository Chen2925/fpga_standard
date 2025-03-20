// =================================================================================================
// File Name      : pc_sim.v
// Module         : PC_SIM
// Function       : PC simulation module
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.level  Date         Code by           Contents
// 0.1.0      20XX/XX/XX   XXX.XXX           Creat new
//
// =================================================================================================

`timescale 1ps / 1ps

module PC_SIM (
    //CLK RST
    input                               CLK                                     ,//(i) [  1]
    input                               RST                                     ,//(i) [  1]

    //signal
    output                              DRAM_WR_RDY                             ,//(i) [  1]
    input                               DRAM_WR_REQ                             ,//(i) [  1]
    output                              DRAM_WR_ACK                             ,//(i) [  1]
    input       [  24:0]                DRAM_WR_ADDR                            ,//(i) [  1]
    input       [  11:0]                DRAM_WR_SIZE                            ,//(i) [  1]
    input                               DRAM_WR_SOP                             ,//(i) [  1]
    input                               DRAM_WR_EOP                             ,//(i) [  1]
    input                               DRAM_WR_DVLD                            ,//(i) [  1]
    input       [  63:0]                DRAM_WR_DATA                            ,//(i) [  1]

    output      [  63:0]                AXIS_RX_TDATA                           ,//(o)  [ 64]
    output      [   7:0]                AXIS_RX_TKEEP                           ,//(o)  [  8]
    output                              AXIS_RX_TLAST                           ,//(o)  [  1]
    output                              AXIS_RX_TVALID                          ,//(o)  [  1]
    input                               AXIS_RX_TREADY                          ,//(i)  [  1]
    output      [  21:0]                AXIS_RX_TUSER                           ,//(o)  [ 22]

    input       [  63:0]                AXIS_TX_TDATA                           ,//(i)  [ 64]
    input       [   7:0]                AXIS_TX_TKEEP                           ,//(i)  [  8]
    input                               AXIS_TX_TVALID                          ,//(i)  [  1]
    input                               AXIS_TX_TLAST                           ,//(i)  [  1]
    output                              AXIS_TX_TREADY                          ,//(o)  [  1]
    input       [   3:0]                AXIS_TX_TUSER                            //(i)  [  4]
    );

// =============================================================================
// Parameter define
// =============================================================================

    parameter                           p_GND               = 32'h00000000      ;//(p) [ 32]

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_DRAM_WR_ACK                           ;

/*=============================================================================+/
||                                                                             ||
||               Output                                                        ||
||                                                                             ||
/+=============================================================================*/

    assign DRAM_WR_RDY                  = AXIS_RX_TREADY                        ;
    assign DRAM_WR_ACK                  = r_DRAM_WR_ACK                        ;

    assign AXIS_RX_TDATA                = DRAM_WR_DATA                          ;
    assign AXIS_RX_TKEEP                = 8'hF                                  ;
    assign AXIS_RX_TLAST                = DRAM_WR_EOP                           ;
    assign AXIS_RX_TVALID               = DRAM_WR_DVLD                          ;
    assign AXIS_RX_TUSER                = 22'h3F_FFFF                           ;

    assign AXIS_TX_TREADY               = 1'b1                                  ;

    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            r_DRAM_WR_ACK               <= 'b0 ;
        end else begin
            r_DRAM_WR_ACK               <= DRAM_WR_REQ ;
        end
    end

endmodule