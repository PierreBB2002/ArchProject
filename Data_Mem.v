module DataMemStack(
	input  wire memRead, memWrite, clk,
	input [31:0] address, data,	//data = Rd		
	input wire [31:0] PC, 
	input wire [31:0] Rs1,
	input wire [5:0] opcode,
	output reg [31:0] Data_out,
	output reg [31:0] stackOut,
	output reg [31:0] addRs1,
);					  

reg [7:0] data_mem [1023:0]; 

	initial begin
        sp = 10'd1023; // Initialize stack pointer to the top of byte-addressable memory
    end
	
	
	always @(posedge clk) begin	  
		
		case (opcode)
			begin	 
				6'b001111: begin // PUSH operation code
                sp = sp - 4; // Decrement stack pointer by 4 to move one 'word' down
                // Writing data byte by byte
                memory_array[sp] = data[7:0];
                memory_array[sp+1] = data[15:8];
                memory_array[sp+2] = data[23:16];
                memory_array[sp+3] = data[31:24];
            end		   
				6'b010000: begin // POP operation code
                Data_out = {memory_array[sp+3], memory_array[sp+2], memory_array[sp+1], memory_array[sp]};
                sp = sp + 4; // Increment stack pointer by 4 to move one 'word' up
            end
				 6'001101: begin // CALL
                sp = sp - 4; 		   
				PC = PC + 1; 
                data_mem[sp]   = PC[7:0];
                data_mem[sp+1] = PC[15:8];
                data_mem[sp+2] = PC[23:16];
                data_mem[sp+3] = PC[31:24];
            end
		    	6'b000101: begin // LW
	        	if (memRead) begin
	            Data_out = {data_mem[address+3], data_mem[address+2], data_mem[address+1], data_mem[address]};
	       		 end
	   		 end	
				6'000110: begin // LW.POI
	        	if (memRead) begin
	            Data_out = {data_mem[address+3], data_mem[address+2], data_mem[address+1], data_mem[address]};
				addRs1 = Rs1 + 1; 
	       		 end
	   		 end	   
				
				
			6'b000111: begin // SW
      		  if (memWrite) begin
	            data_mem[address]   = data[7:0]; //Rd is stored in memory
	            data_mem[address+1] = data[15:8];
	            data_mem[address+2] = data[23:16];
	            data_mem[address+3] = data[31:24];
	      	  end
	 	   end		
			6'001110: begin // RET
	      		 stackOut = {memory_array[sp+3], memory_array[sp+2], memory_array[sp+1], memory_array[sp]};
                sp = sp + 4; // Increment stack pointer by 4 to move one 'word' up
		 	   end
	end
		

   	assign Dout = (memR) ? {data_mem[address+3],data_mem[address+2],data_mem[address+1],data_mem[address]} : 32'hzzzzzzzz;
		 
endmodule