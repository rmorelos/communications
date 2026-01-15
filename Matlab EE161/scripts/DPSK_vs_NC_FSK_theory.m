% DPSK_vs_NC_FSK_theory.m
% Compare the performances of DPSK and noncoherent BPSK
% EE161 - Spring 2022 - San Jose State University
snr=0:1:45;
semilogy(snr,1./((2+10.^(snr/10))),'--sr')      % Theory NC-FSK Rayleigh
hold on, axis([snr(1) snr(end) 1e-5 3e-1]), grid on
semilogy(snr,1./(2*(1+10.^(snr/10))),'--*k')    % Theory DPSK Rayleigh
semilogy(snr,(1/2)*exp(-10.^(snr/10)/2),'--^r')   % Theory NC-FSK AWGN
semilogy(snr,(1/2)*exp(-10.^(snr/10)),'--ok')   % Theory DPSK AWGN
xlabel('Average E_s/N_0 (dB)'), ylabel('Bit error probability, P_b')
hold off
legend('NC-BFSK Rayleigh','DPSK Rayleigh','NC-BFSK AWGN','DPSK AWGN')