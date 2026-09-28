`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2026 19:56:01
// Design Name: 
// Module Name: kestirme
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


module kestirme #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 10,
    parameter int DEPTH      = 1024,
    parameter string HEX_FILE = "estimate_lut.hex"
)(
    
    input logic sign ,
    input logic [23:0]mantissa,
    input logic [7:0]exp ,
    input logic op_type , // 0-> inverse 1-> sqrt inverse
    

    output logic [31:0]result,
    output logic lvf,
    output logic luf 
);

    // Bellek dizisi tanýmý
    
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [7:0]estimate ;
    logic [9:0] address;
    // Simülasyon ve sentez baþlangýcýnda hex dosyasýný yükler
    initial begin
        $readmemh(HEX_FILE, mem);
    end


   
    
    always_comb begin
        lvf = 0;
        luf = 0;
        if(op_type == 1'b0)begin
            
            address = {2'b10 , mantissa[22:15]};
            estimate = mem[address];
            result = {sign , 8'(253-exp) , estimate, 15'b0};
       if(exp == 8'b0)begin
               // En temiz ve risksiz yazým:
                result = {sign, 8'hFF, 23'd0}; // 1 + 8 + 23 = 32 bit (+/- Sonsuz);
                lvf = 1 ; 
                end
        if(exp == 8'hFF)
                result = 32'b0 ;
        
        if(exp == 253 || exp == 254)begin
            result = 32'b0;
            luf = 1;
        end
            
        
            end
            
       
        else     begin
        
            address = {1'b0 , exp[0] , mantissa[22:15]} ;
            estimate = mem[address];
            result = {sign , 8'((380-exp) >> 1), estimate , 15'b0};
        
             if(exp == 8'b0)begin
               // En temiz ve risksiz yazým:
                result = {sign, 8'hFF, 23'd0}; // 1 + 8 + 23 = 32 bit (+/- Sonsuz) 
                lvf = 1 ; 
                end
                
              if(exp == 8'hFF)
                result = 32'b0 ;
           
            
             
        end

                
    
    end
    
    

endmodule
