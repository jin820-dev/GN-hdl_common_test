// ------------------------------------------------------------
// File    : ast_util.svh
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

// Check fail
logic fail_latched;
logic fail_next;

always @(posedge clk) begin
    if (!reset_n) begin
        fail_latched <= 1'b0;
    end else if (fail_next) begin
        fail_latched <= 1'b1;
    end
end

initial begin
    fail_next = 1'b0;
end

