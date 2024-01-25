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
	output reg [1:0] wb_data = 00;
	output reg j_src = 0;
	output reg [2:0] next_state = 'b000;
	

	parameter IF_STAGE = 'b000;
	parameter ID_STAGE = 'b001;
	parameter EX_STAGE = 'b010;
	parameter MEM_STAGE ='b011;
	parameter WB_STAGE = 'b100;	
	
	always@(state) begin
		case(state)
			IF_STAGE: begin
				next_state = ID_STAGE;
			end
			ID_STAGE: begin
				if (opcode == 6'b001100)  begin
					next_state = IF_STAGE;
				end
				

	