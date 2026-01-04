// ------------------------------------------------------------
// File    : board_top.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

`timescale 1ns/1ps
`default_nettype none

module board_top();

    parameter P_S_AXIS_DWIDTH = 32;
    parameter P_M_AXIS_DWIDTH = 8;

    logic                       clk    ;
    logic                       reset_n;
    logic [P_S_AXIS_DWIDTH-1:0] w_s_axis_tdata;
    logic                       w_s_axis_tvalid;
    logic                       w_s_axis_tready;
    logic [P_M_AXIS_DWIDTH-1:0] w_m_axis_tdata; 
    logic                       w_m_axis_tvalid;
    logic                       w_m_axis_tready;

    // clock & reset
    gn_mdl_clock #(
        .P_FREQ_MHZ ( 125.0 )
    ) i_clock (
        .clk ( clk )
    );

    gn_mdl_reset #(
        .P_RELS_TIME ( 100 )
    ) i_reset (
        .reset_n ( reset_n )
    );

    // DUT instance
    gn_common_test #(
         .P_S_AXIS_DWIDTH (P_S_AXIS_DWIDTH)
        ,.P_M_AXIS_DWIDTH (P_M_AXIS_DWIDTH)
    ) i_common_test(
         .clk                   ( clk               )
        ,.reset_n               ( reset_n           )
        ,.s_axis_tdata          ( w_s_axis_tdata    )
        ,.s_axis_tvalid         ( w_s_axis_tvalid   )
        ,.s_axis_tready         ( w_s_axis_tready   )
        ,.m_axis_tdata          ( w_m_axis_tdata    )
        ,.m_axis_tvalid         ( w_m_axis_tvalid   )
        ,.m_axis_tready         ( w_m_axis_tready   )
    );

    // Model instance
    gn_mdl_axis_mst #(
        .P_DWIDTH (P_S_AXIS_DWIDTH)
    ) i_mdl_axis_mst (
         .clk                   ( clk                )
        ,.reset_n               ( reset_n            )
        ,.tx_axis_tdata         ( w_s_axis_tdata     )
        ,.tx_axis_tvalid        ( w_s_axis_tvalid    )
        ,.tx_axis_tready        ( w_s_axis_tready    )
    );

    gn_mdl_axis_slv #(
        .P_DWIDTH (P_M_AXIS_DWIDTH)
    ) i_mdl_axis_slv (
         .clk                   ( clk                )
        ,.reset_n               ( reset_n            )
        ,.rx_axis_tdata         ( w_m_axis_tdata     )
        ,.rx_axis_tvalid        ( w_m_axis_tvalid    )
        ,.rx_axis_tready        ( w_m_axis_tready    )
    );

    // SVA module instance
    ast_axi4s #(
      .NAME("DUT_S_AXIS")
    ) i_ast_axi4s_mst (
       .clk     ( clk               )
      ,.reset_n ( reset_n           )
      ,.tvalid  ( w_s_axis_tvalid   )
      ,.tready  ( w_s_axis_tready   )
      ,.tdata   ( w_s_axis_tdata    )
    );

    // test start
    test_scenario i_test_scenario();

    // include task
    `include "util_task.svh"


endmodule

`default_nettype wire