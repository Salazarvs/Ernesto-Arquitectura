`timescale 1ns/1ns

module PC (
    input wire clk,
    input wire reset,
    input wire [31:0] next_address,
    output reg [31:0] current_address
);
    always @(posedge clk) begin
        if (reset) 
            current_address <= 32'd0; 
        else 
            current_address <= next_address; 
    end
endmodule

