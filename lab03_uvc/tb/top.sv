/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
import uvm_pkg::*;
`include "uvm_macros.svh"

import yapp_pkg::*;
`include "router_tb.sv"
`include "router_test_lib.sv"

module top;

  initial begin
    run_test();
  end

endmodule : top
