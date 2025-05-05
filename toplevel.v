module toplevel(
    input clk,                // Clock
    input rst,                // Active-low reset
    input start,              // Trigger to begin hashing
    input [7:0] block_idx_a,  // Address for first 256-bit block
    input [7:0] block_idx_b,  // Address for second 256-bit block
    output [255:0] hash_out,  // Computed SHA-256 hash
    output hash_valid         // High when hash_out is valid
);

//----------------------------------------------------------
// Internal wires
//----------------------------------------------------------
wire [255:0] q_a;
wire [255:0] q_b;
wire [511:0] message_block;

assign message_block = {q_a, q_b};  // Concatenate MSB = q_a, LSB = q_b

//----------------------------------------------------------
// Memory Instance
//----------------------------------------------------------
mem memory_inst (
    .address_a(block_idx_a),
    .address_b(block_idx_b),
    .clock(clk),
    .q_a(q_a),
    .q_b(q_b)
);

//----------------------------------------------------------
// SHA256 Instance
//----------------------------------------------------------
SHA256 sha256_instance (
    .clk(clk),               // Connect to top-level clock
    .rst(rst),               // Connect to top-level reset
    .go_i(start),            // Start signal from top-level
    .block(message_block),   // Concatenated 512-bit input block
    .Digest(hash_out),       // Final hash output (256 bits)
    .sig_done(hash_valid)    // Indicates hash_out is valid
);

endmodule
