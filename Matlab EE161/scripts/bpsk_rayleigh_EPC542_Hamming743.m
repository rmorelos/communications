% File: bpsk_rayleigh_EPC542_Hamming743.m
% Simulation of BPSK over under flat Rayleigh fading. Ilustration
% of the (time) diversity achieved with an even parity-check
% (5,4,2) and a Hamming (7,4,3) code.
% Ideal interleaving (i.e., very large block interveaver length) assumed
% so that fading amplitudes are uncorrelated. Maximum-likelihood decoding.
% EE 161 - Spring 2014 - San Jose State University. Modified in 2015/2020

clear all

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

% -----------------------------------------------------------------
%             Parameters of the EPC (5,4,2) code
% -----------------------------------------------------------------
nc = 5;                 % Code length EPC code
kc = nc-1;              % Code dimension EPC code
Gc = [ 1 0 0 0 1        % Generator matrix
    0 1 0 0 1
    0 0 1 0 1
    0 0 0 1 1 ];
b =  [ 0 0 0 0          % Information vectors
    0 1 0 0
    1 0 0 0
    1 1 0 0
    0 0 1 0
    0 1 1 0
    1 0 1 0
    1 1 1 0
    0 0 0 1
    0 1 0 1
    1 0 0 1
    1 1 0 1
    0 0 1 1
    0 1 1 1
    1 0 1 1
    1 1 1 1 ];

% All codewords and their modulated (BPSK or polar mapping) versions
cc = mod(b*Gc,2); mc = 1-2*cc;

% -----------------------------------------------------------------
%            Parameters of the Hamming (7,4,3) code
% -----------------------------------------------------------------
nh = 7;                 % Code length Hamming code
kh = 4;                 % Code dimension Hamming code
H = [ 1 1 1 0 1 0 0     % Systematic parity-check matrix
    1 1 0 1 0 1 0
    1 0 1 1 0 0 1 ];
P = H(1:3,1:4);         % Parity submatrix
G = [ eye(4) P'];       % Generator matrix

% All codewords and their modulated (BPSK or polar mapping) versions
c = mod(b*G,2); mh = 1-2*c;

N = 1e+7;               % Maximum number of codewords sent per E/No value

snr=4:1:18;             % Es/N0 values in dB

fprintf('Starting simulation with Es/No from %f to %f \n\n', snr(1),snr(end));
fprintf('\nThis script will take SEVERAL MINUTES to finish. Patience ...\n\n');
fprintf('-----------------------------------------------------------------\n');
fprintf('Es/No     \t BPSK     \t     EPC     \t     Hamming\n');
fprintf('-----------------------------------------------------------------\n');

tic
for m=1:length(snr)
    err = 0; error = 0; error_h = 0;                 % Error counters
    n = 0;
    No=10^(-snr(m)/10);                     % PSD of AWGN
    sigma=sqrt(No/2);                       % Standard deviation
    
    while ( (error_h<500) && (n<N) )
        
        % ------------    Uncoded BPSK   ------------
        mess = round(rand(1,4)); symb = 1 - 2*mess; % Map: 0 -> +, 1 -> -
        x=randn(1,4)/sqrt(2); y=randn(1,4)/sqrt(2);
        p=x.^2 + y.^2;                      % Fading Power
        a=sqrt(p);                          % Fading Amplitude
        rec = a.*symb + + sigma*randn(1,4); % Faded symbols + AWGN
        est = (rec <= 0);
        err = err + sum(xor(mess,est));
        
        % ------------  EPC(nc,nc-1,2) code  ------------
        par = 0;
        for (k=1:kc)
            code(k) = round(rand);
            par = mod(par+code(k),2);
        end
        code(nc) = par;                     % Parity-check position
        s=1-2*code;                         % BPSK mapping
        x=randn(1,nc)/sqrt(2); y=randn(1,nc)/sqrt(2);
        p=x.^2 + y.^2;                      % Fading Power
        a=sqrt(p);                          % Fading Amplitude
        r=a.*s + sigma*randn(1,nc);         % Faded symbols + AWGN
        % Maximum-likelihood decoding: Correlation !!!
        [cor,I] = max(r*mc');           % I: Index of maximum correlation
        % Compute the number of errors in information bits and update sum
        error = error + sum(xor(cc(I,1:kc),code(1:kc)));
        
        if snr(m) <= 14 
            % ---------  Hamming (7,4,3) code  -----------
            msg = round(rand(1,kh));            % Random binary message vector
            codeword = mod(msg*G,2);            % Encoding
            sh = 1-2*codeword;                  % BPSK mapping
            x=randn(1,nh)/sqrt(2); y=randn(1,nh)/sqrt(2);
            p=x.^2 + y.^2;                      % Fading Power
            a=sqrt(p);                          % Fading Amplitude
            rec = a.*sh + sigma*randn(1,nh);    % Add AWGN to received vector
            % Maximum-likelihood decoding: Correlation !!!
            [cor,I] = max(rec*mh');          % I: Index of maximum correlation
            % Compute the number of errors in information bits and update sum
            error_h = error_h + sum(xor(c(I,1:k),codeword(1:k)));
        end
        
        n = n + 1;

    end

    peb(m) = err/(4*n);                     % BER uncoded BPSK
    pe(m)  = error/(n*kc);                  % BER of EPC(3,2,2) code
    peh(m) = error_h/(n*kh);                % BER of Hamming(7,4,3) code
    fprintf('%f \t %e \t %e \t %e\n',snr(m),peb(m),pe(m),peh(m));

end

toc

snr_r = 10.^(snr/10);

semilogy(snr,peb,'-ok'), hold on
pb = (1/2)*(1 - sqrt(snr_r./(1+snr_r)));
semilogy(snr, pb,'-+r')                 % Theory BPSK

semilogy(snr,pe,'-*k'), 
p_epc = (10 /(2*(5)))*( 1./((4/5)*snr_r) ).^2;
semilogy(snr, p_epc,'-.r')              % Approximation EPC code

semilogy(snr,peh,'-^k')
p_ham = (7 /(2*(7)))*( 1./((4/7)*snr_r) ).^3;
semilogy(snr, p_ham,'--r')              % Approximation EPC code

ylabel('Bit Error Rate')
xlabel('Average E_s/N_0 (dB)')
title('BPSK modulation under flat Rayleigh fading with EPC(5,4,2) and Hamming (7,4,3) codes');
legend('BPSK', 'Theory BPSK', ...
    'EPC(5,4,2)', 'Approximation EPC(5,4,2)', ...
    'Hamming(7,4,3)', 'Approximation Hamming(7,4,3)')

axis([snr(1) snr(end) 1e-5 1e-1]), grid on, hold off
