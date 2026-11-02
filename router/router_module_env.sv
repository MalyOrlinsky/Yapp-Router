class router_module_env extends uvm_env;

  `uvm_component_utils(router_module_env)

  router_reference reference_model;
  router_scoreboard_fifo scoreboard;

  // External TLM exports
  uvm_analysis_export #(hbus_transaction) hbus_export;

  uvm_analysis_export #(yapp_packet) yapp_export;

  uvm_analysis_export #(channel_packet) chan0_export;
  uvm_analysis_export #(channel_packet) chan1_export;
  uvm_analysis_export #(channel_packet) chan2_export;

  function new(
    string name = "router_module_env",
    uvm_component parent = null
  );
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    reference_model =
      router_reference::type_id::create("reference_model", this);

    scoreboard =
      router_scoreboard_fifo::type_id::create("scoreboard", this);

    hbus_export = new("hbus_export", this);

    yapp_export = new("yapp_export", this);

    chan0_export = new("chan0_export", this);
    chan1_export = new("chan1_export", this);
    chan2_export = new("chan2_export", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    hbus_export.connect(reference_model.hbus_export);
    hbus_export.connect(scoreboard.hbus_fifo.analysis_export);

    yapp_export.connect(reference_model.yapp_export);

    chan0_export.connect(scoreboard.chan0_fifo.analysis_export);
    chan1_export.connect(scoreboard.chan1_fifo.analysis_export);
    chan2_export.connect(scoreboard.chan2_fifo.analysis_export);

    reference_model.valid_yapp_port.connect(
      scoreboard.yapp_fifo.analysis_export
    );
  endfunction : connect_phase

endclass : router_module_env