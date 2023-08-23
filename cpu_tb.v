`timescale 1ns / 1ns

module cpu_tb ();

    reg clk = 0;
    reg rst = 1;
    always #1 clk <= ~clk;
    initial begin
        rst <= 1'b1;
        #12 rst <= 1'b0;
    end

    cpu_top u_cpu_top (
        .clk(clk),
        .rst(rst)
    );

endmodule
