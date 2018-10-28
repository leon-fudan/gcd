`timescale 1ns/1ps

module gcd(opa, opb, start, resetn, clk, result, done);
//Eucldean GCD 

input wire [31:0] opa;
input wire [31:0] opb;
input wire start, resetn;
input wire clk;

output wire [31:0] result;
output wire done;

reg     [31:0] r;

reg     [31:0] opa_reg;
reg     [31:0] opb_reg;
reg     start_reg;
reg     done_reg;
reg     run_reg;

wire    [31:0] mod_r;
wire    mod_ready;

assign result = opa_reg;
assign done = done_reg;

assign r_is_zero = (r == 0);
assign init = ({start,start_reg,run_reg} == 3'b100);
assign done_sig = run_reg & r_is_zero & ~init;
assign r_run = run_reg;

mod mod1 (clk,resetn,r_run,opa_reg,opb_reg,mod_r,mod_ready);

always@(*) begin
    r = (mod_ready)?mod_r:32'b1;
    //$display("r= ",r);
end


always @(posedge clk or negedge resetn) begin
    if (~resetn)
        done_reg <= 0;
    else if(init)
        done_reg <= 0;
    else if (done_sig)
        done_reg <= 1;
end

always @(posedge clk or negedge resetn) begin
    if (~resetn)
        start_reg <= 0 ;
    else
        start_reg <= start;
end


always @(posedge clk or negedge resetn) begin
    if (~resetn)
        run_reg <= 0;
    else if (init)
        run_reg <= 1;
    else if (done_sig)
        run_reg <= 0;
end

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        opa_reg <= 0;
        opb_reg <= 0;
    end
    else if (init)begin
        opa_reg <= opa;
        opb_reg <= opb;
    end
    else if (run_reg & mod_ready) begin
        opa_reg <= opb_reg;
        opb_reg <= r;
    end
end

endmodule
