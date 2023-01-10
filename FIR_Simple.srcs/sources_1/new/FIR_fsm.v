`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/06 14:47:19
// Design Name: 
// Module Name: FIR_fsm
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


module FIR_fsm(
    input clk,
	input rst,
	input data_val,
	input[8*24-1:0] signal_in,
//	input axi_tvalid,
	output reg [8*39-1:0] signal_out,
	output reg FIR_valid
    );
    
    // 输入输出缓存
    reg[24-1:0]signal_buffer[7:0];
    reg[39-1:0]signal_out_buffer[7:0];
//    reg [39-1:0]signal_reg;
    // fir 输出连线
    wire [39-1:0]signal_wire;
    // 数据计数，顺序写入
    reg [3:0]cnt;
    // FIR输入信号
    reg[24-1:0] FIR_in;
    // fir 接收信号
    wire t_ready;
//    reg data_ready_flag;
//    reg FIR_flag;
    // 通道数指示
    reg[2:0] user_input;
    wire[2:0] user_output;
    

    // 检测data_val 脉冲 
     wire data_val_flag;
     wire t_valid;
     reg data_val1;
     reg data_val2;
     assign data_val_flag = (data_val1^data_val2)&&data_val1;
     
     // 检测tdata_ready 脉冲 下降沿
     wire t_ready_flag;
     reg t_ready1;
     reg t_ready2;
     reg t_ready_lock;
     assign t_ready_flag = (t_ready1^t_ready2)&&t_ready2;
     
     // fsm 状态
     parameter IDLE = 2'b00;
     parameter READY = 2'b01;
     parameter FIR = 2'b10;
     parameter OUT = 2'b11;
     reg[1:0] state;
     reg [3:0]i=0;
     reg [3:0]j=0;
     reg tlast;
//     reg ready_flag;
     
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            state<=IDLE;
            while(i<=8)begin
                signal_buffer[i]<=0;
                signal_out_buffer[i]<=0;
                i=i+1;
            end
            data_val1<=0;
            data_val2<=0;
            t_ready1<=0;
            t_ready2<=0;
            cnt<=0;
            FIR_in<=0;
            user_input<=0;
            t_ready_lock<=0;
            tlast<=0;
        end
        else begin
            case(state)
                IDLE:begin // 数据初始化
                    while(j<=8)begin
                        signal_buffer[j]<=0;
                        signal_out_buffer[j]<=0;
                        j=j+1;
                    end
                    cnt<=0;
                    data_val2<=data_val1;
                    data_val1<=data_val;
                    tlast<=0;
                    FIR_valid<=0;
                    if(data_val_flag)
                        state<=READY;
                    else
                        state<=IDLE;               
                end
                
                READY:begin // 输入数据缓存计数
                    signal_buffer[0]<=signal_in[8*24-1:7*24];
                    signal_buffer[1]<=signal_in[7*24-1:6*24];
                    signal_buffer[2]<=signal_in[6*24-1:5*24];
                    signal_buffer[3]<=signal_in[5*24-1:4*24];
                    signal_buffer[4]<=signal_in[4*24-1:3*24];
                    signal_buffer[5]<=signal_in[3*24-1:2*24];
                    signal_buffer[6]<=signal_in[2*24-1:1*24];
                    signal_buffer[7]<=signal_in[1*24-1:0*24];
                    state<=FIR;
                end
                
                
                // todo: 这一阶段的持续时间有问题，需要调整
                // todo2: 此处根据师兄所说无需考虑同一次ready下多个输入，此处需要更改输出赋值部分
                FIR:begin // 向FIR模块中输入数据，延时一个周期将数据读出
                    t_ready1<=t_ready;
                    t_ready2<=t_ready1;
                    if(!t_ready_lock)begin
                        if(t_ready)begin
                            if(cnt<8)begin
                                user_input<=cnt;
                                FIR_in<=signal_buffer[cnt][23:0];
                                t_ready_lock<=1; // 阻塞输入
                                cnt<=cnt+1;
                            end
                            // 输出时钟和输入时钟不对应
                            if(t_valid)
                                signal_out_buffer[user_output]<=signal_wire; 
                            if(cnt==8)begin
                                tlast<=1;
                                state<=OUT;
                            end
                            else
                                state<=FIR;
                        end
                    end
                    if(t_ready_lock&&t_ready_flag)begin
                        t_ready_lock<=0; // 解锁
                    end
                end
                
                OUT:begin
                    FIR_valid<=1; // 指示输出成功
                    signal_out[8*39-1:7*39]<=signal_out_buffer[0];
                    signal_out[7*39-1:6*39]<=signal_out_buffer[1];
                    signal_out[6*39-1:5*39]<=signal_out_buffer[2];
                    signal_out[5*39-1:4*39]<=signal_out_buffer[3];
                    signal_out[4*39-1:3*39]<=signal_out_buffer[4];
                    signal_out[3*39-1:2*39]<=signal_out_buffer[5];
                    signal_out[2*39-1:1*39]<=signal_out_buffer[6];
                    signal_out[1*39-1:0*39]<=signal_out_buffer[7];
                    state<=IDLE;
                end
            default:state<=IDLE;   
            endcase
        end
    end
    
    fir250_45 FIR_0(
 	.s_axis_data_tdata(FIR_in),
 	.s_axis_data_tready(t_ready),
 	.s_axis_data_tvalid(1'b1),
 	.s_axis_data_tuser(user_input),
 	.s_axis_data_tlast(tlast),
 	.aclk(clk),
 	.m_axis_data_tdata(signal_wire),
 	.m_axis_data_tvalid(t_valid),
 	.m_axis_data_tready(1'b1),
 	.m_axis_data_tuser(user_output)
 	);
     
     
endmodule
