`timescale 1ns / 1ps
`include "instruction.vh"
module cpu_top(
    input clk,
    input rst
);

    wire [31:0] instruction;
    reg  [31:0] instruction_d1;
    wire        fetch;
    wire        execute;
    wire [ 4:0] op_type;
    reg         firstInstruction;

    wire [ 4:0] rs1;
    wire [ 4:0] rs2;
    wire [ 4:0] rd;
    reg  [31:0] A;
    reg  [31:0] B;
    wire [31:0] offset;
    wire [31:0] immediate;
    wire  [31:0] result;
    wire        write_back;
    wire        SF;
    wire        ZF;

    reg         jmp_flag;



    always @(posedge clk or posedge rst) begin
        if (rst) begin
            firstInstruction <= 1'b1;
        end else begin
            firstInstruction <= 1'b0;
        end
    end
    // instruction buf
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_d1 <= instruction;
        end else if (fetch || firstInstruction) begin
            instruction_d1 <= instruction;
        end
    end

    flow_ctrl u_flow_ctrl (
        .clk        (clk),
        .rst        (rst),
        .instruction(instruction),
        .op_type    (op_type),
        .fetch      (fetch),
        .decode     (decode),
        .execute    (execute),
        .visit_mem  (visit_mem),
        .write_back (write_back)
    );

    decoder u_decoder (
        .instruction(instruction_d1),
        .op         (op),
        .op_type    (op_type),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .offset     (offset),
        .immediate  (immediate)
    );

    wire [31:0] i_addr;

    pc u_pc (
        .clk       (clk),
        .rst       (rst),
        .offset    (offset),
        .fetch_flag(fetch),
        .jmp_flag  (jmp_flag),
        .i_addr    (i_addr)
    );
    wire di;
    wire dout;
    cache u_cache (
        .clk   (clk),
        .rst   (rst),
        .i_addr(i_addr >> 2),
        .d_addr(d_addr >> 2),
        .i     (instruction),
        .we    (1'b0),
        .di    (di),
        .do    (dout)
    );

    // rs1 rs2 rd is the index of the register
    wire [31:0] reg_data1;
    wire [31:0] reg_data2;
    reg  [31:0] result_d1;
    always @(posedge clk) begin
        if (execute) result_d1 <= result;
    end
    reg_file u_reg_file (
        .clk(clk),
        .rst(rst),
        .we (write_back),
        .ra1(rs1),         // read addr
        .ra2(rs2),         // read addr
        .wa (rd),          // write addr
        .rd1(reg_data1),
        .rd2(reg_data2),
        .wd (result_d1)
    );

    reg [6:0] opcode;
    alu u_alu (
        .A     (A),
        .B     (B),
        .opcode(opcode),
        .result(result),
        .SF    (SF),
        .ZF    (ZF)
    );

    always @(*) begin
        case (op_type)
            `I_ADD, `I_ADDW: begin
                opcode = 'd0;
                A      = reg_data1;
                B      = reg_data2;
            end
            `I_ADDI: begin
                opcode = 'd0;
                A      = reg_data1;
                B      = immediate;
            end
            `I_BEQ, `I_BNE, `I_BLT: begin
                opcode = 'd1;  // -
                A      = reg_data1;
                B      = reg_data2;
            end
            `I_LW: begin
                opcode = 'd0;
                A      = 'd0;
                B      = 'd0;
            end
            `I_SW: begin
                opcode = 'd0;
                A      = 'd0;
                B      = 'd0;
            end
            `I_JAL: begin
                opcode = 'd0;
                A      = i_addr;
                B      = 32'd0;
            end
            default: begin
                opcode = 'd9;
                A      = 'd0;
                B      = 'd0;
            end
        endcase
    end



    // branch jmp flag
    always @(*) begin
        if (execute) begin
            case (op_type)
                `I_BEQ: begin
                    if (ZF) jmp_flag = 1'd1;
                    else jmp_flag = 1'd0;
                end
                `I_BNE: begin
                    if (!ZF) jmp_flag = 1'd1;
                    else jmp_flag = 1'd0;
                end
                `I_BLT: begin
                    if (SF) jmp_flag = 1'd1;
                    else jmp_flag = 1'd0;
                end
                `I_JAL: begin
                    jmp_flag = 1'b1;
                end
                default: jmp_flag = 1'd0;
            endcase
        end else jmp_flag = 1'd0;
    end




endmodule
