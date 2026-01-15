% 16-QAM

s1 = [ -3 -3 -3 -3 -1 -1 -1 -1  1  1  1  1  3  3  3  3];
s2 = [ -3 -1  1  3 -3 -1  1  3 -3 -1  1  3 -3 -1  1  3];
Es = sum(s1.^2+s2.^2)/16

figure(1)
plot(s1,s2,'o'), grid on, axis([-4 4 -4 4])
xlabel('s_1/a'), ylabel('s_2/a')
title(strcat('16-QAM signal constellation, E_s=', num2str(Es),'a^2'))

figure(2)
voronoi(s1,s2,'-b'), axis([-4 4 -4 4]), grid on
xlabel('y_1/a'), ylabel('y_2/a')
title('16-QAM decision regions')

figure(3)
esno_dB = 0:21;
esno = 10.^(esno_dB/10);
Pb = (3/4)*qfunc(sqrt(esno/5));
semilogy(esno_dB,Pb,'-sk'), axis([esno_dB(1) esno_dB(end) 1e-6 1e-1]), grid on
xlabel('E_s/N_0 (dB)'), ylabel('P_b')
title('Error performance of 16-QAM modulation under AWGN')
hold on
Pb3 = qfunc(sqrt(2*esno/5)); semilogy(esno_dB,Pb3,'-*k')
Pb2 = qfunc(sqrt(esno)); semilogy(esno_dB,Pb2,'-^k')
Pb3 = qfunc(sqrt(2*esno)); semilogy(esno_dB,Pb3,'-ok')
hold off, legend('16-QAM (4 bps/baud)','4-PAM (2 bps/baud)', ...
    'QPSK (2 bps/baud)','BPSK (1 bps/baud)')

%%%%%%%%%%%%%%%%%%%
% Simulation AWGN %
%%%%%%%%%%%%%%%%%%%
