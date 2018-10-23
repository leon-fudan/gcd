#!/bin/tcsh
mc
ma vcs/2017.03 
ma verdi
setenv TMPDIR /tmp/
vcs -kdb -lca -debug_access+all  +v2k -f ../file_list_1
