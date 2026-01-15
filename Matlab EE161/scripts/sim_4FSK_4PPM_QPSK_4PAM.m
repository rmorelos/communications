% File: sim_4FSK_4PPM_QPSK_4PAM.m
% Simulation under AWGN of
% (1) 4PAM mapping with Gray labeling 
% (2) QPSK mapping with Gray labeling
% (3) 4-FSK/4-PPM mapping
% The constellations are normalized to energy E_s=1
% EE 161 - Spring 2023 - San Jose State University

clear
s = input('Enter your student ID number: ');
randn('seed',s); rand('seed',s)

% Number of simulated quaternary symbols
N=550000; 

% QPSK constellation with Gray mapping of bits to symbols
qpsk_1(1) =  1/sqrt(2);  qpsk_2(1) =  1/sqrt(2);
qpsk_1(2) = -1/sqrt(2);  qpsk_2(2) =  1/sqrt(2);
qpsk_1(4) = -1/sqrt(2);  qpsk_2(4) = -1/sqrt(2);
qpsk_1(3) =  1/sqrt(2);  qpsk_2(3) = -1/sqrt(2);

% 4-PAM constellation with Gray mapping of bits to symbols
pam4(1) = -3/sqrt(5);
pam4(2) = -1/sqrt(5);
pam4(4) =  1/sqrt(5);
pam4(3) =  3/sqrt(5);
lambda1 = -2/sqrt(5); lambda2 = 0; lambda3 = 2/sqrt(5);

% 4-FSK/4-PPM constellation: Identity matrix of order 4  :)
fsk4 = eye(4);

% SNR (Es/No) values
snr=0:1:16;
fprintf('\nSimulation of QPSK, 4-PAM and 4-FSK mappings\n');
fprintf('with transmission over an AWGN channel\n\n')
fprintf('-----------------------------------------------------\n');
fprintf(['Es/No     BER_QPSK  \t   BER_4PAM  \t   BER_4FSK \n----' ...
    '-------------------------------------------------\n']);
for m=1:length(snr) 

    No=10^(-snr(m)/10);                         % AWGN single-sided power
    sigma = sqrt(No/2);                         % AWGN standard deviation

    error  = 0; error4 = 0;  error4f=0;         % Bit error counters

    for n=1:N
        M = ceil(4*rand)-1;                     % Random (2-bit) message

        % %%%%%%%%%%%%%%%%%%%%%%%%%   MAPPINGS  %%%%%%%%%%%%%%%%%%%%%%%%%

        % QPSK MAPPING
        S1 = qpsk_1(M+1);                       % In-phase QPSK symbol
        S2 = qpsk_2(M+1);                       % Quadrature QPSK symbol

        % 4-PAM MAPPING
        S3 = pam4(M+1);                         % 4-PAM symbol

        % 4-FSK MAPPING
        S4 = fsk4(M+1,:);                       % 4-FSK/4-PPAM symbols    

        % %%%%%%%%%%%%%%%%%%%%%%%%  AWGN AND MF %%%%%%%%%%%%%%%%%%%%%%%%%
        Y1 = S1 + sigma*randn;                  % MF output QPSK, Y1
        Y2 = S2 + sigma*randn;                  % MF output QPSK, Y2

        Y3 = S3 + sigma*randn;                  % MF output 4-PAM

        Y4 = S4 + sigma*randn(1,4);             % MF outputs for 4-FSK

        % %%%%%%%%%%%%%%%%%%%%%   DECISION DEVICES  %%%%%%%%%%%%%%%%%%%%%

        % DECISION DEVICE FOR 4-PAM
        if Y3 < lambda1, Mhat4 = 0; end
        if Y3 > lambda1 && Y3 <= lambda2, Mhat4 = 1; end
        if Y3 > lambda2 && Y3 <= lambda3, Mhat4 = 3; end
        if Y3 > lambda3, Mhat4 = 2; end

        % DECISION DEVICE FOR QPSK
        if Y1 > 0 && Y2 > 0, Mhat = 0;   end
        if Y1 < 0 && Y2 > 0, Mhat = 1;   end
        if Y1 < 0 && Y2 < 0, Mhat = 3;   end
        if Y1 > 0 && Y2 < 0, Mhat = 2;   end

        % DECISION DEVICE FOR 4-FSK:
        % Minimum distance is equivalent to maximum correlation w.r.t. the
        % identity matriz: That is, choose coordinate of largest value !!
        [Ymax,Mhat4F] = max(Y4);

        % %%%%%%%%%%%%%%%%%%%%  BIT ERROR COUNTERS  %%%%%%%%%%%%%%%%%%%%%
        
        % COMPUTE BIT ERRORS FOR 4-PAM
        if bitget(Mhat4,1) ~= bitget(M,1)    error4 = error4 + 1;  end
        if bitget(Mhat4,2) ~= bitget(M,2)    error4 = error4 + 1;  end

        % COMPUTE BIT ERRORS FOR QPSK
        if bitget(Mhat,1) ~= bitget(M,1)    error = error + 1;  end
        if bitget(Mhat,2) ~= bitget(M,2)    error = error + 1;  end
        
        % COMPUTE BIT ERRORS FOR 4-FSK (Big endian)
        if bitget(Mhat4F-1,1) ~= bitget(M,1)    error4f = error4f + 1;  end
        if bitget(Mhat4F-1,2) ~= bitget(M,2)    error4f = error4f + 1;  end

    end

    pb4(m)=error4/(2*N);                        % Bit error rate 4-PAM
    pb(m)=error/(2*N);                          % Bit error rate QPSK
    pb4f(m)=error4f/(2*N);                      % Bit error rate 4-FPSK
    fprintf('%5.2f   %e\t %e\t %e\n',snr(m),pb(m),pb4(m),pb4f(m));
end
fprintf('--------------------------------------\n');


% Plot BER of 4-PAM
semilogy(snr,pb4,':ok'), hold on
% Plot theoretical value of bit error probability for 4-PAM
semilogy(snr, (3/4)*qfunc(sqrt((2/5)*10.^(snr/10))),'^k')

% Plot BER of 4-FSK
semilogy(snr,pb4f,':dk')
% Plot theoretical value of bit error probability for 4-FPSK
semilogy(snr, (3/2)*qfunc(sqrt(10.^(snr/10))),'+k')

% Plot BER of QPSK
semilogy(snr,pb,':sk')
% Plot theoretical value of bit error probability for QPSK
semilogy(snr, qfunc(sqrt(10.^(snr/10))),'*k')

grid on, xlabel('Symbol E_s/N_0 (dB)'), ylabel('Bit Error Rate')
legend('Simulation 4-PAM', 'Theory 4-PAM',  ...
    'Simulation 4-FSK','Theory 4-FSK','Simulation QPSK','Theory QPSK', ...
    'Location','southwest')
title('Simulation of QPSK/4-PAM/4-FSK mappings under AWGN ')
axis([snr(1) snr(end) 9.99e-6 1e-1])
hold off

