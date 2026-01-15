% Probability of a bit error for BPSK, 4PAM and QPSK
% EE 161 - Digital Communication Systems - Spring 2023
% Prof. Robert Morelos-Zaragoza. San Jose State University
EsN0dB = 0:18;
EsN0 = 10.^(EsN0dB/10);
Pb_bpsk = qfunc(sqrt(2*EsN0));
Pb_4pam = (3/4) *  qfunc(sqrt((2/5)*EsN0));
Pb_qpsk = qfunc(sqrt(EsN0));
semilogy(EsN0dB,Pb_4pam,'-o',EsN0dB,Pb_qpsk,'-s',EsN0dB,Pb_bpsk,'-^')
axis( [0 18 1e-6 1e-1]), grid on
xlabel('E_s/N_0 (dB)'); ylabel('Bit error probability')
legend('4-PAM','QPSK','BPSK');
