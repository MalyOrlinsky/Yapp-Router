class router_tb extends uvm_env;

  `uvm_component_utils(router_tb)

  yapp_env yapp;

  channel_env chan0;
  channel_env chan1;
  channel_env chan2;

  hbus_env hbus;

  clock_and_reset_env clock_and_reset;

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

    clock_and_reset =
        clock_and_reset_env::type_id::create("clock_and_reset", this);

    mcsequencer = router_mcsequencer::type_id::create(
      "mcsequencer",
      this
    );

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
  
    mcsequencer.yapp_seqr = yapp.agent.sequencer;
    mcsequencer.hbus_seqr = hbus.masters[0].sequencer;
  
  endfunction

endclass
