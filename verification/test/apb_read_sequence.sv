/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file implements APB READ SEQUENCE logic.
 Date       : 25/03/2025

***************************************************************************************************/

`ifndef _APB_READ_SEQUENCE_
`define _APB_READ_SEQUENCE_

class apb_read_sequence extends uvm_sequence#(apb_transaction);

//Handle for transaction

   apb_transaction transaction_req_h;
   apb_transaction transaction_res_h;
   int number_of_transaction;

//Factory Registration

   `uvm_object_utils_begin(apb_read_sequence)
   `uvm_field_object(transaction_req_h,UVM_DEFAULT)
   `uvm_field_object(transaction_res_h,UVM_DEFAULT)
   `uvm_object_utils_end

//Construct

    function new(string name="apb_sequence");
       super.new(name);
    endfunction:new

//Body Method

    task body();
// Create response transaction object        
          transaction_res_h=apb_transaction::type_id::create("transaction_res_h");
          `uvm_info("SEQ","before start item",UVM_LOW);
// Check if number of transaction is passed through plusarg          
          if($value$plusargs("number of transaction=%0d",number_of_transaction))
// Use default value if plusarg is not provided              
             number_of_transaction=number_of_transaction;
          else
// Set transaction count to 10              
             number_of_transaction=10;

          repeat(number_of_transaction)begin
// Create request transaction object               
             transaction_req_h=apb_transaction::type_id::create("transaction_req_h");
// Send transaction to sequencer             
             start_item(transaction_req_h);
          `uvm_info("SEQ","after start item",UVM_LOW);
// Check if response transaction is available
          if(transaction_res_h.flag==1)begin
             transaction_res_h.flag=0;
// Copy response data into request             
             transaction_req_h.copy(transaction_res_h);
             `uvm_info("DEBUG",$sformatf("response data passing to driver=%0s",transaction_req_h.sprint()),UVM_LOW);
          end

        else begin
           `uvm_info("SEQ","before randomize",UVM_LOW);
          transaction_req_h.randomize()with{pwrite==0;};
          `uvm_info("DEBUG",$sformatf("randomization data passing to driver=%0s",transaction_res_h.sprint()),UVM_LOW);
          `uvm_info("SEQ","after randomize",UVM_LOW);
       end
          `uvm_info("SEQ","before finish item",UVM_LOW);
// Send transaction from sequencer to driver                 
          finish_item(transaction_req_h);
          `uvm_info("SEQ","after finish item",UVM_LOW);
// Wait and receive response from driver

          get_response(transaction_res_h);
          `uvm_info("DEBUG",$sformatf("get response data=%0s",transaction_res_h.sprint()),UVM_LOW);
          
       end
    endtask:body

endclass:apb_read_sequence
`endif
