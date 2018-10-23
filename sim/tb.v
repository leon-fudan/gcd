`timescale 1ns/1ps

module tb;
reg clk;
reg [31:0] opa;
reg [31:0] opb;
reg start;
reg reset;
wire [31:0] result;
wire done;

gcd gdc1(opa, opb, start, reset, clk, result, done);

initial
begin
        $fsdbDumpfile("tb.fsdb");
        $fsdbDumpvars;
end

initial
begin
    clk = 1'b1;
    forever #1 clk = ~clk;
end

initial
begin
    reset = 1;
    start = 0;
#6  reset = 0;
#1  start = 1;
    opa = 32'd1071;
    opb = 32'd462;
    #40 $finish;
end
always@(clk) begin
    $display(result);
end
endmodule

