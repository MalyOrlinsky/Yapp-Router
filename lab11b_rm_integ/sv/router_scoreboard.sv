`uvm_analysis_imp_decl(_yapp)
`uvm_analysis_imp_decl(_chan0)
`uvm_analysis_imp_decl(_chan1)
`uvm_analysis_imp_decl(_chan2)

class router_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(router_scoreboard)

  uvm_analysis_imp_yapp #(yapp_packet, router_scoreboard) yapp_export;

  uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) chan0_export;
  uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) chan1_export;
  uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) chan2_export;

  yapp_packet yapp_queue0[$];
  yapp_packet yapp_queue1[$];
  yapp_packet yapp_queue2[$];

  int matched_packets = 0;
  int wrong_packets = 0;
  int received_packets = 0;

  function new(string name = "router_scoreboard",
               uvm_component parent = null);
    super.new(name, parent);

    yapp_export = new("yapp_export", this);
    chan0_export = new("chan0_export", this);
    chan1_export = new("chan1_export", this);
    chan2_export = new("chan2_export", this);
  endfunction

  function void write_yapp(yapp_packet pkt);
    yapp_packet pkt_clone;

    received_packets++;
  
    $cast(pkt_clone, pkt.clone());
  
    case (pkt_clone.addr)
      0: yapp_queue0.push_back(pkt_clone);
      1: yapp_queue1.push_back(pkt_clone);
      2: yapp_queue2.push_back(pkt_clone);
      default:
        `uvm_error("SCOREBOARD",
                   $sformatf("Invalid address: %0d", pkt_clone.addr))
    endcase
  endfunction : write_yapp

  function void write_chan(channel_packet pkt, ref yapp_packet yapp_queue[$]);
    yapp_packet yp;
  
    if (yapp_queue.size() == 0) begin
      wrong_packets++;
      `uvm_error("SCOREBOARD", "Channel received packet with empty queue")
      return;
    end
  
    yp = yapp_queue.pop_front();

    if (comp_equal(yp, pkt)) begin
      matched_packets++;
    end
    else begin
      wrong_packets++;
    end

  endfunction : write_chan

  function void write_chan0(channel_packet pkt);
    write_chan(pkt, yapp_queue0);
  endfunction : write_chan0

  function void write_chan1(channel_packet pkt);
    write_chan(pkt, yapp_queue1);
  endfunction : write_chan1

  function void write_chan2(channel_packet pkt);
    write_chan(pkt, yapp_queue2);
  endfunction : write_chan2

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  
    `uvm_info("SCOREBOARD",
      $sformatf("Received packets: %0d", received_packets),
      UVM_LOW)
  
    `uvm_info("SCOREBOARD",
      $sformatf("Matched packets: %0d", matched_packets),
      UVM_LOW)
  
    `uvm_info("SCOREBOARD",
      $sformatf("Wrong packets: %0d", wrong_packets),
      UVM_LOW)
  
    `uvm_info("SCOREBOARD",
      $sformatf("Packets left in queues: %0d",
        yapp_queue0.size() +
        yapp_queue1.size() +
        yapp_queue2.size()),
      UVM_LOW)
  endfunction : report_phase

  function bit comp_equal(input yapp_packet yp,
                          input channel_packet cp);
    // returns first mismatch only
    if (yp.addr != cp.addr) begin
      `uvm_error("PKT_COMPARE",
        $sformatf("Address mismatch YAPP %0d Chan %0d",
                  yp.addr, cp.addr))
      return(0);
    end
  
    if (yp.length != cp.length) begin
      `uvm_error("PKT_COMPARE",
        $sformatf("Length mismatch YAPP %0d Chan %0d",
                  yp.length, cp.length))
      return(0);
    end
  
    foreach (yp.payload[i])
      if (yp.payload[i] != cp.payload[i]) begin
        `uvm_error("PKT_COMPARE",
          $sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",
                    i, yp.payload[i], cp.payload[i]))
        return(0);
      end
  
    if (yp.parity != cp.parity) begin
      `uvm_error("PKT_COMPARE",
        $sformatf("Parity mismatch YAPP %0d Chan %0d",
                  yp.parity, cp.parity))
      return(0);
    end
  
    return(1);
  endfunction

endclass : router_scoreboard