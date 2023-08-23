`timescale 1ns / 1ps

module cache(
    input clk,
    input rst,
    input [31:0] i_addr, // pc >> 2
    input [31:0] d_addr, // unit is in 32bit aligned
    output reg [31:0] i,
    input  we,
    input  [31:0] di,
    output reg [31:0] do
    );

    reg [31:0] mem [511:0];
    
    // write
    integer j;
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            for(j =0; j<512;j=j+1) mem[j] <= 32'd0;             
        end
        else if(we) begin
        // if(we) begin
            mem[d_addr] <= di;
        end
    end

    always @(*) begin
        i = mem[i_addr];
        do = mem[d_addr];
    end

    initial begin
        @(negedge rst)
        $readmemb("cache.bin",mem);
    end

endmodule
