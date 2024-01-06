module stackBlock (	
	input wire [31:0] PC,
	input wire [5:0] opcode,
	input wire [3:0] Rd,
	input wire [3:0] Rs1,
	input wire clk,	
	output wire [31:0] data_out
     );
	
	reg [9:0] stackP = 0; //initialize stack pointer to 0
	reg [31:0] stack [0:1023]; // stack block with 16 elements each one 32-bits 
	reg [31:0] registers [0:1023]; // array to store popped values

    
    always @(posedge clk)  
		
	begin			   
	  if ((opcode == 6'b010100) && (stackP < 1023)) //PUSH.1
		  begin	     
			  stack[stackP] = Rd; 
			  stackP = stackP + 1;	
		  end  
	   if ((opcode == 6'b010101) && (stackP < 1023))  // PUSH.M
		  begin 
            for (int i = Rd; i <= Rs1; i = i + 1)
                stack[stackP + (i - Rd)] = i;	
				
            stackP = stackP + (Rs1 - Rd) + 1;
           end
       if ((opcode == 6'b010110) && (stackP > 0)) // POP.1
		   begin 
            stackP = stackP - 1;
            Rd = stack[stackP];
        end	   
	   if ((opcode == 6'b010111) && (stackP >= (Rs1 - Rd)) && (stackP > 0))	// POP.M
		   begin 
            for (int i = Rd; i <= Rs1; i = i + 1)
                stackP = stackP - 1;
                registers[i] = stack[stackP + (Rs1 - i)];
            end	 
	if ((opcode == 6'b010000) && (stackP < 1023))	//CALL
		begin
			stack[stackP] = (PC + 4); 
			stackP = stackP + 1;  
		end	  
	if ((opcode == 6'b010010))	// JR
		begin
			data_out = Rs1;
		end	 			  
	if ((opcode == 6'b010011))  // CALL.R
		begin  
			if (stackP < 1023)
				begin
			stack[stackP] = (PC + 4); 
			stackP = stackP + 1;
			end
			data_out = Rs1;
		end	 
	
	if ((opcode == 6'b010001) && (stackP > 0))	//RET
		begin 
			stackP = stackP - 1;  	  
			data_out = stack[stackP];
		end		
	

	   
    end
endmodule