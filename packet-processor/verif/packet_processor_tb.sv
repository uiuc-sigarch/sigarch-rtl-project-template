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

`define MAX_PACKETS 4
`define HEADER_WIDTH_BYTES 1
`define DATA_WIDTH_BYTES 2

module packet_processor_tb;
   localparam int HEADER_WIDTH = `HEADER_WIDTH_BYTES*8;
   localparam int DATA_WIDTH = `DATA_WIDTH_BYTES*8;
   localparam int PACKET_WIDTH = HEADER_WIDTH + DATA_WIDTH;

   bit clk;
   bit rst_n;
   bit valid_o;
   bit [$clog2(`MAX_PACKETS):0] length_o;
   bit [`MAX_PACKETS-1:0][DATA_WIDTH-1:0] data_o;

   always #5 clk = clk === 1'b0;

   axi_stream_if #(.DATA_WIDTH_BYTES(`DATA_WIDTH_BYTES + `HEADER_WIDTH_BYTES)) stream_in ();
   assign stream_in.clk = clk;

   packet_processor #(.MAX_PACKETS(`MAX_PACKETS), .HEADER_WIDTH_BYTES(`HEADER_WIDTH_BYTES),
                      .DATA_WIDTH_BYTES(`DATA_WIDTH_BYTES))
   dut (.*);

   logic [DATA_WIDTH-1:0] data_queue [$];

   task reset();
      rst_n = 1'b0;
      @(posedge clk) rst_n = 1'b1;
   endtask : reset

   task send_packet(input logic [PACKET_WIDTH-1:0] packet, input bit is_last);
      axi_stream_if.valid = 1'b1;
      @(posedge clk iff axi_stream_if.ready);
      axi_stream_if.data = packet;
      axi_stream_if.last = is_last;
      @(posedge clk);
      axi_stream_if.valid = 1'b0;

      data_queue.push_back(packet[DATA_WIDTH-1:0]);

      if(is_last) begin
         assert(valid_o === 1);
         for(int i = 0; i < length_o; ++i) begin
            assert(data_queue.pop_front() === data_o[i]);
         end
      end
   endtask : send_packet

   initial begin
      axi_stream_if.valid = 1'b0;
      axi_stream_if.last = 1'b0;
      $display("Starting packet processor testbench.");
      reset();

      send_packet(16'habcd, 1);

      // TODO add more tests

      $finish;
   end
endmodule : packet_processor_tb;
