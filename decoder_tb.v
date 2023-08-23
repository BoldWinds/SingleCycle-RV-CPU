`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2023 05:01:39 PM
// Design Name: 
// Module Name: decoder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder_tb();

reg [31:0] instruction;

decoder u_decoder(
    .instruction  ( instruction  )
);


initial begin
    instruction <= 32'b00000001011101100000010100110011; // add
    # 10
    instruction <= 32'b00000000011000001000000100010011; // addi 
    #10
    instruction <= 32'b00001100101001001000010001100011; // 
    #10
    instruction <= 32'b00001100101001001001010001100011;
    #10
    instruction <= 32'b00001100101001001100010001100011;
    #10
    instruction <= 32'b00001100100000000000000011101111;
end

endmodule
