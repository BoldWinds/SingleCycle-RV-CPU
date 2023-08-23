// ███████╗ ██████╗ ██████╗  ██████╗  ██████╗ ██╗  ██╗
// ╚══███╔╝██╔═══██╗██╔══██╗██╔═══██╗██╔════╝ ██║  ██║
//   ███╔╝ ██║   ██║██████╔╝██║   ██║██║  ███╗███████║
//  ███╔╝  ██║   ██║██╔══██╗██║   ██║██║   ██║██╔══██║
// ███████╗╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██║
// ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
`timescale 1ns / 1ps
`include "instruction.vh"
// this module is the core module witch control the PC increase or decrease
module flow_ctrl (
    input             clk,
    input             rst,
    input      [31:0] instruction,
    input      [ 4:0] op_type,
    output            fetch,
    output            decode,
    output            execute,
    output            visit_mem,
    output            write_back
    // output            new_cyc       // indicate a new cpu cycle , means that PC can inc or dec
);
    wire [6:0] op;
    assign op = instruction[6:0];

    reg [4:0] ctrl;
    assign fetch      = ctrl[0];
    assign decode     = ctrl[1];
    assign execute    = ctrl[2];
    assign visit_mem  = ctrl[3];
    assign write_back = ctrl[4];


    localparam IDLE = 0;
    localparam FETCH = 1;
    localparam DECODE = 2;
    localparam EXECUTE = 4;
    localparam VISIT_MEM = 8;
    localparam WRITE_BACK = 16;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ctrl <= 5'd0;
        end else
            case (op_type)
                `I_ADD, `I_ADDI, `I_ADDW: begin
                    // idle --> fetch --> decode --> execute --> write back --> idle
                    case (ctrl)
                        IDLE: ctrl <= FETCH;
                        FETCH, DECODE: ctrl <= ctrl << 1;
                        EXECUTE: ctrl <= WRITE_BACK;
                        default: ctrl <= IDLE;
                    endcase
                end
                `I_BEQ, `I_BNE, `I_BLT: begin
                    // idle --> fetch --> decode --> execute --> idle
                    case (ctrl)
                        IDLE : ctrl <= FETCH;
                        FETCH, DECODE: ctrl <= ctrl << 1;
                        default: ctrl <= IDLE;
                    endcase
                end
                `I_LW, `I_SW: begin
                    case (ctrl)
                        IDLE: ctrl <= FETCH;
                        FETCH, DECODE, EXECUTE, VISIT_MEM: ctrl <= ctrl << 1;
                        default: ctrl <= IDLE;
                    endcase
                end
                `I_JAL: begin
                    case (ctrl)
                        IDLE : ctrl <= FETCH;
                        FETCH, DECODE  : ctrl <= ctrl << 1;
                        EXECUTE : ctrl <= WRITE_BACK;
                        default: ctrl <= IDLE;
                    endcase
                end
                `I_NULL: begin
                    ctrl <= IDLE;
                end
                default: begin
                    ctrl <= IDLE;
                end
            endcase
    end


endmodule
