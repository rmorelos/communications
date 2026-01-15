% file: dpsk_AWGN_rayleigh.m
% Simulation of the bit error rate (BER) of DPSK modulation over (1) a 
% flat Rayleigh fading channel and (2) AWGN channel, both with random phase
% EE 161 - Spring 2019 - San Jose State University

clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

N=2700000;
snr=0:2:40;
fprintf('----------------------------------------------\n');
fprintf('   E/No   \t  AWGN  \t  Rayleigh\n');
fprintf('----------------------------------------------\n');


tic
for m=1:size(snr,2)
    efade = 0; egauss = 0;
    No = 10^(-snr(m)/10);           % AWGN single-sided power
    sigma = sqrt(No/2);             % AWGN standard deviation

    phi = 2*pi*rand;                % Uniform random (but constant) phase
    c1 = cos(phi);
    c2 = sin(phi);
    
    dprev = 0;                      % Inital state of differential encoder
    yIprev = 1;                     % Initial in-phase delay output
    yQprev = 1;                     % Initial quadrature delay output
    ygaussIprev = 1;                     % Initial in-phase delay output
    ygaussQprev = 1;                     % Initial quadrature delay output
    
    for n=1:N
        b = round(rand);                % Random bit
        
        d = mod(b+dprev, 2);            % Differential encoding
        dprev = d;
        s=2*d-1;                        % BPSK (polar) mapping
        
        % ------------    Rayleigh fading amplitude   -----------------
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x^2 + y^2;                    % Fading Power
        a=sqrt(p);                      % Fading Amplitude
        
        yI = a*s*c1 + sigma*randn;      % faded in-phase symbol + AWGN
        yQ = a*s*c2 + sigma*randn;      % faded quadrature symbol + AWGN
        
        r = yIprev*yI + yQprev*yQ;
        yIprev = yI; yQprev = yQ;
        
        if (r>0) bhat= 0;               % Decision device same as BPSK!
        else     bhat= 1;   end
        if (bhat ~= b), efade = efade + 1; end  % Count errors 
        
        % ------------            No fading           -----------------
        yIgauss = s*c1 + sigma*randn;   %  in-phase symbol + AWGN
        yQgauss = s*c2 + sigma*randn;   %  quadrature symbol + AWGN
        
        r = ygaussIprev*yIgauss + ygaussQprev*yQgauss;
        ygaussIprev = yIgauss; ygaussQprev = yQgauss;
        
        if (r>0) bhat= 0;               % Decision device same as BPSK!
        else     bhat= 1;   end
        if (bhat ~= b), egauss = egauss + 1; end  % Count errors 
        
    end
    
    pe1(m)=efade/N;                     % BER flat Rayleigh fading
    pe2(m)=egauss/N;                    % BER AWGN channel
    fprintf('%f \t %e\t %e\n',snr(m),pe2(m),pe1(m));
end
toc

semilogy(snr,pe1,'-ok'), hold on, semilogy(snr,pe2,'-*k')
axis([snr(1) snr(end) 1e-5 1e-1]), grid on
semilogy(snr,1./(2*(1+10.^(snr/10))),'--sk')
semilogy(snr,(1/2)*exp(-10.^(snr/10)),'--^k'), hold off
xlabel('Average E_s/N_0 (dB)'), ylabel('Bit error rate')
title('Performance of differential BPSK (DPSK)')
legend('Simulation Rayleigh','Simulation AWGN','Theory Rayleigh', 'Theory AWGN')

