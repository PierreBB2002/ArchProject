module RegFile(
    input clk, reg_write,
    input [4:0] RA, RB, RW,
    input [31:0] Bus_W,
    output wire [31:0] Bus_A, Bus_B
);

    reg [31:0] register_file [0:15]; // 16 registers, each 32 bits wide

    // Write operation (on rising edge of clk)
    always @(posedge clk) begin
        if (reg_write && RW != 5'b0) begin // Assuming R0 is read-only
            register_file[RW] <= Bus_W;
        end
    end

    // Read operation (asynchronous)
    assign Bus_A = (RA != 5'b0) ? register_file[RA] : 32'b0; // R0 is zero
    assign Bus_B = (RB != 5'b0) ? register_file[RB] : 32'b0;

endmodule
