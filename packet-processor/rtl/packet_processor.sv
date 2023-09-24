module packet_processor
  #(
    parameter MAX_PACKETS=8, // maximum number of packets before final
    parameter HEADER_WIDTH_BYTES=4,
    parameter DATA_WIDTH_BYTES=4
    )
   (
    input                                                    clk,
    input                                                    rst_n,

    axi_stream_if.receiver                                   stream_in,

    output logic                                             valid_o,
    output logic [$clog2(MAX_PACKETS):0]                     length_o,
    output logic [MAX_PACKETS-1:0][(DATA_WIDTH_BYTES*8)-1:0] data_o
    );

   assign stream_in.ready = 1'b1;


   // TODO your code goes here

endmodule : packet_processor
