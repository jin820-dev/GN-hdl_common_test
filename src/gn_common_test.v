// ------------------------------------------------------------
// File    : gn_common_test.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

module gn_common_test #(
     parameter P_S_AXIS_DWIDTH = 32'd32
    ,parameter P_M_AXIS_DWIDTH = 32'd8
)(
     input  wire                        clk
    ,input  wire                        reset_n 
    ,input  wire [P_S_AXIS_DWIDTH-1:0]  s_axis_tdata 
    ,input  wire                        s_axis_tvalid
    ,output wire                        s_axis_tready
    ,output wire [P_M_AXIS_DWIDTH-1:0]  m_axis_tdata 
    ,output wire                        m_axis_tvalid
    ,input  wire                        m_axis_tready
);

    // internal register
    reg [P_M_AXIS_DWIDTH-1:0]   r_dat;
    reg                         r_vld;

    // ready generate
    assign s_axis_tready = !r_vld || m_axis_tready;

    // function
    always @(posedge clk) begin
        if (!reset_n) begin
            r_dat <= {P_S_AXIS_DWIDTH{1'b0}};
        end else if (s_axis_tready) begin
            r_dat <= s_axis_tdata[P_S_AXIS_DWIDTH-1:0];
        end
    end
    assign m_axis_tdata  =  r_dat;

    always @(posedge clk) begin
        if (!reset_n) begin
            r_vld <= 1'b0;
        end else begin
            r_vld <= s_axis_tvalid;
        end
    end
    assign m_axis_tvalid =  r_vld;

endmodule

