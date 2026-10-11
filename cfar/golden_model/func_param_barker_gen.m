function barker_signal = func_param_barker_gen(len)
%FUNC_PARAM_BARKER_GEN : Generates specified and licenced barker codes
%Can Ertürk
%
%   Purpose:  Generating the original barker coded pulses with specified
%             indexes [2, 3, 5, 7, 11, 13]. Switch and case mechanism is
%             implemented.
%            
%   inputs:
%             len: Barker Code Index 
%   
%    output: 
%             barker_signal: Selected Barker Signal
    switch len
        case 2, code        =   [1 -1];
        case 3, code        =   [1 1 -1];
        case 5, code        =   [1 1 1 -1 1];
        case 7, code        =   [1 1 1 -1 -1 1 -1];
        case 11, code       =   [1 1 1 -1 -1 -1 1 -1 -1];
        case 13, code       =   [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];
        case default, code  =   [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];
      
    end
    barker_signal = code;
end