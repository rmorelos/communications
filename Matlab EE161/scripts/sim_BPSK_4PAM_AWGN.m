% File: sim_BPSK_4PAM_AWGN.m
% Simulation of 4PAM mapping with Gray labeling over AWGN channel
% EE 161 - Spring 2022 - San Jose State University

clear
s = input('Enter your student ID number: ');
randn('seed',s); rand('seed',s)

% Number of simulated quaternary symbols
N=500000; 

% BPSK constellation with Gray mapping of bits to symbols
bpsk(1) =  -1;  bpsk(2) =  1;

% 4-PAM constellation with Gray mapping of bits to symbols
pam4(1) = -3/sqrt(5);
pam4(2) = -1/sqrt(5);
pam4(4) =  1/sqrt(5);
pam4(3) =  3/sqrt(5);
lambda1 = -2/sqrt(5); lambda2 = 0; lambda3 = 2/sqrt(5);

% SNR (Es/No) values
snr=0:1:17;
fprintf('\nSimulation of BPSK/4-PAM mapping with Gray labeling\n');
fprintf('      with transmission over an AWGN channel\n\n')
fprintf('--------------------------------------\n');
fprintf('Es/No     BER_BPSK  \t   BER_4PAM\n--------------------------------------\n');
for m=1:size(snr,2)
    error  = 0; error4 = 0;
    No=10^(-snr(m)/10);                         % AWGN single-sided power
    sigma = sqrt(No/2);                         % AWGN standard deviation

    for n=1:N
        M = ceil(4*rand)-1;                     % Random (2-bit) message

        % BPSK MAPPING (2 bits)
        if M<2
            S1 = bpsk(mod(M,2)+1);              % First BPSK symbol
            S2 = bpsk(1);                       % Second BPSK symbol
        else
            S1 = bpsk(mod(M,2)+1);              % First BPSK symbol
            S2 = bpsk(2);                       % Second BPSK symbol
        end
        

        % 4-PAM MAPPING
        S3 = pam4(M+1);                         % 4-PAM symbol

        % AWGN CHANNEL
        Y1 = S1 + sigma*randn;                  % Matched filter output 1
        Y2 = S2 + sigma*randn;                  % Matched filter output 2
        Y3 = S3 + sigma*randn;

        % DECISION DEVICE FOR BPSK (2 bits)
        if Y1 > 0,  Mhat = 1;   end
        if Y1 <= 0, Mhat = 0;   end
        if Y2 > 0,  Mhat = Mhat+2;   end
        if Y2 <= 0, Mhat = Mhat;   end

        % DECISION DEVICE FOR 4-PAM
        if Y3 < lambda1, Mhat4 = 0; end
        if Y3 > lambda1 && Y3 <= lambda2, Mhat4 = 1; end
        if Y3 > lambda2 && Y3 <= lambda3, Mhat4 = 3; end
        if Y3 > lambda3, Mhat4 = 2; end
        
        % COMPUTE BIT ERRORS FOR BPSK
        if bitget(Mhat,1) ~= bitget(M,1),       error = error + 1;  end
        if bitget(Mhat,2) ~= bitget(M,2),       error = error + 1;  end

        % COMPUTE BIT ERRORS FOR 4-PAM
        if bitget(Mhat4,1) ~= bitget(M,1),      error4 = error4 + 1;  end
        if bitget(Mhat4,2) ~= bitget(M,2),      error4 = error4 + 1;  end
    end

    pb(m)=error/(2*N);                          % Bit error rate BPSK
    pb4(m)=error4/(2*N);                        % Bit error rate 4-PAM
    fprintf('%5.2f   %e\t %e\n',snr(m),pb(m),pb4(m));
end

fprintf('--------------------------------------\n');
% Plot BER of 4-PAM
semilogy(snr,pb4,':ok'), axis([0 17 9.98e-6 2e-1]), hold on
% Plot theoretical value of bit error probability for 4-PAM
semilogy(snr, (3/4)*qfunc(sqrt((2/5)*10.^(snr/10))),'^k')
% Plot BER of BPSK
semilogy(snr,pb,':sk')
% Plot theoretical value of bit error probability for BSK
semilogy(snr, qfunc(sqrt(2*10.^(snr/10))),'*k')
grid on, xlabel('Symbol E_s/N_0 (dB)'), ylabel('Bit Error Rate')
legend('Simulation 4-PAM','Theory 4-PAM','Simulation BPSK','Theory BPSK')
title('Simulation of BPSK/4-PAM over AWGN channel')
hold off
