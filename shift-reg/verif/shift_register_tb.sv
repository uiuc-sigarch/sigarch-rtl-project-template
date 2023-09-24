//-----------------------------------------------------------------------------
// Title         : Testbench for Shift Register
// Project       : SIGARCH Shift Register
//-----------------------------------------------------------------------------
// Description :
// Testbench for shift register module
//-----------------------------------------------------------------------------
// Copyright (c) SIGARCH@UIUC <sigarch@acm.illinois.edu>
//------------------------------------------------------------------------------

`define DEBUG_PRINT 1

`define CHUNK_WIDTH 8
`define REG_WIDTH 4

module shift_register_tb;

   bit clk; // Why do we use bit instead of logic in our testbenches?
   bit rst_n;
   bit [`CHUNK_WIDTH-1:0] data_i;
   bit valid_i;
   bit [`REG_WIDTH-1:0][`CHUNK_WIDTH-1:0] data_o;

   always #1 clk = clk === 1'b0;
   shift_register #(.CHUNK_WIDTH(`CHUNK_WIDTH), .REG_WIDTH(`REG_WIDTH)) dut (.*); // dut = Device Under Test

   bit [`REG_WIDTH-1:0][`CHUNK_WIDTH-1:0] expected_data = 0;

   task reset();
      rst_n = 1'b0;
      @(posedge clk) rst_n = 1'b1;

      assert(data_o === 0);
   endtask : reset

   task input_data(input logic [`CHUNK_WIDTH-1:0] data);
      data_i = data;
      if(`DEBUG_PRINT) $display("Enqueuing %x", data);
      valid_i = 1'b1;
      @(posedge clk) valid_i = 1'b0;

      expected_data = {data, expected_data[`REG_WIDTH-1:1]};
      if(`DEBUG_PRINT) $display("data_o: %x", data_o);

      assert(data_o === expected_data);

   endtask : input_data

   initial begin
      $display("Starting shift register testbench.");
      // clear signals
      rst_n = 1'b1;
      valid_i = 1'b0;

      reset();
      $display("Reset complete.");

      input_data(8'hff);

      $display("All tests passed.");
      $finish;
   end

endmodule : shift_register_tb
