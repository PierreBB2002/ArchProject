module IR(	
	input [31:0] PC;
	input [31:0] inst;
	output reg [5:0] opcode;
	output reg [3:0] inst_rs1, inst_rs2, inst_rd; 
	output reg [15:0] imm_16; 
	output reg [31:0] imm_26;
	output reg [1:0] mode
);

parameter [3:0] R_Type_Bits = 4'b0000;
parameter [5:0] I_Type_Bits = 6'b000000;

always @(inst)
begin 
	R_Type_Bits = inst[31:28]; // first 4 bits of the opcode
	I_Type_Bits = inst[31:26]; // first 6 bits of the opcode

	opcode = inst[31:26];

	if ((R_Type_Bits == 4'b0000) && (I_Type_Bits != 6'b000011)) // R-Type
	begin 
		inst_rd = inst[25:22]; 
		inst_rs1 = inst[21:18]; 
		inst_rs2 = inst[17:14]; 
	end   
	
	else if ((R_Type_Bits == 4'b0001) || (R_Type_Bits == 4'b0010) || (I_Type_Bits == 6'b000011)) // I-Type
	begin 
		inst_rd = inst[25:22]; 
		inst_rs1 = inst[21:18]; 
		imm_16 = inst[17:2]; 
		mode = inst[1:0];
	end 
	
	else if ((I_Type_Bits == 6'b001100) || (I_Type_Bits == 6'b001101)) // J-Type --> JMP or CALL
	begin 
		imm_26 = {PC[31:26], inst[25:0]}; 
	end		
	
	else if ((I_Type_Bits == 6'b001111) || (I_Type_Bits == 6'b010000)) // S-Type --> PUSH or POP
	begin
		inst_rd = inst[25:22];
	end
				
end

endmodule
