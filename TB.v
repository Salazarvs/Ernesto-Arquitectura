`timescale 1ns/1ns

module tb_TypeR;  

    reg clk;      
    reg reset;    

    TypeR instTypeR (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;  
        forever begin
            #5 clk = ~clk;  
        end
    end

    initial begin
        reset = 1;     
        #10;           

        reset = 0;     
        #10;    
		#10;
		#10;
		#10;
		#10;
		#10;
		
        $stop;
    end

endmodule
