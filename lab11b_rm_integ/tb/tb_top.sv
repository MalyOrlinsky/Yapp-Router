/*-----------------------------------------------------------------
File name     : tb_top.sv
Description   : lab01_data tb_top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
import uvm_pkg::*;
`include "uvm_macros.svh"

import yapp_pkg::*;
import channel_pkg::*;
import hbus_pkg::*;
import clock_and_reset_pkg::*;
import yapp_router_reg_pkg::*;

`include "../../router/router_module.sv"
import router_module::*;

`include "router_mcsequencer.sv"
`include "router_mcseqs_lib.sv"
`include "router_tb.sv"
`include "router_test_lib.sv"

module tb_top;

  initial begin
    yapp_vif_config::set(null, "*", "vif", hw_top.in0);

    channel_vif_config::set(null, "uvm_test_top.tb.chan0.*", "vif", hw_top.chan0);
    channel_vif_config::set(null, "uvm_test_top.tb.chan1.*", "vif", hw_top.chan1);
    channel_vif_config::set(null, "uvm_test_top.tb.chan2.*", "vif", hw_top.chan2);
    
    hbus_vif_config::set(null, "*", "vif", hw_top.hbus);
    
    clock_and_reset_vif_config::set(
      null, "*", "vif", hw_top.clock_and_reset
    );

    run_test();
  end

endmodule : tb_top
