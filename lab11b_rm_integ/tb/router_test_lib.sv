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

  endfunction

endclass : router_mcseq_test


class uvm_reset_test extends base_test;

  uvm_reg_hw_reset_seq reset_seq;

  `uvm_component_utils(uvm_reset_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
    reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");

    uvm_config_wrapper::set(
      this,
      "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence",
      clk10_rst5_seq::get_type()
    );

    super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this, "Raising Objection to run uvm built in reset test");

    reset_seq.model = tb.yapp_rm;
    reset_seq.start(null);

    phase.drop_objection(this, "Dropping Objection to uvm built reset test finished");
  endtask : run_phase

  virtual function void set_default_sequence();
  endfunction

endclass : uvm_reset_test


class uvm_mem_walk_test extends base_test;

  uvm_mem_walk_seq walk_seq;

  `uvm_component_utils(uvm_mem_walk_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
    walk_seq = uvm_mem_walk_seq::type_id::create("uvm_walk_seq");

    uvm_config_wrapper::set(
      this,
      "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence",
      clk10_rst5_seq::get_type()
    );

    super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this, "Raising Objection to run uvm built in reset test");

    walk_seq.model = tb.yapp_rm;
    walk_seq.start(null);

    phase.drop_objection(this, "Dropping Objection to uvm built reset test finished");
  endtask : run_phase

  virtual function void set_default_sequence();
  endfunction

endclass : uvm_mem_walk_test


class reg_access_test extends base_test;

  uvm_reg_hw_reset_seq reset_seq;
  yapp_regs_c regs;

  `uvm_component_utils(reg_access_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
    reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");

    uvm_config_wrapper::set(
      this,
      "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence",
      clk10_rst5_seq::get_type()
    );

    super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    uvm_status_e status;
    uvm_reg_data_t data;

    phase.raise_objection(this, "Starting register access test");

    regs = tb.yapp_rm.router_yapp_regs;

    reset_seq.model = tb.yapp_rm;
    reset_seq.start(null);

    // RW register: frontdoor write, then backdoor peek
    regs.ctrl_reg.write(status, 8'h12, UVM_FRONTDOOR, regs.default_map, null);
    regs.ctrl_reg.peek(status, data);

    if (data == 8'h12)
      uvm_report_info("REG_ACCESS", "RW peek check passed", UVM_NONE);
    else
      uvm_report_error("REG_ACCESS", $sformatf("RW peek failed: expected 0x12, got 0x%0h", data), UVM_NONE);

    // RW register: backdoor poke, then frontdoor read
    regs.ctrl_reg.poke(status, 8'h34);
    regs.ctrl_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);

    if (data == 8'h34)
      uvm_report_info("REG_ACCESS", "RW read check passed", UVM_NONE);
    else
      uvm_report_error("REG_ACCESS", $sformatf("RW read failed: expected 0x34, got 0x%0h", data), UVM_NONE);

    // RO register: backdoor poke, then frontdoor read
    regs.addr0_cnt_reg.poke(status, 8'h56);
    regs.addr0_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);

    if (data == 8'h56)
      uvm_report_info("REG_ACCESS", "RO read check passed", UVM_NONE);
    else
      uvm_report_error("REG_ACCESS", $sformatf("RO read failed: expected 0x56, got 0x%0h", data), UVM_NONE);

    // RO register: frontdoor write should not change the value
    regs.addr0_cnt_reg.write(status, 8'hAA, UVM_FRONTDOOR, regs.default_map, null);
    regs.addr0_cnt_reg.peek(status, data);

    if (data == 8'h56)
      uvm_report_info("REG_ACCESS", "RO peek check passed", UVM_NONE);
    else
      uvm_report_error("REG_ACCESS", $sformatf("RO value changed: expected 0x56, got 0x%0h", data), UVM_NONE);

    phase.drop_objection(this, "Register access test finished");
  endtask : run_phase


  virtual function void set_default_sequence();
  endfunction

endclass : reg_access_test


class reg_function_test extends base_test;

  `uvm_component_utils(reg_function_test)

  yapp_regs_c regs;
  yapp_012_seq yapp_seq;
  yapp_tx_sequencer sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    yapp_seq = yapp_012_seq::type_id::create("yapp_seq");
    super.build_phase(phase);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sequencer = tb.yapp.agent.sequencer;
  endfunction : connect_phase

  virtual function void set_default_sequence();
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
  endfunction : set_default_sequence

  virtual task run_phase(uvm_phase phase);
    uvm_status_e status;
    uvm_reg_data_t data;

    phase.raise_objection(this, "Starting register function test");

    regs = tb.yapp_rm.router_yapp_regs;

    regs.en_reg.write(status, 8'h01, UVM_FRONTDOOR, regs.default_map, null);

    regs.en_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);

    if (data != 8'h01)
      uvm_report_error("REG_FUNCTION",
        $sformatf("en_reg expected 0x01, got 0x%0h", data),
        UVM_NONE);
    else
      uvm_report_info("REG_FUNCTION", "en_reg check passed", UVM_NONE);

    yapp_seq.start(sequencer);

    regs.addr0_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);
    if (data != 0)
      uvm_report_error("REG_FUNCTION", $sformatf("addr0 expected 0, got %0d", data), UVM_NONE);

    regs.addr1_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);
    if (data != 0)
      uvm_report_error("REG_FUNCTION", $sformatf("addr1 expected 0, got %0d", data), UVM_NONE);

    regs.addr2_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);
    if (data != 0)
      uvm_report_error("REG_FUNCTION", $sformatf("addr2 expected 0, got %0d", data), UVM_NONE);

    regs.addr3_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);
    if (data != 0)
      uvm_report_error("REG_FUNCTION", $sformatf("addr3 expected 0, got %0d", data), UVM_NONE);

    regs.en_reg.write(
      status, 8'hff, UVM_FRONTDOOR, regs.default_map, null
    );

    yapp_seq.start(sequencer);
    yapp_seq.start(sequencer);

    regs.addr0_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);
    if (data != 2)
      uvm_report_error("REG_FUNCTION", $sformatf("addr0 expected 2, got %0d", data), UVM_NONE);
    else
      uvm_report_info("REG_FUNCTION", "addr0 counter check passed", UVM_NONE);

    regs.addr1_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);
    if (data != 2)
      uvm_report_error("REG_FUNCTION", $sformatf("addr1 expected 2, got %0d", data), UVM_NONE);
    else
      uvm_report_info("REG_FUNCTION", "addr1 counter check passed", UVM_NONE);

    regs.addr2_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);
    if (data != 2)
      uvm_report_error("REG_FUNCTION", $sformatf("addr2 expected 2, got %0d", data), UVM_NONE);
    else
      uvm_report_info("REG_FUNCTION", "addr2 counter check passed", UVM_NONE);

    regs.addr3_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);
    if (data != 0)
      uvm_report_error("REG_FUNCTION", $sformatf("addr3 expected 0, got %0d", data), UVM_NONE);
    else
      uvm_report_info("REG_FUNCTION", "addr3 counter check passed", UVM_NONE);

    regs.parity_err_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);

    uvm_report_info(
      "REG_FUNCTION",
      $sformatf("Parity error counter = %0d", data),
      UVM_NONE
    );

    regs.oversized_pkt_cnt_reg.read(status, data, UVM_FRONTDOOR, regs.default_map, null);

    uvm_report_info(
      "REG_FUNCTION",
      $sformatf("Oversized packet counter = %0d", data),
      UVM_NONE
    );

    phase.drop_objection(this, "Register function test finished");
  endtask : run_phase

endclass : reg_function_test