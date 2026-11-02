class yapp_tx_monitor extends uvm_monitor;

  `uvm_component_utils(yapp_tx_monitor)

  function new(string name = "yapp_tx_monitor",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info("MONITOR",
              "You are in the monitor",
              UVM_LOW)
  endtask

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  
    `uvm_info("START_SIM",
              $sformatf("start_of_simulation_phase in %s",
                        get_type_name()),
              UVM_HIGH)
  endfunction

endclass
