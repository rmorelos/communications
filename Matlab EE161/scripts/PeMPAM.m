% Probability of a bit error for M-PAM
% EE 161 - Digital Communication Systems - Spring 2012
% Prof. Robert Morelos-Zaragoza. San Jose State University

clear all;
set(1)=2; set(2)=4; set(3)=8; set(4)=16; set(5)=32;  % Constellation sizes
for j=1:5
    i = 1;
    M = set(j); 
    for esnodb=0:0.5:30
        esno = 10^(esnodb/10);
        Pe(j,i) = (2*(M-1)/(log2(M)*M))*qfunc(sqrt((6*log2(M)/(M^2-1))*esno)); 
        snr(i) = esnodb;
        i=i+1;
    end
end
semilogy(snr,Pe(1,:),'-^',snr,Pe(2,:),'-o',snr,Pe(3,:),'-s', ...
                                    snr,Pe(4,:),'-*',snr,Pe(5,:),'-+')
axis( [0 30 1e-6 1e-1]), grid on
xlabel('E_s/N_0 (dB)'); ylabel('Bit error probability')
legend('2-PAM','4-PAM','8-PAM','16-PAM','32-PAM');
title('Average probability of a bit error for M-PAM')
hold off