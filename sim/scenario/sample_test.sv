// ------------------------------------------------------------
// File    : sample_test.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

`timescale 1ns/1ps
`default_nettype none

module test_scenario ();

    // show testname
    string TEST_NAME;
    initial begin
        if (!$value$plusargs("SCENARIO=%s", TEST_NAME)) begin
            TEST_NAME = "scn_basic"; // default
        end
        $display("INFO: SCENARIO = %s", TEST_NAME);
    end

    // include signal assign
    `include "tb_ref.svh"

    // test start
    initial begin

        $display("=== START %s", TEST_NAME);

        test_task();
        // init
        i_mdl_axis_mst.init();
        wait(reset_n == 1'b1);
        @(posedge clk);
        
        // send_word
        send_word(32'hDEADBEEF);
        repeat(1) @(posedge clk);
        send_word(32'h12345678);
        repeat(10) @(posedge clk);

        $display("=== DONE %s", TEST_NAME);
        $finish;
    end

endmodule

`default_nettype wire
