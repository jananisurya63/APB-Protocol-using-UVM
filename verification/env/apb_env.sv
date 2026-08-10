/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file implements APB ENV logic.Top-level UVM component that connects and controls
              all testbench components like driver,monitor,sequencer and scoreboard.
 Date       : 25/03/2025

****************************************************************************************************/

`ifndef _APB_ENV_
`define _APB_ENV_
class apb_env extends uvm_env;

//Handle for agent and scoreboard
    apb_agent agent_h;
    apb_scoreboard scoreboard_h;
//Factory Registration
    `uvm_component_utils(apb_env)

//construct

   function new(string name="apb_env",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//Build Phase

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);      
      `uvm_info(get_type_name(),"before memory creation of en",UVM_LOW);
//Creating Memory for agent and scoreboard      
      agent_h=apb_agent::type_id::create("agent_h",this);
      scoreboard_h=apb_scoreboard::type_id::create("scoreboard_h",this);
   endfunction:build_phase

//Connect Phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
//Connecting monitor to scoreboard      
      agent_h.monitor_h.mon_port.connect(scoreboard_h.ap_sb);
   endfunction:connect_phase

endclass:apb_env

`endif
