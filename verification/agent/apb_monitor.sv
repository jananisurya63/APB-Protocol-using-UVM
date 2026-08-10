/***************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file implements APB MONITOR logic.Observes DUT APB signals and converts them into               transactions.
 Date       : 25/03/2025

****************************************************************************************************/

`ifndef _APB_MONITOR_
`define _APB_MONITOR_

class apb_monitor extends uvm_monitor;

//Factory Registration
   
   `uvm_component_utils(apb_monitor)
//Handshake between dut and monitor through virtual interface   
   virtual apb_interface vif;
//Analysis port
   uvm_analysis_port #(apb_transaction)mon_port;

//Construct

   function new(string name="apb_monitor",uvm_component parent=null);
      super.new(name,parent);
      `uvm_info("MON","entered into monitor",UVM_LOW);
//Memory for monitor      
      mon_port=new("mon_port",this);
   endfunction : new

//Build Phase

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
//Getting the signal using config_db through virtual interface      
      uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif);
   endfunction : build_phase

//Run Phase
   
   task run_phase(uvm_phase phase);
      apb_transaction transaction_h;
      forever begin
         @(vif.master_cb); 
          if(vif.monitor_cb.psel && vif.monitor_cb.penable && vif.monitor_cb.pready)begin
//Memory for transaction
             transaction_h=apb_transaction::type_id::create("transaction_h");
//Collecting signal from interface and storing them into a transaction object
            transaction_h.paddr <= vif.monitor_cb.paddr;
            transaction_h.pwdata <= vif.monitor_cb.pwdata;
            transaction_h.pwrite <= vif.monitor_cb.pwrite;
            transaction_h.prdata <= vif.monitor_cb.prdata;
            transaction_h.pslverr <= vif.monitor_cb.pslverr;
//Sends the collected transaction from monitor to scoreboard,coverage using UVM analysis port           
            mon_port.write(transaction_h);

         end
      end
      endtask : run_phase
endclass : apb_monitor
`endif
