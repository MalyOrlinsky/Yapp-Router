-64
-uvm
-timescale 1ns/1ns
-incdir ../sv

../sv/yapp_if.sv
../sv/yapp_pkg.sv
clkgen.sv
../../router_rtl/yapp_router.sv
hw_top.sv
tb_top.sv

+UVM_TESTNAME=yapp_012_test
+SVSEED=random
+UVM_VERBOSITY=UVM_HIGH