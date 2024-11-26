`timescale 1ns/1ns

module Alu_Control(
    input [2:0] Entre_ALUC,
    input [5:0] funct,   
    output reg [2:0] AluOpC
);

always @* begin
    case(Entre_ALUC)
        3'b000: 
            begin
                case(funct)
                    6'b100000: 
                        AluOpC = 3'b010; // ADD
                    6'b100010: 
                        AluOpC = 3'b011; // SUB
                    6'b100100: 	
                        AluOpC = 3'b000; // AND
                    6'b100101: 
                        AluOpC = 3'b001; // OR
                    6'b100110: 
                        AluOpC = 3'b100; // XOR
                    6'b100111: 
                        AluOpC = 3'b101; // NOR
                    6'b101010: 
                        AluOpC = 3'b110; // SLT
                    default: 
                        AluOpC = 3'b000; // Default case
                endcase
            end

        // ADDI (Suma Inmediata) 
        3'b001: 
            AluOpC = 3'b010; 

        // LW y SW (carga y almacenamiento)
        3'b010: 
            AluOpC = 3'b010; 
            
        // BEQ (Branch if Equal) -> Operación de comparación
        3'b011: 
            AluOpC = 3'b011; 

        default: 
            AluOpC = 3'b000; // Default case
    endcase
end

endmodule
