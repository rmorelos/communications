esno_dB = 0:2:85;
esno = 10.^(esno_dB/10);

C=2;
M=4096; delta = 3/(M-1); 
C=( (2*4 + 3*4*(sqrt(M)-2) + 4*(sqrt(M)-2)^2) / M ) / log2(M);
pb4096 = (C/2) * ( 1 - sqrt(delta*esno ./ (2 + delta*esno)) );
M=1024; delta = 3/(M-1);
C=( (2*4 + 3*4*(sqrt(M)-2) + 4*(sqrt(M)-2)^2) / M ) / log2(M);
pb1024 = (C/2) * ( 1 - sqrt(delta*esno ./ (2 + delta*esno)) );
M=256; delta = 3/(M-1);
C=( (2*4 + 3*4*(sqrt(M)-2) + 4*(sqrt(M)-2)^2) / M ) / log2(M);
pb256 = (C/2) * ( 1 - sqrt(delta*esno ./ (2 + delta*esno)) );
M=64; delta = 3/(M-1);
C=( (2*4 + 3*4*(sqrt(M)-2) + 4*(sqrt(M)-2)^2) / M ) / log2(M);
pb64 = (C/2) * ( 1 - sqrt(delta*esno ./ (2 + delta*esno)) );

delta=1; pb4 = (1/2) * ( 1 - sqrt(delta*esno ./ (2 + delta*esno)) );
pb2 = (1/2) * ( 1 - sqrt(delta*esno ./ (1 + delta*esno)) );

figure(100)
semilogy(esno_dB,pb4096,'-+k'), hold on
semilogy(esno_dB,pb1024,'-ok'), 
semilogy(esno_dB,pb256,'-^k'), 
semilogy(esno_dB,pb64,'-sk'),
semilogy(esno_dB,pb4,'-*k'), 
semilogy(esno_dB,pb2,'-k'), hold off
axis([0 esno_dB(end) 9.999e-7 2e-1]), grid on, xlabel('Es/N_0 (dB)'), ylabel('P_b')
legend('4096-QAM','1024-QAM','256-QAM','64-QAM','QPSK','BPSK')

% EsNo for given pb
pb = 2e-4;

M=[4 16 64 256 1924 4096]; delta = 3./(M-1); 
C=( (2*4 + 3*4*(sqrt(M)-2) + 4*(sqrt(M)-2).^2) ./ M ) ./ log2(M);
eps = 1-2*pb./C;
rho = 10*log10(2*eps.^2./(delta.*(1-eps.^2)));
