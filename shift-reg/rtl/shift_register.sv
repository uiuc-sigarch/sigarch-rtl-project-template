module shift_register
  #(
    parameter CHUNK_WIDTH=8,
    parameter REG_WIDTH=1
    )
  (
   input logic                                   clk,
   input logic                                   rst_n,  // _n is used to signify a signal is active low

   input logic [CHUNK_WIDTH-1:0]                 data_i, // _i is used to signify an input
   input logic                                   valid_i,

   output logic [REG_WIDTH-1:0][CHUNK_WIDTH-1:0] data_o  // _o is used to signify an output
   );

   // TODO your code goes here.

endmodule : shift_register
