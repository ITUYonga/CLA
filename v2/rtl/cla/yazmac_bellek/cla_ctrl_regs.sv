`timescale 1ns / 1ps

module cla_ctrl_regs(
    
    input logic clk,
    input logic rst_n,
    
    input logic cpu_wr_en,
    input logic [2:0] cpu_reg_addr, // 0:MIFR, 1:MIOVF, 2:MICLR, 3:MICLROVF, 4:MIFRC, 5:MIER, 6:MIRUN
    input logic [15:0] cpu_wr_data,
    output logic [15:0] cpu_rd_data,
    
    // Peripheral Donanımsal Tetikleri
    input logic hw_task_trig [7:0], // Task 1-8 donanım tetikleri
    
    // CLA Çekirdeği Arayüzü
    input  logic        task_done,     // MSTOP komutu işlendiğinde 1 olur
    output logic        task_start_req,// FSM'e: "Yeni task başlat"
    output logic [2:0]  selected_task, // MVECT'e: "Başlayacak Task ID" (0..7)
    
    // Dışarıdan izleme çıkışları
    output logic [15:0] mifr_out,
    output logic [15:0] miovf_out,
    output logic [15:0] mier_out,
    output logic [15:0] mirun_out
    
    );
    // Fiziksel Durum Tutan Register'lar (Alt 8 bit kullanılır)
    logic [7:0] mier_q;
    logic [7:0] mifr_q;
    logic [7:0] miovf_q;
    logic [7:0] mirun_q;
    
    // Bekleyen ve İzin Verilen Görevler
    logic [7:0] pending_tasks;
    assign pending_tasks = mifr_q & mier_q;
    
    logic cla_idle;
    assign cla_idle = (mirun_q == 8'h00); // CLA boşta mı?
    assign task_start_req = (pending_tasks != 8'h00) && cla_idle;
    
    always_comb begin // priority encoder
    if (pending_tasks[0]) selected_task = 3'd0;
    else if(pending_tasks[1]) selected_task = 3'd1;
    else if(pending_tasks[2]) selected_task = 3'd2;
    else if(pending_tasks[3]) selected_task = 3'd3;
    else if(pending_tasks[4]) selected_task = 3'd4;
    else if(pending_tasks[5]) selected_task = 3'd5;
    else if(pending_tasks[6]) selected_task = 3'd6;
    else selected_task = 3'd7;
    end
    
    
    always_ff@(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin 
    
    mifr_q <= 8'h00;
    mier_q <= 8'h00;
    mirun_q <= 8'h00;
    miovf_q <= 8'h00;
    end else begin
        if(cpu_wr_en) begin
        case(cpu_reg_addr)
        3'd2: mifr_q  <= mifr_q & ~cpu_wr_data[7:0];  // MICLR: 1 yazılan biti temizle
        3'd3: miovf_q <= miovf_q & ~cpu_wr_data[7:0]; // MICLROVF: 1 yazılan biti temizle            
        3'd4: mifr_q  <= mifr_q | cpu_wr_data[7:0];   // MIFRC: 1 yazılan görevi zorla tetikle
        3'd5: mier_q  <= cpu_wr_data[7:0];            // MIER: İzin maskesini güncelle
        default: ;
        endcase
        end
    end
    for (int i=0; i<8; i++) begin
    if (hw_task_trig[i]) begin
        if(mifr_q[i]) begin // Bayrak zaten 1 iken tekrar tetik gelirse overflow olur
        miovf_q[i] <= 1;
        end else begin
        mifr_q[i] <= 1;
        end
    end
    end
    
    
    if(task_start_req) begin
    
    mifr_q[selected_task] <= 0; // Görev servise alındığı için bayrak iner
    mirun_q[selected_task] <= 1; // Çalışıyor olarak kilitlenir
    end
    
    if(task_done) begin
    mirun_q <= 8'h00;
    end
    
    end
    //CPU Okuma MUX'ı
    always_comb begin
        case(cpu_reg_addr)
        3'd0: cpu_rd_data = {8'h00 , mifr_q};
        3'd1: cpu_rd_data = {8'h00 , miovf_q};
        3'd5: cpu_rd_data = {8'h00 , mier_q};
        3'd6: cpu_rd_data = {8'h00 , mirun_q};
        default: cpu_rd_data = 16'h0000;
        endcase
    end
    // Çıkışlar
    assign mifr_out = {8'h00 , mifr_q};
    assign miovf_out = {8'h00 , miovf_q};
    assign mier_out = {8'h00 , mier_q};
    assign mirun_out = {8'h00 , mirun_q};
endmodule
