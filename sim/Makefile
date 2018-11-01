sim:init
	cd work;../script/run_compile.csh;./simv
init:
	mkdir -p work
trace:sim
	cd work;../script/run_trace.csh
sim_i:init
	cd work;iverilog -g2001 -D iverilog ../tb.v ../../rtl/gcd.v ../../rtl/mod.v;./a.out
clean:
	rm -rf work/*
