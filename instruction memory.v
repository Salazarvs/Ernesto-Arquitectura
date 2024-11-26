`timescale 100ns/100ns

module instruction(
	input[31:0] Entre_instru,       //entra lo que sale de pc
	output reg [31:0] exit_instru    
);
	reg [36:0] MEM [0:36]; 
	
	initial
		begin
		$readmemb("instructionMem.txt", MEM);
		#100;
	end
	
	always @* begin
		exit_instru = MEM[Entre_instru[4:0]];
	end


endmodule

