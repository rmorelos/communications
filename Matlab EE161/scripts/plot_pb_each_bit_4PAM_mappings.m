% Plot the average error probabilities of each bit in 4-PAM mapping 
% for Gray and Natural bits-to-symbols labelings
% EE251 - Fall 2017. San Jose State University

esnodb = 0:1:17;
esno = 10.^(esnodb/10);
a = sqrt(esno/5);

% Labeling is (B1,B2)
% Bit 1 (MSB), B1 - Both Natural and Gray labelings
pb1 = 0.5 * (qfunc(sqrt(2*a.^2))+2*qfunc(sqrt(8*a.^2))+qfunc(sqrt(18*a.^2)));
% Bit 2 (LSB), B2 - Natural labeling
pb2N = 0.5 * (3*qfunc(sqrt(2*a.^2))+qfunc(sqrt(18*a.^2)));
% Bit 2 (LSB), B2 - Gray labeling
pb2G = 0.5 * (2*qfunc(sqrt(2*a.^2))+qfunc(sqrt(8*a.^2)));
% Average Pb for Natural labeling
pbN = (pb1+pb2N)/2;
% Average Pb for Gray labeling
pbG = (pb1+pb2G)/2;

figure(3)
semilogy(esnodb,pb2N,'-k*'), axis tight, hold on
semilogy(esnodb,pb2G,'-ks'), semilogy(esnodb,pb1,'-k^')
axis([esnodb(1) esnodb(length(esnodb)) 1e-6 1e-1])
grid on, xlabel('Signal energy-to-noise ratio E_s/N_0 dB'), ylabel('P_b')
legend('Bit 2, Natural','Bit 2, Gray','Bit 1'), hold off
title('Average probabilities of error per bit')

figure(2)
semilogy(esnodb,pbN,'--k<'), axis tight, hold on
semilogy(esnodb,pbG,'--ks')
axis([esnodb(1) esnodb(length(esnodb)) 1e-6 1])
grid on, xlabel('Signal energy-to-noise ratio E_s/N_0 dB'), ylabel('P_b')
legend('Natural','Gray'), hold off
title('Average bit error probability')