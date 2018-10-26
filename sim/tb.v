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
    `ifndef iverilog
        $fsdbDumpfile("tb.fsdb");
        $fsdbDumpvars;
    `endif
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
    check_gcd(91571,8225,1);
    check_gcd(83314,20415,1);
    check_gcd(17304,15041,1);
    check_gcd(94554,28123,1);
    check_gcd(45850,97569,1);
    check_gcd(21892,51581,1);
    check_gcd(59359,71883,1);
    check_gcd(89538,96781,1);
    check_gcd(78004,132,4);
    check_gcd(35802,98620,2);
    check_gcd(77789,17030,1);
    check_gcd(51167,266,19);
    check_gcd(400,54163,1);
    check_gcd(7191,83984,1);
    check_gcd(12162,31171,1);
    check_gcd(81269,78207,1);
    check_gcd(41153,61862,1);
    check_gcd(53537,58950,1);
    check_gcd(39041,9221,1);
    check_gcd(21419,8054,1);
    check_gcd(95041,96237,1);
    check_gcd(91400,98638,2);
    check_gcd(23040,1944,72);
    check_gcd(83399,26638,1);
    check_gcd(42393,57894,3);
    check_gcd(43232,12559,1);
    check_gcd(23998,39602,2);
    check_gcd(83148,25166,2);
    check_gcd(56398,80952,2);
    check_gcd(26503,68237,1);
    check_gcd(83429,7833,1);
    check_gcd(56032,70964,4);
    check_gcd(76750,66244,2);
    check_gcd(24924,7215,3);
    check_gcd(46500,18677,1);
    check_gcd(5828,44428,4);
    check_gcd(81314,96161,1);
    check_gcd(7356,48328,4);
    check_gcd(35589,95069,1);
    check_gcd(17219,97904,1);
    check_gcd(1079,65063,1);
    check_gcd(68027,1670,1);
    check_gcd(62817,63499,1);
    check_gcd(98410,75832,2);
    check_gcd(97413,1398,3);
    check_gcd(75257,95473,7);
    check_gcd(11373,43504,1);
    check_gcd(1605,68967,3);
    check_gcd(79464,18891,3);
    check_gcd(89905,28927,1);
    check_gcd(51995,13538,1);
    check_gcd(93842,82082,14);
    check_gcd(26146,84932,34);
    check_gcd(24097,47931,1);
    check_gcd(48037,81335,1);
    check_gcd(60674,89827,1);
    check_gcd(98774,75278,2);
    check_gcd(20611,87823,1);
    check_gcd(7151,54398,1);
    check_gcd(42642,44145,9);
    check_gcd(5490,48791,1);
    check_gcd(69752,55178,2);
    check_gcd(63665,5452,1);
    check_gcd(39821,5608,1);
    check_gcd(80045,1419,1);
    check_gcd(68199,70360,1);
    check_gcd(38468,31627,1);
    check_gcd(81205,42741,1);
    check_gcd(31084,90594,2);
    check_gcd(44667,6321,21);
    check_gcd(64781,21782,1);
    check_gcd(39558,5179,1);
    check_gcd(62522,16286,2);
    check_gcd(91426,50018,2);
    check_gcd(31149,81199,1);
    check_gcd(31141,9177,19);
    check_gcd(88172,78077,1);
    check_gcd(94770,35996,2);
    check_gcd(88998,98139,3);
    check_gcd(36362,35264,2);
    check_gcd(10935,61134,3);
    check_gcd(75657,39444,3);
    check_gcd(13211,27632,11);
    check_gcd(69360,32351,17);
    check_gcd(95642,52590,2);
    check_gcd(17025,10396,1);
    check_gcd(6595,64424,1);
    check_gcd(24374,77298,2);
    check_gcd(82207,40584,1);
    check_gcd(45171,53762,1);
    check_gcd(40822,26710,2);
    check_gcd(6778,35273,1);
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
            $display("Passed: opa = %0d \t opb = %0d \t result = %0d as expected",opa,opb,result);
        else 
            $display("Error: opa = %0d\topb = %0d\tresult = %0d; Expected result = %0d", opa,opb,result,result_t);
    end
endtask



endmodule

