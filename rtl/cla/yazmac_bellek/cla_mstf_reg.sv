`timescale 1ns / 1ps

// MOD_CLA_MSTF_REG : CLA 32-bit durum yazmacı (MSTF: RPC, MEALLOW, RND32, TF, ZF, NF, LUF, LVF) modülü
//
//   Amaç:     Mimari 32-bit MSTF yazmacının bayrak ve kontrol alanlarını
//             (bit [23:12] RPC, bit 11 MEALLOW, bit 9 RND32, bit 6 TF, bit 3
//             ZF, bit 2 NF, bit 1 LUF, bit 0 LVF) tutar. Bellekten doğrudan
//             MSTF yükleme (wr_mstf_en), MCCNDD dönüş adresi kaydetme
//             (save_rpc_en), MEALLOW/MEDIS, test bayrağı (update_tf) ve ALU
//             sonuç bayraklarını (alu_update_flags) günceller.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           wr_mstf_en:     MMOV32 MSTF, mem32 buyruğu için doğrudan 32-bit
//                           MSTF yazma izni
//           wr_mstf_data:   Bellekten MSTF'ye yüklenecek 32-bit veri
//           alu_update_flags: ALU sonucuna göre ZF, NF, LVF ve LUF
//                             bayraklarını güncelleme izni
//           save_rpc_en:    MCCNDD buyruğunda current_mpc değerini RPC alanına
//                           kaydetme izni
//           current_mpc:    Kaydedilecek 12-bitlik dönüş program sayacı
//           set_meallow:    MEALLOW buyruğu ile MEALLOW bitini 1 yapma sinyali
//           clr_meallow:    MEDIS buyruğu ile MEALLOW bitini 0 yapma sinyali
//           update_tf:      MTESTTF buyruğu ile TF bayrağını güncelleme izni
//           tf_value_in:    TF bayrağına yazılacak yeni koşul sonucu
//           alu_result:     ZF ve NF hesabı için 32-bit ALU sonucu
//           alu_overflow:   LVF bitini 1'e kilitleyen (sticky) taşma sinyali
//           alu_underflow:  LUF bitini 1'e kilitleyen (sticky) alt-taşma
//                           sinyali
//   Outputlar:
//           flag_zf:        Sıfır bayrağı (Zero Flag, bit 3)
//           flag_nf:        Negatif bayrağı (Negative Flag, bit 2)
//           flag_luf:       Yapışkan alt-taşma bayrağı (Latched Underflow
//                           Flag, bit 1)
//           flag_lvf:       Yapışkan taşma bayrağı (Latched Overflow Flag, bit
//                           0)
//           flag_tf:        Test bayrağı (Test Flag, bit 6)
//           meallow_out:    Korumalı yazmaç erişim izni biti (MEALLOW, bit 11)
//           rnd32_mode:     Yuvarlama modu biti (RND32, bit 9)
//           rpc_out:        12-bit dönüş program sayacı (RPC, bit [23:12])
//           mstf_reg_out:   Birleştirilmiş 32-bitlik tam MSTF yazmacı çıkışı
//
//   Notlar:
//           LVF ve LUF bayrakları yapışkandır (sticky); alu_overflow veya
//           alu_underflow 1 olduğunda kurulur ve yalnızca wr_mstf_en veya
//           MSETFLG ile temizlenebilir.

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
