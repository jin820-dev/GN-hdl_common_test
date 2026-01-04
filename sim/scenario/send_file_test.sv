// ------------------------------------------------------------
// File    : send_file_test.sv
// Author  : jin820
// Created : 2026-01-02
// Updated :
// History:
// 2026-01-04  Initial version
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

    // set data file path 
    string DATA_FILE;
    initial begin
        if ($value$plusargs("DATA_DIR=%s", DATA_FILE)) begin
          $display("DATA_DIR value was %s", DATA_FILE);
        end else begin
          $display("+DATA_DIR= not found");
        end
        DATA_FILE = {DATA_FILE, "/32bit_32words.txt"};
    end

    // test start
    initial begin

        $display("=== START %s", TEST_NAME);

        test_task();
        // init
        i_mdl_axis_mst.init();
        wait(reset_n == 1'b1);
        @(posedge clk);
        
        // send_word (dwidth = 32bit)
        send_file(DATA_FILE, 32, 256);

        repeat(10) @(posedge clk);

        $display("=== DONE %s", TEST_NAME);
        $finish;
    end

endmodule

`default_nettype wire
