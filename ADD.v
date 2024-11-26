`timescale 1ns/1ns

module Add (
    input wire [31:0] pc_value,
    output wire [31:0] result
);
    assign result = pc_value + 32'd4; 
endmodule

