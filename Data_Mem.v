module DataMemStack(
	input  wire memRead, memWrite, clk,
	input [31:0] address, data,			
	input wire [31:0] PC, 
	input wire [3:0] Rd,
	input wire [5:0] opcode,
	output reg [31:0] Data_out, [31:0] stackOut,
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
                data = {memory_array[sp+3], memory_array[sp+2], memory_array[sp+1], memory_array[sp]};
                sp = sp + 4; // Increment stack pointer by 4 to move one 'word' up
            end
				6'b000011: begin
				Data_out[] = address;
			end	  
		    	6'b000100: begin
				
			end
		    	6'b000110: begin			
			end	
		     
		if(memWrite)
			begin
			data_mem[address] <= Data_in[7:0];
    		data_mem[address+1] <= Data_in[15:8];
    		data_mem[address+2] <= Data_in[23:16];
    		data_mem[address+3] <= Data_in[31:24];
		end	
	end
		

   	assign Dout = (memR) ? {data_mem[address+3],data_mem[address+2],data_mem[address+1],data_mem[address]} : 32'hzzzzzzzz;
		 
endmodule