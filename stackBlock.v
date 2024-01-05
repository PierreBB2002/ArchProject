module stackBlock (		
	input wire [31:0] data_in,
    output reg [31:0] data_out,
    input wire clk,
    input wire pop_en,
    input wire push_en );
	
	reg [3:0] stackP = 0; //initialize stack pointer to 0
    reg [31:0] stack [0:15]; // stack block with 16 elements each one 32-bits
    
    always @(posedge clk)  
		
	begin
      if ((push_en == 1) && (pop_en == 0 ) && (stackP < 15)) //push element to stack if available
		 begin
       	 stackP = stackP + 1;	  
		 stack[stackP] = data_in;
  	  end
    
	  if ((pop_en == 1) && (push_en == 0) && (stackP > 0))  //pop element from stack 
	     begin 
		 stackP = stackP - 1;
      	 data_out =  stack[stackP]; 	
      end
	   
    end
endmodule