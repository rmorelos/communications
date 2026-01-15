% File: pb_polar_unipolar.m
% Comparison of average bit error probabilities between polar and unipolar
% mappings
% EE 161 - Spring 2016 - San Jose State University
clear;  esno_dB = 0:14;   esno = 10.^(esno_dB/10);
Pb_polar =  qfunc(sqrt(2*esno));   Pb_unipolar =  qfunc(sqrt(esno));
semilogy(esno_dB,Pb_unipolar,'-sk'), hold on, semilogy(esno_dB,Pb_polar,'-ok')
axis([esno_dB(1) esno_dB(end) 9.99e-7 5e-1])
legend('Unipolar','Polar','Location','NorthEast')
grid on, xlabel('Symbol energy-to-noise ratio, E_s/N_0 (dB)')
ylabel('Bit error probability, P_b')
title('Theoretical performance of polar and unipolar mappings')