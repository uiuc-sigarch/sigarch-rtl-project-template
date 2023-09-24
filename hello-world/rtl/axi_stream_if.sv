//-----------------------------------------------------------------------------
// Title         : AXI4-Stream Interface
// Project       : SIGARCH Blank RTL
//-----------------------------------------------------------------------------
// File          : axi_stream_if.sv
// Author        : Nebhrajani A. V.
// Created       : 21.07.2023
//-----------------------------------------------------------------------------
// Description :
// Implements a basic AXI4-Stream interface, along with modports for transmitter
// and receiver, and clocking blocks for verification. Note: parameter enforces
// byte-sized data buses, this can be changed, though.
//-----------------------------------------------------------------------------
// Copyright (c) SIGARCH@UIUC <sigarch@acm.illinois.edu>
//------------------------------------------------------------------------------

interface axi_stream_if #(parameter int DATA_WIDTH_BYTES = 8);

  // Enforces byte granularity of AXI Stream.
  localparam int DATA_WIDTH = 8 * DATA_WIDTH_BYTES;

  // For clocking blocks.
  logic                        clk;

  //============================================================
  // AXI4 Stream signals.
  //============================================================
  logic                        ready;
  logic                        valid;
  logic [DATA_WIDTH-1:0]       data;
  logic                        last;
  logic [DATA_WIDTH_BYTES-1:0] keep;

  //============================================================
  // Modports
  //============================================================
  modport transmitter (
    input  ready,
    output valid,
    output data,
    output last,
    output keep
  );

  modport receiver (
    input  valid,
    input  data,
    input  last,
    input  keep,
    output ready
  );

  //============================================================
  // Clocking blocks for simulation.
  //============================================================
  clocking driver_cb @(posedge clk);
    default input #1step output #0;

    input  ready;
    output valid;
    output data;
    output last;
    output keep;
  endclocking: driver_cb

  clocking responder_cb @(posedge clk);
    default input #1step output #0;

    input  valid;
    input  data;
    input  last;
    input  keep;
    output ready;
  endclocking: responder_cb

  clocking monitor_cb @(posedge clk);
    default input #1step output #0;

    input valid;
    input data;
    input last;
    input keep;
    input ready;
  endclocking: monitor_cb

endinterface : axi_stream_if
