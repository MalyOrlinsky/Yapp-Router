class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  router_tb tb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    tb = new("tb", this);

    `uvm_info("BASE_TEST",
              "Build phase of test is executing",
              UVM_HIGH)

    uvm_config_wrapper::set(this,
              "tb.yapp.agent.sequencer.run_phase",
              "default_sequence",
              yapp_5_packets::get_type());
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  
    `uvm_info("START_SIM",
              $sformatf("start_of_simulation_phase in %s",
                        get_type_name()),
              UVM_HIGH)
  endfunction

endclass



class test2 extends base_test;

  `uvm_component_utils(test2)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
