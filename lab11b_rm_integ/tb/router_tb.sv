class router_tb extends uvm_env;

  yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5 yapp_rm;

  `uvm_component_utils_begin(router_tb)
    `uvm_field_object(yapp_rm, UVM_ALL_ON)
  `uvm_component_utils_end

  yapp_env yapp;

  channel_env chan0;
  channel_env chan1;
  channel_env chan2;

  hbus_env hbus;

  hbus_reg_adapter reg2hbus;

  clock_and_reset_env clock_and_reset;

  router_module_env router_env;

  router_mcsequencer mcsequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("ROUTER_TB",
              "Build phase of testbench is executing",
              UVM_HIGH)

    yapp = yapp_env::type_id::create("yapp", this);

    uvm_config_int::set(this, "chan0", "channel_id", 0);
    chan0 = channel_env::type_id::create("chan0", this);

    uvm_config_int::set(this, "chan1", "channel_id", 1);
    chan1 = channel_env::type_id::create("chan1", this);

    uvm_config_int::set(this, "chan2", "channel_id", 2);
    chan2 = channel_env::type_id::create("chan2", this);

    uvm_config_int::set(this, "hbus", "num_masters", 1);
    uvm_config_int::set(this, "hbus", "num_slaves", 0);
    
    hbus = hbus_env::type_id::create("hbus", this);

    clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);

    router_env = router_module_env::type_id::create("router_env", this);

    mcsequencer = router_mcsequencer::type_id::create("mcsequencer", this);

    yapp_rm = yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5::type_id::create("yapp_rm", this);
    yapp_rm.build();
    yapp_rm.lock_model();
    yapp_rm.set_hdl_path_root("hw_top.dut");
    yapp_rm.default_map.set_auto_predict(1);

    reg2hbus = hbus_reg_adapter::type_id::create("reg2bus", this);

  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  
    `uvm_info("START_SIM",
              $sformatf("start_of_simulation_phase in %s",
                        get_type_name()),
              UVM_HIGH)
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    yapp_rm.default_map.set_sequencer(
      hbus.masters[0].sequencer, reg2hbus);
  
    mcsequencer.yapp_seqr = yapp.agent.sequencer;
    mcsequencer.hbus_seqr = hbus.masters[0].sequencer;
  
    yapp.agent.monitor.item_collected_port.connect(router_env.yapp_export);
    hbus.masters[0].monitor.item_collected_port.connect(router_env.hbus_export);
    
    chan0.rx_agent.monitor.item_collected_port.connect(router_env.chan0_export);
    chan1.rx_agent.monitor.item_collected_port.connect(router_env.chan1_export);
    chan2.rx_agent.monitor.item_collected_port.connect(router_env.chan2_export);
  endfunction

endclass
