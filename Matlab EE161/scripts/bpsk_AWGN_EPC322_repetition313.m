% Simulation of BPSK under AWGN with a binary even parity-check 
% (3,2,2) code and a binary repetition (3,1,3) code.
% Maximum-likelihood decoding. 
% EE 161 - Spring 2025 - San Jose State University

clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

N = 2e+6;               % Maximum number of codewords sent per E/No value

% ----------     Parameters of the binary EPC (3,2,2) code     ------------
nc = 3;                 % Code length EPC code
kc = nc-1;              % Code dimension EPC code
Gc = [ 1 0 1            % Generator matrix
       0 1 1 ];
b =  [ 0 0              % Information vectors
       0 1
       1 0
       1 1 ];
       
% All codewords and their modulated (BPSK or polar mapping, 802.11) versions
cc = mod(b*Gc,2); mc = 2*cc-1;

% ---------   Parameters of the binary repetiion (3,1,3) code   -----------
nh = 3;                 % Code length repetition code
kh = 1;                 % Code dimension repetition code
H = [ 1 0 1             % Systematic parity-check matrix
      0 1 1 ];
G = [ 1 1 1 ];          % Generator matrix
br = [ 0                % Information vectors
       1 ];
   
% All codewords and their modulated (BPSK or polar mapping) versions
c = mod(br*G,2); mh = 2*c-1;


snr=-2:0.5:6;

fprintf('\nThis script may take several minutes to finish. Please be patient ...\n\n');
fprintf('-----------------------------------------------------------------\n');
fprintf('Eb/No     \t BPSK     \t     EPC     \t     Repetition\n');
fprintf('-----------------------------------------------------------------\n');
    
for m=1:size(snr,2)
    err = 0; error = 0; error_h = 0;                 % Error counters
    n = 0;
    No=10^(-snr(m)/10);                     % PSD of AWGN
    sigma=sqrt(No/2);                       % Standard deviation
    
    while ( (error_h<150) && (n<N) )
        
        % ------------    Uncoded BPSK   ------------
        mess = round(rand(1,4)); symb = 1 - 2*mess;
        rec = symb + sigma*randn(1,4); % symbols + AWGN
        est = (rec <= 0);
        err = err + sum(xor(mess,est));

        % ------------  EPC(nc,nc-1,2) code  ------------
        par = 0;
        for (k=1:kc)
            code(k) = round(rand);
            par = mod(par+code(k),2);
        end
        code(nc) = par;                     % Parity-check position
        s=2*code-1;                         % BPSK mapping
        r=s + sigma*randn(1,nc);            % Symbols + AWGN
        
        % Maximum-likelihood decoding of EPC (nc,nc-1,2) code: Correlation!
        [cor,I] = max(r*mc');           % I: Index of maximum correlation
        % Compute the number of errors in information bits and update sum
        error = error + sum(xor(cc(I,1:kc),code(1:kc)));
        
        % --------   Repetition (nh,1,nh) code  ----------
        msg = round(rand);                  % Random binary message vector
        codeword = msg*G;                   % Encoding
        sh = 2*codeword-1;                  % BPSK mapping
        rec = sh + sigma*randn(1,nh);        % Add AWGN to received vector
        % Maximum-likelihood decoding: Correlation !!!
        cor = sum(rec);                     % Correlation with all-one vector
        if cor < 0, I=1;
        else I=2; end
        % Compute the number of errors in information bits and update sum
        error_h = error_h + sum(xor(c(I,1),codeword(1)));
        
        n = n + 1;
    end
    peb(m) = err/(4*n);                     % BER uncoded BPSK
    pe(m)  = error/(n*kc);                  % BER of EPC(3,2,2) code
    peh(m) = error_h/(n*kh);                % BER of Hamming(3,1,3) code
    fprintf('%f \t %e \t %e \t %e\n',snr(m),peb(m),pe(m),peh(m));
end

snr_r = 10.^(snr/10);

semilogy(snr,peb,'-ok'), hold on
% pb = (1/2)*(1 - sqrt(snr_r./(1+snr_r)));
% semilogy(snr, pb,'-+r')                 % Theory BPSK

semilogy(snr,pe,'-*k')
% p_epc = (3 /(2*(3)))*( 1./((2/3)*snr_r) ).^2;
% semilogy(snr, p_epc,'-.r')              % Approximation EPC code

semilogy(snr,peh,'-^k')
% p_ham = (1 /(2*(3)))*( 1./((4/7)*snr_r) ).^3;
% semilogy(snr, p_ham,'--r')              % Approximation Hamming code

ylabel('Bit Error Rate')
xlabel('Average E_s/N_0 (dB)');
title('BPSK modulation under AWGN with binary (3,2,2) and (3,1,3) codes');
legend('BPSK',... % 'Theory BPSK', ...
    'EPC(3,2,2)', ...%'Approximation EPC(3,2,2)', ...
    'Hamming(3,1,3)') %, 'Approximation Hamming(3,1,3)')

axis([snr(1) snr(length(snr)) 9e-5 1e-1]), grid on, hold off