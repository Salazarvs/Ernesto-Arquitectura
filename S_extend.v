`timescale 1ns/1ns

module s_extend (

	input [15:0] Ent_sign,
	output reg [31:0] exit_sign32
);
	
always @* begin
    if (Ent_sign[15] == 1'b1)  
        exit_sign32 = {16'b1111111111111111, Ent_sign}; 
    else  
        exit_sign32 = {16'b0000000000000000, Ent_sign}; 
end

endmodule