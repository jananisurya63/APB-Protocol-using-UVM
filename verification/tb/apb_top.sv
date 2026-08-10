/***************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file implements APB TOP logic.
 Date       : 25/03/2025

***************************************************************************************************/

`ifndef _APB_TOP_
`define _APB_TOP_
import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_test_package::*;
//`include "apb_transaction.sv"
//`include "apb_sequence.sv"
//`include "apb_write_sequence.sv"
//`include "apb_rw_sequence.sv"
//`include "apb_error_sequence.sv"
//`include "apb_sequencer.sv"
//`include "driver.sv"
//`include "apb_monitor.sv"
//`include "apb_agent.sv"
//`include "apb_scoreboard.sv"
//`include "apb_env.sv"
//`include "apb_test.sv"
//`include "apb_interface.sv"
//`include "apb_slave_design.sv"

module apb_top();

logic pclk;
logic presetn;
apb_interface intf(pclk,presetn);
apb_slave dut(intf);
always #5 pclk=~pclk;

initial begin
   uvm_config_db#(virtual apb_interface)::set(null,"*","vif",intf);
end
initial begin
   pclk=0;
   presetn=0;

   #10;
   presetn=1;
   #20;
   presetn=0;
   #20;
   presetn=1;
   
   #3000;
   $finish;
end
initial begin
   `uvm_info("apb_top","before calling run_test",UVM_LOW);
   run_test("apb_test");
end
endmodule:apb_top
`endif
