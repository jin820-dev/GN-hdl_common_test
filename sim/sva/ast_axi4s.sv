// ------------------------------------------------------------
// File    : ast_axi4s.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

module ast_axi4s #(
  parameter string NAME = "S_AXIS"
)(
  input logic clk,
  input logic reset_n,
  input logic tvalid,
  input logic tready,
  input logic [31:0] tdata
);

    initial begin
        $display ("Assert Active: %s", NAME);
    end

    // include property
    `include "ast_axi4s.svh"
    `include "ast_util.svh"
    
    ast_tvalid_hold: assert property (
        p_tvalid_hold
    )
    else begin 
        $error("[%s] tvalid dropped without handshake", NAME);
        fail_next = 1'b1;
    end

    ast_tdata_stable: assert property (
        p_tdata_stable 
    )
    else begin
        $error("[%s] tdata changed while stalled", NAME);
        fail_next = 1'b1;
    end

    //// assertion fail test for debug
    //ast_force_fail: assert property (
    //    p_force_fail ( clk )
    //)
    //else begin
    //    $error("FORCED FAIL");
    //    fail_next = 1'b1;
    //end

endmodule
