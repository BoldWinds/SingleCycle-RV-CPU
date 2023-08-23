`timescale 1ns / 1ns
// ███████╗ ██████╗ ██████╗  ██████╗  ██████╗ ██╗  ██╗
// ╚══███╔╝██╔═══██╗██╔══██╗██╔═══██╗██╔════╝ ██║  ██║
//   ███╔╝ ██║   ██║██████╔╝██║   ██║██║  ███╗███████║
//  ███╔╝  ██║   ██║██╔══██╗██║   ██║██║   ██║██╔══██║
// ███████╗╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██║
// ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
module alu_tb ();

    reg clk = 0;
    always #5 clk <= ~clk;

    reg  [31:0] A = 0;
    reg  [31:0] B = 0;
    reg  [ 7:0] opcode = 0;

    wire [31:0] result;


    alu u_alu (
        .A     (A),
        .B     (B),
        .opcode(opcode),
        .result(result)
    );
    event round;
    always @(posedge clk) begin
        if (opcode == 7'd6) begin
            ->round;
            opcode <= 7'd0;
        end else opcode <= opcode + 7'd1;
    end


    initial begin

        @(round);
        A = 32'd11;
        B = 32'd12;

        @(round);

        A <= 32'd15;
        B <= 32'd12;

        @(round);

        A <= -32'd20;
        B <= 32'd12;

        @(round);

        A <= 32'd11;
        B <= -32'd12;
    end


endmodule
