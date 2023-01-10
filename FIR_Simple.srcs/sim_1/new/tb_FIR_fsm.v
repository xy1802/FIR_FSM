`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/09 10:37:06
// Design Name: 
// Module Name: tb_FIR_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_FIR_fsm(

    );
    reg clk;
    reg rst;
    reg data_val;
    reg [8*24-1:0] signal_in;
//    reg axi_tvalid;
    wire[8*39-1:0]signal_out;
    wire FIR_valid;
    
    // clk and rst 
    // 200MHZ  ±÷”
    initial begin
        clk=0;
        forever #10 clk=~clk;    
    end
    
    initial begin
        rst = 1;
        #15 rst=0;
    end
    
    initial begin
        signal_in = {24'd0,24'd1,24'd2,24'd3,24'd4,24'd5,24'd6,24'd7};
        #4000
        signal_in = {24'd1,24'd2,24'd3,24'd4,24'd5,24'd6,24'd7,24'd8};
        #4000
        signal_in = {24'd2,24'd3,24'd4,24'd5,24'd6,24'd7,24'd8,24'd9};
        #4000
        signal_in = {24'd3,24'd4,24'd5,24'd6,24'd7,24'd8,24'd9,24'd10};
        #4000
        signal_in = {24'd4,24'd5,24'd6,24'd7,24'd8,24'd9,24'd10,24'd11};
    end

    initial begin
        forever begin
            data_val = 0;
            #3990 data_val=1;
            #10 data_val=0;
        end 
    end    
    
    FIR_fsm fir_test(
    .clk(clk),
	.rst(rst),
	.data_val(data_val),
	.signal_in(signal_in),
	.signal_out(signal_out),
	.FIR_valid(FIR_valid)  
    );
    
endmodule
