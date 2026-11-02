package router_module;

  import uvm_pkg::*;
  import yapp_pkg::*;
  import channel_pkg::*;
  import hbus_pkg::*;

  `include "uvm_macros.svh"

  `include "../../router/router_scoreboard.sv"
  `include "../../router/router_scoreboard_fifo.sv"
  `include "../../router/router_reference.sv"
  `include "../../router/router_module_env.sv"

endpackage : router_module