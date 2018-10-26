`timescale 1ns/1ps

module tb;
reg clk;
reg [31:0] opa;
reg [31:0] opb;
reg start;
reg resetn;
wire [31:0] result;
wire done;

gcd gdc1(opa, opb, start, resetn, clk, result, done);

initial
begin
        //$fsdbDumpfile("tb.fsdb");
        //$fsdbDumpvars;
end

initial
begin
    clk = 1'b1;
    forever #1 clk = ~clk;
end

initial
begin
<<<<<<< HEAD
    $display("simulation start");
    resetn = 1;
=======
    resetn = 0;
>>>>>>> 2d5e0a47c28d0126ee585a248bd4ff906114ae6a
    start = 0;
#6  resetn = 1;
#1  start = 1;
<<<<<<< HEAD
    opa = 32'd1075;
    opb = 32'd255;
    @(done);
    #1 $finish;
=======
    opa = 32'd1071;
    opb = 32'd462;
    #400 $finish;
>>>>>>> 2d5e0a47c28d0126ee585a248bd4ff906114ae6a
end
always@(clk) begin
    if (done)
        $display("opa=",opa," opb=",opb,"  result =", result);
end
endmodule

