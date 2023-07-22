//-----------------------------------------------------------------------------
// Title         : Passthrough module
// Project       : SIGARCH Blank RTL
//-----------------------------------------------------------------------------
// File          : sigarch_blank.sv
// Author        : Nebhrajani A. V.
// Created       : 21.07.2023
//-----------------------------------------------------------------------------
// Description :
// A passthrough blank RTL module.
//-----------------------------------------------------------------------------
// Copyright (c) SIGARCH@UIUC <sigarch@acm.illinois.edu>
//------------------------------------------------------------------------------

module sigarch_blank (
  input                     clk,
  input                     rst,
  axi_stream_if.receiver    stream_in,
  axi_stream_if.transmitter stream_out
);

  logic dff;
  always_ff @(posedge clk) begin
    if (rst == 1'b1) dff <= '0;
    else dff <= ~dff;
  end

  // Make module passthrough.
  always_comb begin
    stream_out.data = stream_in.data;
    stream_out.valid = stream_in.valid;
    stream_out.last = stream_in.last;
    stream_out.keep = stream_in.keep;
    stream_in.ready = 1'b1;
  end

endmodule : sigarch_blank
