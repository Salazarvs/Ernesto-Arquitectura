`timescale 1ns/1ns

module ALU(
	input [31:0] Ope1,
	input [31:0] Ope2,
	input [2:0] AluOp,
	output reg [31:0] Resultado,
	output Zero	
);

always @* begin 
	case (AluOp)
		3'b010: // ADD
			Resultado = Ope1 + Ope2;

		3'b011: // SUB
			Resultado = Ope1 - Ope2;
			
		3'b000: // AND
			Resultado = Ope1 & Ope2;

		3'b001: // OR
			Resultado = Ope1 | Ope2;

		3'b100: // XOR
			Resultado = Ope1 ^ Ope2;

		3'b101: // NOR
			Resultado = ~(Ope1 | Ope2);
			
		3'b110: // SLT (Set on Less Than)
            Resultado = (Ope1 < Ope2) ? 32'b1 : 32'b0;

		default: 
			Resultado = 32'b0; 
	endcase
end

assign Zero = (Resultado == 32'b0) ? 1'b1 : 1'b0;

endmodule
