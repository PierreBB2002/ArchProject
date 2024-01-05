// Store Module
module store_instruction (
    input [31:0] base_address, // Base address from base register
    input [15:0] offset,       // 16-bit offset
    output [31:0] mem_address  // Calculated memory address
);

    assign mem_address = base_address + {{16{offset[15]}}, offset}; // Sign extend the offset and add to base

endmodule
