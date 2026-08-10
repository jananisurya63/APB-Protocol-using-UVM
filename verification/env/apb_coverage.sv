/***************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file implements APB COVERAGE logic.Measures how much of the APB functionality and
              scenarios have been exercised during simulation.
 Date       : 25/03/2025

****************************************************************************************************/

`ifndef _APB_COVERAGE_
`define _APB_COVERAGE_
class apb_coverage extends uvm_subscriber#(apb_transaction);
// Handle for transaction   
   apb_transaction transaction_h;
// Factory Registration   
   `uvm_component_utils(apb_coverage)
   uvm_analysis_imp#(apb_transaction,apb_coverage)cov_imp;

// Covergroup    
   covergroup apb_cg;
// Coverage for address      
      PADDR:coverpoint transaction_h.paddr{bins paddr={[13:30]};
                                           ignore_bins ig_s={[31:255]};
                                           illegal_bins il_s={0,4,8,12};
                                           bins error_occur={32'hffff_ffff};}
// Coverage for data
      PWDATA:coverpoint transaction_h.pwdata{bins data[]={[1:10]};}
// Coverage for read and write      
      PWRITE:coverpoint transaction_h.pwrite{bins read={0};
                                             bins write={1};}
// Coverage for sel                                             
      PSEL:coverpoint transaction_h.psel{bins psel_on={1};
                                         bins psel_off={0};}
// Coverage of enable                                         
      PENABLE:coverpoint transaction_h.pready{bins wait_state={1};
                                              bins no_wait_state={0};}

// Cross Coverage                                              

      cross_1:cross PADDR,PWRITE;
      cross_2:cross PADDR,PWDATA;
   endgroup


// Constructor
   function new(string name="apb_coverage",uvm_component parent=null);
      super.new(name,parent);
      apb_cg=new();
   endfunction:new

// Build phase   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      cov_imp=new("cov_imp",this);
   endfunction:build_phase


// Receives transaction from monitor through analysis port
   function void write(apb_transaction t);
// Store received transactions      
      transaction_h=t;
// sample coverage      
      apb_cg.sample();
   endfunction:write

endclass:apb_coverage
`endif 
