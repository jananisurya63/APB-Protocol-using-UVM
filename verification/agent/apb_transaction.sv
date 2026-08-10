/****************************************************************************************************

Author     : JANANI S
e-mail     : jananisurya63@gmail.com
Project    : APB Protocol
Description: This file implements APB TRANSACTION logic.Defines the APB data packet structure used
             for communication.
Date       : 25/03/2025

****************************************************************************************************/

`ifndef _APB_TRANSACTION_
`define _APB_TRANSACTION_

class apb_transaction extends uvm_sequence_item;
//Signals
   bit psel;
   bit penable;
   bit pready;

   rand bit [31:0]paddr;
   rand bit pwrite;
   rand bit [31:0]pwdata;
        bit [31:0]prdata;
        bit pslverr;
        bit flag;
//Factory Registration
    `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(psel,UVM_DEFAULT)
    `uvm_field_int(penable,UVM_DEFAULT)
    `uvm_field_int(pready,UVM_DEFAULT)
    `uvm_field_int(paddr,UVM_DEFAULT)
    `uvm_field_int(pwrite,UVM_DEFAULT)
    `uvm_field_int(pwdata,UVM_DEFAULT)
    `uvm_field_int(prdata,UVM_DEFAULT)
    `uvm_field_int(pslverr,UVM_DEFAULT)
    `uvm_field_int(flag,UVM_DEFAULT)
    `uvm_object_utils_end
//construct
    function new(string name="apb_transaction");
       super.new(name);
    endfunction:new

    constraint c_paddr{paddr inside{[13:30]};}
    constraint c_pwdata{pwdata inside{[1:10]};}
endclass:apb_transaction
`endif
