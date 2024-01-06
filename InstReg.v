module IR(	
	input [31:0] PC;
	input [31:0] inst;
	output reg [31:26] opcode;
	output reg [3:0] inst_rs1 , inst_rs2 , inst_rd; 
	output reg [15:0] imm_16; 
	output reg [25:0] imm_26;
	output reg [1:0] mode;
);				

parameter  [3:0] R_Type_Bits;
parameter [5:0] I_Type_Bits;  

opcode = inst[31:26];

	always @(inst)
	begin 
		R_Type_Bits = inst[31:28];
		I_Types_Bits = inst [31:26];
		if (R_Type_Bits == 4'b0000)	 //R-Type
			begin 
			inst_rd = inst[25:22]; 
			inst_rs1 = inst[21:18]; 
			inst_rs2 = inst[17:14]; 
		end   
		
		else if (R_Type_Bits == 4'b0001 || R_Type_Bits == 4'b0010 || R_Type_Bits == 4'b0011 && I_Type_Bits != 6'b001111) // I_Type
			begin 
			inst_rd = inst[25:22]; 
			inst_rs1 = inst[21:18]; 
			imm_16 = inst[17:2]; 
			mode = inst[1:0];
		end 
		
		else if (I_Type_Bits == 6'b001111 || I_Type_Bits == 6'b010000) //J_Type --> JMP
			begin 
			imm_24 = {PC[31:26],inst[25:0]}; 
		end		
		
		else if (I_Type_Bits == 6'010001) //J_Type --> CALL
			begin 
			 imm_24 = {PC[31:26],inst[25:0]};
			 
			 
		     end	
		else if (I_Type_Bits == 6'010010) //J_Type --> JR 
			begin
			  inst_rd = inst[25:22];
		end	
		else if (I_Type_Bits == 6'010001) //J_Type --> return
			begin 
			
		end	   
		else if (I_Type_Bits == 6'010011) //J_Type --> CALL.R
			begin 
			
		end	
		
		else if (I_Type_Bits == 6'010101 || I_Type_Bits == 6'010111 )	//S-Type .M
		    begin
				inst_rd = inst[25:22];
				inst_rs1 = inst[21:18];
		    end
		else if (I_Type_Bits == 6'010100 || I_Type_Bits == 6'010110 )	//S-Type .1
			 begin
				inst_rd = inst[25:22];
		    end	

		
	    else begin 
		   	inst_rs1 = inst[26:22] ; 
			inst_rd = inst[21:17] ; 
			inst_rs2 = inst[16:12] ; 
			inst_SA = inst[11:7]; 
		end
	end	
	
	
	
endmodule