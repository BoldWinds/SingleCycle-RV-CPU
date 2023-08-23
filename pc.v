module pc(
    input clk,
    input rst,
    input  [31:0] offset,
    input fetch_flag, // indicate that the current instruction is fetched and pc can increase
    input jmp_flag,
    output reg [31:0] i_addr
);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        i_addr <= 32'd0;
    end
    else if(jmp_flag) begin
        i_addr <= i_addr + offset - 32'd4;
    end
    else if(fetch_flag) begin
        i_addr <= i_addr + 32'd4;
    end
end

endmodule


// power on --> load the first instruction --> flow control fecth --> pc++ --> load next instruction
