`timescale 1ns / 1ps

module reg_tb();

    reg         clk = 0;
    reg         rst;
    always #0.5 clk <= ~clk;
    initial begin
        rst <= 1'b1;
        #12 rst <= 1'b0;
    end
reg we;
reg ra1;
reg ra2;
reg wa;
reg rd1;
reg rd2;
reg wd;

    reg_file u_reg_file(
        .clk ( clk ),
        .rst ( rst ),
        .we  ( we  ),
        .ra1 ( ra1 ),
        .ra2 ( ra2 ),
        .wa  ( wa  ),
        .rd1 ( rd1 ),
        .rd2 ( rd2 ),
        .wd  ( wd  )
    );





    initial begin
        
    end


endmodule
