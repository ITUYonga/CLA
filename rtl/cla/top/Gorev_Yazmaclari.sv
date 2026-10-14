`timescale 1ns / 1ps

// cla_ctrl_regs'in CPU adres duzeniyle ayni; gorevi kendisi baslatmaz, gorev denetcisinin
// olaylarini (gorev_basla, gorev_no, gorev_bitti) uygular. MCTL ile soft/hard reset eklendi.
//   CPU adresi : 0 MIFR (R) , 1 MIOVF (R) , 2 MICLR (W) , 3 MICLROVF (W) , 4 MIFRC (W) ,
//                5 MIER (RW) , 6 MIRUN (R) , 7 MCTL (W: bit0 HARDRESET, bit1 SOFTRESET, bit2 IACKE)

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
