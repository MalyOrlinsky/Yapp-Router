class router_module_env extends uvm_env;

  `uvm_component_utils(router_module_env)

  router_reference reference_model;
  router_scoreboard scoreboard;

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
      router_scoreboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    reference_model.valid_yapp_port.connect(
      scoreboard.yapp_export
    );
  endfunction

endclass : router_module_env