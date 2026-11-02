`uvm_analysis_imp_decl(_yapp_ref)
`uvm_analysis_imp_decl(_hbus_ref)

class router_reference extends uvm_component;

  `uvm_component_utils(router_reference)

  // Input: YAPP packets
  uvm_analysis_imp_yapp_ref #(
    yapp_packet, router_reference
  ) yapp_export;

  // Input: HBUS transactions
  uvm_analysis_imp_hbus_ref #(
    hbus_transaction, router_reference
  ) hbus_export;

  // Output: valid YAPP packets
  uvm_analysis_port #(yapp_packet) valid_yapp_port;

  // Mirrored register fields
  bit [5:0] maxpktsize = 6'h3f;
  bit       router_en  = 1'b1;

  // Invalid packet counters
  int dropped_size    = 0;
  int dropped_disabled = 0;
  int dropped_address  = 0;

  function new(
    string name = "router_reference",
    uvm_component parent = null
  );
    super.new(name, parent);

    yapp_export = new("yapp_export", this);
    hbus_export = new("hbus_export", this);
    valid_yapp_port = new("valid_yapp_port", this);
  endfunction

  function void write_hbus_ref(hbus_transaction tr);
  
    if (tr.hwr_rd == HBUS_WRITE) begin
      case (tr.haddr)
        16'h1000: maxpktsize = tr.hdata[5:0];
        16'h1001: router_en  = tr.hdata[0];
        default: ;
      endcase
    end
  
  endfunction : write_hbus_ref

  function void write_yapp_ref(yapp_packet pkt);

    if (!router_en) begin
      dropped_disabled++;
    end
    else if (pkt.length > maxpktsize) begin
      dropped_size++;
    end
    else if (pkt.addr > 2) begin
      dropped_address++;
    end
    else begin
      valid_yapp_port.write(pkt);
    end

  endfunction : write_yapp_ref

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  
    `uvm_info("ROUTER_REFERENCE",
      $sformatf("Dropped due to router disabled: %0d",
                dropped_disabled), UVM_LOW)
  
    `uvm_info("ROUTER_REFERENCE",
      $sformatf("Dropped due to oversized packet: %0d",
                dropped_size), UVM_LOW)
  
    `uvm_info("ROUTER_REFERENCE",
      $sformatf("Dropped due to invalid address: %0d",
                dropped_address), UVM_LOW)
  endfunction : report_phase    

endclass : router_reference