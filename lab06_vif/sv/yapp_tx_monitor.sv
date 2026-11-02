class yapp_tx_monitor extends uvm_monitor;

  `uvm_component_utils(yapp_tx_monitor)

  virtual interface yapp_if vif;
  yapp_packet pkt;
  int num_pkt_col;

  function new(string name = "yapp_tx_monitor",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", "vif not set")
  endfunction

  virtual task run_phase(uvm_phase phase);

    @(posedge vif.reset);
    @(negedge vif.reset);

    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)

    forever begin
      pkt = yapp_packet::type_id::create("pkt", this);

      fork
        vif.collect_packet(
          pkt.length,
          pkt.addr,
          pkt.payload,
          pkt.parity
        );

        begin
          @(posedge vif.monstart);
          void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
        end
      join
      pkt.parity_type =
        (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;

      end_tr(pkt);

      `uvm_info(
        get_type_name(),
        $sformatf("Packet Collected:\n%s", pkt.sprint()),
        UVM_LOW
      )

      num_pkt_col++;
    end
  endtask

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  
    `uvm_info("START_SIM",
              $sformatf("start_of_simulation_phase in %s",
                        get_type_name()),
              UVM_HIGH)
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info(
      get_type_name(),
      $sformatf(
        "Report: YAPP Monitor Collected %0d Packets",
        num_pkt_col
      ),
      UVM_LOW
    )
  endfunction

endclass
