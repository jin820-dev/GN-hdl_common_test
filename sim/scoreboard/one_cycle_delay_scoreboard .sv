// ------------------------------------------------------------
// File    : one_cycle_delay_scoreboard.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

//--------------------------------------------------------------
// One-cycle delay scoreboard (valid/ready based, no class)
//
// Contract (scoreboard assumptions):
//  - Input transfer  : in_fire  = in_valid  && in_ready
//  - Output transfer : out_fire = out_valid && out_ready
//  - Data appears at output after at least 1 cycle (may be delayed by ready)
//  - Output data equals lower P_OUT_DWIDTH bits of input data
//
// Checks:
//  1) Data match (truncated bits)
//  2) Transfer count match (in_fire == out_fire)
//  3) No pending expected data at end of simulation
//--------------------------------------------------------------

module one_cycle_delay_scoreboard #(
     parameter int P_IN_DWIDTH  = 32
    ,parameter int P_OUT_DWIDTH = 8

    // 1: assume single-stage buffering, 0: allow multiple outstanding data
    ,parameter bit ASSUME_SINGLE_STAGE = 1'b1
)(
     input  logic                      clk
    ,input  logic                      rst_n

    // Input side
    ,input  logic                      in_valid
    ,input  logic                      in_ready
    ,input  logic [P_IN_DWIDTH-1:0]    in_data

    // Output side
    ,input  logic                      out_valid
    ,input  logic                      out_ready
    ,input  logic [P_OUT_DWIDTH-1:0]   out_data
);

    // Parameter sanity check
    initial begin
      if (P_OUT_DWIDTH > P_IN_DWIDTH) begin
        $error("[SCB] P_OUT_DWIDTH (%0d) must be <= P_IN_DWIDTH (%0d)", P_OUT_DWIDTH, P_IN_DWIDTH);
        $finish;
      end
    end
  
    // Transfer handshake
    logic in_fire;
    logic out_fire;
    assign in_fire  = in_valid  && in_ready;
    assign out_fire = out_valid && out_ready;
  
    // Expected data (lower P_OUT_DWIDTH bits)
    logic                       have_exp;
    logic [P_OUT_DWIDTH-1:0]    exp_data;
  
    // Counters
    longint unsigned            in_count;
    longint unsigned            out_count;
    longint unsigned            err_count;
  
    always @(posedge clk) begin
        if (!rst_n) begin
          have_exp  <= 1'b0;
          exp_data  <= '0;
          in_count  <= 0;
          out_count <= 0;
          err_count <= 0;
        end else begin
  
            // Input side: capture expected data on transfer
            if (in_fire) begin
                in_count <= in_count + 1;
  
                if (ASSUME_SINGLE_STAGE && have_exp && !out_fire) begin
                  $error("[%0t][SCB] Input accepted while previous output is still pending.", $time);
                  err_count <= err_count + 1;
                end
  
                exp_data <= in_data[P_OUT_DWIDTH-1:0];
                have_exp <= 1'b1;
            end
  
            // Output side: compare and consume expected data on transfer
            if (out_fire) begin
                out_count <= out_count + 1;
  
                if (!have_exp) begin
                    $error("[%0t][SCB] Output transfer without expected data.", $time);
                    err_count <= err_count + 1;
                end else if (out_data !== exp_data) begin
                    $error("[%0t][SCB] DATA MISMATCH exp=0x%0h act=0x%0h (in_data[%0d:0])",
                           $time, exp_data, out_data, P_OUT_DWIDTH-1);
                    err_count <= err_count + 1;
                end
  
                // Clear expected data unless replaced in the same cycle
                if (!in_fire) begin
                    have_exp <= 1'b0;
                end
            end
  
            // Optional sanity warning
            if (out_valid && !have_exp) begin
                $warning("[%0t][SCB] out_valid asserted with no expected data pending.", $time);
            end

        end
    end
  
    // Final checks
    final begin
        if (in_count != out_count) begin
            $error("[SCB] COUNT MISMATCH in_fire=%0d out_fire=%0d", in_count, out_count);
        end
  
        if (have_exp) begin
            $error("[SCB] Pending expected data remains at end of simulation.");
        end
  
        if (err_count == 0 && (in_count == out_count) && !have_exp) begin
            $display("[SCB] ========= TEST PASSED ========= (transfers=%0d)", in_count);
        end else begin
            $display("[SCB] ========= TEST FAILED ========= (errors=%0d, in=%0d, out=%0d, pending=%0d)",
                     err_count, in_count, out_count, have_exp);
        end
    end

endmodule
