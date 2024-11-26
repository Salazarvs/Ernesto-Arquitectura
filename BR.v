`timescale 100ns/100ns

module Banco(
    input [4:0] DL1,      
    input [4:0] DL2,      
    input [4:0] DE,   
    input [31:0] Dato,     
    input WE,            
    output reg [31:0] op1,  
    output reg [31:0] op2   
);
    reg [31:0] BR [0:31]; 
	
	initial
		begin
		$readmemh("datos.txt",BR);
		#10;
	end

    always @* begin
        if (WE) begin
            BR[DE] = Dato;    
		end
		
		op1 = BR[DL1]; 
        op2 = BR[DL2];
	end
endmodule
