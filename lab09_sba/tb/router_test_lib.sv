class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  router_tb tb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_int::set(this, "*", "recording_detail", 1);

    tb = router_tb::type_id::create("tb", this);

    `uvm_info("BASE_TEST",
              "Build phase of test is executing",
              UVM_HIGH)

    set_default_sequence();
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

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    check_config_usage();
  endfunction

  virtual function void set_default_sequence();
    uvm_config_wrapper::set(
      this,
      "tb.yapp.agent.sequencer.run_phase",
      "default_sequence",
      yapp_012_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence",
      clk10_rst5_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.chan?.rx_agent.sequencer.run_phase",
      "default_sequence",
      channel_rx_resp_seq::get_type()
    );

  endfunction

endclass



class test2 extends base_test;

  `uvm_component_utils(test2)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass



class short_packet_test extends base_test;

  `uvm_component_utils(short_packet_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(
      short_yapp_packet::get_type()
    );

    super.build_phase(phase);
  endfunction

endclass: short_packet_test


class set_config_test extends base_test;

  `uvm_component_utils(set_config_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    uvm_config_int::set(
      this,
      "tb.yapp.agent",
      "is_active",
      UVM_PASSIVE
    );

    super.build_phase(phase);
  endfunction

  function void set_default_sequence(); endfunction

endclass: set_config_test


class incr_payload_test extends base_test;

  `uvm_component_utils(incr_payload_test)

  function new(string name = "incr_payload_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(
      short_yapp_packet::get_type()
    );

    super.build_phase(phase);
  endfunction

  virtual function void set_default_sequence();
    uvm_config_wrapper::set(
      this,
      "tb.yapp.agent.sequencer.run_phase",
      "default_sequence",
      yapp_incr_payload_seq::get_type()
    );
  endfunction

endclass : incr_payload_test


class exhaustive_seq_test extends base_test;

  `uvm_component_utils(exhaustive_seq_test)

  function new(string name = "exhaustive_seq_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(
      short_yapp_packet::get_type()
    );

    super.build_phase(phase);
  endfunction

  virtual function void set_default_sequence();
    uvm_config_wrapper::set(
      this,
      "tb.yapp.agent.sequencer.run_phase",
      "default_sequence",
      yapp_exhaustive_seq::get_type()
    );
  endfunction

endclass : exhaustive_seq_test


class yapp_012_test extends base_test;

  `uvm_component_utils(yapp_012_test)

  function new(string name = "yapp_012_test",
                uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void set_default_sequence();
    uvm_config_wrapper::set(
      this,
      "tb.yapp.agent.sequencer.run_phase",
      "default_sequence",
      yapp_012_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence",
      clk10_rst5_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.chan?.rx_agent.sequencer.run_phase",
      "default_sequence",
      channel_rx_resp_seq::get_type()
    );
  endfunction

endclass : yapp_012_test


class simple_test extends base_test;

  `uvm_component_utils(simple_test)

  function new(string name = "simple_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(
      short_yapp_packet::get_type()
    );

    super.build_phase(phase);
  endfunction

  virtual function void set_default_sequence();

    // YAPP sequence
    uvm_config_wrapper::set(
      this,
      "tb.yapp.agent.sequencer.run_phase",
      "default_sequence",
      yapp_012_seq::get_type()
    );

    // Channel response sequences
    uvm_config_wrapper::set(
      this,
      "tb.chan?.rx_agent.sequencer.run_phase",
      "default_sequence",
      channel_rx_resp_seq::get_type()
    );

    // Clock and reset sequence
    uvm_config_wrapper::set(
      this,
      "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence",
      clk10_rst5_seq::get_type()
    );

    // No default sequence for HBUS

  endfunction

endclass : simple_test


class test_uvc_integration extends base_test;

  `uvm_component_utils(test_uvc_integration)

  function new(string name = "test_uvc_integration",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void set_default_sequence();

    uvm_config_wrapper::set(
      this,
      "tb.yapp.agent.sequencer.run_phase",
      "default_sequence",
      yapp_88_packets_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.hbus.masters[0].sequencer.run_phase",
      "default_sequence",
      hbus_small_packet_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence",
      clk10_rst5_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.chan?.rx_agent.sequencer.run_phase",
      "default_sequence",
      channel_rx_resp_seq::get_type()
    );

  endfunction

endclass : test_uvc_integration


class router_mcseq_test extends base_test;

  `uvm_component_utils(router_mcseq_test)

  function new(string name = "router_mcseq_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
//    yapp_packet::type_id::set_type_override(
//      short_yapp_packet::get_type()
//    );

    super.build_phase(phase);
    
    uvm_top.print_config_with_audit(1);
  endfunction

  virtual function void set_default_sequence();

    uvm_config_wrapper::set(
      this,
      "tb.mcsequencer.run_phase",
      "default_sequence",
      router_simple_mcseq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence",
      clk10_rst5_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.chan?.rx_agent.sequencer.run_phase",
      "default_sequence",
      channel_rx_resp_seq::get_type()
    );

    uvm_config_wrapper::set(
      this,
      "tb.hbus.masters[0].sequencer.run_phase",
      "default_sequence",
      hbus_small_packet_seq::get_type()
    );

  endfunction

endclass : router_mcseq_test