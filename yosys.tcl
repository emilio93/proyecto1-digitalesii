yosys -import

set curDir         "$::env(CUR_DIR)"
set vlogModuleName "$::env(VLOG_MODULE_NAME)"
set vlogFileName   "$::env(VLOG_FILE_NAME)"

yosys read_verilog $vlogFileName

hierarchy -check -top $vlogModuleName
#show -prefix pdfs/$vlogModuleName-original   -colors 3 -viewer echo

yosys proc
#show -prefix pdfs/$vlogModuleName-proc -colors 3 -viewer echo

opt
#show -prefix pdfs/$vlogModuleName-proc_opt   -colors 3 -viewer echo

fsm
#show -prefix pdfs/$vlogModuleName-fsm   -colors 3 -viewer echo

opt
#show -prefix pdfs/$vlogModuleName-fsm_opt   -colors 3 -viewer echo

memory
#show -prefix pdfs/$vlogModuleName-memory   -colors 3 -viewer echo

opt
#show -prefix pdfs/$vlogModuleName-memory_opt   -colors 3 -viewer echo

techmap
# show -prefix pdfs/$vlogModuleName-techmap   -colors 3 -viewer echo

opt
# show -prefix pdfs/$vlogModuleName-techmap_opt   -colors 3 -viewer echo

write_verilog ./build/$vlogModuleName-rtlil.v

dfflibmap -liberty ./lib/cmos_cells.lib
# show -prefix pdfs/$vlogModuleName-dff_seq -lib ./lib/cmos_cells.v   -colors 3 -viewer echo

abc -liberty ./lib/cmos_cells.lib
# show -prefix pdfs/$vlogModuleName-abc_comb -lib ./lib/cmos_cells.v   -colors 3 -viewer echo

clean

# show -prefix pdfs/$vlogModuleName-synth -lib ./lib/cmos_cells.v -viewer echo   -colors 3 -viewer echo
write_verilog ./build/$vlogModuleName-sintetizado.v
