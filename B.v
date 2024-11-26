`timescale 100ns/100ns

module Ram(
	input wire [31:0] Address,
	input wire [31:0] writeDta,
	input wire WE,
	input RE,
	
	output reg [31:0] Datoout
);

	reg [31:0] ram [0:31];
	
	initial
		begin
		$readmemh("MemB.txt", ram);
		#100;
	end
	
	always @(*)
	begin
		if(WE)
		begin
			ram[Address] = writeDta;
		end
		
		else if(RE)
		
		begin
			Datoout = ram[Address];
		end
		
	end
	

endmodule
