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
    $display("simulation start");
    resetn = 1;
#5  resetn = 0;
    start = 0;
#6  resetn = 1;
    check_gcd(102,12,6);
    check_gcd(18190,13082,2);
    check_gcd(82066,36915,1);
    check_gcd(34456,36928,8);
    check_gcd(76156,1924,4);
    check_gcd(10118,64431,1);
    check_gcd(68490,78579,9);
    check_gcd(65414,95995,1);
    check_gcd(59203,36405,1);
#1  $finish;
end

task check_gcd;
    input [31:0] opa_t;
    input [31:0] opb_t;
    input [31:0] result_t;
    begin
        @(posedge clk);
        #0.001 start = 0;
        @(posedge clk);
        #0.001 start = 1;
        opa = opa_t;
        opb = opb_t;
        @(posedge clk);
        @(posedge clk)
        @(done);
        @(posedge clk);
        if (result == result_t) 
            $display("pass: opa=",opa," opb=",opb , " result = ",result, " as expected");
        else 
            $display("faill: opa=",opa," opb=",opb , " result = ",result, " Expected result = ", result_t);
    end
endtask



endmodule

