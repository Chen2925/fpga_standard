//================================================================================================
// File Name      : pcie_if_gx.v
// Module         : PCIE_IF_GX
// Function       : PCIE interface with Arria II GX Hard IP
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents
// 0.0.1        2011/05/31   chen.y            create new
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ps / 1ps

module PCIE_IF_GX (
    output                              PCIE_SOFT_RST                           ,//(o)  [  1]

    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    input                               USER_CLK                                ,//(i)  [  1]
    input                               USER_RST                                ,//(i)  [  1]

    input                               PCIE_INT_0                              ,//(i)  [  1]
    input                               PCIE_INT_1                              ,//(i)  [  1]
    input                               PCIE_INT_2                              ,//(i)  [  1]
    input                               PCIE_INT_3                              ,//(i)  [  1]

    input       [  63:0]                AXIS_RX_TDATA                           ,//(i)  [ 64]
    input       [   7:0]                AXIS_RX_TKEEP                           ,//(i)  [  8]
    input                               AXIS_RX_TLAST                           ,//(i)  [  1]
    input                               AXIS_RX_TVALID                          ,//(i)  [  1]
    output                              AXIS_RX_TREADY                          ,//(o)  [  1]
    input       [  21:0]                AXIS_RX_TUSER                           ,//(i)  [ 22]

    output      [  63:0]                AXIS_TX_TDATA                           ,//(o)  [ 64]
    output      [   7:0]                AXIS_TX_TKEEP                           ,//(o)  [  8]
    output                              AXIS_TX_TVALID                          ,//(o)  [  1]
    output                              AXIS_TX_TLAST                           ,//(o)  [  1]
    input                               AXIS_TX_TREADY                          ,//(i)  [  1]
    output      [   3:0]                AXIS_TX_TUSER                           ,//(o)  [  4]

    input       [  15:0]                DMA_DN0_RDY                             ,//(i)  [ 16]
    output      [  63:0]                DMA_DN0_DATA                            ,//(o)  [ 64]
    output                              DMA_DN0_DVLD                            ,//(o)  [  1]
    output                              DMA_DN0_SOF                             ,//(o)  [  1]
    output                              DMA_DN0_EOF                             ,//(o)  [  1]
    output      [  15:0]                DMA_DN0_VCH                             ,//(o)  [ 16]
    output      [  31:0]                DMA_DN0_ADDR                            ,//(o)  [ 32]
    output      [  31:0]                DMA_DN0_SIZE                            ,//(o)  [ 32]

    output                              DMA_WR0_START                           ,//(o)  [ 16]
    output      [  15:0]                DMA_WR0_VCH                             ,//(o)  [ 16]
    output      [  31:0]                DMA_WR0_ADDR                            ,//(o)  [ 32]
    output      [  31:0]                DMA_WR0_SIZE                            ,//(o)  [ 32]

    input       [  15:0]                DMA_DN1_RDY                             ,//(i)  [ 16]
    output      [  63:0]                DMA_DN1_DATA                            ,//(o)  [ 64]
    output                              DMA_DN1_DVLD                            ,//(o)  [  1]
    output                              DMA_DN1_SOF                             ,//(o)  [  1]
    output                              DMA_DN1_EOF                             ,//(o)  [  1]
    output      [  15:0]                DMA_DN1_VCH                             ,//(o)  [ 16]
    output      [  31:0]                DMA_DN1_ADDR                            ,//(o)  [ 32]
    output      [  31:0]                DMA_DN1_SIZE                            ,//(o)  [ 32]

    output                              DMA_WR1_START                           ,//(o)  [ 16]
    output      [  15:0]                DMA_WR1_VCH                             ,//(o)  [ 16]
    output      [  31:0]                DMA_WR1_ADDR                            ,//(o)  [ 32]
    output      [  31:0]                DMA_WR1_SIZE                            ,//(o)  [ 32]

    output                              DMA_UP0_RDY                             ,//(i)  [  1]
    input       [  63:0]                DMA_UP0_DATA                            ,//(i)  [ 64]
    input                               DMA_UP0_DVLD                            ,//(i)  [  1]
    input                               DMA_UP0_SOF                             ,//(i)  [  1]
    input                               DMA_UP0_EOF                             ,//(i)  [  1]
    input       [  15:0]                DMA_UP0_VCH                             ,//(i)  [ 16]
    input       [  31:0]                DMA_UP0_SIZE                            ,//(i)  [ 32]
    input       [  31:0]                DMA_UP0_ADDR                            ,//(i)  [ 32]

    output                              DMA_RD0_START                           ,//(o)  [ 16]
    output      [  15:0]                DMA_RD0_VCH                             ,//(o)  [ 16]
    output      [  31:0]                DMA_RD0_ADDR                            ,//(o)  [ 32]
    output      [  31:0]                DMA_RD0_SIZE                            ,//(o)  [ 32]

    output                              DMA_UP1_RDY                             ,//(i)  [  1]
    input       [  63:0]                DMA_UP1_DATA                            ,//(i)  [ 64]
    input                               DMA_UP1_DVLD                            ,//(i)  [  1]
    input                               DMA_UP1_SOF                             ,//(i)  [  1]
    input                               DMA_UP1_EOF                             ,//(i)  [  1]
    input       [  15:0]                DMA_UP1_VCH                             ,//(i)  [ 16]
    input       [  31:0]                DMA_UP1_SIZE                            ,//(i)  [ 32]
    input       [  31:0]                DMA_UP1_ADDR                            ,//(i)  [ 32]

    output                              DMA_RD1_START                           ,//(o)  [ 16]
    output      [  15:0]                DMA_RD1_VCH                             ,//(o)  [ 16]
    output      [  31:0]                DMA_RD1_ADDR                            ,//(o)  [ 32]
    output      [  31:0]                DMA_RD1_SIZE                            ,//(o)  [ 32]

    output                              REG3_WR_REQ                             ,//(o)  [  1]
    input                               REG3_WR_ACK                             ,//(i)  [  1]
    output      [  31:0]                REG3_WR_DATA                            ,//(o)  [ 32]
    output                              REG3_RD_REQ                             ,//(o)  [  1]
    input                               REG3_RD_ACK                             ,//(i)  [  1]
    input       [  31:0]                REG3_RD_DATA                            ,//(i)  [ 32]
    output      [  15:0]                REG3_OP_ADDR                            ,//(o)  [ 16]

    output                              REG4_WR_REQ                             ,//(o)  [  1]
    input                               REG4_WR_ACK                             ,//(i)  [  1]
    output      [  31:0]                REG4_WR_DATA                            ,//(o)  [ 32]
    output                              REG4_RD_REQ                             ,//(o)  [  1]
    input                               REG4_RD_ACK                             ,//(i)  [  1]
    input       [  31:0]                REG4_RD_DATA                            ,//(i)  [ 32]
    output      [  15:0]                REG4_OP_ADDR                            ,//(o)  [ 16]

    output                              REG5_WR_REQ                             ,//(o)  [  1]
    input                               REG5_WR_ACK                             ,//(i)  [  1]
    output      [  31:0]                REG5_WR_DATA                            ,//(o)  [ 32]
    output                              REG5_RD_REQ                             ,//(o)  [  1]
    input                               REG5_RD_ACK                             ,//(i)  [  1]
    input       [  31:0]                REG5_RD_DATA                            ,//(i)  [ 32]
    output      [  15:0]                REG5_OP_ADDR                            ,//(o)  [ 16]

    output                              REG6_WR_REQ                             ,//(o)  [  1]
    input                               REG6_WR_ACK                             ,//(i)  [  1]
    output      [  31:0]                REG6_WR_DATA                            ,//(o)  [ 32]
    output                              REG6_RD_REQ                             ,//(o)  [  1]
    input                               REG6_RD_ACK                             ,//(i)  [  1]
    input       [  31:0]                REG6_RD_DATA                            ,//(i)  [ 32]
    output      [  15:0]                REG6_OP_ADDR                             //(o)  [ 16]
    );

