sim:init
	cd work;../script/run_compile.csh
init:
	mkdir -p work
trace:sim
	cd work;../script/run_trace.csh
sim_v:init
	cd work;iverilog -g2001 ../tb.v ../../rtl/gcd.v ../../rtl/mod.v;./a.out
clean:
	rm -rf work/*
