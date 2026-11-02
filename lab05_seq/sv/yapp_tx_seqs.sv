/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets


class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),
              "Executing yapp_1_seq",
              UVM_LOW)

    `uvm_do_with(req, {
      addr == 1;
    })
  endtask

endclass : yapp_1_seq


class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  function new(string name = "yapp_012_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),
              "Executing yapp_012_seq",
              UVM_LOW)

    `uvm_do_with(req, { addr == 0; })
    `uvm_do_with(req, { addr == 1; })
    `uvm_do_with(req, { addr == 2; })
  endtask

endclass : yapp_012_seq


class yapp_111_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_111_seq)

  yapp_1_seq seq1;
  yapp_1_seq seq2;
  yapp_1_seq seq3;

  function new(string name = "yapp_111_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),
              "Executing yapp_111_seq",
              UVM_LOW)

    `uvm_do(seq1)
    `uvm_do(seq2)
    `uvm_do(seq3)
  endtask

endclass : yapp_111_seq


class yapp_repeat_addr_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_repeat_addr_seq)

  rand bit [1:0] prev_addr;

  constraint prev_addr_c {
    prev_addr inside {[0:2]};
  }

  function new(string name = "yapp_repeat_addr_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),
              "Executing yapp_repeat_addr_seq",
              UVM_LOW)

    if (!this.randomize())
      `uvm_fatal(get_type_name(),
                 "Failed to randomize prev_addr")

    `uvm_do_with(req, { addr == prev_addr; })
    `uvm_do_with(req, { addr == prev_addr; })
  endtask

endclass : yapp_repeat_addr_seq


class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)

  function new(string name = "yapp_incr_payload_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),
              "Executing yapp_incr_payload_seq",
              UVM_LOW)

    `uvm_create(req)

    if (!req.randomize())
      `uvm_fatal(get_type_name(),
                 "Packet randomization failed")

    foreach (req.payload[i])
      req.payload[i] = i;

    req.set_parity();

    `uvm_send(req)
  endtask

endclass : yapp_incr_payload_seq


class yapp_rnd_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_rnd_seq)

  rand int count;

  function new(string name = "yapp_rnd_seq");
    super.new(name);
  endfunction

  constraint count_c {
    count inside {[1:10]};
  }

  virtual task body();
    `uvm_info(get_type_name(),
              "Executing yapp_rnd_seq",
              UVM_LOW)

    if (!this.randomize())
      `uvm_fatal(get_type_name(),
                 "Packet randomization failed")

    `uvm_info(get_type_name(), $sformatf("count = %0d", count), UVM_LOW)

    repeat (count)
      `uvm_do(req)

  endtask

endclass : yapp_rnd_seq


class six_yapp_seq extends yapp_rnd_seq;

  `uvm_object_utils(six_yapp_seq)

  function new(string name = "six_yapp_seq");
    super.new(name);
  endfunction

  constraint count_6 {
    count == 6;
  }

  virtual task body();
    `uvm_info(get_type_name(),
              "Executing six_yapp_seq",
              UVM_LOW)

    if (!this.randomize())
      `uvm_fatal(get_type_name(),
                 "Packet randomization failed")

    `uvm_info(get_type_name(), $sformatf("count = %0d", count), UVM_LOW)

    repeat (count)
      `uvm_do(req)

  endtask

endclass : six_yapp_seq


class yapp_exhaustive_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_exhaustive_seq)

  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction

  virtual task body();
    yapp_1_seq             seq_1;
    yapp_012_seq           seq_012;
    yapp_111_seq           seq_111;
    yapp_repeat_addr_seq   seq_repeat_addr;
    yapp_incr_payload_seq  seq_incr_payload;
    yapp_rnd_seq           seq_rnd;
    six_yapp_seq           seq_six_rnd;

    `uvm_info(get_type_name(),
              "Executing yapp_exhaustive_seq",
              UVM_LOW)

    `uvm_do(seq_1)
    `uvm_do(seq_012)
    `uvm_do(seq_111)
    `uvm_do(seq_repeat_addr)
    `uvm_do(seq_incr_payload)
    `uvm_do(seq_rnd)
    `uvm_do(seq_six_rnd)
  endtask

endclass : yapp_exhaustive_seq
