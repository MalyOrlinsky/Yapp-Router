//`uvm_analysis_imp_decl(_yapp)
//`uvm_analysis_imp_decl(_chan0)
//`uvm_analysis_imp_decl(_chan1)
//`uvm_analysis_imp_decl(_chan2)

class router_scoreboard_fifo extends uvm_scoreboard;

  `uvm_component_utils(router_scoreboard_fifo)

  uvm_tlm_analysis_fifo #(yapp_packet)     yapp_fifo;
  uvm_tlm_analysis_fifo #(hbus_transaction) hbus_fifo;
  uvm_tlm_analysis_fifo #(channel_packet)  chan0_fifo;
  uvm_tlm_analysis_fifo #(channel_packet)  chan1_fifo;
  uvm_tlm_analysis_fifo #(channel_packet)  chan2_fifo;

  uvm_get_port #(yapp_packet)      yapp_get_port;
  uvm_get_port #(hbus_transaction) hbus_get_port;
  uvm_get_port #(channel_packet)   chan0_get_port;
  uvm_get_port #(channel_packet)   chan1_get_port;
  uvm_get_port #(channel_packet)   chan2_get_port;

  bit [5:0] maxpktsize = 6'h3f;
  bit router_en = 1'b1;

  int received_packets = 0;
  int matched_packets = 0;
  int wrong_packets = 0;
  int dropped_disabled = 0;
  int dropped_size = 0;
  int dropped_address = 0;

  function new(string name = "router_scoreboard_fifo",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    yapp_fifo = new("yapp_fifo", this);
    hbus_fifo = new("hbus_fifo", this);
    chan0_fifo = new("chan0_fifo", this);
    chan1_fifo = new("chan1_fifo", this);
    chan2_fifo = new("chan2_fifo", this);

    yapp_get_port = new("yapp_get_port", this);
    hbus_get_port = new("hbus_get_port", this);
    chan0_get_port = new("chan0_get_port", this);
    chan1_get_port = new("chan1_get_port", this);
    chan2_get_port = new("chan2_get_port", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    yapp_get_port.connect(yapp_fifo.get_peek_export);
    hbus_get_port.connect(hbus_fifo.get_peek_export);
    chan0_get_port.connect(chan0_fifo.get_peek_export);
    chan1_get_port.connect(chan1_fifo.get_peek_export);
    chan2_get_port.connect(chan2_fifo.get_peek_export);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      process_yapp();
      process_hbus();
    join
  endtask

  task process_hbus();
    hbus_transaction tr;

    forever begin
      hbus_get_port.get(tr);

      if (tr.hwr_rd == HBUS_WRITE) begin
        case (tr.haddr)
          16'h1000: maxpktsize = tr.hdata[5:0];
          16'h1001: router_en = tr.hdata[0];
          default: ;
        endcase
      end
    end
  endtask

  task process_yapp();
    yapp_packet yp;
    channel_packet cp;

    forever begin
      yapp_get_port.get(yp);
      received_packets++;

      if (!router_en) begin
        dropped_disabled++;
      end
      else if (yp.length > maxpktsize) begin
        dropped_size++;
      end
      else if (yp.addr > 2) begin
        dropped_address++;
      end
      else begin
        case (yp.addr)
          0: chan0_get_port.get(cp);
          1: chan1_get_port.get(cp);
          2: chan2_get_port.get(cp);
          default: begin
            wrong_packets++;
            continue;
          end
        endcase

        if (comp_equal(yp, cp))
          matched_packets++;
        else
          wrong_packets++;
      end
    end
  endtask

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);

    if (yapp_fifo.used() != 0 ||
        hbus_fifo.used() != 0 ||
        chan0_fifo.used() != 0 ||
        chan1_fifo.used() != 0 ||
        chan2_fifo.used() != 0) begin
      `uvm_error("SCOREBOARD_FIFO", "One or more FIFOs are not empty")
    end
  endfunction

 function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info("SCOREBOARD_FIFO",
      $sformatf("Received packets: %0d", received_packets), UVM_LOW)
    `uvm_info("SCOREBOARD_FIFO",
      $sformatf("Matched packets: %0d", matched_packets), UVM_LOW)
    `uvm_info("SCOREBOARD_FIFO",
      $sformatf("Wrong packets: %0d", wrong_packets), UVM_LOW)
    `uvm_info("SCOREBOARD_FIFO",
      $sformatf("Dropped disabled: %0d", dropped_disabled), UVM_LOW)
    `uvm_info("SCOREBOARD_FIFO",
      $sformatf("Dropped oversized: %0d", dropped_size), UVM_LOW)
    `uvm_info("SCOREBOARD_FIFO",
      $sformatf("Dropped invalid address: %0d", dropped_address), UVM_LOW)
  endfunction

  function bit comp_equal(yapp_packet yp, channel_packet cp);
    if (yp.addr != cp.addr)
      return 0;

    if (yp.length != cp.length)
      return 0;

    foreach (yp.payload[i])
      if (yp.payload[i] != cp.payload[i])
        return 0;

    if (yp.parity != cp.parity)
      return 0;

    return 1;
  endfunction

endclass : router_scoreboard