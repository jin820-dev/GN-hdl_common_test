// ------------------------------------------------------------
// File    : tb_ref.svh
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

// -------------------------------
// board_top reference signals
// -------------------------------
// parameter
parameter P_S_AXIS_DWIDTH = 32;
parameter P_M_AXIS_DWIDTH = 8;

// signal
logic                       clk;
logic                       reset_n;
// AXI4-Stream (S -> DUT)
logic [P_S_AXIS_DWIDTH-1:0] tx_axis_tdata;
logic                       tx_axis_tvalid;
logic                       tx_axis_tready;
// AXI4-Stream (DUT -> M)
logic [P_M_AXIS_DWIDTH-1:0] rx_axis_tdata;
logic                       rx_axis_tvalid; 
logic                       rx_axis_tready;


// -------------------------------
// board_top alias
// -------------------------------
assign clk      = board_top.clk;
assign reset_n  = board_top.reset_n;

// Model -> DUT
assign tx_axis_tdata  = board_top.i_mdl_axis_mst.tx_axis_tdata;
assign tx_axis_tvalid = board_top.i_mdl_axis_mst.tx_axis_tvalid;
assign tx_axis_tready = board_top.i_mdl_axis_mst.tx_axis_tready;

// DUT -> Model
assign rx_axis_tdata  = board_top.i_mdl_axis_slv.rx_axis_tdata;
assign rx_axis_tvalid = board_top.i_mdl_axis_slv.rx_axis_tvalid;
assign rx_axis_tready = board_top.i_mdl_axis_slv.rx_axis_tready;


// -------------------------------
// Model task wrapper
// -------------------------------
task automatic send_word(input logic [31:0] data);
    board_top.i_mdl_axis_mst.send_word(data);
endtask

