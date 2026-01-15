% Spectrum of OFDM signal with rectangular pulses of duration T
% EE265 - Fall 2017. San Jose State University
 
clear all
W = 1e6;                                    % Channel bandwidth
K = input('Enter the number of carriers, K: ');
T = K/W;
f = -0.5*W:W/(10*K):1.5*W;
C = zeros(size(f));
for k=1:K
    tone = sinc((f-(k-1)/T)*T);
    plot(f,tone,'--r'), hold on
    C = C + tone;
end
plot(f,C,'-b'), axis tight, grid on, hold off
xlabel('f (Hz)'), ylabel('S(f)')
title(strcat('Spectrum of a 1 MHz OFDM signal, K=',num2str(K),' carriers'))