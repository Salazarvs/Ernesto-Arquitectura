`timescale 1ns/1ns

module TypeR(
	input reset,
	input clk
);	

//BR
wire [31:0] d1BR_op1ALu;
wire [31:0] d2BR_op2ALu;  //Mux before alup
//cable Mux1
wire [31:0] DatoMem2BR;
//cables Alu
wire [31:0] ResALU;

wire [31:0] w_next_address; //De ADD a PC
wire [31:0] w_current_address; //De PC a ADD
wire [31:0] instruccion;

//cable para unidad de control a mux2
wire RegDst;
//cable de mux2 a Br
wire [4:0] ExitMux1;
wire [4:0] DirBr = instruccion [20:16];
wire [4:0] WriteBr = instruccion [15:11];

//cables de signExtend
wire [15:0] ent_sign = instruccion[15:0];
wire [31:0] exi_sign;

//cables mux before the alu
wire rico;
wire [31:0] alu_entre;

//CABLES PARA UNIDAD DE CONTROL
wire BR_enabler; //BR
wire [2:0] AluControl; //AluControl
wire MemW; //mem
wire MemR; //mem
wire Mem_to_BR; //Mux

//Cable de AluControl a Alu
wire [2:0]AluConExit;

//cables de mem
wire [31:0] MemD;

//cable de unidad de control a AND
wire entraAnd;
//alu a AND
wire entreAnd;
//salida de AND
wire andExit;
//salida mux 4 ->PC
wire [31:0] ExitMux4;
//salida Shift2 a ADD
wire [31:0] left2;
//Salida de add para mux 4
wire [31:0] ExitADD;

PC instPC (                    
	.clk(clk),
    .reset(reset),
    .next_address(ExitMux4), 
    .current_address(w_current_address) 
);

Add instAdd (                   
    .pc_value(w_current_address), 
    .result(w_next_address)
);

instruction intru(
	.Entre_instru(w_current_address),
	.exit_instru(instruccion)
);

U_Control U_C (
	.OpCode(instruccion [31:26]), //input
	.BR_En(BR_enabler),  //BR
	.AluC(AluControl),  //AluControl*
	.EnW(MemW), //mem
	.EnR(MemR), //mem
	.Mux1(Mem_to_BR), //mux
	.Mux2(RegDst), //Mux before BR
	.Mux3(rico), //Mux before alup
	.Branch(entraAnd)   
);

Banco instBanco (
	.DL1(instruccion [25:21]),
	.DL2(instruccion [20:16]),
	.DE (ExitMux1),
	.Dato (DatoMem2BR),
	.WE(BR_enabler), //U_Control
	.op1(d1BR_op1ALu),
	.op2(d2BR_op2ALu)
);

Alu_Control alu_C (
	.Entre_ALUC(AluControl),
	.funct(instruccion[5:0]),
	.AluOpC(AluConExit)
);

ALU instAlu (
	.Ope1(d1BR_op1ALu),
	.Ope2(alu_entre),
	.AluOp(AluConExit),
	.Resultado(ResALU),
	.Zero(entreAnd)
);

Ram instRam(
	.Address(ResALU),
	.writeDta(d2BR_op2ALu),
	.WE(MemW),
	.RE(MemR),
	.Datoout(MemD)
);

mux2_1 mux3(
	.sel(Mem_to_BR),
	.A(MemD),
	.B(ResALU),
	.C(DatoMem2BR)
);

mux1 Mux1(
	.sel(RegDst),
	.A(DirBr), //DirBr
	.B(WriteBr),
	.C(ExitMux1)
);


s_extend SignEx(
	.Ent_sign(ent_sign),
	.exit_sign32(exi_sign)
);

mux2 Mux2(
	.sel(rico),
	.A(d2BR_op2ALu),
	.B(exi_sign),
	.C(alu_entre)
);

AND AND1(
	.a(entraAnd),   
    .b(entreAnd),    
    .out(andExit)
);

mux4 Mux4(
	.sel(andExit),
	.A(w_next_address),
	.B(ExitADD),
	.C(ExitMux4)
);

ShiftLeft2 Shift2(
    .in(exi_sign),    
    .out(left2)   
);

Adder addAlu(
    .a(w_next_address),  
    .b(left2),  
    .sum(ExitADD)
);

endmodule

//INTRUCCION ADD $7, $1, $2 
//OP      Rs    Rt    Rd    Shamt    Fnc
//000000_00001_00010_00111_00000_100000

//OP      Rs    Rt    inmediate
//001000_00001_00010_0000000000110000

//Lw      BASE    RT    OFFSET    $9 $6 #5
// OP      RT   RS       INMEDIATE
//100011_01001_00110_0000000000000101

//SW ----store word ----- guarda un dato que esta en el br a mem de datos
// OP      RS     RT       INMEDIATE
//sw $12, $6, #10
//100011_00110_01100_0000000000001010

///-------BEQ - Branch on Equals---
//se hace un Branch si 2 registros del BR son iguales
//SI ES ASI SE HACE UN Branch
//beq     $8, $9, #3
// OP      RS     RT       INMEDIATE
//000100_01000_01001_0000000000000011

//Addi $8, $8, #2
//Addi $8, $8, #2
//J#16
//sw $8, $6, #9