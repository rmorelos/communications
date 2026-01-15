% File: pb_modulations_80211_2.m
% Comparison of average bit error probabilities between BPSK, QPSK, 16-QAM
% and 64-QAM modulations used in the IEEE 802.11 standard for wireless
% local area networks. Added 256-QAM and 1024-QAM
% EE 161 - Spring 2012, 2015 - San Jose State University

clear
esno_dB = 0:40;
esno = 10.^(esno_dB/10);
Pb_bpsk =  qfunc(sqrt(2*esno));
Pb_qpsk =  qfunc(sqrt(esno));
Pb_16qam = 2*qfunc(sqrt(esno/5));
Pb_64qam = 2*qfunc(sqrt(esno/21));
Pb_256qam = 2*qfunc(sqrt(esno/88));
Pb_1024qam = 2*qfunc(sqrt(esno/341));
semilogy(esno_dB,Pb_1024qam,'-*k'), hold on, semilogy(esno_dB,Pb_256qam,'-+k')
semilogy(esno_dB,Pb_64qam,'-pk'), semilogy(esno_dB,Pb_16qam,'-^k')
semilogy(esno_dB,Pb_qpsk,'-sk'),  semilogy(esno_dB,Pb_bpsk,'-ok')
hold off, axis([esno_dB(1) esno_dB(length(esno_dB)) 9.99e-7 1e-1])
legend('1024-QAM','256-QAM','64-QAM','16-QAM','QPSK','BPSK','Location','SouthWest')
grid on, xlabel('Signal energy-to-noise ratio, E_s/N_0 (dB)')
ylabel('Bit error probability, P_b')
title('Theoretical performance of IEEE 802.11 modulations over an AWGN channel - SJSU 2015')