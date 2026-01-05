// ------------------------------------------------------------
// File    : gn_common_test.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// 2026-01-05  BugFix
// ------------------------------------------------------------

module gn_common_test #(
     parameter P_S_AXIS_DWIDTH = 32
    ,parameter P_M_AXIS_DWIDTH = 8
)(
     input  wire                       clk
    ,input  wire                       reset_n
    ,input  wire [P_S_AXIS_DWIDTH-1:0] s_axis_tdata
    ,input  wire                       s_axis_tvalid
    ,output wire                       s_axis_tready
    ,output wire [P_M_AXIS_DWIDTH-1:0] m_axis_tdata
    ,output wire                       m_axis_tvalid
    ,input  wire                       m_axis_tready
);

    // 1-entry buffer
    reg [P_M_AXIS_DWIDTH-1:0] r_dat;
    reg                       r_vld;
    wire                      in_hndshk;
    wire                      out_hndshk;

    // ready: buffer empty OR downstream will accept current data this cycle
    assign s_axis_tready = (~r_vld) | m_axis_tready;

    assign in_hndshk  = s_axis_tvalid & s_axis_tready;
    assign out_hndshk = m_axis_tvalid & m_axis_tready;

    always @(posedge clk) begin
        if (!reset_n) begin
            r_dat <= {P_M_AXIS_DWIDTH{1'b0}};
        end else begin
            // accept new data (may replace if out_hndshk same cycle)
            if (in_hndshk) begin
                r_dat <= s_axis_tdata[P_M_AXIS_DWIDTH-1:0];
            end
        end
    end
    assign m_axis_tdata  = r_dat;

    always @(posedge clk) begin
        if (!reset_n) begin
            r_vld <= 1'b0;
        end else begin
            if (in_hndshk) begin
                // accept new data (replace if out_hndshk also asserted)
                r_vld <= 1'b1;
            end else if (out_hndshk) begin
                // consumed without replacement
                r_vld <= 1'b0;
            end else begin
                // hold
                r_vld <= r_vld;
            end
        end
    end
    assign m_axis_tvalid = r_vld;

endmodule

