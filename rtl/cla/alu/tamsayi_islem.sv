`timescale 1ns / 1ps

// MOD_TAMSAYI_ISLEM : 32-bit tamsayı aritmetik, bit düzeyinde mantıksal işlem ve kaydırma (shift) birimi
//
//   Amaç:     MADD32, MSUB32, MAND32, MOR32, MXOR32, MLSL32, MLSR32 ve
//             MASR32 buyrukları için 32-bit toplama, çıkarma, AND, OR, XOR,
//             sola mantıksal kaydırma, sağa mantıksal kaydırma ve sağa
//             aritmetik kaydırma işlemlerini kombinasyonel olarak yürütür ve
//             MSTF için ZF/NF bayraklarını üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           in_1:           1. 32-bit tamsayı operandı (MRa veya MRb)
//           in_2:           2. 32-bit tamsayı operandı (MRc veya kaydırma
//                           miktarı #SHIFT)
//           alu_cntrl_1:    3-bitlik tamsayı işlem kodu (tamsayi_op_e: SUM,
//                           SUB, AND, OR, XOR, LSHIFT_L, LSHIFT_R, ASHIFT_R)
//   Outputlar:
//           mr_out3:        32-bit tamsayı işlem sonucu
//           mstf_out3:      5-bit bayrak çıkışı ({1'b0, zf, nf, 2'b00}; bit 3:
//                           ZF, bit 2: NF)
//
//   Notlar:
//           Sonuç 32'h0000_0000 ise ZF = 1, sonucun işaret biti
//           (mr_out3[31]) 1 ise NF = 1 üretilir; TF, LUF ve LVF bitleri bu
//           modülde her zaman 0 sürülür.

typedef enum logic[2:0]{
    
    SUM = 3'b000,
    SUB = 3'b001,
    AND = 3'b010,
    OR = 3'b011,
    XOR = 3'b100,
    LSHIFT_L = 3'b101,
    LSHIFT_R = 3'b110,
    ASHIFT_R = 3'b111
    
}tamsayi_op_e;   // eski adi op_type: kestirme/karsilastirma port adiyla cakisiyordu




module tamsayi_islem(

        input [31:0]in_1,
        input [31:0]in_2,
              
        input logic[2:0]alu_cntrl_1,
        
        
        output logic [31:0]mr_out3,
        output logic [4:0]mstf_out3 // 4: TF 3: ZF 2:NF 1: LUF 0:LVF

    );
    
    logic nf;
    logic zf;
    
    
    always_comb begin
    
    
    
    
        case(alu_cntrl_1)
            
            SUM: begin
                mr_out3 = in_1 + in_2;
                   end   
                   
            SUB: begin
                mr_out3= in_1 - in_2;
                end   
            
            AND:begin
                mr_out3 = in_1 & in_2;
                end
                
            OR:begin
                mr_out3 = in_1 | in_2;
             end   
                
             XOR:begin
                mr_out3 = in_1 ^ in_2;
             end   
             
             LSHIFT_L:begin
                mr_out3 = in_1 << in_2;
                end
             
             LSHIFT_R:begin
                mr_out3 = in_1 >> in_2;
                end 
                
             ASHIFT_R:begin
                
                mr_out3 = $signed(in_1)>>>in_2;
             end
                
        endcase
        
        
        nf = (mr_out3[31] == 1'b1) ?  1'b1 :  1'b0; //MSTF[2]
        
        zf = (mr_out3 == 0 ) ? 1'b1 : 1'b0 ; //MSTF[3]
        
        mstf_out3 = {1'b0 , zf , nf , 2'b0}; 
    
   
    
    
    end
    
    
    
    
    
    
    
endmodule
