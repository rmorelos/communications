% File: bpsk_EPC322_Interleaver23.m
% Simulation of BPSK with a binary EPC (3,2,2) channel code, using a block
% interleavear with J=2 and M=3, under block Rayleigh fading Tc/T = NB = 2
% EE 161 - Spring 2019 - San Jose State University

clear 
seed = input('Enter your student ID: ');
rand('state',seed); randn('state',seed);

k_epc = 2; n_epc = 3; dmin = 2;     % Parameters of channel code
J = 2; M = 3;                       % Parameters of interleaver
NB = 2;                             % NB symbols/fading amplitude
N = 175000*n_epc;                   % Number of bits per E/No value
snr = 5:5:40;                       % Es/N0 values in dB


Gc = [ 1 0 1                        % Generator matrix of EPC(3,2,2) code
       0 1 1];
bc = [ 0 0                          % 2-bit information vectors
       0 1
       1 0
       1 1];
% All codewords and their modulated BPSK versions:
cc = mod(bc*Gc,2); mc = 2*cc-1;


fprintf('Starting simulation with Es/No from %.1f to %.1f\n', snr(1),snr(end));
fprintf('Block Rayleigh fading of length = %d\n', NB);
fprintf('BPSK modulated EPC(3,2,2) code used with and without interleaving\n');
fprintf('-----------------------------------------------------------------\n');
fprintf('Es/No     \t   Uncoded   \t Interleaver \t No interleaver\n');
fprintf('-----------------------------------------------------------------\n');

for m=1:length(snr)
    
    No=10^(-snr(m)/10);                     % PSD of AWGN
    sigma=sqrt(No/2);                       % Standard deviation

    error_1 = 0; error_2 = 0; error_3 = 0;  % Error counters
    
    n = 0; nlast = N;
    while (n < nlast)       

        % ---------------------- EPC(3,2,2) ------------------------
        % Codeword 1
        par = 0;
        for (k=1:k_epc)
            code1(k) = round(rand);
            par = mod(par+code1(k),2);
        end
        code1(n_epc) = par;                 % Parity-check bit
        s1=2*code1-1;                       % BPSK modulation
        % Codeword 2
        par = 0;
        for (k=1:k_epc)
            code2(k) = round(rand);
            par = mod(par+code2(k),2);
        end
        code2(n_epc) = par;                 % Parity-check bit
        s2=2*code2-1;                       % BPSK modulation

        % ***********     Interleaver     ************
        s(1) = s1(1); s(2) = s2(1); s(3) = s1(2);
        s(4) = s2(2); s(5) = s1(3); s(6) = s2(3);
        
        % >>>>>>>>>>> NO INTERLEAVER <<<<<<<<<<<<<<<<
        sNI(1:3) = s1(1:3); sNI(4:6) = s2(1:3);
        
        % >>>>>>>>>>>>>>>   Block fading NB=2, block 1   <<<<<<<<<<<<<
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x.^2 + y.^2;                      % Fading Power
        a=sqrt(p);                          % Fading Amplitude

        r(1:2)=a.*s(1:2)     + sigma*randn(1,NB);   % Interleaved
        rNI(1:2)=a.*sNI(1:2) + sigma*randn(1,NB);   % Not interleaved
        % ---------------------- Uncoded ---------------------------
        mess1 = round(rand(1,NB)); symb = 2*mess1 - 1; 
        rec1 = a*symb + sigma*randn(1,NB);      % Faded symbols + AWGN
        est1 = (rec1 > 0);
        error_1 = error_1 + sum(xor(mess1,est1));      
        
        % >>>>>>>>>>>>>>>   Block fading NB=2, block 2   <<<<<<<<<<<<<
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x.^2 + y.^2;                      % Fading Power
        a=sqrt(p);                          % Fading Amplitude

        r(3:4)=a.*s(3:4)     + sigma*randn(1,NB);   % Interleaved
        rNI(3:4)=a.*sNI(3:4) + sigma*randn(1,NB);   % Not interleaved
        % ---------------------- Uncoded ---------------------------
        mess1 = round(rand(1,NB)); symb = 2*mess1 - 1; 
        rec1 = a*symb + sigma*randn(1,NB);      % Faded symbols + AWGN
        est1 = (rec1 > 0);
        error_1 = error_1 + sum(xor(mess1,est1));      

        % >>>>>>>>>>>>>>>   Block fading NB=2, block 3   <<<<<<<<<<<<<
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x.^2 + y.^2;                      % Fading Power
        a=sqrt(p);                          % Fading Amplitude

        r(5:6)=a.*s(5:6)     + sigma*randn(1,NB);   % Interleaved
        rNI(5:6)=a.*sNI(5:6) + sigma*randn(1,NB);   % Not interleaved
        % ---------------------- Uncoded ---------------------------
        mess1 = round(rand(1,NB)); symb = 2*mess1 - 1; 
        rec1 = a*symb + sigma*randn(1,NB);      % Faded symbols + AWGN
        est1 = (rec1 > 0);
        error_1 = error_1 + sum(xor(mess1,est1));      

        % ***********    Deinterleaver   ************
        r1(1) = r(1); r1(2) = r(3); r1(3) = r(5);
        r2(1) = r(2); r2(2) = r(4); r2(3) = r(6);
        
        % Maximum-likelihood decoding of interleaved sequence 1
        [cor,I] = max(r1*mc');              % I: Index maximum correlation
        % Compute the number of errors in information bits and update sum
        error_2 = error_2 + sum(xor(cc(I,1:k_epc),code1(1:k_epc)));
        % Maximum-likelihood decoding of interleaved sequence 2
        [cor,I] = max(r2*mc');              % I: Index maximum correlation
        % Compute the number of errors in information bits and update sum
        error_2 = error_2 + sum(xor(cc(I,1:k_epc),code2(1:k_epc)));
         
        % >>>>>>>>>>>    NO INTERLEAVER  <<<<<<<<<<<<<
        r1(1:3) = rNI(1:3);
        r2(1:3) = rNI(4:6);
        % Maximum-likelihood decoding of interleaved sequence 1
        [cor,I] = max(r1*mc');              % I: Index maximum correlation
        % Compute the number of errors in information bits and update sum
        error_3 = error_3 + sum(xor(cc(I,1:k_epc),code1(1:k_epc)));
        [cor,I] = max(r2*mc');              % I: Index maximum correlation
        % Compute the number of errors in information bits and update sum
        error_3 = error_3 + sum(xor(cc(I,1:k_epc),code2(1:k_epc)));
        
        n = n + 1;

    end
            
    pe1(m) = error_1/(N*n_epc*NB);      % BER uncoded
    pe2(m) = error_2/(N*k_epc*NB);      % BER EPC code + interleaving
    pe3(m) = error_3/(N*k_epc*NB);      % BER EPC code NO interleaving
    fprintf('%f \t %e \t %e \t %e\n',snr(m),pe1(m),pe2(m),pe3(m));
end

semilogy(snr,pe1,'-ok'), hold on
semilogy(snr,pe3,'-*k'), semilogy(snr,pe2,'-^k'), ylabel('Bit Error Rate')
xlabel('Average E_s/N_0 (dB)');
title(strcat('BPSK modulation under block Rayleigh fading of length NB=', ...
    num2str(NB)));
legend('Uncoded','EPC(3,2,2) No Interleaver','EPC(3,2,2)  Iterleaver')
axis([snr(1) snr(end) 1e-6 0.1]), grid on, hold off
