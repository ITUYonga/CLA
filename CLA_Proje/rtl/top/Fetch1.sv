`timescale 1ns / 1ps

module Fetch1(
                input logic clk ,
                input logic rst_n ,

                //////////////gorev denetcisi ve MVECT'ten
                input logic getir_izin ,
                input logic gorev_basla ,
                input logic [11:0]mvect_pc ,

                //////////////D2'den (dal birimi)
                input logic dal_alindi ,
                input logic [11:0]dal_hedef ,

                //////////////boru hatti denetiminden
                input logic en ,                        // F1 ve F1/F2 ilerler
                input logic balon ,                     // F1/F2 <- balon (MSTOP, reset)

                //////////////L3 program bellegine
                output logic [10:0]l3_adr ,             // 32 bitlik satir (getir_pc[11:1])

                //////////////F1/F2 yazmaci
                output logic f1f2_gecerli ,
                output logic [11:0]f1f2_pc

                );



/////////////////////////SONRAKI GETIRME ADRESI

logic [11:0]getir_pc;
logic [11:0]sonraki_pc;

always_comb begin

if(gorev_basla) sonraki_pc = mvect_pc;                  // gorev basi
else if(dal_alindi) sonraki_pc = dal_hedef;             // dal karari D2'de, 3 gecikme yuvasi calisir
else if(getir_izin) sonraki_pc = getir_pc + 12'd2;      // siradaki buyruk (buyruk = 2 kelime)
else sonraki_pc = getir_pc;

end



/////////////////////////GETIRME SAYACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        getir_pc <= 12'h000;
    end
    else if(gorev_basla) begin
        getir_pc <= mvect_pc;                           // beklemeden bagimsiz yuklenir
    end
    else if(en) begin
        getir_pc <= sonraki_pc;
    end

end

assign l3_adr = getir_pc[11:1];



/////////////////////////F1/F2 YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        f1f2_gecerli <= 1'b0;
        f1f2_pc <= 12'h000;
    end
    else if(balon) begin
        f1f2_gecerli <= 1'b0;
    end
    else if(en) begin
        f1f2_gecerli <= getir_izin;                     // gorev yokken getirme yok
        f1f2_pc <= getir_pc;
    end

end



endmodule
