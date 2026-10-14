`timescale 1ns / 1ps



module cla_mstf_reg(
    
    input logic clk,
    input logic rst_n,
    
    input logic wr_mstf_en,
    input logic [31:0] wr_mstf_data,
    
    input logic alu_update_flags,
    input logic save_rpc_en,
    input logic [11:0] current_mpc,
    
    input logic set_meallow,
    input logic clr_meallow,
    input logic update_tf,
    input logic tf_value_in,
    
    input logic [31:0] alu_result,
    input logic alu_overflow,
    input logic alu_underflow,
    
    output logic flag_zf,
    output logic flag_nf,
    output logic flag_luf,
    output logic flag_lvf,
    output logic flag_tf,
    output logic meallow_out,
    output logic rnd32_mode,
    output logic [11:0] rpc_out,
    
    output logic [31:0] mstf_reg_out
    );
    
    logic [11:0]rpc_q;
    logic meallow_q;
    logic rnd32_q;  
    logic tf_q;
    logic zf_q;
    logic nf_q;
    logic luf_q;
    logic lvf_q;
    
    always_ff@(posedge clk or negedge rst_n)begin
        if (!rst_n) begin
        rpc_q <= 12'h000;
        meallow_q <= 0;
        rnd32_q <= 0; 
        tf_q <= 0;
        zf_q <= 0;
        nf_q <= 0;
        luf_q <= 0;
        lvf_q <= 0;
        end else begin
            if(wr_mstf_en)begin
            
            rpc_q <= wr_mstf_data [23:12];
            meallow_q <= wr_mstf_data [11];
            rnd32_q <= wr_mstf_data [9];
            tf_q <= wr_mstf_data [6];
            zf_q <= wr_mstf_data [3];
            nf_q <= wr_mstf_data [2];
            luf_q <= wr_mstf_data [1];
            lvf_q <= wr_mstf_data [0];
            
            end else begin
                if (save_rpc_en) begin
                rpc_q <= current_mpc;
                end
                
                if (set_meallow) begin
                meallow_q <= 1;
                end else if (clr_meallow) begin 
                meallow_q <= 0;
                end
                
                if (update_tf) begin
                   tf_q <= tf_value_in;
                end
                
                if (alu_update_flags) begin
                zf_q <= (alu_result[30:0] == 31'h0);
                nf_q <= (alu_result[31]);
                    
                    if (alu_overflow) lvf_q <= 1;
                    if (alu_underflow) luf_q <= 1;
                
                end
            end
        end
    end
    
    assign flag_zf     = zf_q;
    assign flag_nf     = nf_q;
    assign flag_luf    = luf_q;
    assign flag_lvf    = lvf_q;
    assign flag_tf     = tf_q;
    assign meallow_out = meallow_q;
    assign rnd32_mode  = rnd32_q;
    assign rpc_out     = rpc_q;
    assign mstf_reg_out = {
    
    8'h00,
    rpc_q,
    meallow_q,
    1'b0,
    rnd32_q,
    2'b00,
    tf_q,
    2'b00,
    zf_q,
    nf_q,
    luf_q,
    lvf_q
    };
    
endmodule
