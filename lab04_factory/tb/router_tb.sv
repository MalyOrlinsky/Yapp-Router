class router_tb extends uvm_env;

  `uvm_component_utils(router_tb)

  yapp_env yapp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("ROUTER_TB",
              "Build phase of testbench is executing",
              UVM_HIGH)

    yapp = yapp_env::type_id::create("yapp", this);

  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  
    `uvm_info("START_SIM",
              $sformatf("start_of_simulation_phase in %s",
                        get_type_name()),
              UVM_HIGH)
  endfunction

endclass
