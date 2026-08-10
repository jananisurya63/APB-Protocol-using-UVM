/****************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file is implement apb scoreboard logic
 Date       : 25/03/2025

****************************************************************************************************/

`ifndef _APB_SCOREBOARD_
`define _APB_SCOREBOARD_
class apb_scoreboard extends uvm_scoreboard;

//Handle for transaction

   apb_transaction transaction_h;

//Memory
   bit[31:0] mem[bit[31:0]];
   virtual apb_interface vif;
    `uvm_component_utils(apb_scoreboard)
    uvm_analysis_imp#(apb_transaction,apb_scoreboard)ap_sb;

//Construct

   function new(string name="apb_scoreboard",uvm_component parent=null);
      super.new(name,parent);
          `uvm_info("SB","entered into scoreboard",UVM_LOW);
   endfunction:new

//Build Phase

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      ap_sb=new("ap_sb",this);
      if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif));
      `uvm_info(get_type_name(),"virtual interface is notfound",UVM_LOW);
   endfunction:build_phase


  function void write(apb_transaction transaction_h);
      `uvm_info(get_type_name(),"received packet inside scoreboard",UVM_LOW);
      if(transaction_h.pslverr)begin
         `uvm_error(get_type_name(),$sformatf("slave error paddr=%0h pslverr=%0b",transaction_h.paddr,transaction_h.pslverr));
         return;
      end

      if(transaction_h.pwrite)begin
         mem[transaction_h.paddr]=transaction_h.pwdata;
      `uvm_info(get_type_name(),$sformatf("write data mem[%0h]=%0hh",transaction_h.paddr,transaction_h.pwdata),UVM_LOW);

   end
   else begin
      if(!mem.exists(transaction_h.paddr))begin
         `uvm_warning(get_type_name(),$sformatf("read from uninitialized paddr=%0h",transaction_h.paddr));
         return;
      end

      if(mem[transaction_h.paddr]==transaction_h.prdata)begin
      `uvm_info(get_type_name(),$sformatf("pass addr=%0h mem=%0h prdata=%0h",transaction_h.paddr,mem[transaction_h.paddr],transaction_h.prdata),UVM_LOW);
   end
   else begin
      `uvm_info(get_type_name(),$sformatf("fail addr=%0h mem=%0h prdata=%0h",transaction_h.paddr,mem[transaction_h.paddr],transaction_h.prdata),UVM_LOW);

   end
end
endfunction:write

endclass:apb_scoreboard

`endif
