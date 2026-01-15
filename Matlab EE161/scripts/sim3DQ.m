% File: sim3DQ.m
% Simulation of three-dimensional quaternary (3DQ) and two-dimensional 
% QPSK modulations for digital communication over an AWGN channel
% EE 161 - Spring 2012 - San Jose State University
% Copyright (c) 2012. Robert Morelos-Zaragoza. All rights reserved
% Modified Spring 2015 and Spring 2018 to match IEEE 802.11 QPSK mapping.
 
clear
id = input('Enter your student ID (tower card) number: ');
rand('state',id), randn('state',id)

% Number of simulated quaternary symbols
N = 2500000; 

% QPSK constellation with Gray mapping of bits to symbols
qpsk_1(1) = -1/sqrt(2);   qpsk_2(1) = -1/sqrt(2);
qpsk_1(2) = -1/sqrt(2);   qpsk_2(2) =  1/sqrt(2);
qpsk_1(4) =  1/sqrt(2);   qpsk_2(4) =  1/sqrt(2);
qpsk_1(3) =  1/sqrt(2);   qpsk_2(3) = -1/sqrt(2);

% 3DQ constellation
q3d_1(1) = -1/sqrt(3);    q3d_2(1) = -1/sqrt(3);    q3d_3(1) = -1/sqrt(3); 
q3d_1(2) = -1/sqrt(3);    q3d_2(2) =  1/sqrt(3);    q3d_3(2) =  1/sqrt(3); 
q3d_1(3) =  1/sqrt(3);    q3d_2(3) =  1/sqrt(3);    q3d_3(3) = -1/sqrt(3); 
q3d_1(4) =  1/sqrt(3);    q3d_2(4) = -1/sqrt(3);    q3d_3(4) =  1/sqrt(3); 

% SNR (Es/No) values
snr = 4:1:13;

fprintf('\nSimulation of QPSK and 3DQ modulations\n');
fprintf('(Be patient, as this will take some time ...)\n\n');
fprintf('--------------------------------------\n');
fprintf(' Es/No\t   BER(QPSK) \t   BER(3DQ)\n--------------------------------------\n');

for m=1:length(snr)
    
    error  = 0; error3 = 0;
    No=10^(-snr(m)/10);                 % AWGN single-sided power
    sigma = sqrt(No/2);                 % AWGN standard deviation
    
    for n=1:N
        M = ceil(4*rand);               % Random (2-bit) data symbol
        
        % MAPPING FOR QPSK
        S1 = qpsk_1(M);                 % In-phase QPSK symbol - Gray
        S2 = qpsk_2(M);                 % Quadrature QPSK symbol - Gray 
        % MAPPING FOR 3DQ
        S1Q = q3d_1(M);   S2Q = q3d_2(M);   S3Q = q3d_3(M); 
        
        
        % AWGN CHANNEL AND CORRELATOR OUTPUTS FOR QPSK
        Y1 = S1 + sigma*randn;          % Correlator-1 output - QPSK
        Y2 = S2 + sigma*randn;          % Correlator-2 output - QPSK
        % AWGN CHANNEL AND CORRELATOR OUTPUTS FOR 3DQ
        Y1Q = S1Q + sigma*randn;        % Correlator-1 output - 3DQ
        Y2Q = S2Q + sigma*randn;        % Correlator-2 output - 3DQ
        Y3Q = S3Q + sigma*randn;        % Correlator-3 output - 3DQ

        
        % DECISION DEVICE: QPSK
        if Y1 < 0 && Y2 < 0, Mhat = 0;   end
        if Y1 < 0 && Y2 > 0, Mhat = 1;   end
        if Y1 > 0 && Y2 > 0, Mhat = 3;   end
        if Y1 > 0 && Y2 < 0, Mhat = 2;   end

        % DECISION DEVICE: 3DQ (CORRELATION BASED)
        corr(1) = -Y1Q -Y2Q -Y3Q;       % (-1 -1 -1) or (0 0 0)
        corr(2) = -Y1Q +Y2Q +Y3Q;       % (-1 +1 +1) or (0 1 1)
        corr(3) = +Y1Q +Y2Q -Y3Q;       % (+1 +1 -1) or (1 1 0)
        corr(4) = +Y1Q -Y2Q +Y3Q;       % (+1 -1 +1) or (1 0 1)
        % Determine maximum correlation
        max = 0;
        for i=1:4
            if corr(i) > max
                max = corr(i); Mhat_3DQ = i-1;
            end
        end
%         [C,I] = max(corr);
%         Mhat_3DQ = I-1;
%         

        % COMPUTE BIT ERRORS QPSK
        if bitget(Mhat,1) ~= bitget(M-1,1),  error = error + 1;  end
        if bitget(Mhat,2) ~= bitget(M-1,2),  error = error + 1;  end
        % COMPUTE BIT ERRORS 3DQ
        if bitget(Mhat_3DQ,1) ~= bitget(M-1,1),  error3 = error3 + 1;  end
        if bitget(Mhat_3DQ,2) ~= bitget(M-1,2),  error3 = error3 + 1;  end

    end
    pb(m)  = error/(2*N);                          % Bit error rate
    pb3(m) = error3/(2*N); 
    fprintf('%5.2f \t %e \t %e\n',snr(m),pb(m),pb3(m));
end
fprintf('---------------------------------\n');

% BER values
semilogy(snr,qfunc(sqrt(10.^(snr/10))),'-+k'), grid on, hold on
semilogy(snr,pb,'-ok')
% 3DQ theory: Note that every signal point has three neighbors
semilogy(snr,3*(2/3)*qfunc(sqrt((4/3)*(10.^(snr/10)))),'--^k')
semilogy(snr,pb3,'--sk')
xlabel('E_s/N_0 (dB)'), ylabel('Bit Error Rate')
axis([ snr(1) snr(length(snr)) 5e-6 1e-1 ]), legend('Theory QPSK','BER QPSK', ...
        'Theory 3DQ','BER 3DQ')
title('Error performace of 2-D (QPSK) and 3-D quaternary modulations')
hold off