% File: pb_modulations_80211_admendment
% EE 161 - Spring 2015 - San Jose State University

clear all

esno_dB = 0:50;
esno = 10.^(esno_dB/10);

% Model eq: Pb = 2*qfunc(sqrt(3*esno/(M-1)))

M = [4 16 64 256 1024 4096];
Pbs = zeros(length(esno),length(M));


for j=1:length(M)
    Pbs(:,j) = 2*qfunc(sqrt(3*esno/(M(j)-1)));
end


semilogy(esno_dB,Pbs(:,1),'-pr'), hold on, %% Plot 4qam
semilogy(esno_dB,Pbs(:,2),'-hb'), %% 16qam
semilogy(esno_dB,Pbs(:,3),'-or'), %% 64qam
semilogy(esno_dB,Pbs(:,4),'-db'), %% 256qam
semilogy(esno_dB,Pbs(:,5),'-xr'), %% 1024qam
semilogy(esno_dB,Pbs(:,6),'-sb'), hold off, %% 4096qam

axis([esno_dB(1) esno_dB(length(esno_dB)) 9.99e-7 5e-1])
legend('4-QAM','16-QAM','64-QAM','256-QAM','1024-QAM','4096-QAM')
grid on,xlabel('Symbol energy-to-noise ratio, E_s/N_0 (dB)')
ylabel('Bit error probability, P_b')
title('Theoretical performance of IEEE 802.11 modulations over an AWGN channel - SJSU')
