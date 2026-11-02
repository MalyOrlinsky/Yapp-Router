
-64
-uvm
-timescale 1ns/1ns

-incdir ../sv
-incdir ../../yapp/sv
-incdir ../../channel/sv
-incdir ../../hbus/sv
-incdir ../../clock_and_reset/sv

-incdir ../../router

../../yapp/sv/yapp_if.sv
../../yapp/sv/yapp_pkg.sv

../../channel/sv/channel_if.sv
../../channel/sv/channel_pkg.sv

../../hbus/sv/hbus_if.sv
../../hbus/sv/hbus_pkg.sv

../../clock_and_reset/sv/clock_and_reset_if.sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv

clkgen.sv
../../router_rtl/yapp_router.sv
hw_top.sv
cdns_uvmreg_utils_pkg.sv
yapp_router_regs_rdb.sv
tb_top.sv

+UVM_TESTNAME=reg_function_test
+SVSEED=random
+UVM_VERBOSITY=UVM_HIGH
