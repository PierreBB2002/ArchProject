module ControlUnit( opcode, zeroFlag, carryFlag, negFlag, state, mode, PC_src, ext_src, RegW1, RegW2, read, write, reg_des, ALU_src, wb_data, j_src, next_state);	  
	input [5:0] opcode;
	input zeroFlag;
	input carryFlag;
	input negFlag;
	input [2:0] state;
	input [1:0] mode;
	output reg [1:0] PC_src = 'b00;
	output reg ext_src = 0;
	output reg RegW1 = 0;
	output reg RegW2 = 0;
	output reg read = 0;
	output reg write = 0; 
	output reg reg_des = 0;
	output reg ALU_src = 0;
	output reg [1:0] wb_data = 'b00;
	output reg j_src = 0;
	output reg [2:0] next_state = 'b000;
	

	parameter IF_STAGE = 0;
	parameter ID_STAGE = 1;
	parameter EX_STAGE = 2;
	parameter MEM_STAGE = 3;
	parameter WB_STAGE = 4;
	
	always@(state) begin
		case(state)
			IF_STAGE: begin
				next_state = ID_STAGE;
			end
			ID_STAGE: begin
				if (opcode == 6'b001100)  begin
					next_state = IF_STAGE;
				end
				else
					next_state = EX_STAGE;
			end
			EX_STAGE: begin
				if (opcode == 6'000000 || opcode == 6'b000001 || opcode == 6'b000010 || opcode == 6'b000011 || opcode == 6'b000100)	
					next_state = WB_STAGE;
				else if (opcode == 6'b000101 || opcode == 6'b000110 || opcode == 6'b000111 || opcode == 6'b001101 || opcode == 6'b001110|| opcode == 6'b001111|| opcode == 6'b001111)  
					next_state = MEM_STAGE;
				else 
					next_state = IF_STAGE;
			end
			MEM_STAGE: begin
				if (opcode == 6'b000101 || opcode == 6'b000110 || opcode == 6'b010000)
					next_state = WB_STAGE;	 
				else 
					next_state = IF_STAGE;
			end	
			WB_STAGE: begin
				next_state = IF_STAGE;
			end
		endcase
		end
	always@ (state, opcode) begin
		if (opcode == 6'b000000 || opcode == 6'b000001 || opcode == 6'b000010) //R_type
			begin
				reg_des <= 0;
				ALU_src <= 0;
				wb_data <= 0;
			end
		else if (opcode == 6'b000011 || opcode == 6'b000100) //ADDI ANDI
			begin
				reg_des <= 1;
				ALU_src <= 1;
				ext_src <= 1; 
				wb_data <= 0;
			end
		else if (opcode == 6'b000101) // LW--> write to Rd
			begin
				reg_des <= 1;
				ALU_src <= 1;
				ext_src <= 1; 
				wb_data <= 1;
				read <= 1; 
				write <= 0; 
				if (next_state == 4) begin
				RegW1 <= 1;
				end
			end
		else if (opcode == 6'b000110) //LWPOI  //////////////////////////////////////////come backkkkk
			begin
				reg_des <= 1;
				ALU_src <= 1;
				ext_src <= 1; 
				wb_data <= 1; 
				read <= 1; 
				write <= 0; 
				if (next_state == 4) begin
					RegW1 <= 1;	 
					RegW2 <= 1;
				end
			end
		else if (opcode == 6'b000111) //SW
			begin
				reg_des <= 1;
				ALU_src <= 1;
				ext_src <= 1; 
				RegW1 <= 0;	 
				RegW2 <= 0;
				read <= 0; 
				if(next_state == 3) begin
					write <= 1; 
				end	
		else if (opcode == 6'b001000 || opcode == 6'b001001 || opcode == 6'b001010 || opcode == 6'b001011)	//Branch
			begin 
				reg_des <= 1;
				ALU_src <= 1;
				ext_src <= 1;
				read <= 0;
				write <= 0;
			    RegW1 <= 0;
				RegW2 <= 0;
			end
		else if (opcode == 6'b001100) begin	// JMP
			j_src <= 0;
		end
		else if (opcide == 6'b001110) begin	// RET
			j_src <= 1;
		end	
		else if (opcode == 6'b010000) begin	 //POP
			wb_data <= 2;
			if (next_state == 4)  begin
				RegW1 <= 1;
			end
		end
		
	endcase
	
 end 
 
 always@ (opcode, zeroFlag, carryFlag, negFlag, state , next_state) begin
	if (next_state == IF_STAGE) begin
		if (opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110)	begin // JMP RET CALL
			PC_src <= 1;
		end
		else if (opcode == 6'b001000) begin //BGT 
			if (carryFlag == 0) begin
				PC_src <= 2;
			end
		else		 
			begin
			PC_src <= 0;  
			end
		end
		else if (opcode == 6'b001001) begin //BLT
			if (negFlag == 1) begin
				PC_src <= 2;
			end
		else
			begin
			PC_src <= 0;
			end
		end
		else if (opcode == 6'b001010) begin //BEQ
			if (zeroFlag == 1) begin
				PC_src <= 2;
			end
		else
			begin
			PC_src <= 0;
			end
		end	
		else if (opcode == 6'b001011) begin //BNE
			if (zeroFlag == 0) begin
				PC_src <= 2;
			end
		else if (opcode == 6'b001101 || opcode == 6'b001110) begin // CALL RET
			PC_src <= 1; 
			end
		else
			begin
			PC_src <= 0;
			end
		end
	end
		
			
				
endmodule
				
			
		
		
			

	