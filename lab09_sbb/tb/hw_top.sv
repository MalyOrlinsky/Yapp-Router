/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  // YAPP Interface to the DUT
  yapp_if in0(clock, reset);

  channel_if chan0(clock, reset);
  channel_if chan1(clock, reset);
  channel_if chan2(clock, reset);
  
  hbus_if hbus(clock, reset);
  
  clock_and_reset_if clock_and_reset(clock, reset);

  yapp_router dut(
    .reset(reset),
    .clock(clock),
    .error(),

    // YAPP interface
    .in_data(in0.in_data),
    .in_data_vld(in0.in_data_vld),
    .in_suspend(in0.in_suspend),

    // Output Channels
    .data_0(chan0.data),
    .data_vld_0(chan0.data_vld),
    .suspend_0(chan0.suspend),
    
    .data_1(chan1.data),
    .data_vld_1(chan1.data_vld),
    .suspend_1(chan1.suspend),
    
    .data_2(chan2.data),
    .data_vld_2(chan2.data_vld),
    .suspend_2(chan2.suspend),

    // HBUS Interface
    .haddr(hbus.haddr),
    .hdata(hbus.hdata_w),
    .hen(hbus.hen),
    .hwr_rd(hbus.hwr_rd)
  );

  // CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(clock_and_reset.run_clock),
    .clock_period(clock_and_reset.clock_period)
  );

endmodule
