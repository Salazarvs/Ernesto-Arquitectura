`timescale 1ns/1ns

module ShiftLeft2(
    input [31:0] in,    
    output [31:0] out   
);
    assign out = in << 2; 
endmodule

