/***************************************************************************************************

 Author     : JANANI S
 e-mail     : jananisurya63@gmail.com
 Project    : APB Protocol
 Description: This file implements APB INTERFACE logic.
 Date       : 25/03/2025

***************************************************************************************************/

`ifndef _APB_INTERFACE_
`define _APB_INTERFACE_
interface apb_interface(input logic pclk,input logic presetn);

   logic pready;
   logic penable;
   logic psel;
   logic [31:0]paddr;
   logic [31:0]pwdata;
   logic [31:0]prdata;
   logic pwrite;
   logic pslverr;


// Clocking block used by driver(master)   
   clocking master_cb @(posedge pclk);
//      default input #1 output #1;
      input pready,prdata,pslverr;
      output psel,penable,paddr,pwrite,pwdata;
   endclocking


// Clocking block used by monitor   
   clocking monitor_cb @(posedge pclk);
//      default input #1 output #1;
      input pready,prdata,pslverr;
      input psel,penable,paddr,pwrite,pwdata;
   endclocking

endinterface
`endif
