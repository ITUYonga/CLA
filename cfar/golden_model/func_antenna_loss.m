function L_dB = func_antenna_loss(x,angles,losses)

% x = boresight'tan sapma
% angles = referans açılar örnek olarak
% [-8 -3 0 3 8]

% losses: o açılardaki kayıplar(dB)
% örnek [25 -3 0 3 8]

p = polyfit(angles,losses,length(angles)-1);
L_dB = polyval(p,x);
L_dB = max(L_dB, 0);

end