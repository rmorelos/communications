% file: simbpsk.m
% Description: Simulation of a binary communication system using polar NRZ
% signaling over an AWGN channel with a correlator-based receiver
% EE160 - Fall 2004 - San Jose State University
% Modified in Spring 2012 and Spring 2020 by Robert Morelos-Zaragoza

clear

id = input('Enter your student ID (tower card) number: ');
rand('state',id), randn('state',id)
fprintf('\nPlease be patient, as the script will take time to execute...\n');
fprintf('--------------------\n');
fprintf('Eb/No \t   BER\n');
fprintf('--------------------\n');

Ns=10;                                  % 10 samples per bit duration
Nsim = 900000;                          % Number of simulated bits
i = 1;                                  % Index for array of rEbults
P0 = 1/2;                               % Probability of bit = "0"
for j=1:Ns, g(j) = 1; end
for EbNo=0:1:10
    error = 0;                          % Error counter
    for n = 1:Nsim
        No = Ns*10^(-EbNo/10);
        sigma= sqrt(No/2);              % Standard deviation of AWGN
        % Random bit
        if (rand < P0), M = 0; else M = 1; end
        % Mapping: "0" --> 1, "1" --> -1
        amp = (-1)^M;                       
        % Samples of a rectangular pulse of amplitude a, s(t) = a g_T(t)
        for j=1:Ns, s(j) = amp*g(j); end
        % Add AWGN samples
        for j=1:Ns
            y(j) = s(j) + sigma*randn;      % Add noise 
            YT(j) = 0;                      % Initialize correlator output
        end
        % Correlator output
        YT = y*g'/Ns;
        % Decision device
        if YT > 0, Mhat = 0; else Mhat = 1; end
        % Count errors
        if Mhat ~= M, error = error+1; end
    end % for n
    snr(i) = EbNo;
    ber(i) = error/Nsim;
    fprintf('% 3.1f  \t%9.6e \n', snr(i), ber(i)); 
    i = i + 1;
end % for EbNo

% Plotting commands
semilogy(snr,ber,'-*k')
hold on
perr = qfunc(sqrt(2*10.^(snr/10)));
semilogy(snr,perr,'-ok')
legend('Simulated','Theory');
title('Simulation of binary communication (BPSK) under AWGN');
xlabel('E_b/N_0 (dB)');
ylabel('Bit error rate');
grid on
hold off
