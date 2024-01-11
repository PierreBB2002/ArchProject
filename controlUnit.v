module controlUnit (clk , inst_type, inst_function, stop_bit, zero_flag,
	ExSrc, ExS, RS2src, WB, MemR, MemW, WBdata,
	 PCaddSrc1, PCaddSrc2, next_state , 
	ALUsrc, ALUop,
	StR, StW,PCsrc, 
	state);
	

	input clk ; 
  	input [1:0] inst_type;
  	input [4:0] inst_function;
	input stop_bit, zero_flag; 
	input [2:0] state;
	output reg  ExS =0 , RS2src =0 , WB=0 , MemR =0 , MemW =0 , WBdata =0 , PCaddSrc1 =0 , PCaddSrc2 =0 , ALUsrc =0               , StR =0 , StW =0 ;
    output reg [1:0] ExSrc ; 
    output reg [1:0] PCsrc = 'b10 ; 

    output reg [2:0] ALUop = 0 ; 
  input [2:0] next_state ; 
	

endmodule
