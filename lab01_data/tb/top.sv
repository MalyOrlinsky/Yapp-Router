/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
import uvm_pkg::*;
`include "uvm_macros.svh"

import yapp_pkg::*;

module top;

  yapp_packet packet;
/////////////////////////////////
  yapp_packet packet_copy;
  yapp_packet packet_clone;
/////////////////////////////////

  initial begin

////    repeat (5) begin
////      packet = new();
////      packet.randomize();
////      packet.print();
////    end

    // ---------------------------------------------------------
    // Create and randomize original packet
    // ---------------------------------------------------------
    packet = new("packet");

    if (!packet.randomize())
      `uvm_error("RAND", "Packet randomization failed")

    $display("\n================ ORIGINAL PACKET ================\n");
    packet.print();

    // ---------------------------------------------------------
    // copy()
    // ---------------------------------------------------------
    packet_copy = new("packet_copy");

    packet_copy.copy(packet);

    $display("\n================ COPIED PACKET ==================\n");
    packet_copy.print();

    // Compare original and copy
    if (packet.compare(packet_copy))
      $display("\nCOPY TEST: PASS - packets are identical\n");
    else
      $display("\nCOPY TEST: FAIL - packets are different\n");

    // ---------------------------------------------------------
    // clone()
    // ---------------------------------------------------------
    packet_clone = packet.clone();

    $display("\n================ CLONED PACKET ==================\n");
    packet_clone.print();

    // Compare original and clone
    if (packet.compare(packet_clone))
      $display("\nCLONE TEST: PASS - packets are identical\n");
    else
      $display("\nCLONE TEST: FAIL - packets are different\n");

    // ---------------------------------------------------------
    // Modify copy and test compare()
    // ---------------------------------------------------------
    packet_copy.addr = packet.addr + 1;

    $display("\n============= MODIFIED COPIED PACKET =============\n");
    packet_copy.print();

    if (packet.compare(packet_copy))
      $display("\nCOMPARE TEST: FAIL - packets should be different\n");
    else
      $display("\nCOMPARE TEST: PASS - packets are different\n");

    // ---------------------------------------------------------
    // Table printer
    // ---------------------------------------------------------
    $display("\n================ TABLE PRINTER ==================\n");
    packet.print(uvm_default_table_printer);

    // ---------------------------------------------------------
    // Tree printer
    // ---------------------------------------------------------
    $display("\n================= TREE PRINTER ==================\n");
    packet.print(uvm_default_tree_printer);

    $finish;


  end

  // generate 5 random packets and use the print method
  // to display the results

  // experiment with the copy, clone and compare UVM method

endmodule : top
