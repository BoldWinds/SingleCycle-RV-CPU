`timescale 1ns / 1ps
// ███████╗ ██████╗ ██████╗  ██████╗  ██████╗ ██╗  ██╗
// ╚══███╔╝██╔═══██╗██╔══██╗██╔═══██╗██╔════╝ ██║  ██║
//   ███╔╝ ██║   ██║██████╔╝██║   ██║██║  ███╗███████║
//  ███╔╝  ██║   ██║██╔══██╗██║   ██║██║   ██║██╔══██║
// ███████╗╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██║
// ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝

module alu (
    input      [31:0] A,
    input      [31:0] B,
    input      [ 6:0] opcode,
    output reg [31:0] result,
    output SF,
    output ZF
);

    always @(*) begin
        case (opcode)
            7'd0: result = A + B;
            7'd1: result = A - B;
            7'd2: result = A & B;
            7'd3: result = A | B;
            7'd4: result = A ^ B;
            7'd5: result = A << B;
            7'd6: result = A >> B;
            default: result = 32'd0;
        endcase
    end
    // for debug

    reg [127:0] opcode_ascii;
    always @(*) begin
        case (opcode)
            7'd0: opcode_ascii = "+";
            7'd1: opcode_ascii = "-";
            7'd2: opcode_ascii = "&";
            7'd3: opcode_ascii = "|";
            7'd4: opcode_ascii = "^";
            7'd5: opcode_ascii = "<<";
            7'd6: opcode_ascii = ">>";
            default: opcode_ascii = "error";
        endcase
    end

    assign SF = result[31];
    assign ZF = result==32'd0;


endmodule
