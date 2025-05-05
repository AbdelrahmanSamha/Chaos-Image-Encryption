module mux2 (
    input sel,          // 1-bit select
    input [31:0] in0,   // 32-bit input 0
    input [31:0] in1,   // 32-bit input 1
    output [31:0] out   // 32-bit output
);
    assign out = sel ? in1 : in0;  // Compact combinational logic
endmodule