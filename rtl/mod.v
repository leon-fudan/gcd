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
wire [31:0] atemp;
//wire [31:0] asub,atemp;

//parallel
wire [31:0] b0_0,b1_1,b2_2,b3_3,b4_4;
wire [31:0] b0,b1,b2,b3,b4;
wire [31:0] temp0,temp1,temp2,temp3,temp4;
wire [32:0] as;
wire [32:0] bs0,bs1,bs2,bs3,bs4,bs5,bs6,bs7,bs8,bs9,bs10,bs11,bs12,bs13,bs14,bs15;
wire [32:0] cs0,cs1,cs2,cs3,cs4,cs5,cs6,cs7,cs8,cs9,cs10,cs11,cs12,cs13,cs14,cs15;
wire [15:0] judge;
reg [32:0] ssub;
reg [31:0] asub;

parameter s0=3'h0;
parameter s1=3'h1;
parameter s2=3'h2;
parameter s3=3'h3;
parameter s4=3'h4;


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
//parallel
assign b0_0 = B_TEMP;
shr shrb1( .a(btemp) , .ar(b1_1) );
shr shrb2( .a(b1_1) , .ar(b2_2) );
shr shrb3( .a(b2_2) , .ar(b3_3) );
shr shrb4( .a(b3_3) , .ar(b4_4) );
assign temp0 = temp;
shr shrtemp1( .a(temptemp) , .ar(temp1) );
shr shrtemp2( .a(temp1) , .ar(temp2) );
shr shrtemp3( .a(temp2) , .ar(temp3) );
shr shrtemp4( .a(temp3) , .ar(temp4) );

assign b0=(temp0==0)?0:b0_0;
assign b1=(temp1==0)?0:b1_1;
assign b2=(temp2==0)?0:b2_2;
assign b3=(temp3==0)?0:b3_3;
assign b4=(temp4==0)?0:b4_4;

