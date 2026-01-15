% file: Trellis_dpsk_vs_bpsk_AWGN_rayleigh.m
% Simulation of the bit error rate (BER) of DPSK modulation over (1) a 
% flat Rayleigh fading channel and (2) AWGN channel, both with random phase
% EE 161 - Spring 2019 - San Jose State University

clear all

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

phase=input('Enter the value of propagation phase in degrees: ');    
phi = phase*pi/180;                % Fixed value of phase

N=20000000;
snr=0:2:42;
fprintf('-------------------------------------------------------------------------------\n');
fprintf('   E/No   \t  AWGN  \t \t Rayleigh  \t \t AWGN    \t   \t Rayleigh\n');
fprintf('-------------------------------------------------------------------------------\n');


tic 
for m=1:size(snr,2)
    efade = 0; egauss = 0;          % Error counters for DPSK
    befade = 0; begauss = 0;        % Error counters of BPSK
    No = 10^(-snr(m)/10);           % AWGN single-sided power
    sigma = sqrt(No/2);             % AWGN standard deviation

%    phi = 2*pi*rand;                % Uniform random (but constant) phase
    c1 = cos(phi);
    c2 = sin(phi);
    
    dprev = 1;                      % Inital state of differential encoder
    yIprev = 1;                     % Initial in-phase delay output
    yQprev = 1;                     % Initial quadrature delay output
    ygaussIprev = 1;                % Initial in-phase delay output
    ygaussQprev = 1;                % Initial quadrature delay output
    
    for n=1:N
        b = round(rand);                % Random bit
        
        d = mod(b+dprev, 2);            % Differential encoding
        dprev = d;
        s=2*d-1;                        % BPSK (polar) mapping
        
        sb=2*b-1;                       % BPSK without differential encoding
        
        % ------------    Rayleigh fading amplitude   -----------------
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x^2 + y^2;                    % Fading Power
        a=sqrt(p);                      % Fading Amplitude
        
        yI = a*s*c1 + sigma*randn;      % faded in-phase symbol + AWGN
        yQ = a*s*c2 + sigma*randn;      % faded quadrature symbol + AWGN
        
        yIb = a*sb*c1 + sigma*randn;    % BPSK faded symbol + AWGN

        r = yIprev*yI + yQprev*yQ;
        yIprev = yI; yQprev = yQ;
        
        if (r>0) bhat= 0;               % Decision device same as BPSK!
        else     bhat= 1;   end
        if (bhat ~= b), efade = efade + 1; end  % Count errors 

        if (yIb<0) bbhat= 0;            % BPSK w/o diffential encoding
        else     bbhat= 1;   end
        if (bbhat ~= b), befade = befade + 1; end  % Count errors 
        
        % ------------            No fading           -----------------
        yIgauss = s*c1 + sigma*randn;   %  in-phase symbol + AWGN
        yQgauss = s*c2 + sigma*randn;   %  quadrature symbol + AWGN
        
        r = ygaussIprev*yIgauss + ygaussQprev*yQgauss;
        ygaussIprev = yIgauss; ygaussQprev = yQgauss;
        
        if (r>0) bhat= 0;               % Decision device same as BPSK!
        else     bhat= 1;   end
        if (bhat ~= b), egauss = egauss + 1; end  % Count errors 

        yIb = sb*c1 + sigma*randn;       % BPSK symbol + AWGN

        if (yIb<0) bbhat= 0;            % BPSK w/o diffential encoding
        else     bbhat= 1;   end
        if (bbhat ~= b), begauss = begauss + 1; end  % Count errors 
        
    end
    
    pe1(m)=efade/N;                     % BER flat Rayleigh fading
    pe2(m)=egauss/N;                    % BER AWGN channel
    pe3(m)=befade/N;                    % BER flat Rayleigh fading
    pe4(m)=begauss/N;                   % BER AWGN channel    
    fprintf('%f \t %e\t %e\t %e\t %e\n',snr(m),pe2(m),pe1(m),pe4(m),pe3(m));
end
toc

semilogy(snr,pe1,'-ok'), hold on, semilogy(snr,pe2,'-vk')
semilogy(snr,pe3,'-<r'), semilogy(snr,pe4,'-^r')
axis([snr(1) snr(end) 1e-5 3e-1]), grid on
semilogy(snr,1./(2*(1+10.^(snr/10))),'--sk')        % Theory DPSK Rayleigh
semilogy(snr,(1/2)*exp(-10.^(snr/10)),'-->k')       % Theory DPSK AWGN
semilogy(snr,(1/2)*(1 - sqrt((10.^(snr/10))./(1+10.^(snr/10)))),'--sr') % Theory BPSK Rayleigh
semilogy(snr,qfunc(sqrt(2*10.^(snr/10))),'--+r'),       % Theory BPSK AWGN
hold off
xlabel('Average E_s/N_0 (dB)'), ylabel('Bit error rate')
title(strcat('Performance of DPSK versus BPSK, \phi = ',num2str(phase), ' deg'))
legend('DPSK Rayleigh','DPSK AWGN','BPSK Rayleigh', ...
'BPSK AWGN','Theory DPSK Rayleigh','Theory DPSK AWGN', ...
'Theory BPSK Rayleigh','Theory BPSK AWGN')

