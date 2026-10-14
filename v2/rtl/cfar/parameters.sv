package parameters;

    localparam int FAST_SIGNAL = 1000;
    localparam int SLOW_SIGNAL = 20;
    localparam int MTI_SIGNAL  = SLOW_SIGNAL - 2;
    localparam int FFT_POINT   = 128;
    localparam int FFT_STAGE   = $clog2(FFT_POINT);
    localparam int XLEN        = 20;

    localparam int TX_DEPTH = 20;
    localparam int RX_DEPTH = 1000;

    //Matched Filter
    localparam int MF_RX_IN = 16;
    localparam int MF_TX_IN = 16;
    localparam int MF_OUT = 18;
    localparam int MF_SHIFT = 14;
    localparam int MF_PAD = TX_DEPTH/2;

    //MTI 
    localparam int MTI_IN = 18; 
    localparam int MTI_OUT = 20; 

    //Windowing before FFT
    localparam int WIN_PRE_FFT            = 20;
    localparam int WIN_PRE_FFT_COEF_WIDTH = 18;
    localparam int WIN_PRE_FFT_MUL        = 38;
    localparam string WIN_PRE_FFT_FILE    = "win_pre_fft.mem";

    //FFT
    localparam int TWLEN       = 18;
    localparam int TWFRAC      = 16;
    localparam int TW_DEPTH    = FFT_POINT/4 + 1;
    localparam string TW_FILE  = "tw_cos.mem";

    localparam int FFT_OUT_LEN  = XLEN + FFT_STAGE;
    localparam int XLEN_LOG_IN  = 2*FFT_OUT_LEN;
    localparam int XLEN_LOG_OUT = 16;

    //OS-CFAR
    localparam int CFAR_REF   = 30;
    localparam int CFAR_GUARD = 6;
    localparam int CFAR_K     = 20;
    localparam int CFAR_WIN   = CFAR_REF + CFAR_GUARD + 1;
    localparam int CFAR_HALF  = CFAR_WIN / 2;
    localparam int CFAR_ALPHA = 3072;

    //Post-processing
    localparam int MAXDET     = 16;
    localparam int PP_LOGRATIO = -1024;
    localparam int PP_MAX_GAP = 15;
endpackage
