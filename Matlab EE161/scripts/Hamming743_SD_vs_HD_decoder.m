% File: Hamming743_SD_vs_HD_decoder.m
% Soft-decision (SD) decoding of the binary Hamming (7,4,3) code based on
% correlations. Hard-decision (HD) decoding based on syndrome computation 
% and look-up table (LUT) --- BPSK modulation over an AWGN channel.
% EE 161 - Spring 2014 - San Jose State University
% Modified in Spring 2023. Updated in Spring 2024.

clear all

nsim = 250000;                      % Number of codewords per Eb/No value

n = 7;                              % Code length
k = 4;                              % Code dimension
dmin = 3;                           % Minimum distance
rate = k/n;                         % Rate

% Systematic parity-check matrix:
H = [ 1 1 1 0 1 0 0
      1 1 0 1 0 1 0
      1 0 1 1 0 0 1 ];
% Parity submatrix:
P = H(1:3,1:4);
% Generator matrix:
G = [ eye(4) P'];

% Information vectors
b = [ 0 0 0 0
      0 0 0 1
      0 0 1 0
      0 0 1 1
      0 1 0 0
      0 1 0 1
      0 1 1 0
      0 1 1 1
      1 0 0 0
      1 0 0 1
      1 0 1 0
      1 0 1 1
      1 1 0 0
      1 1 0 1
      1 1 1 0
      1 1 1 1 ];

% All codewords and their modulated (BPSK or polar mapping) versions
c = mod(b*G,2); m = 1-2*c;

% Compute Hamming weight distribution 
k2=2^k;
for i=1:n+1, W(i)=0; end
for i=1:k2
    weight = sum(c(i,:));
    W(weight+1) = W(weight+1)+1;
end

% LUT for HD decoding: Error vector as function of syndrome value
est_e(1,:) = [0 0 0 0 0 0 0];     % 0 0 0 = 1 - 1
est_e(8,:) = [1 0 0 0 0 0 0];     % 1 1 1 = 8 - 1
est_e(7,:) = [0 1 0 0 0 0 0];     % 1 1 0 = 7 - 1
est_e(6,:) = [0 0 1 0 0 0 0];     % 1 0 1 = 6 - 1
est_e(4,:) = [0 0 0 1 0 0 0];     % 0 1 1 = 4 - 1
est_e(5,:) = [0 0 0 0 1 0 0];     % 1 0 0 = 5 - 1
est_e(3,:) = [0 0 0 0 0 1 0];     % 0 1 0 = 3 - 1
est_e(2,:) = [0 0 0 0 0 0 1];     % 0 0 1 = 2 - 1

init =  0;                          % Inital value of Eb/No(dB)
inc =   0.25;                       % Increment in Eb/No(dB)
final = 8.0;                        % Final value of Eb/No(dB)
num=0;                              % Index for bit error rate (BER) values

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

fprintf('\nSimulation of HD and SD decoding of a binary Hamming (7,4,3) code\n\n');
fprintf('Eb/No(dB) \tBER \t\tErrors\n');
fprintf('------------------------------\n');

for SNRdB = init:inc:final
    
    error=0;error_HD=0;TotalNumError=0;TotalN=0;    % Counters
    SNRdBs = SNRdB + 10*log(rate)/log(10);          % Energy with rate loss
    No = (10.^(-SNRdBs/10)); Var = No/2;            % AWGN variance
    
    for Ns = 1:nsim
        
        % Use the first line below and comment the following line if
        % using Matlab 2011b or earlier versions
        %msg = randint(1,k,[0,1]);       % Random binary message vector
        msg = round(rand(1,k));
        codeword = mod(msg*G,2);        % Compute the codeword in C (mod 2)
        x = 1-2*codeword;               % BPSK mapping
        rec = x + sqrt(Var)*randn(1,n); % Add AWGN to received vector
        
        % Soft-decision decoding: Correlation !!!
        [cor,I] = max(rec*m');          % I: Index of maximum correlation
        % Compute the number of errors in information bits and update sum
        error = error + sum(xor(c(I,1:k),codeword(1:k)));
        
        % Hard-decision decoding
        hard = (rec < 0);
        syn = mod(hard*H',2);
        index = 4*syn(1) + 2*syn(2) + syn(3) + 1;
        hat_c = mod(hard+est_e(index,:),2);
        error_HD = error_HD +sum(xor(hat_c(1:k),codeword(1:k)));
        
    end % for Ns
    
    num = num + 1;
    ber(num) = error/(nsim*k);
    ber_HD(num) = error_HD/(nsim*k);
    snr(num) = SNRdB;
    
    fprintf('%5.2f\t%e \t%6.0f\n', snr(num), ber(num), error);

end % for SNRdB

EbNo = init:inc:final+1.5; EbNoratio = 10.^(EbNo/10);
% Plot the average probability of a bit error for BPSK:
semilogy(EbNo,qfunc(sqrt(2*EbNoratio)),'-k'), hold on

% Plot the simulated BER valus of hard- and soft-decision decoding
semilogy(snr,ber_HD,'-k*'), axis tight, grid on
semilogy(snr,ber,'-ks'), axis tight, grid on

% Compute union bound for ML decoding (to check decoder works) and plot it
EbNo = init:inc:final; EbNoratio = 10.^(EbNo/10);
bound = 0;
for i=1:n
    bound = bound + i*W(i+1)/n * qfunc(sqrt(2*i*(k/n)*EbNoratio));
end
semilogy(EbNo,bound,':ko'), axis([init final 5e-5 1e-1]), hold off
legend('Uncoded BPSK','HD decoding','SD decoding','Union bound')
title('Hamming (7,4,3) code with BPSK modulation (polar mapping) over an AWGN channel')
xlabel('E_b/N_0 (dB)'), ylabel('BER')