// =============================================================================
// Internal Signal Declare
// =============================================================================

    localparam                          p_CH_ID         = 2'b10                 ;//(p)  [  2]
    localparam                          p_CH_NM         = 2                     ;//(p)  [  2]

    //pcie rx
    wire        [  63:0]                s_AXIS_RX_TDATA                         ;//(s)  [ 64]
    wire        [   7:0]                s_AXIS_RX_TKEEP                         ;//(s)  [  8]
    wire                                s_AXIS_RX_TLAST                         ;//(s)  [  1]
    wire                                s_AXIS_RX_TVALID                        ;//(s)  [  1]
    wire                                s_AXIS_RX_TREADY                        ;//(s)  [  1]
    wire        [  21:0]                s_AXIS_RX_TUSER                         ;//(s)  [ 22]

    wire        [  63:0]                s_AXIS_TX_TDATA                         ;//(s)  [ 64]
    wire        [   7:0]                s_AXIS_TX_TKEEP                         ;//(s)  [  8]
    wire                                s_AXIS_TX_TVALID                        ;//(s)  [  1]
    wire                                s_AXIS_TX_TLAST                         ;//(s)  [  1]
    wire                                s_AXIS_TX_TREADY                        ;//(s)  [  1]
    wire        [   3:0]                s_AXIS_TX_TUSER                         ;//(s)  [  4]

    wire                                s_BAR0_DN_CPLD_SOP                      ;//(s)  [  1]
    wire                                s_BAR0_DN_CPLD_EOP                      ;//(s)  [  1]
    wire        [  63:0]                s_BAR0_DN_CPLD_DATA                     ;//(s)  [ 64]
    wire                                s_BAR0_DN_CPLD_DVLD                     ;//(s)  [  1]
    wire        [   7:0]                s_BAR0_DN_CPLD_TAG                      ;//(s)  [  8]
    wire        [  11:0]                s_BAR0_DN_CPLD_DCNT                     ;//(s)  [ 12]

    wire                                s_BAR0_REG_WR_REQ                       ;//(s)  [  1]
    wire                                s_BAR0_REG_RD_REQ                       ;//(s)  [  1]
    wire                                s_BAR0_REG_WR_OK                        ;//(s)  [  1]
    wire                                s_BAR0_REG_RD_OK                        ;//(s)  [  1]
    wire        [  31:0]                s_BAR0_REG_WR_DATA                      ;//(s)  [ 32]
    wire        [  31:0]                s_BAR0_REG_RD_DATA                      ;//(s)  [ 32]
    wire        [  63:0]                s_BAR0_REG_OP_ADDR                      ;//(s)  [ 64]
    wire                                s_BAR0_REG_WR_ACK                       ;//(s)  [  1]
    wire                                s_BAR0_REG_RD_ACK                       ;//(s)  [  1]

    wire        [   6:0]                s_BAR0_RX_FMT                           ;//(s)  [  7]
    wire        [   2:0]                s_BAR0_RX_TC                            ;//(s)  [  3]
    wire                                s_BAR0_RX_TD                            ;//(s)  [  1]
    wire                                s_BAR0_RX_EP                            ;//(s)  [  1]
    wire        [   1:0]                s_BAR0_RX_ATTR                          ;//(s)  [  2]
    wire        [   9:0]                s_BAR0_RX_LEN                           ;//(s)  [ 10]
    wire        [  15:0]                s_BAR0_RX_RID                           ;//(s)  [ 16]
    wire        [   7:0]                s_BAR0_RX_RTAG                          ;//(s)  [  8]
    wire        [   7:0]                s_BAR0_RX_BE                            ;//(s)  [  8]

    wire        [   7:0]                s_PCIE_INT_ACT                          ;//(s)  [  8]
    wire                                s_PCIE_INT_CLR                          ;//(s)  [  8]
    wire                                s_SOFT_INT                              ;//(s)  [  1]
    wire                                s_SOFT_RST                              ;//(s)  [  1]

    wire                                s_DEK_TX_REQ                            ;//(s)  [  1]
    wire                                s_DEK_TX_ACK                            ;//(s)  [  1]
    wire                                s_DEK_TX_DVLD                           ;//(s)  [  1]
    wire        [  63:0]                s_DEK_TX_DATA                           ;//(s)  [ 64]
    wire        [   1:0]                s_DEK_TX_MASK                           ;//(s)  [  2]
    wire                                s_DEK_TX_SOP                            ;//(s)  [  1]
    wire                                s_DEK_TX_EOP                            ;//(s)  [  1]

    wire                                s_DFK_TX_REQ                            ;//(s)  [  1]
    wire                                s_DFK_TX_ACK                            ;//(s)  [  1]
    wire                                s_DFK_TX_DVLD                           ;//(s)  [  1]
    wire        [  63:0]                s_DFK_TX_DATA                           ;//(s)  [ 64]
    wire        [   1:0]                s_DFK_TX_MASK                           ;//(s)  [  2]
    wire                                s_DFK_TX_SOP                            ;//(s)  [  1]
    wire                                s_DFK_TX_EOP                            ;//(s)  [  1]

    wire                                s_DPK_TX_REQ                            ;//(s)  [  1]
    wire                                s_DPK_TX_ACK                            ;//(s)  [  1]
    wire                                s_DPK_TX_DVLD                           ;//(s)  [  1]
    wire        [  63:0]                s_DPK_TX_DATA                           ;//(s)  [ 64]
    wire        [   1:0]                s_DPK_TX_MASK                           ;//(s)  [  2]
    wire                                s_DPK_TX_SOP                            ;//(s)  [  1]
    wire                                s_DPK_TX_EOP                            ;//(s)  [  1]
    wire                                s_DPK_TX_END                            ;//(s)  [  1]

    wire                                s_UPK_TX_REQ                            ;//(s)  [  1]
    wire                                s_UPK_TX_ACK                            ;//(s)  [  1]
    wire                                s_UPK_TX_DVLD                           ;//(s)  [  1]
    wire        [  63:0]                s_UPK_TX_DATA                           ;//(s)  [ 64]
    wire        [   1:0]                s_UPK_TX_MASK                           ;//(s)  [  2]
    wire                                s_UPK_TX_SOP                            ;//(s)  [  1]
    wire                                s_UPK_TX_EOP                            ;//(s)  [  1]
    wire                                s_UPK_TX_END                            ;//(s)  [  1]

    wire                                s_UEK_TX_REQ                            ;//(s)  [  1]
    wire                                s_UEK_TX_ACK                            ;//(s)  [  1]
    wire                                s_UEK_TX_DVLD                           ;//(s)  [  1]
    wire        [  63:0]                s_UEK_TX_DATA                           ;//(s)  [ 64]
    wire        [   1:0]                s_UEK_TX_MASK                           ;//(s)  [  2]
    wire                                s_UEK_TX_SOP                            ;//(s)  [  1]
    wire                                s_UEK_TX_EOP                            ;//(s)  [  1]

    wire                                s_UFK_TX_REQ                            ;//(s)  [  1]
    wire                                s_UFK_TX_ACK                            ;//(s)  [  1]
    wire                                s_UFK_TX_DVLD                           ;//(s)  [  1]
    wire        [  63:0]                s_UFK_TX_DATA                           ;//(s)  [ 64]
    wire        [   1:0]                s_UFK_TX_MASK                           ;//(s)  [  2]
    wire                                s_UFK_TX_SOP                            ;//(s)  [  1]
    wire                                s_UFK_TX_EOP                            ;//(s)  [  1]

    wire                                s_CPK_TX_REQ                            ;//(s)  [  1]
    wire                                s_CPK_TX_ACK                            ;//(s)  [  1]
    wire                                s_CPK_TX_DVLD                           ;//(s)  [  1]
    wire        [  63:0]                s_CPK_TX_DATA                           ;//(s)  [ 64]
    wire        [   1:0]                s_CPK_TX_MASK                           ;//(s)  [  2]
    wire                                s_CPK_TX_SOP                            ;//(s)  [  1]
    wire                                s_CPK_TX_EOP                            ;//(s)  [  1]

    wire                                s_DFK_CX_SOP            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DFK_CX_EOP            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DFK_CX_DATA           [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_DFK_CX_DVLD           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [   7:0]                s_DFK_CX_TAG            [p_CH_NM-1:0]   ;//(s)  [  8]
    wire        [  11:0]                s_DFK_CX_DCNT           [p_CH_NM-1:0]   ;//(s)  [ 12]

    wire                                s_UEK_CX_SOP            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UEK_CX_EOP            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_UEK_CX_DATA           [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_UEK_CX_DVLD           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [   7:0]                s_UEK_CX_TAG            [p_CH_NM-1:0]   ;//(s)  [  8]
    wire        [  11:0]                s_UEK_CX_DCNT           [p_CH_NM-1:0]   ;//(s)  [ 12]

    wire                                s_DPK_CX_SOP            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DPK_CX_EOP            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DPK_CX_DATA           [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_DPK_CX_DVLD           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [   7:0]                s_DPK_CX_TAG            [p_CH_NM-1:0]   ;//(s)  [  8]
    wire        [  11:0]                s_DPK_CX_DCNT           [p_CH_NM-1:0]   ;//(s)  [ 12]

    wire                                s_REG_WR_REQ            [        3:0]   ;//(s)  [  1]
    wire                                s_REG_WR_ACK            [        3:0]   ;//(s)  [  1]
    wire        [  31:0]                s_REG_WR_DATA           [        3:0]   ;//(s)  [ 32]
    wire                                s_REG_RD_REQ            [        3:0]   ;//(s)  [  1]
    wire                                s_REG_RD_ACK            [        3:0]   ;//(s)  [  1]
    wire        [  31:0]                s_REG_RD_DATA           [        3:0]   ;//(s)  [ 32]
    wire        [  15:0]                s_REG_OP_ADDR           [        3:0]   ;//(s)  [ 16]

    wire                                s_DN_FILE_SOF           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_FILE_EOF           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_DN_FILE_VCH           [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_DN_FILE_ADDR          [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire        [  31:0]                s_DN_FILE_SIZE          [p_CH_NM-1:0]   ;//(s)  [ 32]

    wire                                s_DN_LBUF_RD_RDY        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_LBUF_RD_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DN_LBUF_RD_DATA       [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_DN_LBUF_RD_DVLD       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_LBUF_RD_SOP        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_LBUF_RD_EOP        [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_DN_DMA_INT            [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  15:0]                s_DN_DMA_RDY            [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  63:0]                s_DN_DMA_DATA           [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_DN_DMA_DVLD           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_DMA_SOF            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_DMA_EOF            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_DN_DMA_VCH            [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_DN_DMA_ADDR           [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire        [  31:0]                s_DN_DMA_SIZE           [p_CH_NM-1:0]   ;//(s)  [ 32]

    wire                                s_DN_LBUF_WR_RDY        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_LBUF_WR_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DN_LBUF_WR_DATA       [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_DN_LBUF_WR_DVLD       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_LBUF_WR_SOP        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_LBUF_WR_EOP        [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_DMA_WR_START          [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_DMA_WR_VCH            [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_DMA_WR_ADDR           [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_WR_SIZE           [p_CH_NM-1:0]   ;//(s)  [ 32]

    wire                                s_UP_DMA_RDY            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_UP_DMA_DATA           [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_UP_DMA_DVLD           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_DMA_SOF            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_DMA_EOF            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_UP_DMA_VCH            [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_UP_DMA_SIZE           [p_CH_NM-1:0]   ;//(s)  [ 32]

    wire                                s_UP_FILE_SOF           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_FILE_EOF           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_UP_FILE_VCH           [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_UP_FILE_ADDR          [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire        [  31:0]                s_UP_FILE_SIZE          [p_CH_NM-1:0]   ;//(s)  [ 32]

    wire                                s_DMA_RD_START          [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_DMA_RD_VCH            [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_DMA_RD_ADDR           [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_RD_SIZE           [p_CH_NM-1:0]   ;//(s)  [ 32]

    wire                                s_DMA_UP_RDY            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DMA_UP_DATA           [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_DMA_UP_DVLD           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DMA_UP_SOF            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DMA_UP_EOF            [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_DMA_UP_VCH            [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_DMA_UP_ADDR           [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_UP_SIZE           [p_CH_NM-1:0]   ;//(s)  [ 32]

    wire                                s_UP_LBUF_WR_RDY        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_UP_LBUF_WR_DATA       [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_UP_LBUF_WR_DVLD       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_WR_SOF        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_WR_EOF        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_UP_LBUF_WR_VCH        [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_UP_LBUF_WR_ADDR       [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire        [  31:0]                s_UP_LBUF_WR_FSZ        [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire                                s_UP_LBUF_WR_SOB        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_WR_EOB        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_UP_LBUF_WR_BSZ        [p_CH_NM-1:0]   ;//(s)  [ 16]

    wire                                s_UP_LBUF_RD_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_RD_ACK        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [   7:0]                s_UP_LBUF_RD_PSZ        [p_CH_NM-1:0]   ;//(s)  [  8]
    wire        [  15:0]                s_UP_LBUF_RD_BSZ        [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  31:0]                s_UP_LBUF_RD_FSZ        [p_CH_NM-1:0]   ;//(s)  [ 32]
    wire        [  15:0]                s_UP_LBUF_RD_VCH        [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire        [  63:0]                s_UP_LBUF_RD_DATA       [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire                                s_UP_LBUF_RD_DVLD       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_RD_SOP        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_RD_EOP        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_RD_SOB        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_RD_EOB        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_RD_SOF        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_LBUF_RD_EOF        [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_UEK_TXX_REQ           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UEK_TXX_ACK           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UEK_TXX_DVLD          [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_UEK_TXX_DATA          [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [   1:0]                s_UEK_TXX_MASK          [p_CH_NM-1:0]   ;//(s)  [  2]
    wire                                s_UEK_TXX_SOP           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UEK_TXX_EOP           [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_UFK_TXX_REQ           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UFK_TXX_ACK           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UFK_TXX_DVLD          [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_UFK_TXX_DATA          [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [   1:0]                s_UFK_TXX_MASK          [p_CH_NM-1:0]   ;//(s)  [  2]
    wire                                s_UFK_TXX_SOP           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UFK_TXX_EOP           [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_DEK_TXX_REQ           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DEK_TXX_ACK           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DEK_TXX_DVLD          [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DEK_TXX_DATA          [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [   1:0]                s_DEK_TXX_MASK          [p_CH_NM-1:0]   ;//(s)  [  2]
    wire                                s_DEK_TXX_SOP           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DEK_TXX_EOP           [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_DFK_TXX_REQ           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DFK_TXX_ACK           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DFK_TXX_DVLD          [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DFK_TXX_DATA          [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [   1:0]                s_DFK_TXX_MASK          [p_CH_NM-1:0]   ;//(s)  [  2]
    wire                                s_DFK_TXX_SOP           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DFK_TXX_EOP           [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_DPK_TXX_REQ           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DPK_TXX_ACK           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DPK_TXX_DVLD          [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DPK_TXX_DATA          [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [   1:0]                s_DPK_TXX_MASK          [p_CH_NM-1:0]   ;//(s)  [  2]
    wire                                s_DPK_TXX_SOP           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DPK_TXX_EOP           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DPK_TXX_END           [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_UPK_TXX_REQ           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UPK_TXX_ACK           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UPK_TXX_DVLD          [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_UPK_TXX_DATA          [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [   1:0]                s_UPK_TXX_MASK          [p_CH_NM-1:0]   ;//(s)  [  2]
    wire                                s_UPK_TXX_SOP           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UPK_TXX_END           [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UPK_TXX_EOP           [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_DN_EBUF_WR_TRIG       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DN_EBUF_WR_ADDR       [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [  23:0]                s_DN_EBUF_WR_SIZE       [p_CH_NM-1:0]   ;//(s)  [ 24]

    wire                                s_DN_FBUF_WR_RDY        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_FBUF_RD_ACK1       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_FBUF_RD_REQ0       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_FBUF_RD_REQ1       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_FBUF_RD_TRIG       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_DN_FBUF_RD_ADDR       [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [  23:0]                s_DN_FBUF_RD_SIZE       [p_CH_NM-1:0]   ;//(s)  [ 24]
    wire                                s_DN_FBUF_RD_AUTO       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [   8:0]                s_DN_FBUF_WR_DCNT       [p_CH_NM-1:0]   ;//(s)  [  9]

    wire                                s_DN_EBUF_WR_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  15:0]                s_DN_EBUF_WR_DATA       [p_CH_NM-1:0]   ;//(s)  [ 16]
    wire                                s_DN_FBUF_WR_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  95:0]                s_DN_FBUF_WR_DATA       [p_CH_NM-1:0]   ;//(s)  [ 96]
    wire                                s_DN_FBUF_RD_RDY        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_DN_FBUF_RD_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  95:0]                s_DN_FBUF_RD_DATA       [p_CH_NM-1:0]   ;//(s)  [ 96]

    wire                                s_UP_EBUF_WR_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  95:0]                s_UP_EBUF_WR_DATA       [p_CH_NM-1:0]   ;//(s)  [ 96]
    wire        [   8:0]                s_UP_EBUF_WR_DCNT       [p_CH_NM-1:0]   ;//(s)  [  9]
    wire                                s_UP_EBUF_WR_RDY        [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_UP_EBUF_RD_REQ0       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_EBUF_RD_REQ1       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_EBUF_RD_ACK1       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_EBUF_RD_TRIG       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_UP_EBUF_RD_ADDR       [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [  23:0]                s_UP_EBUF_RD_SIZE       [p_CH_NM-1:0]   ;//(s)  [ 24]
    wire                                s_UP_EBUF_RD_AUTO       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_EBUF_RD_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire                                s_UP_EBUF_RD_RDY        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  95:0]                s_UP_EBUF_RD_DATA       [p_CH_NM-1:0]   ;//(s)  [ 96]

    wire                                s_UP_FBUF_WR_TRIG       [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [  63:0]                s_UP_FBUF_WR_ADDR       [p_CH_NM-1:0]   ;//(s)  [ 64]
    wire        [  23:0]                s_UP_FBUF_WR_SIZE       [p_CH_NM-1:0]   ;//(s)  [ 24]
    wire                                s_UP_FBUF_WR_REQ        [p_CH_NM-1:0]   ;//(s)  [  1]
    wire        [ 127:0]                s_UP_FBUF_WR_DATA       [p_CH_NM-1:0]   ;//(s)  [128]
    wire                                s_UP_FBUF_WR_INT        [p_CH_NM-1:0]   ;//(s)  [  1]

    wire                                s_BUS_MSTR_EN                           ;//(s)  [  1]
    wire        [  15:0]                s_COMPLETER_ID                          ;//(s)  [ 16]

    wire        [  31:0]                s_REG_DEBUG2                            ;//(s)  [ 32]
    wire        [  31:0]                s_REG_DEBUG3                            ;//(s)  [ 32]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                               IO Port                                       ||
||                                                                             ||
/+=============================================================================*/

    assign  PCIE_SOFT_RST               = s_SOFT_RST                            ;

    assign  s_DN_DMA_RDY         [0]    = DMA_DN0_RDY                           ;
    assign  s_DN_DMA_RDY         [1]    = DMA_DN1_RDY                           ;

    assign  DMA_DN0_DATA                = s_DN_DMA_DATA       [0]               ;
    assign  DMA_DN0_DVLD                = s_DN_DMA_DVLD       [0]               ;
    assign  DMA_DN0_SOF                 = s_DN_DMA_SOF        [0]               ;
    assign  DMA_DN0_EOF                 = s_DN_DMA_EOF        [0]               ;
    assign  DMA_DN0_VCH                 = s_DN_DMA_VCH        [0]               ;
    assign  DMA_DN0_ADDR                = s_DN_DMA_ADDR       [0]               ;
    assign  DMA_DN0_SIZE                = s_DN_DMA_SIZE       [0]               ;

    assign  DMA_WR0_START                = s_DMA_WR_START     [0]               ;
    assign  DMA_WR0_VCH                  = s_DMA_WR_VCH       [0]               ;
    assign  DMA_WR0_ADDR                 = s_DMA_WR_ADDR      [0]               ;
    assign  DMA_WR0_SIZE                 = s_DMA_WR_SIZE      [0]               ;

    assign  DMA_DN1_DATA                = s_DN_DMA_DATA       [1]               ;
    assign  DMA_DN1_DVLD                = s_DN_DMA_DVLD       [1]               ;
    assign  DMA_DN1_SOF                 = s_DN_DMA_SOF        [1]               ;
    assign  DMA_DN1_EOF                 = s_DN_DMA_EOF        [1]               ;
    assign  DMA_DN1_VCH                 = s_DN_DMA_VCH        [1]               ;
    assign  DMA_DN1_ADDR                = s_DN_DMA_ADDR       [1]               ;
    assign  DMA_DN1_SIZE                = s_DN_DMA_SIZE       [1]               ;

    assign  DMA_WR1_START                = s_DMA_WR_START     [1]               ;
    assign  DMA_WR1_VCH                  = s_DMA_WR_VCH       [1]               ;
    assign  DMA_WR1_ADDR                 = s_DMA_WR_ADDR      [1]               ;
    assign  DMA_WR1_SIZE                 = s_DMA_WR_SIZE      [1]               ;

    assign  DMA_RD0_START                = s_DMA_RD_START     [0]               ;
    assign  DMA_RD0_VCH                  = s_DMA_RD_VCH       [0]               ;
    assign  DMA_RD0_ADDR                 = s_DMA_RD_ADDR      [0]               ;
    assign  DMA_RD0_SIZE                 = s_DMA_RD_SIZE      [0]               ;

    assign  DMA_RD1_START                = s_DMA_RD_START     [1]               ;
    assign  DMA_RD1_VCH                  = s_DMA_RD_VCH       [1]               ;
    assign  DMA_RD1_ADDR                 = s_DMA_RD_ADDR      [1]               ;
    assign  DMA_RD1_SIZE                 = s_DMA_RD_SIZE      [1]               ;

    assign  DMA_UP0_RDY                 = s_DMA_UP_RDY        [0]               ;
    assign  DMA_UP1_RDY                 = s_DMA_UP_RDY        [1]               ;

    assign  s_DMA_UP_DATA       [0]     = DMA_UP0_DATA                          ;
    assign  s_DMA_UP_DVLD       [0]     = DMA_UP0_DVLD                          ;
    assign  s_DMA_UP_SOF        [0]     = DMA_UP0_SOF                           ;
    assign  s_DMA_UP_EOF        [0]     = DMA_UP0_EOF                           ;
    assign  s_DMA_UP_VCH        [0]     = DMA_UP0_VCH                           ;
    assign  s_DMA_UP_SIZE       [0]     = DMA_UP0_SIZE                          ;
    assign  s_DMA_UP_ADDR       [0]     = DMA_UP0_ADDR                          ;

    assign  s_DMA_UP_DATA       [1]     = DMA_UP1_DATA                          ;
    assign  s_DMA_UP_DVLD       [1]     = DMA_UP1_DVLD                          ;
    assign  s_DMA_UP_SOF        [1]     = DMA_UP1_SOF                           ;
    assign  s_DMA_UP_EOF        [1]     = DMA_UP1_EOF                           ;
    assign  s_DMA_UP_VCH        [1]     = DMA_UP1_VCH                           ;
    assign  s_DMA_UP_SIZE       [1]     = DMA_UP1_SIZE                          ;
    assign  s_DMA_UP_ADDR       [1]     = DMA_UP1_ADDR                          ;

/*=============================================================================+/
||                                                                             ||
||                                     RX                                      ||
||                                                                             ||
/+=============================================================================*/

    PCIE_RX U_PCIE_RX (
        //system signals
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]

        //pcie core
//      .AXIS_RX_TDATA                              ( s_AXIS_RX_TDATA           ),//(i)  [ 64]
//      .AXIS_RX_TKEEP                              ( s_AXIS_RX_TKEEP           ),//(o)  [  8]
//      .AXIS_RX_TLAST                              ( s_AXIS_RX_TLAST           ),//(i)  [  1]
//      .AXIS_RX_TVALID                             ( s_AXIS_RX_TVALID          ),//(i)  [  1]
//      .AXIS_RX_TREADY                             ( s_AXIS_RX_TREADY          ),//(i)  [  1]
//      .AXIS_RX_TUSER                              ( s_AXIS_RX_TUSER           ),//(i)  [ 22]

        .AXIS_RX_TDATA                              ( AXIS_RX_TDATA             ),//(i)  [ 64]
        .AXIS_RX_TKEEP                              ( AXIS_RX_TKEEP             ),//(o)  [  8]
        .AXIS_RX_TLAST                              ( AXIS_RX_TLAST             ),//(i)  [  1]
        .AXIS_RX_TVALID                             ( AXIS_RX_TVALID            ),//(i)  [  1]
        .AXIS_RX_TREADY                             ( AXIS_RX_TREADY            ),//(i)  [  1]
        .AXIS_RX_TUSER                              ( AXIS_RX_TUSER             ),//(i)  [ 22]

        //pcie download cpld
        .BAR0_DN_CPLD_SOP                           ( s_BAR0_DN_CPLD_SOP        ),//(o)  [  1]
        .BAR0_DN_CPLD_EOP                           ( s_BAR0_DN_CPLD_EOP        ),//(o)  [  1]
        .BAR0_DN_CPLD_DATA                          ( s_BAR0_DN_CPLD_DATA       ),//(o)  [ 64]
        .BAR0_DN_CPLD_DVLD                          ( s_BAR0_DN_CPLD_DVLD       ),//(o)  [  1]
        .BAR0_DN_CPLD_TAG                           ( s_BAR0_DN_CPLD_TAG        ),//(o)  [  8]
        .BAR0_DN_CPLD_DCNT                          ( s_BAR0_DN_CPLD_DCNT       ),//(o)  [ 12]

        //pcie register
        .BAR0_REG_WR_REQ                            ( s_BAR0_REG_WR_REQ         ),//(i)  [  1]
        .BAR0_REG_RD_REQ                            ( s_BAR0_REG_RD_REQ         ),//(i)  [  1]
        .BAR0_REG_WR_OK                             ( s_BAR0_REG_WR_OK          ),//(o)  [  1]
        .BAR0_REG_RD_OK                             ( s_BAR0_REG_RD_OK          ),//(o)  [  1]
        .BAR0_REG_WR_DATA                           ( s_BAR0_REG_WR_DATA        ),//(o)  [ 32]
        .BAR0_REG_OP_ADDR                           ( s_BAR0_REG_OP_ADDR        ),//(o)  [ 64]

        //register packter buffer
        .BAR0_RX_FMT                                ( s_BAR0_RX_FMT             ),//(o)  [  7]
        .BAR0_RX_TC                                 ( s_BAR0_RX_TC              ),//(o)  [  3]
        .BAR0_RX_TD                                 ( s_BAR0_RX_TD              ),//(o)  [  1]
        .BAR0_RX_EP                                 ( s_BAR0_RX_EP              ),//(o)  [  1]
        .BAR0_RX_ATTR                               ( s_BAR0_RX_ATTR            ),//(o)  [  2]
        .BAR0_RX_LEN                                ( s_BAR0_RX_LEN             ),//(o)  [ 10]
        .BAR0_RX_RID                                ( s_BAR0_RX_RID             ),//(o)  [ 16]
        .BAR0_RX_RTAG                               ( s_BAR0_RX_RTAG            ),//(o)  [  8]
        .BAR0_RX_BE                                 ( s_BAR0_RX_BE              ) //(o)  [  8]
        );

/*=============================================================================+/
||                                                                             ||
||                                      TX                                     ||
||                                                                             ||
/+=============================================================================*/

    PCIE_TX U_PCIE_TX (
        //system signals
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        .PCIE_TX_EN                                 ( s_BUS_MSTR_EN             ),//(i)  [  1]
        //completion packet tx
        .CPK_TX_REQ                                 ( s_CPK_TX_REQ              ),//(i)  [  1]
        .CPK_TX_ACK                                 ( s_CPK_TX_ACK              ),//(o)  [  1]
        .CPK_TX_DVLD                                ( s_CPK_TX_DVLD             ),//(i)  [  1]
        .CPK_TX_DATA                                ( s_CPK_TX_DATA             ),//(i)  [ 64]
        .CPK_TX_MASK                                ( s_CPK_TX_MASK             ),//(i)  [  2]
        .CPK_TX_SOP                                 ( s_CPK_TX_SOP              ),//(i)  [  1]
        .CPK_TX_EOP                                 ( s_CPK_TX_EOP              ),//(i)  [  1]
        //completion packet tx
        .UEK_TX_REQ                                 ( s_UEK_TX_REQ              ),//(i)  [  1]
        .UEK_TX_ACK                                 ( s_UEK_TX_ACK              ),//(o)  [  1]
        .UEK_TX_DVLD                                ( s_UEK_TX_DVLD             ),//(i)  [  1]
        .UEK_TX_DATA                                ( s_UEK_TX_DATA             ),//(i)  [ 64]
        .UEK_TX_MASK                                ( s_UEK_TX_MASK             ),//(i)  [  2]
        .UEK_TX_SOP                                 ( s_UEK_TX_SOP              ),//(i)  [  1]
        .UEK_TX_EOP                                 ( s_UEK_TX_EOP              ),//(i)  [  1]
        //completion packet tx
        .UFK_TX_REQ                                 ( s_UFK_TX_REQ              ),//(i)  [  1]
        .UFK_TX_ACK                                 ( s_UFK_TX_ACK              ),//(o)  [  1]
        .UFK_TX_DVLD                                ( s_UFK_TX_DVLD             ),//(i)  [  1]
        .UFK_TX_DATA                                ( s_UFK_TX_DATA             ),//(i)  [ 64]
        .UFK_TX_MASK                                ( s_UFK_TX_MASK             ),//(i)  [  2]
        .UFK_TX_SOP                                 ( s_UFK_TX_SOP              ),//(i)  [  1]
        .UFK_TX_EOP                                 ( s_UFK_TX_EOP              ),//(i)  [  1]
        //completion packet tx
        .DEK_TX_REQ                                 ( s_DEK_TX_REQ              ),//(i)  [  1]
        .DEK_TX_ACK                                 ( s_DEK_TX_ACK              ),//(o)  [  1]
        .DEK_TX_DVLD                                ( s_DEK_TX_DVLD             ),//(i)  [  1]
        .DEK_TX_DATA                                ( s_DEK_TX_DATA             ),//(i)  [ 64]
        .DEK_TX_MASK                                ( s_DEK_TX_MASK             ),//(i)  [  2]
        .DEK_TX_SOP                                 ( s_DEK_TX_SOP              ),//(i)  [  1]
        .DEK_TX_EOP                                 ( s_DEK_TX_EOP              ),//(i)  [  1]
        //completion packet tx
        .DFK_TX_REQ                                 ( s_DFK_TX_REQ              ),//(i)  [  1]
        .DFK_TX_ACK                                 ( s_DFK_TX_ACK              ),//(o)  [  1]
        .DFK_TX_DVLD                                ( s_DFK_TX_DVLD             ),//(i)  [  1]
        .DFK_TX_DATA                                ( s_DFK_TX_DATA             ),//(i)  [ 64]
        .DFK_TX_MASK                                ( s_DFK_TX_MASK             ),//(i)  [  2]
        .DFK_TX_SOP                                 ( s_DFK_TX_SOP              ),//(i)  [  1]
        .DFK_TX_EOP                                 ( s_DFK_TX_EOP              ),//(i)  [  1]
        //channel packet tx
        .UPK_TX_REQ                                 ( s_UPK_TX_REQ              ),//(i)  [  1]
        .UPK_TX_ACK                                 ( s_UPK_TX_ACK              ),//(o)  [  1]
        .UPK_TX_DVLD                                ( s_UPK_TX_DVLD             ),//(i)  [  1]
        .UPK_TX_DATA                                ( s_UPK_TX_DATA             ),//(i)  [ 64]
        .UPK_TX_MASK                                ( s_UPK_TX_MASK             ),//(i)  [  2]
        .UPK_TX_SOP                                 ( s_UPK_TX_SOP              ),//(i)  [  1]
        .UPK_TX_EOP                                 ( s_UPK_TX_EOP              ),//(i)  [  1]
        .UPK_TX_END                                 ( s_UPK_TX_END              ),//(i)  [  1]
        //channel packet tx
        .DPK_TX_REQ                                 ( s_DPK_TX_REQ              ),//(i)  [  1]
        .DPK_TX_ACK                                 ( s_DPK_TX_ACK              ),//(o)  [  1]
        .DPK_TX_DVLD                                ( s_DPK_TX_DVLD             ),//(i)  [  1]
        .DPK_TX_DATA                                ( s_DPK_TX_DATA             ),//(i)  [ 64]
        .DPK_TX_MASK                                ( s_DPK_TX_MASK             ),//(i)  [  2]
        .DPK_TX_SOP                                 ( s_DPK_TX_SOP              ),//(i)  [  1]
        .DPK_TX_EOP                                 ( s_DPK_TX_EOP              ),//(i)  [  1]
        .DPK_TX_END                                 ( s_DPK_TX_END              ),//(i)  [  1]
        //pcie core
        .AXIS_TX_TDATA                              (   AXIS_TX_TDATA           ),//(i)  [  1]
        .AXIS_TX_TKEEP                              (   AXIS_TX_TKEEP           ),//(o)  [  1]
        .AXIS_TX_TVALID                             (   AXIS_TX_TVALID          ),//(o)  [  1]
        .AXIS_TX_TLAST                              (   AXIS_TX_TLAST           ),//(o)  [ 64]
        .AXIS_TX_TREADY                             (   AXIS_TX_TREADY          ),//(o)  [  2]
        .AXIS_TX_TUSER                              (   AXIS_TX_TUSER           ) //(o)  [  1]
        );

/*=============================================================================+/
||                                                                             ||
||                                   PCIE REG                                  ||
||                                                                             ||
/+=============================================================================*/

    PCIE_REG_IF U_PCIE_REG_IF (
        //system signals
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //PCIE RX interface
        .PCIE_WR_REQ                                ( s_BAR0_REG_WR_REQ         ),//(i)  [  1]
        .PCIE_RD_REQ                                ( s_BAR0_REG_RD_REQ         ),//(i)  [  1]
        .PCIE_WR_DATA                               ( s_BAR0_REG_WR_DATA        ),//(i)  [ 32]
        .PCIE_OP_ADDR                               ( s_BAR0_REG_OP_ADDR        ),//(i)  [ 64]
        .PCIE_RD_DATA                               ( s_BAR0_REG_RD_DATA        ),//(o)  [ 32]
        .PCIE_WR_ACK                                ( s_BAR0_REG_WR_OK          ),//(o)  [  1]
        .PCIE_RD_ACK                                ( s_BAR0_REG_RD_ACK         ),//(o)  [  1]
        //REG CTRL interface
        .REG0_WR_REQ                                ( s_REG_WR_REQ         [0]  ),//(o)  [  1]
        .REG0_WR_ACK                                ( s_REG_WR_ACK         [0]  ),//(i)  [  1]
        .REG0_WR_DATA                               ( s_REG_WR_DATA        [0]  ),//(o)  [ 32]
        .REG0_RD_REQ                                ( s_REG_RD_REQ         [0]  ),//(o)  [  1]
        .REG0_RD_ACK                                ( s_REG_RD_ACK         [0]  ),//(i)  [  1]
        .REG0_RD_DATA                               ( s_REG_RD_DATA        [0]  ),//(i)  [ 32]
        .REG0_OP_ADDR                               ( s_REG_OP_ADDR        [0]  ),//(o)  [ 16]

        .REG1_WR_REQ                                ( s_REG_WR_REQ         [1]  ),//(o)  [  1]
        .REG1_WR_ACK                                ( s_REG_WR_ACK         [1]  ),//(i)  [  1]
        .REG1_WR_DATA                               ( s_REG_WR_DATA        [1]  ),//(o)  [ 32]
        .REG1_RD_REQ                                ( s_REG_RD_REQ         [1]  ),//(o)  [  1]
        .REG1_RD_ACK                                ( s_REG_RD_ACK         [1]  ),//(i)  [  1]
        .REG1_RD_DATA                               ( s_REG_RD_DATA        [1]  ),//(i)  [ 32]
        .REG1_OP_ADDR                               ( s_REG_OP_ADDR        [1]  ),//(o)  [ 16]

        .REG2_WR_REQ                                ( s_REG_WR_REQ         [2]  ),//(o)  [  1]
        .REG2_WR_ACK                                ( s_REG_WR_ACK         [2]  ),//(i)  [  1]
        .REG2_WR_DATA                               ( s_REG_WR_DATA        [2]  ),//(o)  [ 32]
        .REG2_RD_REQ                                ( s_REG_RD_REQ         [2]  ),//(o)  [  1]
        .REG2_RD_ACK                                ( s_REG_RD_ACK         [2]  ),//(i)  [  1]
        .REG2_RD_DATA                               ( s_REG_RD_DATA        [2]  ),//(i)  [ 32]
        .REG2_OP_ADDR                               ( s_REG_OP_ADDR        [2]  ),//(o)  [ 16]

        .REG3_WR_REQ                                (   REG3_WR_REQ             ),//(o)  [  1]
        .REG3_WR_ACK                                (   REG3_WR_ACK             ),//(i)  [  1]
        .REG3_WR_DATA                               (   REG3_WR_DATA            ),//(o)  [ 32]
        .REG3_RD_REQ                                (   REG3_RD_REQ             ),//(o)  [  1]
        .REG3_RD_ACK                                (   REG3_RD_ACK             ),//(i)  [  1]
        .REG3_RD_DATA                               (   REG3_RD_DATA            ),//(i)  [ 32]
        .REG3_OP_ADDR                               (   REG3_OP_ADDR            ),//(o)  [ 16]

        .REG4_WR_REQ                                (   REG4_WR_REQ             ),//(o)  [  1]
        .REG4_WR_ACK                                (   REG4_WR_ACK             ),//(i)  [  1]
        .REG4_WR_DATA                               (   REG4_WR_DATA            ),//(o)  [ 32]
        .REG4_RD_REQ                                (   REG4_RD_REQ             ),//(o)  [  1]
        .REG4_RD_ACK                                (   REG4_RD_ACK             ),//(i)  [  1]
        .REG4_RD_DATA                               (   REG4_RD_DATA            ),//(i)  [ 32]
        .REG4_OP_ADDR                               (   REG4_OP_ADDR            ),//(o)  [ 16]

        .REG5_WR_REQ                                (   REG5_WR_REQ             ),//(o)  [  1]
        .REG5_WR_ACK                                (   REG5_WR_ACK             ),//(i)  [  1]
        .REG5_WR_DATA                               (   REG5_WR_DATA            ),//(o)  [ 32]
        .REG5_RD_REQ                                (   REG5_RD_REQ             ),//(o)  [  1]
        .REG5_RD_ACK                                (   REG5_RD_ACK             ),//(i)  [  1]
        .REG5_RD_DATA                               (   REG5_RD_DATA            ),//(i)  [ 32]
        .REG5_OP_ADDR                               (   REG5_OP_ADDR            ),//(o)  [ 16]

        .REG6_WR_REQ                                (   REG6_WR_REQ             ),//(o)  [  1]
        .REG6_WR_ACK                                (   REG6_WR_ACK             ),//(i)  [  1]
        .REG6_WR_DATA                               (   REG6_WR_DATA            ),//(o)  [ 32]
        .REG6_RD_REQ                                (   REG6_RD_REQ             ),//(o)  [  1]
        .REG6_RD_ACK                                (   REG6_RD_ACK             ),//(i)  [  1]
        .REG6_RD_DATA                               (   REG6_RD_DATA            ),//(i)  [ 32]
        .REG6_OP_ADDR                               (   REG6_OP_ADDR            ),//(o)  [ 16]

        .REG7_WR_REQ                                ( s_REG_WR_REQ         [3]  ),//(o)  [  1]
        .REG7_WR_ACK                                ( s_REG_WR_REQ         [3]  ),//(i)  [  1]
        .REG7_WR_DATA                               (                           ),//(o)  [ 32]
        .REG7_RD_REQ                                ( s_REG_RD_REQ         [3]  ),//(o)  [  1]
        .REG7_RD_ACK                                ( s_REG_RD_REQ         [3]  ),//(i)  [  1]
        .REG7_RD_DATA                               ( 32'd0                     ),//(i)  [ 32]
        .REG7_OP_ADDR                               (                           ) //(o)  [ 16]
        );

    PCIE_REG_ACK U_PCIE_REG_ACK (
        //system signals
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //register control
        .REG_RD_REQ                                 ( s_BAR0_REG_RD_REQ         ),//(i)  [  1]
        .REG_RD_ACK                                 ( s_BAR0_REG_RD_ACK         ),//(i)  [  1]
        .REG_RD_OK                                  ( s_BAR0_REG_RD_OK          ),//(o)  [  1]
        .REG_RD_DATA                                ( s_BAR0_REG_RD_DATA        ),//(i)  [ 32]
        .REG_OP_ADDR                                ( s_BAR0_REG_OP_ADDR        ),//(i)  [ 64]
        //PCIE core
        .RX_FMT                                     ( s_BAR0_RX_FMT             ),//(i)  [  7]
        .RX_TC                                      ( s_BAR0_RX_TC              ),//(i)  [  3]
        .RX_TD                                      ( s_BAR0_RX_TD              ),//(i)  [  1]
        .RX_EP                                      ( s_BAR0_RX_EP              ),//(i)  [  1]
        .RX_ATTR                                    ( s_BAR0_RX_ATTR            ),//(i)  [  2]
        .RX_LEN                                     ( s_BAR0_RX_LEN             ),//(i)  [ 10]
        .RX_RID                                     ( s_BAR0_RX_RID             ),//(i)  [ 16]
        .RX_RTAG                                    ( s_BAR0_RX_RTAG            ),//(i)  [  8]
        .RX_BE                                      ( s_BAR0_RX_BE              ),//(i)  [  8]
        .COMPLETER_ID                               ( s_COMPLETER_ID            ),//(i)  [ 13]
        //completion tx
        .CPK_TX_REQ                                 ( s_CPK_TX_REQ              ),//(o)  [  1]
        .CPK_TX_ACK                                 ( s_CPK_TX_ACK              ),//(i)  [  1]
        .CPK_TX_DATA                                ( s_CPK_TX_DATA             ),//(o)  [ 64]
        .CPK_TX_MASK                                ( s_CPK_TX_MASK             ),//(o)  [  2]
        .CPK_TX_DVLD                                ( s_CPK_TX_DVLD             ),//(o)  [  1]
        .CPK_TX_SOP                                 ( s_CPK_TX_SOP              ),//(o)  [  1]
        .CPK_TX_EOP                                 ( s_CPK_TX_EOP              ) //(o)  [  1]
        );

    PCIE_REG_INT U_PCIE_REG_INT (
        //system signals
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //register if
        .REG_WR_REQ                                 ( s_REG_WR_REQ         [0]  ),//(i)  [  1]
        .REG_RD_REQ                                 ( s_REG_RD_REQ         [0]  ),//(i)  [  1]
        .REG_WR_ACK                                 ( s_REG_WR_ACK         [0]  ),//(o)  [  1]
        .REG_RD_ACK                                 ( s_REG_RD_ACK         [0]  ),//(o)  [  1]
        .REG_WR_DATA                                ( s_REG_WR_DATA        [0]  ),//(i)  [ 32]
        .REG_RD_DATA                                ( s_REG_RD_DATA        [0]  ),//(o)  [ 32]
        .REG_OP_ADDR                                ( s_REG_OP_ADDR        [0]  ),//(i)  [ 16]
        //system
        .SOFT_RST                                   ( s_SOFT_RST                ),//(o)  [  1]
        .PCIE_INT_0                                 ( s_DN_DMA_INT         [0]  ),//(i)  [  1]
        .PCIE_INT_1                                 ( s_DN_DMA_INT         [1]  ),//(i)  [  1]
        .PCIE_INT_2                                 ( s_UP_FBUF_WR_INT     [0]  ),//(i)  [  1]
        .PCIE_INT_3                                 ( s_UP_FBUF_WR_INT     [1]  ),//(i)  [  1]
        .PCIE_INT_4                                 ( PCIE_INT_0                ),//(i)  [  1]
        .PCIE_INT_5                                 ( PCIE_INT_1                ),//(i)  [  1]
        .PCIE_INT_6                                 ( PCIE_INT_2                ),//(i)  [  1]
        .PCIE_INT_7                                 ( PCIE_INT_3                ),//(i)  [  1]
        .PCIE_INT_ACT                               ( s_PCIE_INT_ACT            ),//(o)  [  8]
        .PCIE_INT_CLR                               ( s_PCIE_INT_CLR            ),//(o)  [  1]
        //debug
        .REG_DEBUG0                                 ( s_REG_DEBUG2              ),//(i)  [ 32]
        .REG_DEBUG1                                 ( s_REG_DEBUG3              ),//(i)  [ 32]
        .REG_DEBUG2                                 ( s_REG_DEBUG2              ),//(o)  [ 32]
        .REG_DEBUG3                                 ( s_REG_DEBUG3              ) //(o)  [ 32]
        );

    PCIE_DN_REG U_PCIE_DN_REG (
        //system signals
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
        //register interface
        .REG_WR_REQ                                 ( s_REG_WR_REQ         [1]  ),//(i)  [  1]
        .REG_RD_REQ                                 ( s_REG_RD_REQ         [1]  ),//(i)  [  1]
        .REG_WR_ACK                                 ( s_REG_WR_ACK         [1]  ),//(o)  [  1]
        .REG_RD_ACK                                 ( s_REG_RD_ACK         [1]  ),//(o)  [  1]
        .REG_WR_DATA                                ( s_REG_WR_DATA        [1]  ),//(i)  [ 32]
        .REG_RD_DATA                                ( s_REG_RD_DATA        [1]  ),//(o)  [ 32]
        .REG_OP_ADDR                                ( s_REG_OP_ADDR        [1]  ),//(i)  [ 16]
        //full buffer
        .DN0_EBUF_WR_TRIG                           ( s_DN_EBUF_WR_TRIG    [0]  ),//(o)  [  1]
        .DN0_EBUF_WR_ADDR                           ( s_DN_EBUF_WR_ADDR    [0]  ),//(o)  [ 64]
        .DN0_EBUF_WR_SIZE                           ( s_DN_EBUF_WR_SIZE    [0]  ),//(o)  [ 24]

        .DN1_EBUF_WR_TRIG                           ( s_DN_EBUF_WR_TRIG    [1]  ),//(o)  [  1]
        .DN1_EBUF_WR_ADDR                           ( s_DN_EBUF_WR_ADDR    [1]  ),//(o)  [ 64]
        .DN1_EBUF_WR_SIZE                           ( s_DN_EBUF_WR_SIZE    [1]  ),//(o)  [ 24]
        //empty buffer
        .DN0_FBUF_RD_REQ                            ( s_DN_FBUF_RD_REQ0    [0]  ),//(o)  [  1]
        .DN0_FBUF_RD_TRIG                           ( s_DN_FBUF_RD_TRIG    [0]  ),//(o)  [  1]
        .DN0_FBUF_RD_ADDR                           ( s_DN_FBUF_RD_ADDR    [0]  ),//(o)  [ 64]
        .DN0_FBUF_RD_SIZE                           ( s_DN_FBUF_RD_SIZE    [0]  ),//(o)  [ 24]
        .DN0_FBUF_RD_AUTO                           ( s_DN_FBUF_RD_AUTO    [0]  ),//(o)  [  1]
        .DN0_FBUF_WR_DCNT                           ( s_DN_FBUF_WR_DCNT    [0]  ),//(i)  [ 32]

        .DN1_FBUF_RD_REQ                            ( s_DN_FBUF_RD_REQ0    [1]  ),//(o)  [  1]
        .DN1_FBUF_RD_TRIG                           ( s_DN_FBUF_RD_TRIG    [1]  ),//(o)  [  1]
        .DN1_FBUF_RD_ADDR                           ( s_DN_FBUF_RD_ADDR    [1]  ),//(o)  [ 64]
        .DN1_FBUF_RD_SIZE                           ( s_DN_FBUF_RD_SIZE    [1]  ),//(o)  [ 24]
        .DN1_FBUF_RD_AUTO                           ( s_DN_FBUF_RD_AUTO    [1]  ),//(o)  [  1]
        .DN1_FBUF_WR_DCNT                           ( s_DN_FBUF_WR_DCNT    [1]  ) //(i)  [ 32]
        );

    PCIE_UP_REG U_PCIE_UP_REG (
        //system signals
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
        //register interface
        .REG_WR_REQ                                 ( s_REG_WR_REQ         [2]  ),//(i)  [  1]
        .REG_RD_REQ                                 ( s_REG_RD_REQ         [2]  ),//(i)  [  1]
        .REG_WR_ACK                                 ( s_REG_WR_ACK         [2]  ),//(o)  [  1]
        .REG_RD_ACK                                 ( s_REG_RD_ACK         [2]  ),//(o)  [  1]
        .REG_WR_DATA                                ( s_REG_WR_DATA        [2]  ),//(i)  [ 32]
        .REG_RD_DATA                                ( s_REG_RD_DATA        [2]  ),//(o)  [ 32]
        .REG_OP_ADDR                                ( s_REG_OP_ADDR        [2]  ),//(i)  [ 16]
        //full buffer
        .UP0_FBUF_WR_TRIG                           ( s_UP_FBUF_WR_TRIG    [0]  ),//(o)  [  1]
        .UP0_FBUF_WR_ADDR                           ( s_UP_FBUF_WR_ADDR    [0]  ),//(o)  [ 64]
        .UP0_FBUF_WR_SIZE                           ( s_UP_FBUF_WR_SIZE    [0]  ),//(o)  [ 24]

        .UP1_FBUF_WR_TRIG                           ( s_UP_FBUF_WR_TRIG    [1]  ),//(o)  [  1]
        .UP1_FBUF_WR_ADDR                           ( s_UP_FBUF_WR_ADDR    [1]  ),//(o)  [ 64]
        .UP1_FBUF_WR_SIZE                           ( s_UP_FBUF_WR_SIZE    [1]  ),//(o)  [ 24]
        //empty buffer
        .UP0_EBUF_RD_REQ                            ( s_UP_EBUF_RD_REQ0    [0]  ),//(o)  [  1]
        .UP0_EBUF_RD_TRIG                           ( s_UP_EBUF_RD_TRIG    [0]  ),//(o)  [  1]
        .UP0_EBUF_RD_ADDR                           ( s_UP_EBUF_RD_ADDR    [0]  ),//(o)  [ 64]
        .UP0_EBUF_RD_SIZE                           ( s_UP_EBUF_RD_SIZE    [0]  ),//(o)  [ 24]
        .UP0_EBUF_RD_AUTO                           ( s_UP_EBUF_RD_AUTO    [0]  ),//(o)  [  1]
        .UP0_EBUF_WR_DCNT                           ( s_UP_EBUF_WR_DCNT    [0]  ),//(i)  [ 32]

        .UP1_EBUF_RD_REQ                            ( s_UP_EBUF_RD_REQ0    [1]  ),//(o)  [  1]
        .UP1_EBUF_RD_TRIG                           ( s_UP_EBUF_RD_TRIG    [1]  ),//(o)  [  1]
        .UP1_EBUF_RD_ADDR                           ( s_UP_EBUF_RD_ADDR    [1]  ),//(o)  [ 64]
        .UP1_EBUF_RD_SIZE                           ( s_UP_EBUF_RD_SIZE    [1]  ),//(o)  [ 24]
        .UP1_EBUF_RD_AUTO                           ( s_UP_EBUF_RD_AUTO    [1]  ),//(o)  [  1]
        .UP1_EBUF_WR_DCNT                           ( s_UP_EBUF_WR_DCNT    [1]  ) //(i)  [ 32]
        );

/*============================================================================+/
||                                                                            ||
||                                  CPLD                                      ||
||                                                                            ||
/+============================================================================*/

    PCIE_DN_CPLD_IF U_PCIE_DN_CPLD_IF (
         //system signals
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
         //cpld
        .DN_CPLD_SOP                                ( s_BAR0_DN_CPLD_SOP        ),//(i)  [  1]
        .DN_CPLD_EOP                                ( s_BAR0_DN_CPLD_EOP        ),//(i)  [  1]
        .DN_CPLD_DATA                               ( s_BAR0_DN_CPLD_DATA       ),//(i)  [ 64]
        .DN_CPLD_DVLD                               ( s_BAR0_DN_CPLD_DVLD       ),//(i)  [  1]
        .DN_CPLD_TAG                                ( s_BAR0_DN_CPLD_TAG        ),//(i)  [  8]
        .DN_CPLD_DCNT                               ( s_BAR0_DN_CPLD_DCNT       ),//(i)  [ 12]
         //user if
        .DFK_C0_SOP                                 ( s_DFK_CX_SOP         [0]  ),//(i)  [  1]
        .DFK_C0_EOP                                 ( s_DFK_CX_EOP         [0]  ),//(i)  [  1]
        .DFK_C0_DATA                                ( s_DFK_CX_DATA        [0]  ),//(i)  [ 64]
        .DFK_C0_DVLD                                ( s_DFK_CX_DVLD        [0]  ),//(i)  [  1]
        .DFK_C0_TAG                                 ( s_DFK_CX_TAG         [0]  ),//(i)  [  8]
        .DFK_C0_DCNT                                ( s_DFK_CX_DCNT        [0]  ),//(i)  [ 12]

        .DFK_C1_SOP                                 ( s_DFK_CX_SOP         [1]  ),//(i)  [  1]
        .DFK_C1_EOP                                 ( s_DFK_CX_EOP         [1]  ),//(i)  [  1]
        .DFK_C1_DATA                                ( s_DFK_CX_DATA        [1]  ),//(i)  [ 64]
        .DFK_C1_DVLD                                ( s_DFK_CX_DVLD        [1]  ),//(i)  [  1]
        .DFK_C1_TAG                                 ( s_DFK_CX_TAG         [1]  ),//(i)  [  8]
        .DFK_C1_DCNT                                ( s_DFK_CX_DCNT        [1]  ),//(i)  [ 12]

        .UEK_C0_SOP                                 ( s_UEK_CX_SOP         [0]  ),//(i)  [  1]
        .UEK_C0_EOP                                 ( s_UEK_CX_EOP         [0]  ),//(i)  [  1]
        .UEK_C0_DATA                                ( s_UEK_CX_DATA        [0]  ),//(i)  [ 64]
        .UEK_C0_DVLD                                ( s_UEK_CX_DVLD        [0]  ),//(i)  [  1]
        .UEK_C0_TAG                                 ( s_UEK_CX_TAG         [0]  ),//(i)  [  8]
        .UEK_C0_DCNT                                ( s_UEK_CX_DCNT        [0]  ),//(i)  [ 12]

        .UEK_C1_SOP                                 ( s_UEK_CX_SOP         [1]  ),//(i)  [  1]
        .UEK_C1_EOP                                 ( s_UEK_CX_EOP         [1]  ),//(i)  [  1]
        .UEK_C1_DATA                                ( s_UEK_CX_DATA        [1]  ),//(i)  [ 64]
        .UEK_C1_DVLD                                ( s_UEK_CX_DVLD        [1]  ),//(i)  [  1]
        .UEK_C1_TAG                                 ( s_UEK_CX_TAG         [1]  ),//(i)  [  8]
        .UEK_C1_DCNT                                ( s_UEK_CX_DCNT        [1]  ),//(i)  [ 12]

        .DPK_C0_SOP                                 ( s_DPK_CX_SOP         [0]  ),//(i)  [  1]
        .DPK_C0_EOP                                 ( s_DPK_CX_EOP         [0]  ),//(i)  [  1]
        .DPK_C0_DATA                                ( s_DPK_CX_DATA        [0]  ),//(i)  [ 64]
        .DPK_C0_DVLD                                ( s_DPK_CX_DVLD        [0]  ),//(i)  [  1]
        .DPK_C0_TAG                                 ( s_DPK_CX_TAG         [0]  ),//(i)  [  8]
        .DPK_C0_DCNT                                ( s_DPK_CX_DCNT        [0]  ),//(i)  [ 12]

        .DPK_C1_SOP                                 ( s_DPK_CX_SOP         [1]  ),//(i)  [  1]
        .DPK_C1_EOP                                 ( s_DPK_CX_EOP         [1]  ),//(i)  [  1]
        .DPK_C1_DATA                                ( s_DPK_CX_DATA        [1]  ),//(i)  [ 64]
        .DPK_C1_DVLD                                ( s_DPK_CX_DVLD        [1]  ),//(i)  [  1]
        .DPK_C1_TAG                                 ( s_DPK_CX_TAG         [1]  ),//(i)  [  8]
        .DPK_C1_DCNT                                ( s_DPK_CX_DCNT        [1]  ) //(i)  [ 12]
        );

/*============================================================================+/
||                                                                            ||
||                Down Load User Interface & Loacl Buffer                     ||
||                                                                            ||
/+============================================================================*/

    genvar i ;
    generate
    for (i=0 ; i<=p_CH_NM-1 ; i=i+1) begin : GROUP_DN

        PCIE_DN_IF U_PCIE_DN_IF (
            .PCIE_CLK                               (   PCIE_CLK                ),//(i)  [  1]
            .PCIE_RST                               (   PCIE_RST | s_SOFT_RST   ),//(i)  [  1]
            .USER_CLK                               (   USER_CLK                ),//(i)  [  1]
            .USER_RST                               (   USER_RST | s_SOFT_RST   ),//(i)  [  1]

            .DN_FILE_SOF                            ( s_DN_FILE_SOF        [i]  ),//(i)  [  1]
            .DN_FILE_EOF                            ( s_DN_FILE_EOF        [i]  ),//(i)  [  1]
            .DN_FILE_VCH                            ( s_DN_FILE_VCH        [i]  ),//(i)  [  8]
            .DN_FILE_ADDR                           ( s_DN_FILE_ADDR       [i]  ),//(i)  [ 32]
            .DN_FILE_SIZE                           ( s_DN_FILE_SIZE       [i]  ),//(i)  [ 32]

            .DN_LBUF_RD_RDY                         ( s_DN_LBUF_RD_RDY     [i]  ),//(i)  [  1]
            .DN_LBUF_RD_REQ                         ( s_DN_LBUF_RD_REQ     [i]  ),//(o)  [  1]
            .DN_LBUF_RD_DATA                        ( s_DN_LBUF_RD_DATA    [i]  ),//(i)  [ 64]
            .DN_LBUF_RD_DVLD                        ( s_DN_LBUF_RD_DVLD    [i]  ),//(i)  [  1]
            .DN_LBUF_RD_SOP                         ( s_DN_LBUF_RD_SOP     [i]  ),//(i)  [  1]
            .DN_LBUF_RD_EOP                         ( s_DN_LBUF_RD_EOP     [i]  ),//(i)  [  1]

            .DMA_DN_INT                             ( s_DN_DMA_INT         [i]  ),//(i)  [ 16]
            .DMA_DN_RDY                             ( s_DN_DMA_RDY         [i]  ),//(i)  [ 16]
            .DMA_DN_DATA                            ( s_DN_DMA_DATA        [i]  ),//(o)  [ 64]
            .DMA_DN_DVLD                            ( s_DN_DMA_DVLD        [i]  ),//(o)  [  1]
            .DMA_DN_SOF                             ( s_DN_DMA_SOF         [i]  ),//(o)  [  1]
            .DMA_DN_EOF                             ( s_DN_DMA_EOF         [i]  ),//(o)  [  1]
            .DMA_DN_VCH                             ( s_DN_DMA_VCH         [i]  ),//(o)  [ 16]
            .DMA_DN_ADDR                            ( s_DN_DMA_ADDR        [i]  ),//(o)  [ 32]
            .DMA_DN_SIZE                            ( s_DN_DMA_SIZE        [i]  ),//(o)  [ 32]

            .DMA_WR_START                           ( s_DMA_WR_START       [i]  ),//(o)  [  1]
            .DMA_WR_VCH                             ( s_DMA_WR_VCH         [i]  ),//(o)  [ 16]
            .DMA_WR_ADDR                            ( s_DMA_WR_ADDR        [i]  ),//(o)  [ 32]
            .DMA_WR_SIZE                            ( s_DMA_WR_SIZE        [i]  ) //(o)  [ 32]

            );

        PCIE_DN_LBUF U_PCIE_DN_LBUF (
            .PCIE_CLK                               (   PCIE_CLK                ),//(i)  [  1]
            .PCIE_RST                               (   PCIE_RST | s_SOFT_RST   ),//(i)  [  1]
            .USER_CLK                               (   USER_CLK                ),//(i)  [  1]
            .USER_RST                               (   USER_RST | s_SOFT_RST   ),//(i)  [  1]

            .DN_LBUF_WR_RDY                         ( s_DN_LBUF_WR_RDY     [i]  ),//(o)  [  1]
            .DN_LBUF_WR_REQ                         ( s_DN_LBUF_WR_REQ     [i]  ),//(i)  [  1]
            .DN_LBUF_WR_DATA                        ( s_DN_LBUF_WR_DATA    [i]  ),//(i)  [ 64]
            .DN_LBUF_WR_DVLD                        ( s_DN_LBUF_WR_DVLD    [i]  ),//(i)  [  1]
            .DN_LBUF_WR_SOP                         ( s_DN_LBUF_WR_SOP     [i]  ),//(i)  [  1]
            .DN_LBUF_WR_EOP                         ( s_DN_LBUF_WR_EOP     [i]  ),//(i)  [  1]

            .DN_LBUF_RD_RDY                         ( s_DN_LBUF_RD_RDY     [i]  ),//(o)  [  1]
            .DN_LBUF_RD_REQ                         ( s_DN_LBUF_RD_REQ     [i]  ),//(i)  [  1]
            .DN_LBUF_RD_DATA                        ( s_DN_LBUF_RD_DATA    [i]  ),//(o)  [ 64]
            .DN_LBUF_RD_DVLD                        ( s_DN_LBUF_RD_DVLD    [i]  ),//(o)  [  1]
            .DN_LBUF_RD_SOP                         ( s_DN_LBUF_RD_SOP     [i]  ),//(o)  [  1]
            .DN_LBUF_RD_EOP                         ( s_DN_LBUF_RD_EOP     [i]  ) //(o)  [  1]
            );

        PCIE_DN_DFK # (
            .p_CH_ID                                ( p_CH_ID[i]                ) //(p)  [  1]
            )
        U_PCIE_DN_DFK (
            //system
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
            //register
            .COMPLETER_ID                           ( s_COMPLETER_ID            ),//(i)  [ 13]
            .DN_FBUF_WR_RDY                         ( s_DN_FBUF_WR_RDY      [i] ),//(i)  [  1]
            .DN_FBUF_RD_REQ0                        ( s_DN_FBUF_RD_REQ0     [i] ),//(i)  [  1]
            .DN_FBUF_RD_REQ1                        ( s_DN_FBUF_RD_REQ1     [i] ),//(i)  [  1]
            .DN_FBUF_RD_ACK1                        ( s_DN_FBUF_RD_ACK1     [i] ),//(i)  [  1]
            .DN_FBUF_RD_TRIG                        ( s_DN_FBUF_RD_TRIG     [i] ),//(i)  [  1]
            .DN_FBUF_RD_ADDR                        ( s_DN_FBUF_RD_ADDR     [i] ),//(i)  [ 64]
            .DN_FBUF_RD_SIZE                        ( s_DN_FBUF_RD_SIZE     [i] ),//(i)  [ 24]
            .DN_FBUF_RD_AUTO                        ( s_DN_FBUF_RD_AUTO     [i] ),//(i)  [  1]
            //pcie tx
            .DFK_TX_REQ                             ( s_DFK_TXX_REQ         [i] ),//(o)  [  1]
            .DFK_TX_ACK                             ( s_DFK_TXX_ACK         [i] ),//(i)  [  1]
            .DFK_TX_DVLD                            ( s_DFK_TXX_DVLD        [i] ),//(o)  [  1]
            .DFK_TX_DATA                            ( s_DFK_TXX_DATA        [i] ),//(o)  [ 64]
            .DFK_TX_MASK                            ( s_DFK_TXX_MASK        [i] ),//(o)  [  2]
            .DFK_TX_SOP                             ( s_DFK_TXX_SOP         [i] ),//(o)  [  1]
            .DFK_TX_EOP                             ( s_DFK_TXX_EOP         [i] ) //(o)  [  1]
            );

        PCIE_DN_DEK # (
            .p_CH_ID                                ( p_CH_ID[i]                ) //(p)  [  1]
            )
        U_PCIE_DN_DEK (
            //system
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
            //register
            .COMPLETER_ID                           ( s_COMPLETER_ID            ),//(i)  [ 13]
            .DN_EBUF_WR_TRIG                        ( s_DN_EBUF_WR_TRIG     [i] ),//(i)  [  1]
            .DN_EBUF_WR_ADDR                        ( s_DN_EBUF_WR_ADDR     [i] ),//(i)  [ 64]
            .DN_EBUF_WR_SIZE                        ( s_DN_EBUF_WR_SIZE     [i] ),//(i)  [ 24]
            //dma
            .DN_EBUF_WR_REQ                         ( s_DN_EBUF_WR_REQ      [i] ),//(i)  [  1]
            .DN_EBUF_WR_DATA                        ( s_DN_EBUF_WR_DATA     [i] ),//(i)  [ 16]
            //pcie tx
            .DEK_TX_REQ                             ( s_DEK_TXX_REQ         [i] ),//(o)  [  1]
            .DEK_TX_ACK                             ( s_DEK_TXX_ACK         [i] ),//(i)  [  1]
            .DEK_TX_DVLD                            ( s_DEK_TXX_DVLD        [i] ),//(o)  [  1]
            .DEK_TX_DATA                            ( s_DEK_TXX_DATA        [i] ),//(o)  [ 64]
            .DEK_TX_MASK                            ( s_DEK_TXX_MASK        [i] ),//(o)  [  2]
            .DEK_TX_SOP                             ( s_DEK_TXX_SOP         [i] ),//(o)  [  1]
            .DEK_TX_EOP                             ( s_DEK_TXX_EOP         [i] ) //(o)  [  1]
            );

        PCIE_DN_FBUF U_PCIE_DN_FBUF (
            //system
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
            //register
            .DN_FBUF_WR_RDY                         ( s_DN_FBUF_WR_RDY      [i] ),//(i)  [  1]
            .DN_FBUF_WR_REQ                         ( s_DN_FBUF_WR_REQ      [i] ),//(i)  [  1]
            .DN_FBUF_WR_DATA                        ( s_DN_FBUF_WR_DATA     [i] ),//(i)  [ 96]
            .DN_FBUF_WR_DCNT                        ( s_DN_FBUF_WR_DCNT     [i] ),//(o)  [  8]

            .DN_FBUF_RD_REQ                         ( s_DN_FBUF_RD_REQ      [i] ),//(i)  [  1]
            .DN_FBUF_RD_RDY                         ( s_DN_FBUF_RD_RDY      [i] ),//(o)  [  1]
            .DN_FBUF_RD_DATA                        ( s_DN_FBUF_RD_DATA     [i] ) //(o)  [ 96]
            );

        PCIE_DN_DMA # (
            .p_CH_ID                                ( p_CH_ID[i]                ) //(p)  [  2]
            )
        U_PCIE_DN_DMA (
            //clock and reset
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
            //system signal
            .DN_CX_EOP                              ( s_DN_LBUF_WR_EOP      [i] ),//(i)  [  1]
            .COMPLETER_ID                           ( s_COMPLETER_ID            ),//(i)  [ 13]
            //local buffer
            .DN_LBUF_WR_RDY                         ( s_DN_LBUF_WR_RDY      [i] ),//(i)  [  1]
            .DN_LBUF_WR_REQ                         ( s_DN_LBUF_WR_REQ      [i] ),//(o)  [  1]
            //bufq
            .DN_FBUF_RD_RDY                         ( s_DN_FBUF_RD_RDY      [i] ),//(i)  [  1]
            .DN_FBUF_RD_REQ                         ( s_DN_FBUF_RD_REQ      [i] ),//(o)  [  1]
            .DN_FBUF_RD_DATA                        ( s_DN_FBUF_RD_DATA     [i] ),//(i)  [ 96]
            .DN_EBUF_WR_REQ                         ( s_DN_EBUF_WR_REQ      [i] ),//(o)  [  1]
            .DN_EBUF_WR_DATA                        ( s_DN_EBUF_WR_DATA     [i] ),//(o)  [ 16]
            //pcie tx
            .DPK_TX_REQ                             ( s_DPK_TXX_REQ         [i] ),//(o)  [  1]
            .DPK_TX_ACK                             ( s_DPK_TXX_ACK         [i] ),//(i)  [  1]
            .DPK_TX_DVLD                            ( s_DPK_TXX_DVLD        [i] ),//(o)  [  1]
            .DPK_TX_DATA                            ( s_DPK_TXX_DATA        [i] ),//(o)  [ 64]
            .DPK_TX_MASK                            ( s_DPK_TXX_MASK        [i] ),//(o)  [  2]
            .DPK_TX_SOP                             ( s_DPK_TXX_SOP         [i] ),//(o)  [  1]
            .DPK_TX_EOP                             ( s_DPK_TXX_EOP         [i] ),//(o)  [  1]
            .DPK_TX_END                             ( s_DPK_TXX_END         [i] ) //(o)  [  1]
            );

        PCIE_DN_CPLD_UEK U_PCIE_DN_CPLD_UEK         (
             //system signals
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
             //cpld
            .UEK_CP_SOP                             ( s_UEK_CX_SOP         [i]  ),//(i)  [  1]
            .UEK_CP_EOP                             ( s_UEK_CX_EOP         [i]  ),//(i)  [  1]
            .UEK_CP_DATA                            ( s_UEK_CX_DATA        [i]  ),//(i)  [ 64]
            .UEK_CP_DVLD                            ( s_UEK_CX_DVLD        [i]  ),//(i)  [  1]
            .UEK_CP_TAG                             ( s_UEK_CX_TAG         [i]  ),//(i)  [  8]
            .UEK_CP_DCNT                            ( s_UEK_CX_DCNT        [i]  ),//(i)  [ 12]
             //user if
            .UP_EBUF_RD_REQ                         ( s_UP_EBUF_RD_REQ1    [i]  ),//(o)  [  1]
            .UP_EBUF_RD_ACK                         ( s_UP_EBUF_RD_ACK1    [i]  ),//(o)  [  1]
            .UP_EBUF_WR_REQ                         ( s_UP_EBUF_WR_REQ     [i]  ),//(o)  [  1]
            .UP_EBUF_WR_DATA                        ( s_UP_EBUF_WR_DATA    [i]  ) //(o)  [ 96]
            );

        PCIE_DN_CPLD_DFK U_PCIE_DN_CPLD_DFK         (
             //system signals
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
             //cpld
            .DFK_CP_SOP                             ( s_DFK_CX_SOP         [i]  ),//(i)  [  1]
            .DFK_CP_EOP                             ( s_DFK_CX_EOP         [i]  ),//(i)  [  1]
            .DFK_CP_DATA                            ( s_DFK_CX_DATA        [i]  ),//(i)  [ 64]
            .DFK_CP_DVLD                            ( s_DFK_CX_DVLD        [i]  ),//(i)  [  1]
            .DFK_CP_TAG                             ( s_DFK_CX_TAG         [i]  ),//(i)  [  8]
            .DFK_CP_DCNT                            ( s_DFK_CX_DCNT        [i]  ),//(i)  [ 12]
             //user if
            .DN_FILE_SOF                            ( s_DN_FILE_SOF        [i]  ),//(o)  [  1]
            .DN_FILE_EOF                            ( s_DN_FILE_EOF        [i]  ),//(o)  [  1]
            .DN_FILE_FID                            (                           ),//(o)  [ 16]
            .DN_FILE_SID                            (                           ),//(o)  [ 16]
            .DN_FILE_VCH                            ( s_DN_FILE_VCH        [i]  ),//(o)  [ 16]
            .DN_FILE_ADDR                           ( s_DN_FILE_ADDR       [i]  ),//(o)  [ 32]
            .DN_FILE_SIZE                           ( s_DN_FILE_SIZE       [i]  ),//(o)  [ 32]

            .DN_FBUF_RD_REQ                         ( s_DN_FBUF_RD_REQ1    [i]  ),//(o)  [  1]
            .DN_FBUF_RD_ACK                         ( s_DN_FBUF_RD_ACK1    [i]  ),//(o)  [  1]
            .DN_FBUF_WR_REQ                         ( s_DN_FBUF_WR_REQ     [i]  ),//(o)  [  1]
            .DN_FBUF_WR_DATA                        ( s_DN_FBUF_WR_DATA    [i]  ) //(o)  [ 96]
            );

        PCIE_DN_CPLD_DPK U_PCIE_DN_CPLD_DPK         (
             //system signals
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
             //cpld
            .DPK_CX_SOP                             ( s_DPK_CX_SOP          [i] ),//(i)  [  1]
            .DPK_CX_EOP                             ( s_DPK_CX_EOP          [i] ),//(i)  [  1]
            .DPK_CX_DATA                            ( s_DPK_CX_DATA         [i] ),//(i)  [ 64]
            .DPK_CX_DVLD                            ( s_DPK_CX_DVLD         [i] ),//(i)  [  1]
            .DPK_CX_TAG                             ( s_DPK_CX_TAG          [i] ),//(i)  [  8]
            .DPK_CX_DCNT                            ( s_DPK_CX_DCNT         [i] ),//(i)  [ 12]
             //user if
            .DN_CX_SOP                              ( s_DN_LBUF_WR_SOP      [i] ),//(o)  [  1]
            .DN_CX_EOP                              ( s_DN_LBUF_WR_EOP      [i] ),//(o)  [  1]
            .DN_CX_DATA                             ( s_DN_LBUF_WR_DATA     [i] ),//(o)  [ 64]
            .DN_CX_DVLD                             ( s_DN_LBUF_WR_DVLD     [i] ) //(o)  [  1]
            );

    end
    endgenerate

/*========================================================================+/
||                                                                        ||
||                             Download   Arbit                           ||
||                                                                        ||
/+========================================================================*/

    PCIE_DN_ARBIT U_DN_DFK_ARBIT (
        //system
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //dma
        .DPK_TX0_REQ                                ( s_DFK_TXX_REQ         [0] ),//(i)  [  1]
        .DPK_TX0_ACK                                ( s_DFK_TXX_ACK         [0] ),//(o)  [  1]
        .DPK_TX0_DVLD                               ( s_DFK_TXX_DVLD        [0] ),//(i)  [  1]
        .DPK_TX0_DATA                               ( s_DFK_TXX_DATA        [0] ),//(i)  [ 64]
        .DPK_TX0_MASK                               ( s_DFK_TXX_MASK        [0] ),//(i)  [  2]
        .DPK_TX0_SOP                                ( s_DFK_TXX_SOP         [0] ),//(i)  [  1]
        .DPK_TX0_EOP                                ( s_DFK_TXX_EOP         [0] ),//(i)  [  1]
        .DPK_TX0_END                                ( s_DFK_TXX_EOP         [0] ),//(i)  [  1]

        .DPK_TX1_REQ                                ( s_DFK_TXX_REQ         [1] ),//(i)  [  1]
        .DPK_TX1_ACK                                ( s_DFK_TXX_ACK         [1] ),//(o)  [  1]
        .DPK_TX1_DVLD                               ( s_DFK_TXX_DVLD        [1] ),//(i)  [  1]
        .DPK_TX1_DATA                               ( s_DFK_TXX_DATA        [1] ),//(i)  [ 64]
        .DPK_TX1_MASK                               ( s_DFK_TXX_MASK        [1] ),//(i)  [  2]
        .DPK_TX1_SOP                                ( s_DFK_TXX_SOP         [1] ),//(i)  [  1]
        .DPK_TX1_EOP                                ( s_DFK_TXX_EOP         [1] ),//(i)  [  1]
        .DPK_TX1_END                                ( s_DFK_TXX_EOP         [1] ),//(i)  [  1]

        .DPK_TX_REQ                                 ( s_DFK_TX_REQ              ),//(o)  [  1]
        .DPK_TX_ACK                                 ( s_DFK_TX_ACK              ),//(i)  [  1]
        .DPK_TX_DVLD                                ( s_DFK_TX_DVLD             ),//(o)  [  1]
        .DPK_TX_DATA                                ( s_DFK_TX_DATA             ),//(o)  [ 64]
        .DPK_TX_MASK                                ( s_DFK_TX_MASK             ),//(o)  [  2]
        .DPK_TX_SOP                                 ( s_DFK_TX_SOP              ),//(o)  [  1]
        .DPK_TX_EOP                                 ( s_DFK_TX_EOP              ),//(o)  [  1]
        .DPK_TX_END                                 (                           ) //(o)  [  1]
        );

    PCIE_DN_ARBIT U_DN_DEK_ARBIT (
        //system
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //dma
        .DPK_TX0_REQ                                ( s_DEK_TXX_REQ         [0] ),//(i)  [  1]
        .DPK_TX0_ACK                                ( s_DEK_TXX_ACK         [0] ),//(o)  [  1]
        .DPK_TX0_DVLD                               ( s_DEK_TXX_DVLD        [0] ),//(i)  [  1]
        .DPK_TX0_DATA                               ( s_DEK_TXX_DATA        [0] ),//(i)  [ 64]
        .DPK_TX0_MASK                               ( s_DEK_TXX_MASK        [0] ),//(i)  [  2]
        .DPK_TX0_SOP                                ( s_DEK_TXX_SOP         [0] ),//(i)  [  1]
        .DPK_TX0_EOP                                ( s_DEK_TXX_EOP         [0] ),//(i)  [  1]
        .DPK_TX0_END                                ( s_DEK_TXX_EOP         [0] ),//(i)  [  1]

        .DPK_TX1_REQ                                ( s_DEK_TXX_REQ         [1] ),//(i)  [  1]
        .DPK_TX1_ACK                                ( s_DEK_TXX_ACK         [1] ),//(o)  [  1]
        .DPK_TX1_DVLD                               ( s_DEK_TXX_DVLD        [1] ),//(i)  [  1]
        .DPK_TX1_DATA                               ( s_DEK_TXX_DATA        [1] ),//(i)  [ 64]
        .DPK_TX1_MASK                               ( s_DEK_TXX_MASK        [1] ),//(i)  [  2]
        .DPK_TX1_SOP                                ( s_DEK_TXX_SOP         [1] ),//(i)  [  1]
        .DPK_TX1_EOP                                ( s_DEK_TXX_EOP         [1] ),//(i)  [  1]
        .DPK_TX1_END                                ( s_DEK_TXX_EOP         [1] ),//(i)  [  1]

        .DPK_TX_REQ                                 ( s_DEK_TX_REQ              ),//(o)  [  1]
        .DPK_TX_ACK                                 ( s_DEK_TX_ACK              ),//(i)  [  1]
        .DPK_TX_DVLD                                ( s_DEK_TX_DVLD             ),//(o)  [  1]
        .DPK_TX_DATA                                ( s_DEK_TX_DATA             ),//(o)  [ 64]
        .DPK_TX_MASK                                ( s_DEK_TX_MASK             ),//(o)  [  2]
        .DPK_TX_SOP                                 ( s_DEK_TX_SOP              ),//(o)  [  1]
        .DPK_TX_EOP                                 ( s_DEK_TX_EOP              ),//(o)  [  1]
        .DPK_TX_END                                 (                           ) //(o)  [  1]
        );

    PCIE_DN_ARBIT U_PCIE_DN_ARBIT (
        //system
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //dma
        .DPK_TX0_REQ                                ( s_DPK_TXX_REQ        [0]  ),//(i)  [  1]
        .DPK_TX0_ACK                                ( s_DPK_TXX_ACK        [0]  ),//(o)  [  1]
        .DPK_TX0_DVLD                               ( s_DPK_TXX_DVLD       [0]  ),//(i)  [  1]
        .DPK_TX0_DATA                               ( s_DPK_TXX_DATA       [0]  ),//(i)  [ 64]
        .DPK_TX0_MASK                               ( s_DPK_TXX_MASK       [0]  ),//(i)  [  2]
        .DPK_TX0_SOP                                ( s_DPK_TXX_SOP        [0]  ),//(i)  [  1]
        .DPK_TX0_EOP                                ( s_DPK_TXX_EOP        [0]  ),//(i)  [  1]
        .DPK_TX0_END                                ( s_DPK_TXX_END        [0]  ),//(i)  [  1]

        .DPK_TX1_REQ                                ( s_DPK_TXX_REQ        [1]  ),//(i)  [  1]
        .DPK_TX1_ACK                                ( s_DPK_TXX_ACK        [1]  ),//(o)  [  1]
        .DPK_TX1_DVLD                               ( s_DPK_TXX_DVLD       [1]  ),//(i)  [  1]
        .DPK_TX1_DATA                               ( s_DPK_TXX_DATA       [1]  ),//(i)  [ 64]
        .DPK_TX1_MASK                               ( s_DPK_TXX_MASK       [1]  ),//(i)  [  2]
        .DPK_TX1_SOP                                ( s_DPK_TXX_SOP        [1]  ),//(i)  [  1]
        .DPK_TX1_EOP                                ( s_DPK_TXX_EOP        [1]  ),//(i)  [  1]
        .DPK_TX1_END                                ( s_DPK_TXX_END        [1]  ),//(i)  [  1]

        .DPK_TX_REQ                                 ( s_DPK_TX_REQ              ),//(o)  [  1]
        .DPK_TX_ACK                                 ( s_DPK_TX_ACK              ),//(i)  [  1]
        .DPK_TX_DVLD                                ( s_DPK_TX_DVLD             ),//(o)  [  1]
        .DPK_TX_DATA                                ( s_DPK_TX_DATA             ),//(o)  [ 64]
        .DPK_TX_MASK                                ( s_DPK_TX_MASK             ),//(o)  [  2]
        .DPK_TX_SOP                                 ( s_DPK_TX_SOP              ),//(o)  [  1]
        .DPK_TX_EOP                                 ( s_DPK_TX_EOP              ),//(o)  [  1]
        .DPK_TX_END                                 ( s_DPK_TX_END              ) //(o)  [  1]
        );

/*============================================================================+/
||                                                                            ||
||                               Upload Local Buffer                          ||
||                                                                            ||
/+============================================================================*/

    genvar j ;
    generate
    for (j=0 ; j<=p_CH_NM-1 ; j=j+1) begin : GROUP_UP

        PCIE_UP_IF U_PCIE_UP_IF (
            .PCIE_CLK                               (   PCIE_CLK                ),//(i)  [  1]
            .PCIE_RST                               (   PCIE_RST | s_SOFT_RST   ),//(i)  [  1]
            .USER_CLK                               (   USER_CLK                ),//(i)  [  1]
            .USER_RST                               (   USER_RST | s_SOFT_RST   ),//(i)  [  1]

            .UP_FILE_SOF                            ( s_UP_FILE_SOF        [j]  ),//(i)  [  1]
            .UP_FILE_EOF                            ( s_UP_FILE_EOF        [j]  ),//(i)  [  1]
            .UP_FILE_VCH                            ( s_UP_FILE_VCH        [j]  ),//(i)  [ 16]
            .UP_FILE_ADDR                           ( s_UP_FILE_ADDR       [j]  ),//(i)  [ 32]
            .UP_FILE_SIZE                           ( s_UP_FILE_SIZE       [j]  ),//(i)  [ 32]

            .DMA_RD_START                           ( s_DMA_RD_START       [j]  ),//(o)  [  1]
            .DMA_RD_VCH                             ( s_DMA_RD_VCH         [j]  ),//(o)  [ 16]
            .DMA_RD_ADDR                            ( s_DMA_RD_ADDR        [j]  ),//(o)  [ 32]
            .DMA_RD_SIZE                            ( s_DMA_RD_SIZE        [j]  ),//(o)  [ 32]

            .DMA_UP_RDY                             ( s_DMA_UP_RDY         [j]  ),//(i)  [  1]
            .DMA_UP_DATA                            ( s_DMA_UP_DATA        [j]  ),//(i)  [ 64]
            .DMA_UP_DVLD                            ( s_DMA_UP_DVLD        [j]  ),//(i)  [  1]
            .DMA_UP_SOF                             ( s_DMA_UP_SOF         [j]  ),//(i)  [  1]
            .DMA_UP_EOF                             ( s_DMA_UP_EOF         [j]  ),//(i)  [  1]
            .DMA_UP_VCH                             ( s_DMA_UP_VCH         [j]  ),//(i)  [ 16]
            .DMA_UP_ADDR                            ( s_DMA_UP_ADDR        [j]  ),//(i)  [ 32]
            .DMA_UP_SIZE                            ( s_DMA_UP_SIZE        [j]  ),//(i)  [ 32]

            .UP_LBUF_WR_RDY                         ( s_UP_LBUF_WR_RDY     [j]  ),//(i)  [ 16]
            .UP_LBUF_WR_DATA                        ( s_UP_LBUF_WR_DATA    [j]  ),//(o)  [ 64]
            .UP_LBUF_WR_DVLD                        ( s_UP_LBUF_WR_DVLD    [j]  ),//(o)  [  1]
            .UP_LBUF_WR_SOF                         ( s_UP_LBUF_WR_SOF     [j]  ),//(o)  [  1]
            .UP_LBUF_WR_EOF                         ( s_UP_LBUF_WR_EOF     [j]  ),//(o)  [  1]
            .UP_LBUF_WR_VCH                         ( s_UP_LBUF_WR_VCH     [j]  ),//(o)  [ 16]
            .UP_LBUF_WR_ADDR                        ( s_UP_LBUF_WR_ADDR    [j]  ),//(o)  [ 32]
            .UP_LBUF_WR_FSZ                         ( s_UP_LBUF_WR_FSZ     [j]  ),//(o)  [ 32]
            .UP_LBUF_WR_SOB                         ( s_UP_LBUF_WR_SOB     [j]  ),//(o)  [  1]
            .UP_LBUF_WR_EOB                         ( s_UP_LBUF_WR_EOB     [j]  ),//(o)  [  1]
            .UP_LBUF_WR_BSZ                         ( s_UP_LBUF_WR_BSZ     [j]  ) //(o)  [ 16]
            );

        PCIE_UP_LBUF U_PCIE_UP_LBUF (
            //system signals
            .PCIE_CLK                               (   PCIE_CLK                ),//(i)  [  1]
            .PCIE_RST                               (   PCIE_RST | s_SOFT_RST   ),//(i)  [  1]
            .USER_CLK                               (   USER_CLK                ),//(i)  [  1]
            .USER_RST                               (   USER_RST | s_SOFT_RST   ),//(i)  [  1]

            .UP_LBUF_WR_RDY                         ( s_UP_LBUF_WR_RDY     [j]  ),//(i)  [ 16]
            .UP_LBUF_WR_DATA                        ( s_UP_LBUF_WR_DATA    [j]  ),//(o)  [ 64]
            .UP_LBUF_WR_DVLD                        ( s_UP_LBUF_WR_DVLD    [j]  ),//(o)  [  1]
            .UP_LBUF_WR_SOF                         ( s_UP_LBUF_WR_SOF     [j]  ),//(o)  [  1]
            .UP_LBUF_WR_EOF                         ( s_UP_LBUF_WR_EOF     [j]  ),//(o)  [  1]
            .UP_LBUF_WR_VCH                         ( s_UP_LBUF_WR_VCH     [j]  ),//(o)  [ 16]
            .UP_LBUF_WR_ADDR                        ( s_UP_LBUF_WR_ADDR    [j]  ),//(o)  [ 32]
            .UP_LBUF_WR_FSZ                         ( s_UP_LBUF_WR_FSZ     [j]  ),//(o)  [ 32]
            .UP_LBUF_WR_SOB                         ( s_UP_LBUF_WR_SOB     [j]  ),//(o)  [  1]
            .UP_LBUF_WR_EOB                         ( s_UP_LBUF_WR_EOB     [j]  ),//(o)  [  1]
            .UP_LBUF_WR_BSZ                         ( s_UP_LBUF_WR_BSZ     [j]  ),//(o)  [ 16]

            .UP_LBUF_RD_REQ                         ( s_UP_LBUF_RD_REQ     [j]  ),//(o)  [  1]
            .UP_LBUF_RD_ACK                         ( s_UP_LBUF_RD_ACK     [j]  ),//(i)  [  1]
            .UP_LBUF_RD_PSZ                         ( s_UP_LBUF_RD_PSZ     [j]  ),//(o)  [  8]
            .UP_LBUF_RD_BSZ                         ( s_UP_LBUF_RD_BSZ     [j]  ),//(o)  [ 16]
            .UP_LBUF_RD_FSZ                         ( s_UP_LBUF_RD_FSZ     [j]  ),//(o)  [ 32]
            .UP_LBUF_RD_VCH                         ( s_UP_LBUF_RD_VCH     [j]  ),//(o)  [ 16]
            .UP_LBUF_RD_DATA                        ( s_UP_LBUF_RD_DATA    [j]  ),//(o)  [ 64]
            .UP_LBUF_RD_DVLD                        ( s_UP_LBUF_RD_DVLD    [j]  ),//(o)  [  1]
            .UP_LBUF_RD_SOP                         ( s_UP_LBUF_RD_SOP     [j]  ),//(o)  [  1]
            .UP_LBUF_RD_EOP                         ( s_UP_LBUF_RD_EOP     [j]  ),//(o)  [  1]
            .UP_LBUF_RD_SOB                         ( s_UP_LBUF_RD_SOB     [j]  ),//(o)  [  1]
            .UP_LBUF_RD_EOB                         ( s_UP_LBUF_RD_EOB     [j]  ),//(o)  [  1]
            .UP_LBUF_RD_SOF                         ( s_UP_LBUF_RD_SOF     [j]  ),//(o)  [  1]
            .UP_LBUF_RD_EOF                         ( s_UP_LBUF_RD_EOF     [j]  ) //(o)  [  1]
            );

        PCIE_UP_EBUF U_PCIE_UP_EBUF (
            //system
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
            //register
            .UP_EBUF_WR_RDY                         ( s_UP_EBUF_WR_RDY     [j]  ),//(o)  [  1]
            .UP_EBUF_WR_REQ                         ( s_UP_EBUF_WR_REQ     [j]  ),//(i)  [  1]
            .UP_EBUF_WR_DATA                        ( s_UP_EBUF_WR_DATA    [j]  ),//(i)  [ 96]
            .UP_EBUF_WR_DCNT                        ( s_UP_EBUF_WR_DCNT    [j]  ),//(o)  [  8]

            .UP_EBUF_RD_REQ                         ( s_UP_EBUF_RD_REQ     [j]  ),//(i)  [  1]
            .UP_EBUF_RD_RDY                         ( s_UP_EBUF_RD_RDY     [j]  ),//(o)  [  1]
            .UP_EBUF_RD_DATA                        ( s_UP_EBUF_RD_DATA    [j]  ) //(o)  [ 96]
            );

        PCIE_UP_UFK # (
            .p_CH_ID                                ( p_CH_ID[j]                ) //(p)  [  2]
            )
        U_PCIE_UP_UFK (
            //system
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
            //register
            .COMPLETER_ID                           ( s_COMPLETER_ID            ),//(i)  [ 13]
            .UP_FBUF_WR_TRIG                        ( s_UP_FBUF_WR_TRIG    [j]  ),//(i)  [  1]
            .UP_FBUF_WR_ADDR                        ( s_UP_FBUF_WR_ADDR    [j]  ),//(i)  [ 64]
            .UP_FBUF_WR_SIZE                        ( s_UP_FBUF_WR_SIZE    [j]  ),//(i)  [ 24]
            //dma
            .UP_FBUF_WR_REQ                         ( s_UP_FBUF_WR_REQ     [j]  ),//(i)  [  1]
            .UP_FBUF_WR_DATA                        ( s_UP_FBUF_WR_DATA    [j]  ),//(i)  [128]
            //pcie tx
            .UFK_TX_REQ                             ( s_UFK_TXX_REQ        [j]  ),//(o)  [  1]
            .UFK_TX_ACK                             ( s_UFK_TXX_ACK        [j]  ),//(i)  [  1]
            .UFK_TX_DVLD                            ( s_UFK_TXX_DVLD       [j]  ),//(o)  [  1]
            .UFK_TX_DATA                            ( s_UFK_TXX_DATA       [j]  ),//(o)  [ 64]
            .UFK_TX_MASK                            ( s_UFK_TXX_MASK       [j]  ),//(o)  [  2]
            .UFK_TX_SOP                             ( s_UFK_TXX_SOP        [j]  ),//(o)  [  1]
            .UFK_TX_EOP                             ( s_UFK_TXX_EOP        [j]  ) //(o)  [  1]
            );

        PCIE_UP_UEK # (
            .p_CH_ID                                ( p_CH_ID[j]                ) //(p)  [  2]
            )
        U_PCIE_UP_UEK (
            //system
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
            //register
            .COMPLETER_ID                           ( s_COMPLETER_ID            ),//(i)  [ 13]
            .UP_EBUF_WR_RDY                         ( s_UP_EBUF_WR_RDY     [j]  ),//(i)  [  1]
            .UP_EBUF_RD_REQ0                        ( s_UP_EBUF_RD_REQ0    [j]  ),//(i)  [  1]
            .UP_EBUF_RD_REQ1                        ( s_UP_EBUF_RD_REQ1    [j]  ),//(i)  [  1]
            .UP_EBUF_RD_ACK1                        ( s_UP_EBUF_RD_ACK1    [j]  ),//(i)  [  1]
            .UP_EBUF_RD_TRIG                        ( s_UP_EBUF_RD_TRIG    [j]  ),//(i)  [  1]
            .UP_EBUF_RD_ADDR                        ( s_UP_EBUF_RD_ADDR    [j]  ),//(i)  [ 64]
            .UP_EBUF_RD_SIZE                        ( s_UP_EBUF_RD_SIZE    [j]  ),//(i)  [ 24]
            .UP_EBUF_RD_AUTO                        ( s_UP_EBUF_RD_AUTO    [j]  ),//(i)  [  1]
            //pcie tx
            .UEK_TX_REQ                             ( s_UEK_TXX_REQ        [j]  ),//(o)  [  1]
            .UEK_TX_ACK                             ( s_UEK_TXX_ACK        [j]  ),//(i)  [  1]
            .UEK_TX_DVLD                            ( s_UEK_TXX_DVLD       [j]  ),//(o)  [  1]
            .UEK_TX_DATA                            ( s_UEK_TXX_DATA       [j]  ),//(o)  [ 64]
            .UEK_TX_MASK                            ( s_UEK_TXX_MASK       [j]  ),//(o)  [  2]
            .UEK_TX_SOP                             ( s_UEK_TXX_SOP        [j]  ),//(o)  [  1]
            .UEK_TX_EOP                             ( s_UEK_TXX_EOP        [j]  ) //(o)  [  1]
            );

        PCIE_UP_DMA #  (
            .p_CH_ID                                ( p_CH_ID[j]                ) //(p)  [  2]
            )
        U_PCIE_UP_DMA (
             //clock and reset
            .PCIE_CLK                               ( PCIE_CLK                  ),//(i)  [  1]
            .PCIE_RST                               ( PCIE_RST | s_SOFT_RST     ),//(i)  [  1]
             //system signal
            .COMPLETER_ID                           ( s_COMPLETER_ID            ),//(i)  [ 13]
            .UP_LBUF_RD_REQ                         ( s_UP_LBUF_RD_REQ     [j]  ),//(i)  [  1]
            .UP_LBUF_RD_ACK                         ( s_UP_LBUF_RD_ACK     [j]  ),//(o)  [  1]
            .UP_LBUF_RD_PSZ                         ( s_UP_LBUF_RD_PSZ     [j]  ),//(i)  [  8]
            .UP_LBUF_RD_BSZ                         ( s_UP_LBUF_RD_BSZ     [j]  ),//(i)  [ 16]
            .UP_LBUF_RD_FSZ                         ( s_UP_LBUF_RD_FSZ     [j]  ),//(i)  [ 32]
            .UP_LBUF_RD_VCH                         ( s_UP_LBUF_RD_VCH     [j]  ),//(i)  [ 16]
            .UP_LBUF_RD_DATA                        ( s_UP_LBUF_RD_DATA    [j]  ),//(i)  [ 64]
            .UP_LBUF_RD_DVLD                        ( s_UP_LBUF_RD_DVLD    [j]  ),//(i)  [  1]
            .UP_LBUF_RD_SOP                         ( s_UP_LBUF_RD_SOP     [j]  ),//(i)  [  1]
            .UP_LBUF_RD_EOP                         ( s_UP_LBUF_RD_EOP     [j]  ),//(i)  [  1]
            .UP_LBUF_RD_SOB                         ( s_UP_LBUF_RD_SOB     [j]  ),//(i)  [  1]
            .UP_LBUF_RD_EOB                         ( s_UP_LBUF_RD_EOB     [j]  ),//(i)  [  1]
            .UP_LBUF_RD_SOF                         ( s_UP_LBUF_RD_SOF     [j]  ),//(i)  [  1]
            .UP_LBUF_RD_EOF                         ( s_UP_LBUF_RD_EOF     [j]  ),//(i)  [  1]
             //upload buffer
            .UP_EBUF_RD_RDY                         ( s_UP_EBUF_RD_RDY     [j]  ),//(i)  [  1]
            .UP_EBUF_RD_REQ                         ( s_UP_EBUF_RD_REQ     [j]  ),//(o)  [  1]
            .UP_EBUF_RD_DATA                        ( s_UP_EBUF_RD_DATA    [j]  ),//(i)  [ 96]
            .UP_FBUF_WR_INT                         ( s_UP_FBUF_WR_INT     [j]  ),//(o)  [  1]
            .UP_FBUF_WR_REQ                         ( s_UP_FBUF_WR_REQ     [j]  ),//(o)  [  1]
            .UP_FBUF_WR_DATA                        ( s_UP_FBUF_WR_DATA    [j]  ),//(o)  [128]

             //pcie tx
            .UPK_TX_REQ                             ( s_UPK_TXX_REQ        [j]  ),//(o)  [  1]
            .UPK_TX_ACK                             ( s_UPK_TXX_ACK        [j]  ),//(i)  [  1]
            .UPK_TX_DVLD                            ( s_UPK_TXX_DVLD       [j]  ),//(o)  [  1]
            .UPK_TX_DATA                            ( s_UPK_TXX_DATA       [j]  ),//(o)  [ 64]
            .UPK_TX_MASK                            ( s_UPK_TXX_MASK       [j]  ),//(o)  [  2]
            .UPK_TX_SOP                             ( s_UPK_TXX_SOP        [j]  ),//(o)  [  1]
            .UPK_TX_END                             ( s_UPK_TXX_END        [j]  ),//(o)  [  1]
            .UPK_TX_EOP                             ( s_UPK_TXX_EOP        [j]  ) //(o)  [  1]
            );
    end
    endgenerate

/*============================================================================+/
||                                                                            ||
||                                Upload Arbit                                ||
||                                                                            ||
/+============================================================================*/

    PCIE_UP_ARBIT U_UP_UEK_ARBIT (
        //system
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //dma
        .UPK_TX0_REQ                                ( s_UEK_TXX_REQ        [0]  ),//(i)  [  1]
        .UPK_TX0_ACK                                ( s_UEK_TXX_ACK        [0]  ),//(o)  [  1]
        .UPK_TX0_DVLD                               ( s_UEK_TXX_DVLD       [0]  ),//(i)  [  1]
        .UPK_TX0_DATA                               ( s_UEK_TXX_DATA       [0]  ),//(i)  [ 64]
        .UPK_TX0_MASK                               ( s_UEK_TXX_MASK       [0]  ),//(i)  [  2]
        .UPK_TX0_SOP                                ( s_UEK_TXX_SOP        [0]  ),//(i)  [  1]
        .UPK_TX0_EOP                                ( s_UEK_TXX_EOP        [0]  ),//(i)  [  1]
        .UPK_TX0_END                                ( s_UEK_TXX_EOP        [0]  ),//(i)  [  1]

        .UPK_TX1_REQ                                ( s_UEK_TXX_REQ        [1]  ),//(i)  [  1]
        .UPK_TX1_ACK                                ( s_UEK_TXX_ACK        [1]  ),//(o)  [  1]
        .UPK_TX1_DVLD                               ( s_UEK_TXX_DVLD       [1]  ),//(i)  [  1]
        .UPK_TX1_DATA                               ( s_UEK_TXX_DATA       [1]  ),//(i)  [ 64]
        .UPK_TX1_MASK                               ( s_UEK_TXX_MASK       [1]  ),//(i)  [  2]
        .UPK_TX1_SOP                                ( s_UEK_TXX_SOP        [1]  ),//(i)  [  1]
        .UPK_TX1_EOP                                ( s_UEK_TXX_EOP        [1]  ),//(i)  [  1]
        .UPK_TX1_END                                ( s_UEK_TXX_EOP        [1]  ),//(i)  [  1]

        .UPK_TX_REQ                                 ( s_UEK_TX_REQ              ),//(o)  [  1]
        .UPK_TX_ACK                                 ( s_UEK_TX_ACK              ),//(i)  [  1]
        .UPK_TX_DVLD                                ( s_UEK_TX_DVLD             ),//(o)  [  1]
        .UPK_TX_DATA                                ( s_UEK_TX_DATA             ),//(o)  [ 64]
        .UPK_TX_MASK                                ( s_UEK_TX_MASK             ),//(o)  [  2]
        .UPK_TX_SOP                                 ( s_UEK_TX_SOP              ),//(o)  [  1]
        .UPK_TX_EOP                                 ( s_UEK_TX_EOP              ),//(o)  [  1]
        .UPK_TX_END                                 (                           ) //(o)  [  1]
        );

    PCIE_UP_ARBIT U_UP_UFK_ARBIT (
        //system
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //dma
        .UPK_TX0_REQ                                ( s_UFK_TXX_REQ        [0]  ),//(i)  [  1]
        .UPK_TX0_ACK                                ( s_UFK_TXX_ACK        [0]  ),//(o)  [  1]
        .UPK_TX0_DVLD                               ( s_UFK_TXX_DVLD       [0]  ),//(i)  [  1]
        .UPK_TX0_DATA                               ( s_UFK_TXX_DATA       [0]  ),//(i)  [ 64]
        .UPK_TX0_MASK                               ( s_UFK_TXX_MASK       [0]  ),//(i)  [  2]
        .UPK_TX0_SOP                                ( s_UFK_TXX_SOP        [0]  ),//(i)  [  1]
        .UPK_TX0_EOP                                ( s_UFK_TXX_EOP        [0]  ),//(i)  [  1]
        .UPK_TX0_END                                ( s_UFK_TXX_EOP        [0]  ),//(i)  [  1]

        .UPK_TX1_REQ                                ( s_UFK_TXX_REQ        [1]  ),//(i)  [  1]
        .UPK_TX1_ACK                                ( s_UFK_TXX_ACK        [1]  ),//(o)  [  1]
        .UPK_TX1_DVLD                               ( s_UFK_TXX_DVLD       [1]  ),//(i)  [  1]
        .UPK_TX1_DATA                               ( s_UFK_TXX_DATA       [1]  ),//(i)  [ 64]
        .UPK_TX1_MASK                               ( s_UFK_TXX_MASK       [1]  ),//(i)  [  2]
        .UPK_TX1_SOP                                ( s_UFK_TXX_SOP        [1]  ),//(i)  [  1]
        .UPK_TX1_EOP                                ( s_UFK_TXX_EOP        [1]  ),//(i)  [  1]
        .UPK_TX1_END                                ( s_UFK_TXX_EOP        [1]  ),//(i)  [  1]

        .UPK_TX_REQ                                 ( s_UFK_TX_REQ              ),//(o)  [  1]
        .UPK_TX_ACK                                 ( s_UFK_TX_ACK              ),//(i)  [  1]
        .UPK_TX_DVLD                                ( s_UFK_TX_DVLD             ),//(o)  [  1]
        .UPK_TX_DATA                                ( s_UFK_TX_DATA             ),//(o)  [ 64]
        .UPK_TX_MASK                                ( s_UFK_TX_MASK             ),//(o)  [  2]
        .UPK_TX_SOP                                 ( s_UFK_TX_SOP              ),//(o)  [  1]
        .UPK_TX_EOP                                 ( s_UFK_TX_EOP              ),//(o)  [  1]
        .UPK_TX_END                                 (                           ) //(o)  [  1]
        );

    PCIE_UP_ARBIT U_PCIE_UP_ARBIT (
        //system
        .PCIE_CLK                                   ( PCIE_CLK                  ),//(i)  [  1]
        .PCIE_RST                                   ( PCIE_RST                  ),//(i)  [  1]
        //dma
        .UPK_TX0_REQ                                ( s_UPK_TXX_REQ        [0]  ),//(i)  [  1]
        .UPK_TX0_ACK                                ( s_UPK_TXX_ACK        [0]  ),//(o)  [  1]
        .UPK_TX0_DVLD                               ( s_UPK_TXX_DVLD       [0]  ),//(i)  [  1]
        .UPK_TX0_DATA                               ( s_UPK_TXX_DATA       [0]  ),//(i)  [ 64]
        .UPK_TX0_MASK                               ( s_UPK_TXX_MASK       [0]  ),//(i)  [  2]
        .UPK_TX0_SOP                                ( s_UPK_TXX_SOP        [0]  ),//(i)  [  1]
        .UPK_TX0_EOP                                ( s_UPK_TXX_EOP        [0]  ),//(i)  [  1]
        .UPK_TX0_END                                ( s_UPK_TXX_END        [0]  ),//(i)  [  1]

        .UPK_TX1_REQ                                ( s_UPK_TXX_REQ        [1]  ),//(i)  [  1]
        .UPK_TX1_ACK                                ( s_UPK_TXX_ACK        [1]  ),//(o)  [  1]
        .UPK_TX1_DVLD                               ( s_UPK_TXX_DVLD       [1]  ),//(i)  [  1]
        .UPK_TX1_DATA                               ( s_UPK_TXX_DATA       [1]  ),//(i)  [ 64]
        .UPK_TX1_MASK                               ( s_UPK_TXX_MASK       [1]  ),//(i)  [  2]
        .UPK_TX1_SOP                                ( s_UPK_TXX_SOP        [1]  ),//(i)  [  1]
        .UPK_TX1_EOP                                ( s_UPK_TXX_EOP        [1]  ),//(i)  [  1]
        .UPK_TX1_END                                ( s_UPK_TXX_END        [1]  ),//(i)  [  1]

        .UPK_TX_REQ                                 ( s_UPK_TX_REQ              ),//(o)  [  1]
        .UPK_TX_ACK                                 ( s_UPK_TX_ACK              ),//(i)  [  1]
        .UPK_TX_DVLD                                ( s_UPK_TX_DVLD             ),//(o)  [  1]
        .UPK_TX_DATA                                ( s_UPK_TX_DATA             ),//(o)  [ 64]
        .UPK_TX_MASK                                ( s_UPK_TX_MASK             ),//(o)  [  2]
        .UPK_TX_SOP                                 ( s_UPK_TX_SOP              ),//(o)  [  1]
        .UPK_TX_EOP                                 ( s_UPK_TX_EOP              ),//(o)  [  1]
        .UPK_TX_END                                 ( s_UPK_TX_END              ) //(o)  [  1]
        );

/*============================================================================+/
||                                                                            ||
||                             PCIE IPcore Logic                              ||
||                                                                            ||
/+============================================================================*/

//  assign s_BUS_MSTR_EN                =  s_CFG_COMMAND[2]         ;
//  assign s_COMPLETER_ID               = {s_CFG_BUS_NUMBER         ,
//                                         s_CFG_DEVICE_NUMBER      ,
//                                         s_CFG_FUNCTION_NUMBER   };

    assign s_BUS_MSTR_EN                = 1'b1          ;
    assign s_COMPLETER_ID               = 16'hFFFF      ;

endmodule