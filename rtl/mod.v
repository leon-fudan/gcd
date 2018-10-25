module mod(clk,resetn,run,A,B,result,ready);

input clk;
input resetn;
input run;
input [31:0] A,B;
output [31:0] result;
output ready;

reg [31:0] A_TEMP,B_TEMP;
reg [2:0] state,ns;
reg [31:0] temp;
wire flag1,flag2;
wire [31:0] bl,br,btemp,temptemp,templ,tempr;
wire [31:0] asub,atemp;
parameter s0=3'h0;
parameter s1=3'h1;
parameter s2=3'h2;
parameter s3=3'h3;
parameter s4=3'h4;
parameter s5=3'h5;

//always@(state or A_TEMP or B_TEMP or temp)
assign atemp = A_TEMP;
assign btemp = B_TEMP;
assign temptemp = temp;
assign flag1=(B_TEMP>A_TEMP);
assign flag2=(temp==0);
shl shl1( .a(btemp) , .al(bl) );
shr shr1( .a(btemp) , .ar(br) );
shl shl2( .a(temptemp) , .al(templ) );
shr shr2( .a(temptemp) , .ar(tempr) );
assign asub = A_TEMP - B_TEMP;

assign result=(state==s5)?A_TEMP:32'b0;
assign ready = (state == s5);


always@(posedge clk or negedge resetn) begin
  if(!resetn)
    state<=s0;
  else 
    state<=ns;
end

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        temp<=32'b1;
        A_TEMP<=32'b0;
        B_TEMP<=32'b0;
    end
    else if(state==s1) begin
        temp<=1;
        A_TEMP<=A;
        B_TEMP<=B;
    end
    else if(state==s2)
	 begin
	   B_TEMP<=bl;
	   temp<=templ;
    end
   else if(state==s3)
	  begin
       B_TEMP <= br;
		 temp <= tempr;
	  end
   else if(state==s4)
	  begin
	    temp <= tempr;
		 B_TEMP <= br;
	    if(!flag1) A_TEMP <= asub;
	  end
end

always@(state or flag1 or flag2)
  case(state)
     s0 : if(run) ns = s1;
     s1 : ns = s2;
     s2 : if(flag1)
           ns=s3;
          else 
           ns=s2;
     s3 : ns=s4;
     s4 : if(flag2)
           ns=s5;
          else
           ns=s4;  
     s5 : if (run) ns=s1;
     default : ns=s0;
  endcase
  
endmodule

module shl(a,al);
input [31:0] a;
output [31:0] al;
assign al[31:1] = a[30:0];
assign al[0] = 0;

endmodule

module shr(a,ar);
input [31:0] a;
output [31:0] ar;
assign ar[30:0] = a[31:1];
assign ar[31] = 0;

endmodule
