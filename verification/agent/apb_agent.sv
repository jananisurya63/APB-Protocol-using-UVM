/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: APB agent is a container component that encapsulates the APB driver,sequencer
               and monitor and manages all APB protocol activities.
 Date       : 25/03/2025

***************************************************************************************************/

`ifndef _APB_AGENT_
`define _APB_AGENT_

class apb_agent extends uvm_agent;

//Handle for sequencer,driver,monitor
   apb_sequencer sequencer_h;       
   apb_driver driver_h;
   apb_monitor monitor_h;

//Factory Registration

   `uvm_component_utils(apb_agent)

//Construct

   function new(string name="apb_agent",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//Build Phase

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

//Creating Memory for sequencer,driver,monitor

      sequencer_h=apb_sequencer::type_id::create("sequencer_h",this);
      driver_h=apb_driver::type_id::create("driver_h",this);
      monitor_h=apb_monitor::type_id::create("monitor_h",this);
   endfunction:build_phase


//Connect Phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

//Connect driver to sequencer
   
      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
   endfunction:connect_phase

endclass:apb_agent
`endif
