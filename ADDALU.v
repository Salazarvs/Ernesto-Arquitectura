`timescale 1ns/1ns


module Adder(
    input [31:0] a,  
    input [31:0] b,  
    output [31:0] sum 
);
    assign sum = a + b; 
endmodule