assign as={1'b0,atemp};
assign bs0={1'b0,32'b0},bs1={1'b0,b3},bs2={1'b0,b2},bs3={1'b0,b2+b3},bs4={1'b0,b1},bs5={1'b0,b3+b1},bs6={1'b0,b2+b1},bs7={1'b0,b3+b2+b1},bs8={1'b0,b0},bs9={1'b0,b3+b0},bs10={1'b0,b2+b0},bs11={1'b0,b3+b2+b0},bs12={1'b0,b1+b0},bs13={1'b0,b3+b1+b0},bs14={1'b0,b2+b1+b0},bs15={1'b0,b3+b2+b1+b0};
assign cs0=as-bs0,cs1=as-bs1,cs2=as-bs2,cs3=as-bs3,cs4=as-bs4,cs5=as-bs5,cs6=as-bs6,cs7=as-bs7,cs8=as-bs8,cs9=as-bs9,cs10=as-bs10,cs11=as-bs11,cs12=as-bs12,cs13=as-bs13,cs14=as-bs14,cs15=as-bs15;
assign judge={cs0[32],cs1[32],cs2[32],cs3[32],cs4[32],cs5[32],cs6[32],cs7[32],cs8[32],cs9[32],cs10[32],cs11[32],cs12[32],cs13[32],cs14[32],cs15[32]};

//assign asub = A_TEMP - B_TEMP;


assign result=(state==s4)?A_TEMP:32'b0;
assign ready = (state == s4);

always@(*)
begin
   casex(judge)
   16'bxxxxxxxxxxxxxxx0: ssub=cs15;
   16'bxxxxxxxxxxxxxx01: ssub=cs14;
   16'bxxxxxxxxxxxxx01x: ssub=cs13;
   16'bxxxxxxxxxxxx01xx: ssub=cs12;  
   16'bxxxxxxxxxxx01xxx: ssub=cs11;
   16'bxxxxxxxxxx01xxxx: ssub=cs10;
   16'bxxxxxxxxx01xxxxx: ssub=cs9;
   16'bxxxxxxxx01xxxxxx: ssub=cs8;
   16'bxxxxxxx01xxxxxxx: ssub=cs7;
   16'bxxxxxx01xxxxxxxx: ssub=cs6;
   16'bxxxxx01xxxxxxxxx: ssub=cs5;
   16'bxxxx01xxxxxxxxxx: ssub=cs4;  
   16'bxxx01xxxxxxxxxxx: ssub=cs3;
   16'bxx01xxxxxxxxxxxx: ssub=cs2;
   16'bx01xxxxxxxxxxxxx: ssub=cs1; 
   16'b01xxxxxxxxxxxxxx: ssub=cs0;
   /*
   16'b0000000000000000: ssub=as-bs15;
   16'b0000000000000001: ssub=as-bs14;
   16'b0000000000000011: ssub=as-bs13;
   16'b0000000000000111: ssub=as-bs12;  
   16'b0000000000001111: ssub=as-bs11;
   16'b0000000000011111: ssub=as-bs10;
   16'b0000000000111111: ssub=as-bs9;
   16'b0000000001111111: ssub=as-bs8;
   16'b0000000011111111: ssub=as-bs7;
   16'b0000000111111111: ssub=as-bs6;
   16'b0000001111111111: ssub=as-bs5;
   16'b0000011111111111: ssub=as-bs4;  
   16'b0000111111111111: ssub=as-bs3;
   16'b0001111111111111: ssub=as-bs2;
   16'b0011111111111111: ssub=as-bs1; 
   16'b0111111111111111: ssub=as-bs0;
   //16'b1111111111111111: ssub=as;
   */
   default: ssub=as;
   /*
    16'b0000000000000000: ssub=as-(bs15&{33{!(temp3==0|temp3==1)}});
    16'b0000000000000001: ssub=as-(bs14&{33{!(temp2==0|temp2==1)}});
    16'b0000000000000011: ssub=as-(bs13&{33{!(temp3==0|temp3==1)}});
    16'b0000000000000111: ssub=as-(bs12&{33{!(temp2==0|temp2==1)}});  
    16'b0000000000001111: ssub=as-(bs11&{33{!(temp3==0|temp3==1)}});
    16'b0000000000011111: ssub=as-(bs10&{33{!(temp2==0|temp2==1)}});
    16'b0000000000111111: ssub=as-(bs9&{33{!(temp3==0|temp3==1)}});
    16'b0000000001111111: ssub=as-(bs8&{33{!(temp0==0|temp0==1)}});
    16'b0000000011111111: ssub=as-(bs7&{33{!(temp3==0|temp3==1)}});
    16'b0000000111111111: ssub=as-(bs6&{33{!(temp2==0|temp2==1)}});
    16'b0000001111111111: ssub=as-(bs5&{33{!(temp3==0|temp3==1)}});
    16'b0000011111111111: ssub=as-(bs4&{33{!(temp1==0|temp1==1)}});  
    16'b0000111111111111: ssub=as-(bs3&{33{!(temp3==0|temp3==1)}});
    16'b0001111111111111: ssub=as-(bs2&{33{!(temp2==0|temp2==1)}});
    16'b0011111111111111: ssub=as-(bs1&{33{!(temp3==0|temp3==1)}}); 
    16'b0111111111111111: ssub=as-(bs0&{33{!(temp0==0|temp0==1)}});
    16'b1111111111111111: ssub=as;
   default: ssub=as;
   */
  endcase
  
  asub = ssub[31:0];
end 

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
	    temp <= temp4;
		 B_TEMP <= b4;
		 A_TEMP <= asub;
	    //if(!flag1) A_TEMP <= asub;
	  end
end

always@(state or flag1 or flag2 or run) 
    if (~run) ns = s0;
    else 
  case(state)
     s0 : ns = s1;
     s1 : ns = s2;
     s2 : if(flag1)
           ns=s3;
          else 
           ns=s2;
     s3 : if(flag2)
           ns=s4;
          else
           ns=s3;  
     s4 : if (run) ns=s1;
	       else ns = s4;
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

