% Name: MLdecoder_322code.m
% Simulation of soft-decision (maximum-likelihood) decoding of a binary 
% (3,2,2) code with BPSK modulation over an AWGN channel.
% EE161. Spring 2025. San Jose State University

clear all

n = 3;                              % Code length
k = 2;                              % Code dimension
dmin = 2;                           % Minimum distance
rate = k/n;                         % Rate

G = [ 1 0 1  
      0 1 1 ];                      % Generator matrix

fprintf('-------------------------------------------------------------\n');
fprintf('Montecarlo simulation of soft-decision decoding of a binary\n');
fprintf('(3,2,2) code with BPSK modulation over an AWGN channel\n');
fprintf('-------------------------------------------------------------\n');

W = [1 0 3 0];                      % The weight distribution W(C) of C

% Matrices with the codewords (v) and their modulated versions (m) used
% to compute correlations in the decoder:
v = [ 0 0 0 
      0 1 1 
      1 0 1 
      1 1 0 ];
m = 1-2*v;                          % Mapping:  0 -> +1   and   1 -> -1

% Print the weight distribution
fprintf('Weight distribution: W(C)={1');
for i=2:n+1
    fprintf(',%d',W(i))
end
fprintf('}\n\n');

nsim = 300000;                      % Number of codewords per Eb/No value
init = 0;                           % Inital value of Eb/No(dB)
inc = 0.5;                          % Increment in Eb/No(dB)
final = 8;                          % Final value of Eb/No(dB)
num=0;                              % Index for bit error rate (BER) values

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

fprintf('\nEb/No(dB) \tBER   \t\tErrors\n');
fprintf('------------------------------\n');

for SNRdB = init:inc:final
    
    error = 0;  TotalNumError = 0;  TotalN = 0; % Counters
    SNRdBs = SNRdB + 10*log(rate)/log(10);      % Energy with rate loss
    No = (10.^(-SNRdBs/10)); Var = No/2;        % AWGN variance
    
    for Ns = 1:nsim
        
        msg = randi([0,1],1,k);         % Random binary message vector
        codeword = mod(msg*G,2);        % Compute the codeword in C (mod 2)
        x = 1-2*codeword;               % BPSK mapping
        rec = x + sqrt(Var)*randn(1,n); % Add AWGN to received vector
        
        % ML decoding: Correlation !!!
        [cor,I] = max(rec*m');          % I: Index of maximum correlation
        
        % Compute the number of errors in information bits and update sum
        error = error + sum(xor(v(I,1:k),codeword(1:k)));
        
    end % for Ns
    
    num = num + 1;
    ber(num) = error/(nsim*k);
    snr(num) = SNRdB;
    
    fprintf('%5.2f\t%e \t%6.0f\n', snr(num), ber(num), error);

end % for SNRdB

EbNo = init:inc:final+1.5; EbNoratio = 10.^(EbNo/10);
% Plot the average probability of a bit error for BPSK:
semilogy(EbNo,qfunc(sqrt(2*EbNoratio)),'-k'), hold on

% Compute union bound for ML decoding (to check decoder works) and plot it
EbNo = init:inc:final; EbNoratio = 10.^(EbNo/10);
bound = 0;
for i=1:n
    bound = bound + i*W(i+1)/n * qfunc(sqrt(2*i*(k/n)*EbNoratio));
end
semilogy(EbNo,bound,':ko')

% Plot simulation results
semilogy(snr,ber,'-ks'), axis tight, grid on
xlabel('E_b/N_0 (dB)'), ylabel('Bit Error Rate'), axis([0 9 1e-5 1e-1])
title('Performance of an EPC (3,2,2) code with BPSK under AWGN')

EbNo=0:0.5:9; N=length(EbNo);
targetBER=1e-4*ones(1,N); 
semilogy(EbNo,targetBER,'-r')
hold off
legend('BPSK', 'Union bound', 'Simulation','Target P_b')
