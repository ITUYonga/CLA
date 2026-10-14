`timescale 1ns / 1ps

// MOD_CLA_MVECT_REGS : 8 görevin başlangıç program sayacı (PC) adreslerini tutan MVECT1 - MVECT8 yazmaç öbeği
//
//   Amaç:     Görev 1'den Görev 8'e kadar her görevin L3 program
//             belleğindeki 16-bitlik başlangıç adresini (MVECT1..MVECT8)
//             barındırır. CPU'ya okuma/yazma erişimi sunarken, görev
//             başlatılırken active_task_id ile seçilen görevin başlangıç
//             adresini kombinasyonel olarak Fetch1 aşamasına (target_pc_out)
//             verir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           cpu_wr_en:      CPU MVECT yazma etkinleştirme sinyali
//           cpu_wr_task_id: CPU'nun eriştiği 3-bit görev indeksi (0:MVECT1 ..
//                           7:MVECT8)
//           cpu_wr_data:    MVECT yazmacına yazılacak 16-bit başlangıç PC
//                           adresi
//           active_task_id: Görev denetçisinin başlattığı/çalıştırdığı 3-bit
//                           görev indeksi
//   Outputlar:
//           cpu_rd_data:    CPU tarafından seçilen MVECT yazmacının 16-bit
//                           değeri
//           target_pc_out:  Aktif görevin Fetch1 aşamasına gönderilen 16-bit
//                           başlangıç adresi
//
//   Notlar:
//           CLA_Top içinde MPC ve getir_pc 12-bit genişliğinde olduğu için
//           target_pc_out[11:0] bitleri kullanılır.

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
