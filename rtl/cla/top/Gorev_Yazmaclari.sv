`timescale 1ns / 1ps

// MOD_GOREV_YAZMACLARI : CLA_Top içinde kullanılan MIFR, MIOVF, MIER, MIRUN ve MCTL görev kontrol yazmaçları birimi
//
//   Amaç:     Görev kesme bayrakları (MIFR), taşma bayrakları (MIOVF), görev
//             izin maskesi (MIER), çalışan görev göstergesi (MIRUN) ve
//             kontrol/reset yazmacını (MCTL) barındırır. CPU yazmalarını,
//             donanım tetiklerini (hw_task_trig) ve görev denetçisinden
//             gelen gorev_basla / gorev_bitti olaylarını öncelik sırasıyla
//             uygular; MCTL üzerinden soft/hard reset darbelerini üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           cpu_wr_en:      CPU yazma etkinleştirme sinyali
//           cpu_reg_addr:   3-bit CPU yazmaç adresi (0:MIFR, 1:MIOVF, 2:MICLR,
//                           3:MICLROVF, 4:MIFRC, 5:MIER, 6:MIRUN, 7:MCTL)
//           cpu_wr_data:    CPU'dan yazılacak 16-bit veri
//           hw_task_trig:   Görev 1-8 için dış donanım tetik girişleri
//           gorev_basla:    Görev denetçisinin yeni bir görevi başlattığını
//                           belirten sinyal
//           gorev_no:       Başlatılan görevin 3-bitlik indeksi (0..7)
//           gorev_bitti:    Görev denetçisinin aktif görevin bittiğini
//                           belirten sinyali
//   Outputlar:
//           cpu_rd_data:    CPU tarafından seçilen yazmaçtan okunan 16-bit
//                           veri
//           bekleyen:       Görev denetçisine gönderilen bekleyen ve izinli
//                           görevler vektörü (MIFR & MIER)
//           softreset:      MCTL[1] bitine 1 yazıldığında üretilen 1 çevrimlik
//                           soft reset darbesi
//           hardreset:      MCTL[0] bitine 1 yazıldığında üretilen 1 çevrimlik
//                           hard reset darbesi
//           mifr_out:       16-bit genişletilmiş MIFR izleme çıkışı
//           miovf_out:      16-bit genişletilmiş MIOVF izleme çıkışı
//           mier_out:       16-bit genişletilmiş MIER izleme çıkışı
//           mirun_out:      16-bit genişletilmiş MIRUN izleme çıkışı
//
//   Notlar:
//           Aynı saat çevriminde birden fazla olay gelirse uygulama
//           sırası: CPU yazması -> çevre tetiği -> gorev_basla ->
//           gorev_bitti -> reset (sonraki kazanır).
//
//           Bir görevin MIFR biti zaten 1 iken aynı göreve yeni bir
//           hw_task_trig gelirse ilgili MIOVF taşma biti 1'e kurulur.

module Gorev_Yazmaclari(
                input logic clk ,
                input logic rst_n ,

                //////////////CPU portu
                input logic cpu_wr_en ,
                input logic [2:0]cpu_reg_addr ,
                input logic [15:0]cpu_wr_data ,
                output logic [15:0]cpu_rd_data ,

                //////////////cevre birimi tetikleri (gorev 1-8)
                input logic [7:0]hw_task_trig ,

                //////////////gorev denetcisinden
                input logic gorev_basla ,
                input logic [2:0]gorev_no ,
                input logic gorev_bitti ,

                //////////////gorev denetcisine
                output logic [7:0]bekleyen ,             // MIFR & MIER
                output logic softreset ,                 // 1 cevrim
                output logic hardreset ,                 // 1 cevrim

                //////////////izleme
                output logic [15:0]mifr_out ,
                output logic [15:0]miovf_out ,
                output logic [15:0]mier_out ,
                output logic [15:0]mirun_out

                );



logic [7:0]mifr_q;
logic [7:0]miovf_q;
logic [7:0]mier_q;
logic [7:0]mirun_q;
logic iacke_q;

assign bekleyen = mifr_q & mier_q;



/////////////////////////MCTL : RESET DARBELERI

always_comb begin

hardreset = cpu_wr_en & (cpu_reg_addr == 3'd7) & cpu_wr_data[0];
softreset = cpu_wr_en & (cpu_reg_addr == 3'd7) & cpu_wr_data[1];

end



/////////////////////////YAZMACLAR

// ayni cevrimde sira : CPU yazmasi , cevre tetigi , gorev basla , gorev bitti , reset (sonraki kazanir)

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        mifr_q <= 8'h00;
        miovf_q <= 8'h00;
        mier_q <= 8'h00;
        mirun_q <= 8'h00;
        iacke_q <= 1'b0;
    end
    else begin

        if(cpu_wr_en) begin
            case(cpu_reg_addr)
                3'd2 : mifr_q <= mifr_q & ~cpu_wr_data[7:0];          // MICLR : 1 yazilan bayrak temizlenir
                3'd3 : miovf_q <= miovf_q & ~cpu_wr_data[7:0];        // MICLROVF
                3'd4 : mifr_q <= mifr_q | cpu_wr_data[7:0];           // MIFRC : gorevi yazilimla tetikle
                3'd5 : mier_q <= cpu_wr_data[7:0];                    // MIER
                3'd7 : iacke_q <= cpu_wr_data[2];                     // MCTL IACKE
                default : ;
            endcase
        end

        for(int i = 0 ; i < 8 ; i++) begin
            if(hw_task_trig[i]) begin
                if(mifr_q[i]) miovf_q[i] <= 1'b1;                     // bayrak zaten kuruluysa tasma
                else mifr_q[i] <= 1'b1;
            end
        end

        if(gorev_basla) begin
            mifr_q[gorev_no] <= 1'b0;                                 // gorev servise alindi
            mirun_q[gorev_no] <= 1'b1;
        end

        if(gorev_bitti) begin
            mirun_q <= 8'h00;
        end

        if(softreset) begin
            mier_q <= 8'h00;
            mirun_q <= 8'h00;
        end

        if(hardreset) begin
            mifr_q <= 8'h00;
            miovf_q <= 8'h00;
            mier_q <= 8'h00;
            mirun_q <= 8'h00;
            iacke_q <= 1'b0;
        end

    end

end



/////////////////////////CPU OKUMA

always_comb begin

case(cpu_reg_addr)
    3'd0 : cpu_rd_data = {8'h00 , mifr_q};
    3'd1 : cpu_rd_data = {8'h00 , miovf_q};
    3'd5 : cpu_rd_data = {8'h00 , mier_q};
    3'd6 : cpu_rd_data = {8'h00 , mirun_q};
    3'd7 : cpu_rd_data = {13'h0000 , iacke_q , 2'b00};
    default : cpu_rd_data = 16'h0000;                                 // MICLR, MICLROVF, MIFRC 0 okunur
endcase

end

assign mifr_out = {8'h00 , mifr_q};
assign miovf_out = {8'h00 , miovf_q};
assign mier_out = {8'h00 , mier_q};
assign mirun_out = {8'h00 , mirun_q};



endmodule
