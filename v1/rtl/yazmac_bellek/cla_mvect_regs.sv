`timescale 1ns / 1ps



module cla_mvect_regs(

    input logic clk,
    input logic rst_n,
    
    input logic cpu_wr_en,
    input logic [2:0] cpu_wr_task_id,
    input logic [15:0] cpu_wr_data,
    output logic [15:0] cpu_rd_data,
    
    input logic [2:0] active_task_id,
    output logic [15:0] target_pc_out
    
    );
    
    logic [15:0] mvect_reg [0:7];
    
    always_ff@(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin
        
        for(int i=0; i<8; i++) begin
        mvect_reg[i] <= 16'h0000;
        end
    end
    else if (cpu_wr_en) begin
    
    mvect_reg[cpu_wr_task_id] <= cpu_wr_data;
    
    end
    
    end 
    
    assign cpu_rd_data = mvect_reg[cpu_wr_task_id];
    assign target_pc_out = mvect_reg[active_task_id];
    
endmodule
