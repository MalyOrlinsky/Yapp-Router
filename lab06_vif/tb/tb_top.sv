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
`include "router_tb.sv"
`include "router_test_lib.sv"

module tb_top;

  initial begin
    yapp_vif_config::set(
      null,
      "*",
      "vif",
      hw_top.in0
    );

    run_test();
  end

endmodule : tb_top
