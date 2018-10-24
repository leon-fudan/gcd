#! /bin/tcsh
qsub -P bnormal -pe mt 16 -l cputype=emt64,mem_free=128G -V -cwd -N nvdla_syn "./run"
