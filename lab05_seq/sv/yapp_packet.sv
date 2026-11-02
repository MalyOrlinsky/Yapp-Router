/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : lab01_data YAPP UVC packet template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

// Define your enumerated type(s) here

typedef enum {GOOD_PARITY, BAD_PARITY} parity_type_e;

class yapp_packet extends uvm_sequence_item;

// Follow the lab instructions to create the packet.
// Place the packet declarations in the following order:

  // Define protocol data
  rand bit [1:0] addr;
  rand bit [5:0] length;
  rand bit [7:0] payload[];
  bit [7:0] parity;

  // Define control knobs
  rand parity_type_e parity_type;
  rand int packet_delay;

  // Enable automation of the packet's fields
  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(length, UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity, UVM_ALL_ON)
  `uvm_object_utils_end

  // Define packet constraints
  constraint addr_c {
    addr inside {[0:2]};
  }

  constraint length_c {
    length inside {[1:63]};
    payload.size() == length;
  }

  constraint parity_type_c {
    parity_type dist {
      GOOD_PARITY := 5,
      BAD_PARITY  := 1
    };
  }

  constraint packet_delay_c {
    packet_delay inside {[1:20]};
  }

  // Add methods for parity calculation and class construction
  function new(string name = "yapp_packet");
    super.new(name);
  endfunction
  
  function bit [7:0] calc_parity();
    bit [7:0] parity_calc;

    parity_calc = 0;

    parity_calc ^= addr;
    parity_calc ^= length;

    foreach (payload[i])
      parity_calc ^= payload[i];

    return parity_calc;
  endfunction

  function void set_parity();

    if (parity_type == GOOD_PARITY)
      parity = calc_parity();
    else
      parity = ~calc_parity();

  endfunction

  function void post_randomize();
    set_parity();
  endfunction

endclass: yapp_packet



class short_yapp_packet extends yapp_packet;

  `uvm_object_utils(short_yapp_packet)

  function new(string name = "short_yapp_packet");
    super.new(name);
  endfunction

  constraint short_length_c {
    length < 15;
  }

//  constraint short_addr_c {
//    addr != 2;
//  }

endclass: short_yapp_packet
