`timescale 1ns / 1ps

// MOD_DONUSUM : IEEE-754 FP32 ile 16/32-bit işaretli/işaretsiz tamsayı dönüşümlerini ve kesir kısmı (MFRACF32) hesabını yapan birim
//
//   Amaç:     MF32TOI16, MF32TOI16R, MF32TOI32, MF32TOUI16, MF32TOUI16R,
//             MF32TOUI32, MI16TOF32, MI32TOF32, MUI16TOF32, MUI32TOF32 ve
//             MFRACF32 buyruklarını kombinasyonel olarak yürütür. Float->int
//             dönüşümlerinde sıfıra kesme veya en yakın çifte yuvarlama ('R'
//             sonekli komutlar), int->float dönüşümlerinde ise RND32 bitine
//             göre kesme veya yuvarlama uygular.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           op_type:        4-bit dönüşüm işlemi kodu (fpu_op_e enum tipi,
//                           0..10)
//           rnd:            MSTF.RND32 yuvarlama modu biti (yalnızca 32-bit
//                           int -> float dönüşümlerinde kullanılır)
//           sign:           clasify modülünden gelen 1-bit işaret alanı
//           exp:            clasify modülünden gelen 8-bit üs (exponent) alanı
//           mantissa:       clasify modülünden gelen gizli 1 biti eklenmiş
//                           24-bit mantissa alanı
//   Outputlar:
//           result:         Dönüştürülmüş 32-bitlik tamsayı veya IEEE-754 FP32
//                           sonucu
//
//   Notlar:
//           Float->int dönüşümlerinde +Inf maksimum pozitif tamsayıya
//           (0x7FFF / 0xFFFF / 0x7FFFFFFF / 0xFFFFFFFF), -Inf ise minimum
//           tamsayıya (işaretlide 0xFFFF8000 / 0x80000000, işaretsizde 0)
//           doyar; NaN girişleri 0 üretir.
//
//           MFRACF32 buyruğu |x| < 1 için sayının kendisini (denormaller
//           +0'a bastırılarak), |x| >= 1 için ise işareti korunmuş kesir
//           kısmını döndürür; tam sayılarda (kesir kısmı 0 ise) +0.0
//           üretir.

typedef enum logic [3:0] {
    OP_MF32TOI16   = 4'd0,  // Convert 32-Bit Floating-Point Value to 16-Bit Integer
    OP_MF32TOI16R  = 4'd1,  // Convert 32-Bit Floating-Point Value to 16-Bit Integer and Round
    OP_MF32TOI32   = 4'd2,  // Convert 32-Bit Floating-Point Value to 32-Bit Integer
    OP_MF32TOUI16  = 4'd3,  // Convert 32-Bit Floating-Point Value to 16-bit Unsigned Integer
    OP_MF32TOUI16R = 4'd4,  // Convert 32-Bit Floating-Point Value to 16-bit Unsigned Integer and Round
    OP_MF32TOUI32  = 4'd5,  // Convert 32-Bit Floating-Point Value to 32-Bit Unsigned Integer
    OP_MFRACF32    = 4'd6,  // Fractional Portion of a 32-Bit Floating-Point Value
    OP_MI16TOF32   = 4'd7,  // Convert 16-Bit Integer to 32-Bit Floating-Point Value
    OP_MI32TOF32   = 4'd8,  // Convert 32-Bit Integer to 32-Bit Floating-Point Value
    OP_MUI16TOF32  = 4'd9,  // Convert Unsigned 16-Bit Integer to 32-Bit Floating-Point Value
    OP_MUI32TOF32  = 4'd10  // Convert Unsigned 32-Bit Integer to 32-Bit Floating-Point Value
} fpu_op_e;



module  donusum(

    
    input logic [3:0]op_type,
    input logic rnd ,        // RND32: yalniz int -> float donusumlerinde kullanilacak (R'li float -> int buyruklari her zaman en yakin cifte yuvarlar)
    input logic sign,
    input logic [7:0]exp,
    input logic [23:0]mantissa,

    output logic [31:0] result 


);

    logic [31:0] int_value ;
    logic is_nan , is_inf ;

    logic [31:0] ham ;        // MRb'nin ham 32 biti (int -> float donusumlerinde tamsayi olarak okunur)

    // MFRACF32 ara sinyalleri
    logic [23:0]fraction ;          // virgulun sagi: fraction[23] = 2^-1
    logic [47:0]kaydirilmis ;       // {24'b0 , mantissa} << (exp-126)
    logic [7:0] exp_float ;
    int lz ;
    logic bulundu ;

    // Tamsayi -> float. isaretli_p = 1: ikiye tumleyen (MI16TOF32, MI32TOF32), 0: isaretsiz.
    // rnd_p (RND32): 0 sifira keser, 1 en yakin cifte (golden model 3.17). 16 bitlik girdiler hep tam sigar.
    function logic[31:0] int_to_float(logic [31:0] int_input , logic isaretli_p , logic rnd_p);

        int lz ;
        logic bulundu ;
        logic isaret ;
        logic [31:0] mutlak ;
        logic [31:0] norm ;
        logic [7:0] exp_float ;
        logic [22:0] mantissa_float ;
        logic [23:0] m_yuvarlanmis ;
        logic G , S ;

        isaret = isaretli_p & int_input[31];
        mutlak = isaret ? (~int_input + 32'd1) : int_input ;     // 0x80000000 -> 2^31 (isaretsiz)

        // bastaki sifirlar: 31. bitten asagi ilk 1
        lz = 0 ;
        bulundu = 1'b0 ;
        for (int i = 31; i >= 0; i--) begin
            if (!bulundu && mutlak[i]) begin
                lz = 31 - i ;
                bulundu = 1'b1 ;
            end
        end

        norm = mutlak << lz ;                   // en soldaki 1 -> norm[31] (gizli bit)
        exp_float = 8'(158 - lz) ;              // 127 + 31 - lz
        mantissa_float = norm[30:8] ;
        G = norm[7] ;                           // atilan bitlerin en yuksegi
        S = |norm[6:0] ;                        // altindakilerin OR'u

        if (rnd_p && G && (S || mantissa_float[0])) begin
            m_yuvarlanmis = {1'b0, mantissa_float} + 24'd1 ;
            if (m_yuvarlanmis[23]) begin        // 7FFFFF + 1: mantis tasar, us 1 artar
                mantissa_float = 23'b0 ;
                exp_float = exp_float + 8'd1 ;
            end
            else
                mantissa_float = m_yuvarlanmis[22:0] ;
        end

        if (mutlak == 32'b0)
            return 32'b0 ;                      // 0 -> +0
        return {isaret , exp_float , mantissa_float} ;

    endfunction

    // Sifira keser. Tamsayinin alt 32 biti (32 bitten buyukse sarar, golden model 3.19).
    function logic [31:0] float_to_int (logic sign_p , logic [7:0]exp_p , logic[23:0] mantissa_p);
  
       logic [31:0] int_value ;
       logic [55:0]shifted_value ;
       int_value = 32'b0 ;
       shifted_value = 56'b0 ;
       if(exp_p >= 8'd127)begin     // |x| >= 1

            shifted_value = {32'b0, mantissa_p} << (exp_p - 8'd126);
            int_value = shifted_value[55:24];
            if(sign_p == 1'b1)
                int_value = ~int_value + 1 ; 

       end 
  

    return int_value; 
endfunction


    // En yakin cifte yuvarlar (RND32'den bagimsiz, TRM s.620-621). |x| >= 0.5 icin de calismali.
    function logic [31:0] float_to_int_round (logic sign_p , logic [7:0]exp_p , logic[23:0] mantissa_p);
  
       logic [31:0] int_value ;
       logic [55:0]shifted_value ;
       logic G , S ;
       int_value = 32'b0 ;
       shifted_value = 56'b0 ;
       if(exp_p >= 8'd126)begin     // |x| >= 0.5

            shifted_value = {32'b0, mantissa_p} << (exp_p - 8'd126);
            G = shifted_value[23];              // virgulun hemen sagindaki bit
            S = |shifted_value[22:0];           // altindaki bitlerin OR'u
            int_value = shifted_value[55:24] + {31'b0, G & (S | shifted_value[24])};
           
            if(sign_p == 1'b1)
                int_value = ~int_value + 1 ; 

       end 
  

    return int_value; 
       

endfunction


always_comb begin

    is_nan = (exp == 8'hFF) && (mantissa[22:0] != 23'b0);
    is_inf = (exp == 8'hFF) && (mantissa[22:0] == 23'b0);
    ham = {sign , exp , mantissa[22:0]} ;
    int_value = 32'b0 ;
    result = 32'b0 ;
    fraction = 24'b0 ;
    kaydirilmis = 48'b0 ;
    exp_float = 8'b0 ;
    lz = 0 ;
    bulundu = 1'b0 ;

    case(op_type)

        OP_MF32TOI16:begin

                int_value = float_to_int(sign , exp , mantissa) ; 
                result =  { {16{int_value[15]}} , int_value[15:0]} ;
                if(is_inf) result = sign ? 32'hFFFF8000 : 32'h00007FFF ;
                if(is_nan) result = 32'b0 ;


        end

        OP_MF32TOI16R :begin


                int_value = float_to_int_round(sign , exp , mantissa) ; 
                result =  { {16{int_value[15]}} , int_value[15:0]} ;
                if(is_inf) result = sign ? 32'hFFFF8000 : 32'h00007FFF ;
                if(is_nan) result = 32'b0 ;

        end
        OP_MF32TOI32: begin
                int_value = float_to_int(sign , exp , mantissa) ; 
                result = int_value ;
                if(is_inf) result = sign ? 32'h80000000 : 32'h7FFFFFFF ;
                if(is_nan) result = 32'b0 ;



        end

          OP_MF32TOUI16 : begin
             int_value = float_to_int(1'b0 , exp , mantissa) ; 
              result =   {16'b0 , int_value[15:0]} ;
              if(is_inf) result = 32'h0000FFFF ;
              if(sign || is_nan) result = 32'b0 ;     // negatif (ve -inf) -> 0
          end

          OP_MF32TOUI16R :begin
                int_value = float_to_int_round(1'b0 , exp , mantissa) ; 
                result =   {16'b0 , int_value[15:0]} ;
                if(is_inf) result = 32'h0000FFFF ;
                if(sign || is_nan) result = 32'b0 ;

          end


          OP_MF32TOUI32 :begin
                int_value = float_to_int(1'b0 , exp , mantissa) ; 
                result = int_value ;
                if(is_inf) result = 32'hFFFFFFFF ;
                if(sign || is_nan) result = 32'b0 ;
          end

          OP_MI16TOF32 :  result = int_to_float({{16{ham[15]}} , ham[15:0]} , 1'b1 , rnd) ;   // kaynak MRb(15:0)
          OP_MUI16TOF32 : result = int_to_float({16'b0 , ham[15:0]} , 1'b0 , rnd) ;
          OP_MI32TOF32 :  result = int_to_float(ham , 1'b1 , rnd) ;
          OP_MUI32TOF32 : result = int_to_float(ham , 1'b0 , rnd) ;


          OP_MFRACF32:begin
                if(exp>=127)begin               // |x| >= 1 (exp = 127 dahil: 1.5 -> 0.5)

                    kaydirilmis = {   24'b0    ,mantissa}<<(exp-126) ;
                    fraction = kaydirilmis[23:0] ;

                    for (int i = 23; i >= 0; i--) begin
                        if (!bulundu && fraction[i]) begin
                            lz = 23 - i ;
                            bulundu = 1'b1 ;
                        end
                    end

                end

        fraction = fraction << (lz+1) ;                   // en soldaki 1 (gizli bit) disari tasar, kalan 23 bit mantis
        exp_float = 8'(127 - lz-1) ;              // en soldaki 1'in agirligi 2^-(lz+1)
        result = {sign , exp_float ,fraction[23:1] } ;

        if(!bulundu)
            result = 32'b0 ;                    // kesir yok (tam sayi, ornegin -3.0) -> +0

        if(exp<127)
            result = {sign , exp , mantissa[22:0]};   // |x| < 1: kesir x'in kendisi (-0 -> -0)

        if(exp == 8'h00 && mantissa[22:0] != 23'b0)
            result = 32'b0 ;                    // denormal -> +0 (golden model flush_denormal)

        if(exp == 8'hFF || exp> 150)
            result = 0 ;

          end

          default: result = 32'b0 ;

    endcase




end





    
    
    
endmodule
