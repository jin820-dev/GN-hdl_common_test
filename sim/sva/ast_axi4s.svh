// ------------------------------------------------------------
// File    : ast_axi4s.svh
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

// --------------------------------------------------
// tvalid は ready が来るまで保持される
// --------------------------------------------------
property p_tvalid_hold;
  @(posedge clk)
    disable iff (!reset_n)
    tvalid && !tready |-> ##1 tvalid;
endproperty

// --------------------------------------------------
// tdata は handshake 中に変化しない
// --------------------------------------------------
property p_tdata_stable;
  @(posedge clk)
    disable iff (!reset_n)
    tvalid && !tready |-> ##1 $stable(tdata);
endproperty

// --------------------------------------------------
// assertion fail test for debug
// --------------------------------------------------
property p_force_fail(clk);
    @(posedge clk) 1'b0;
endproperty

