class yapp_tx_driver extends uvm_driver #(yapp_packet);

  `uvm_component_utils(yapp_tx_driver)

  function new(string name = "yapp_tx_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);

      send_to_dut(req);

      seq_item_port.item_done();
    end
  endtask

  virtual task send_to_dut(yapp_packet packet);
    `uvm_info("DRIVER",
              $sformatf("Packet is \n%s", packet.sprint()),
              UVM_LOW)

    #10ns;
  endtask

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  
    `uvm_info("START_SIM",
              $sformatf("start_of_simulation_phase in %s",
                        get_type_name()),
              UVM_HIGH)
  endfunction

endclass
