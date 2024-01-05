// Sign Extender Module
module sign_extender (
    input [31:0] in,
    input signop,
    input EXsrc, 
    output reg [31:0] out
);

always @(*) begin
    integer i;
    integer j;

    // Determine the number of bits to be extended based on EXsrc
    if(EXsrc == 0) begin 
        j = 5; // extend from bit 5 for a specific instruction type
    end 
    else if (EXsrc == 1) begin 
        j = 14; // extend from bit 14 for another instruction type
    end
    else begin 
        j = 24; // extend from bit 24 for yet another instruction type
    end

    // Copy the original bits
    for(i = 0; i < j; i = i + 1) begin
        out[i] = in[i];
    end

    // Perform sign or zero extension
    if (signop) begin
        // Signed extension
        for(i = j; i < 32; i = i + 1) begin
            out[i] = in[j - 1];
        end
    end
    else begin
        // Zero extension
        for(i = j; i < 32; i = i + 1) begin
            out[i] = 1'b0;
        end
    end 
end

endmodule
