class router_mcsequencer extends uvm_sequencer;

  `uvm_component_utils(router_mcsequencer)

  // References to the existing UVC sequencers
  yapp_tx_sequencer  yapp_seqr;
  hbus_master_sequencer hbus_seqr;

  function new(string name = "router_mcsequencer",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass