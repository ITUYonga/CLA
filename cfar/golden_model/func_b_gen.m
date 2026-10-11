function b_code = func_b_gen(len)
%FUNC_B_GEN : Generates randomised barker code pulses without a specific order
%Can Ertürk
%
%   Purpose:  Generates a row with the length of 'len' and random numbers between 0 and 1.
%             if the number is higher that 0.5 then make that value '1'
%             else: make the value '-1'
%            
%   inputs:
%             len: Barker Code Index 
%   
%    output: 
%             b_code: 'the pulse' that has been formed


    b_code = zeros(len,1);
    
    for index = 1:len
        temp = rand();

        if temp < 0.5
            b_code(index) = -1;
        else
            b_code(index) = 1;
        end
    end
end