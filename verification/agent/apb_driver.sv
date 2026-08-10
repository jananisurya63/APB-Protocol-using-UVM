/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file implements APB DRIVER.Drives APB transactions from sequence to DUT signals.
 Date       : 25/03/2025

****************************************************************************************************/
`ifndef _APB_DRIVER_
`define _APB_DRIVER_

class apb_driver extends uvm_driver#(apb_transaction);

//Handle for transaction request,response
   apb_transaction transaction_req_h;
   apb_transaction transaction_res_h;
//Handshake between dut and driver through virtual interface
   virtual apb_interface vif;
//To check pready signals
   int wait_count;
//Factory Registration
   `uvm_component_utils(apb_driver)
  
//Construct
   function new(string name="apb_driver",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new
   
//Build Phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
//Getting the signal using config_db through virtual interface   
      if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
      `uvm_info(get_type_name(),"virtual interface is not found",UVM_LOW);
   endfunction:build_phase
   
//Run Phase
   task run_phase(uvm_phase phase);
      forever begin
         phase.raise_objection(this);
         seq_item_port.get_next_item(transaction_req_h);
         run();
         seq_item_port.item_done();
//if reset occurs send that transaction to sequence or actual transaction should pass to sequence      
         if(transaction_res_h!=null&&transaction_res_h.flag==1)
            seq_item_port.put_response(transaction_res_h);
         else
            seq_item_port.put_response(transaction_req_h);
         phase.drop_objection(this);
      end 
   endtask:run_phase
  
//Main Task
   task run();
      @(vif.master_cb);
//Reset occurs means execute reset logic   
      if(!vif.presetn||$isunknown(vif.presetn))begin
         reset_logic(transaction_req_h);
      end
//If Reset not occurs means execute driver logic
      else begin
         driver_logic(transaction_req_h);
      end
   endtask:run
//Reset logic
   task reset_logic(apb_transaction transaction_req_h);
      `uvm_info("reset occurs","inside reset_logic",UVM_LOW);
      do begin
         $display("entering reset logic");
         vif.paddr<=0;
         vif.pwrite<=0;
         vif.psel<=0;
         vif.penable<=0;
         vif.pwdata<=0;
         $display("finishing reset logic");
         @(vif.master_cb);
      end
      while(!vif.presetn||$isunknown(vif.presetn));
   endtask
//Driver Logic
   task driver_logic(apb_transaction transaction_req_h);
//Idle State   
      @(vif.master_cb);
//Checking reset before entering into setup state   
      if(!vif.presetn||$isunknown(vif.presetn)) begin
         $cast(transaction_res_h,transaction_req_h.clone());
         transaction_res_h.set_id_info(transaction_req_h);
         transaction_res_h.flag=1;
         `uvm_info(get_type_name(),"reset occuring before setup",UVM_LOW);
         reset_logic(transaction_req_h);
         return;
      end
      else begin
//The transaction data is send to dut through virtual interface   
         vif.master_cb.psel<=1'b1;
         vif.master_cb.penable<=1'b0;
         vif.master_cb.paddr<=transaction_req_h.paddr;
         vif.master_cb.pwdata<=transaction_req_h.pwdata;
         vif.master_cb.pwrite<=transaction_req_h.pwrite;
      end
//Checking reset before entering into setup state
      @(vif.master_cb);
      if(!vif.presetn||$isunknown(vif.presetn)) begin
         $cast(transaction_res_h,transaction_req_h.clone());
         transaction_res_h.flag=1;
         `uvm_info(get_type_name(),"reset occuring before setup",UVM_LOW);
         reset_logic(transaction_req_h);
         return;
      end
      else begin 
         `uvm_info(get_type_name(),"entered to access state",UVM_LOW);
//Access state   
         vif.master_cb.penable<=1'b1;
      end
      
      @(vif.master_cb);
   while(!vif.master_cb.pready)begin
      if(!vif.presetn||$isunknown(vif.presetn)) begin
         $cast(transaction_res_h,transaction_req_h.clone());
         transaction_res_h.flag=1;
         `uvm_info(get_type_name(),"reset occuring before setup",UVM_LOW);
         reset_logic(transaction_req_h);
         return;
      end
      else begin
         wait_count++;
//Here checking the pready receiving within 5 clock cycle or not    
         if(wait_count>=5&&!vif.pready)
            `uvm_info(get_type_name(),$sformatf("wait count reached maximum%0d",wait_count),UVM_LOW);
      @(vif.master_cb);
   end
end
   wait_count=0;
      @(vif.master_cb); 
//After transaction completed psel and penable become zero(0) 
              `uvm_info(get_type_name(),$sformatf("trasaction completed data=%0s",transaction_req_h.sprint()),UVM_LOW);
              vif.master_cb.psel<=1'b0;
              vif.master_cb.penable<=1'b0;
   endtask:driver_logic
endclass:apb_driver
`endif
