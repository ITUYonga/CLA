`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2026 16:17:05
// Design Name: 
// Module Name: tamsayi_islem
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