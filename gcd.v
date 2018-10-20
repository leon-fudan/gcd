module gcd(opa, opb, start, reset, clk, result, done);
//Eucldean GCD 

input wire [31:0] opa;
input wire [31:0] opb;
input wire start, reset;
input wire clk;

output reg [31:0] result_reg;
output reg done_reg;

reg     [31:0] r;

reg     [31:0] opa_reg;
reg     [31:0] opb_reg;
reg     start_reg;

always@(*) begin
    r = opa_reg % opb_reg;
    $display("r= ",r);
end

always@(posedge clk) begin
    if(reset) begin
        done_reg <= 1'b0;
        result_reg <= 32'b0;
    end
    else 
    if(start) begin
        if((opa || opb) == 0) begin
            result <= 32'b0;
            done <= 1'b1;
        end
        else 
            if(r) begin
                result <= r;
                opa_reg <= opb;
            end
            else begin
                done <= 1;
            end
    end
end
endmodule
