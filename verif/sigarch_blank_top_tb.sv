//-----------------------------------------------------------------------------
// Title         : Testbench for SIGARCH Blank
// Project       : SIGARCH Blank RTL
//-----------------------------------------------------------------------------
// File          : sigarch_blank_top_tb.sv
// Author        : Nebhrajani A. V.
// Created       : 21.07.2023
//-----------------------------------------------------------------------------
// Description :
// Quick testbench for blank RTL module.
//-----------------------------------------------------------------------------
// Copyright (c) SIGARCH@UIUC <sigarch@acm.illinois.edu>
//------------------------------------------------------------------------------

module sigarch_blank_top_tb;
  import sigarch_blank_top_test_pkg::*;

  bit clk;
  bit rst;

  axi_stream_if stream_in ();
  axi_stream_if stream_out ();

  always_comb begin
    stream_in.clk = clk;
    stream_out.clk = clk;
  end

  sigarch_blank dut (
    // Inputs
    .clk        (clk),
    .rst        (rst),
    // Interfaces
    .stream_in  (stream_in),
    .stream_out (stream_out)
  );

  initial begin
    clk = 1'b0;
    forever #5 clk = !clk;
  end

  initial begin
    rst = 1'b1;
    #20;
    rst <= 1'b0;
    #10;
    stream_in.driver_cb.data <= '1;
    #10;
    stream_in.driver_cb.data <= '0;
    #10;
    `uvm_info($sformatf("%m"), "Hello UVM world!", UVM_MEDIUM)
    #100;
    // run_test();
    $finish;
  end
endmodule : sigarch_blank_top_tb
