module DataMemStack(
    input wire clk,
    input wire memRead, 
    input wire memWrite,
    input wire [31:0] address, 
    input wire [31:0] data,    // Data to write for SW, or data to push for PUSH
    input wire [31:0] PC,      // Program Counter, used for CALL instruction
    input wire [5:0] opcode,   // Operation code to determine the action
    output reg [31:0] Data_out,// Data read for LW, or data popped for POP
    output reg [31:0] stackOut // The current stack pointer output after push or pop
);

    reg [7:0] data_mem [1023:0]; // Data memory array
    reg [31:0] sp;               // Stack Pointer

    initial begin
        sp = 10'd1023; // Initialize stack pointer to the top of the stack
    end

    always @(posedge clk) begin
        case (opcode)
            6'b001111: begin // PUSH
                sp = sp - 4; 
                data_mem[sp]   = data[7:0];
                data_mem[sp+1] = data[15:8];
                data_mem[sp+2] = data[23:16];
                data_mem[sp+3] = data[31:24];
                stackOut = sp; // The new stack pointer after push
            end
            6'b010000: begin // POP
                Data_out = {data_mem[sp+3], data_mem[sp+2], data_mem[sp+1], data_mem[sp]};
                sp = sp + 4; 
                stackOut = sp; // The new stack pointer after pop
            end
            6'b010010: begin // CALL
                sp = sp - 4; 
                data_mem[sp]   = PC[7:0];
                data_mem[sp+1] = PC[15:8];
                data_mem[sp+2] = PC[23:16];
                data_mem[sp+3] = PC[31:24];
                // Note: The PC will be set to the target address by the Control Unit
            end
            // Add I-type LOAD and STORE instruction cases here
        	6'b000101: begin // LW
        	if (memRead) begin
           	 // Assuming address calculation has been done prior
            Data_out = {data_mem[address+3], data_mem[address+2], data_mem[address+1], data_mem[address]};
       	 end
    end
		6'b000110: begin // SW
        if (memWrite) begin
            // Assuming address calculation has been done prior
            data_mem[address]   = data[7:0];
            data_mem[address+1] = data[15:8];
            data_mem[address+2] = data[23:16];
            data_mem[address+3] = data[31:24];
        end
    end

            // Other instructions can be added here
            // ...

            default: begin
                // Default case to handle no operation or unrecognized opcode
                // This can also be used for error handling
            end
        endcase

        // Handle memory read operations
        if (memRead && (opcode != 6'b001111 && opcode != 6'b010000)) begin // Exclude PUSH and POP
            Data_out = {data_mem[address+3], data_mem[address+2], data_mem[address+1], data_mem[address]};
        end

        // Handle memory write operations
        if (memWrite && (opcode != 6'b001111 && opcode != 6'b010000)) begin // Exclude PUSH and POP
            data_mem[address]   = data[7:0];
            data_mem[address+1] = data[15:8];
            data_mem[address+2] = data[23:16];
            data_mem[address+3] = data[31:24];
        end
    end

endmodule
