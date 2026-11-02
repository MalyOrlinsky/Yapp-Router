class router_simple_mcseq extends uvm_sequence;

  `uvm_object_utils(router_simple_mcseq)
  `uvm_declare_p_sequencer(router_mcsequencer)

  function new(string name = "router_simple_mcseq");
    super.new(name);
  endfunction
  
  virtual task body();  
    hbus_set_yapp_regs_seq set_small_regs;
    hbus_read_max_pkt_seq  read_small_regs;
    yapp_012_seq           yapp_012;
    hbus_set_yapp_regs_seq set_large_regs;
    hbus_read_max_pkt_seq  read_large_regs;
    six_yapp_seq           yapp_six_random;
    yapp_coverage_seq      yapp_coverage;
  
  `uvm_info("MCSEQ_CHECK",
          "router_simple_mcseq started",
          UVM_LOW)

    // Raise objection
    if (starting_phase != null)
      starting_phase.raise_objection(this);
  
    // --------------------------------------------------
    // Step 1: Configure router for small packets
    // MAXPKTSIZE = 20, router enabled
    // --------------------------------------------------
    set_small_regs =
      hbus_set_yapp_regs_seq::type_id::create("set_small_regs");
  
    set_small_regs.max_pkt_reg = 8'd20;
    set_small_regs.enable_reg  = 8'd1;
  
    set_small_regs.start(p_sequencer.hbus_seqr);
  
    // --------------------------------------------------
    // Step 2: Read MAXPKTSIZE and check the value
    // --------------------------------------------------
    read_small_regs =
      hbus_read_max_pkt_seq::type_id::create("read_small_regs");
  
    read_small_regs.start(p_sequencer.hbus_seqr);
  
    if (read_small_regs.max_pkt_reg != 8'd20)
      `uvm_error("MAXPKTSIZE_CHECK",
                 $sformatf("Expected 20, got %0d",
                           read_small_regs.max_pkt_reg))
  
    // --------------------------------------------------
    // Step 3: Send six packets to addresses 0, 1, 2
    // yapp_012_seq sends three packets per execution
    // --------------------------------------------------
    yapp_012 = yapp_012_seq::type_id::create("yapp_012_first");
    yapp_012.start(p_sequencer.yapp_seqr);
  
    yapp_012 = yapp_012_seq::type_id::create("yapp_012_second");
    yapp_012.start(p_sequencer.yapp_seqr);
  
    // --------------------------------------------------
    // Step 4: Configure router for large packets
    // MAXPKTSIZE = 63, router enabled
    // --------------------------------------------------
    set_large_regs =
      hbus_set_yapp_regs_seq::type_id::create("set_large_regs");
  
    set_large_regs.max_pkt_reg = 8'd63;
    set_large_regs.enable_reg  = 8'd1;
  
    set_large_regs.start(p_sequencer.hbus_seqr);
  
    // --------------------------------------------------
    // Step 5: Read MAXPKTSIZE and check the value
    // --------------------------------------------------
    read_large_regs =
      hbus_read_max_pkt_seq::type_id::create("read_large_regs");
  
    read_large_regs.start(p_sequencer.hbus_seqr);
  
    if (read_large_regs.max_pkt_reg != 8'd63)
      `uvm_error("MAXPKTSIZE_CHECK",
                 $sformatf("Expected 63, got %0d",
                           read_large_regs.max_pkt_reg))
  
    // --------------------------------------------------
    // Step 6: Send six random YAPP packets
    // --------------------------------------------------
    yapp_six_random =
      six_yapp_seq::type_id::create("yapp_six_random");
  
    yapp_six_random.start(p_sequencer.yapp_seqr);

    // --------------------------------------------------
    // Step 7: Send random YAPP packets in every longers
    // --------------------------------------------------
    yapp_coverage =
      yapp_coverage_seq::type_id::create("yapp_coverage");
  
    yapp_coverage.start(p_sequencer.yapp_seqr);


    // Drop objection
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  
  endtask

endclass