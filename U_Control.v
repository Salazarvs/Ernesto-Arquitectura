`timescale 1ns/1ns


module U_Control (

	input [5:0] OpCode,  //TypeR = 000000
	output reg BR_En,     //regWrite
	output reg [2:0] AluC,
	output reg EnW,  //to Write MemDatos
	output reg EnR,		//to Write MemDatos
	output reg Mux1,		//Mux Alu/mem->BR, mux2_1
	output reg Mux2,    //Mux MUX1, before the Br
	output reg Mux3,     //AluSrc
	output reg Branch
);

always @*
begin
	case (OpCode)
		6'b000000:   //Inst tipo R
			begin
			BR_En = 1'b1;
			AluC = 3'b000;
			EnW = 1'b0;
			EnR = 1'b0;
			Mux1 = 1'b1;
			Mux2 = 1'b1;
			Mux3 = 1'b0;
			end
			
		6'b001000:  //inst ADDI(SUMA INMEDIATA)
			begin
				BR_En = 1'b1;        
				AluC = 3'b010;      
				EnW = 1'b0;         
				EnR = 1'b0;         
				Mux1 = 1'b1;   
				Mux2 = 1'b0;
				Mux3 = 1'b1;
			end	
        
		6'b100011:   // LW (Load Word)
            begin
                BR_En = 1'b1;          
                AluC = 3'b010;         
                EnW = 1'b0;            
                EnR = 1'b1;            
                Mux1 = 1'b0;           
                Mux2 = 1'b0;  
				Mux3 = 1'b1;
            end
        
		6'b101011:   // SW (Store Word)
            begin
                BR_En = 1'b0;          
                AluC = 3'b010;         
                EnW = 1'b1;            
                EnR = 1'b0;            
                Mux1 = 1'b1;           
                Mux2 = 1'b1;  
				Mux3 = 1'b1;
            end
			
		6'b000100:   //BEQ
			begin
				BR_En = 1'b0; 
				AluC = 3'b011;
				EnW = 1'b0;
				EnR = 1'b0;
				Mux1 = 1'b0;
				Mux2 = 1'b0;
				Mux3 = 1'b0;
				Branch = 1'b1;
			end
    endcase
end

endmodule
