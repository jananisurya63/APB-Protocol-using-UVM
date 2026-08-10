/****************************************************************************************************
 
 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file implements APB TEST logic.
 Date       : 25/03/2025

****************************************************************************************************/
`ifndef _APB_TEST_
`define _APB_TEST_

class apb_test extends uvm_test;

//Handle

   apb_read_sequence apb_read_seq_h;
   apb_write_sequence apb_write_seq_h;
   apb_rw_sequence apb_rw_seq_h;
   apb_error_sequence apb_error_seq_h;
   int number_of_transaction;
   apb_env env_h;

//Factory Registration

   `uvm_component_utils(apb_test)

//Construct

    function new(string name="apb_test",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//Build Phase

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"before creating memory for env",UVM_LOW);
// Creating memory for environment      
      env_h=apb_env::type_id::create("env_h",this);
   endfunction:build_phase

//Run Phase

   task run_phase(uvm_phase phase);
// Prevent simulation from ending      
      phase.raise_objection(phase);
// Create read,write,read-write and error sequences      
      apb_read_seq_h=apb_read_sequence::type_id::create("apb_read_seq_h");
      apb_write_seq_h=apb_write_sequence::type_id::create("apb_write_seq_h");
      apb_rw_seq_h=apb_rw_sequence::type_id::create("apb_rw_seq_h");
      apb_error_seq_h=apb_error_sequence::type_id::create("apb_error_seq_h");

// Start read sequence on sequencer      
      apb_read_seq_h.start(env_h.agent_h.sequencer_h);
// Start write sequence on sequencer      
      apb_write_seq_h.start(env_h.agent_h.sequencer_h);
// Start read/write sequence on sequencer      
      apb_rw_seq_h.start(env_h.agent_h.sequencer_h);
// Start error sequence on sequencer      
      apb_error_seq_h.start(env_h.agent_h.sequencer_h);
      #100;
      phase.drop_objection(phase);
   endtask:run_phase

endclass:apb_test


`endif
