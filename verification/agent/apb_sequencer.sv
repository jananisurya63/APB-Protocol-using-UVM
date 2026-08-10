/***************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file  implements APB SEQUENCER logic.Controls and sends sequence-generated
              transactions to the driver in a controlled order.
 Date       : 25/03/2025

****************************************************************************************************/

`ifndef _APB_SEQUENCER_
`define _APB_SEQUENCER_

class apb_sequencer extends uvm_sequencer#(apb_transaction);
//Factory Registration
   `uvm_component_utils(apb_sequencer)

//Construct

    function new(string name="apb_sequencer",uvm_component parent=null);
       super.new(name,parent);
    endfunction:new

endclass:apb_sequencer
`endif
