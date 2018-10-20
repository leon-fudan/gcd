module gcd(opa, opb, start, reset, clk, result, done);
//Eucldean GCD 

input wire [31:0] opa;
input wire [31:0] opb;
input wire start, reset;
input wire clk;

output wire [31:0] result;
output wire done;



reg     [31:0] r;

reg     [31:0] opa_reg;
reg     [31:0] opb_reg;
reg     start_reg;
reg     done_reg;
reg     run_reg;
assign result = opa_reg;
assign done = done_reg;


always@(*) begin
    r = opa_reg % opb_reg;
    $display("r= ",r);
end

assign r_is_zero = (r == 0);

//done 
//init 
assign done_flag = run_reg & r_is_zero;
assign init = ({start,start_reg,run_reg} == 3'b100);

always @(posedge clk) begin
    if (reset) 
        done_reg <= 0;
    else if (done_flag)
        done_reg <= 1;
    else if(init)
        done_reg <= 0;
end

always @(posedge clk) begin
    if (reset)
        start_reg <= 0 ;
    else
        start_reg <= start;
end


always @(posedge clk) begin
    if (reset)
        run_reg <= 0;
    else if (init)
        run_reg <= 1;
    else if (done)
        run_reg <= 0;
end

always @(posedge clk) begin
    if (reset) begin
        opa_reg <= 0;
        opb_reg <= 0;
    end
    else if (init)begin
        opa_reg <= opa;
        opb_reg <= opb;
    end
    else if (run_reg) begin
        opa_reg <= opb_reg;
        opb_reg <= r;
    end
end

endmodule
