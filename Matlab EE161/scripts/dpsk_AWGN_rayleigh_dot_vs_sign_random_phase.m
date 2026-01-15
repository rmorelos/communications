% file: dpsk_AWGN_rayleigh_dor_vs_sign.m
% Simulation of the bit error rate (BER) of DPSK modulation over (1) a 
% flat Rayleigh fading channel and (2) AWGN channel, both with random phase
% EE 161 - Spring 2024 - San Jose State University

clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

N=1e7;
snr=0:2:40;
fprintf('----------------------------------------------\n');
fprintf('   E/No   \t  AWGN  \t  Rayleigh\n');
fprintf('----------------------------------------------\n');


tic
for m=1:size(snr,2)
    efade = 0; egauss = 0;
    efade_s = 0; egauss_s = 0;
    No = 10^(-snr(m)/10);               % AWGN single-sided power
    sigma = sqrt(No/2);                 % AWGN standard deviation

    phi = 2*pi*rand;                    % Uniform random (but constant) phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    phi = pi/3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    c1 = cos(phi);
    c2 = sin(phi);
    
    dprev = 0;                          % Inital state of differential encoder
    yIprev = 1;                         % Initial in-phase delay output
    yQprev = 1;                         % Initial quadrature delay output
    ygaussIprev = 1;                    % Initial in-phase delay output
    ygaussQprev = 1;                    % Initial quadrature delay output
    
    for n=1:N
        b = round(rand);                % Random bit
        
        d = mod(b+dprev, 2);            % Differential encoding
        dprev = d;
        s=2*d-1;                        % BPSK (polar) mapping
        
        % ------------    Rayleigh fading amplitude   -----------------
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x^2 + y^2;                    % Fading Power
        a=sqrt(p);                      % Fading Amplitude

    % phi = phi+2*pi*0.0001;                    % Uniform random (but constant) phase
    % c1 = cos(phi);
    % c2 = sin(phi);


        yI = a*s*c1 + sigma*randn;      % faded in-phase symbol + AWGN
        yQ = a*s*c2 + sigma*randn;      % faded quadrature symbol + AWGN
        
            %%%%%%%%%%%%%%%%   DOT PRODUCT   %%%%%%%%%%%%%%%
        r = yIprev*yI + yQprev*yQ;
        
        if (r>0) bhat= 0;               % Decision device same as BPSK!
        else     bhat= 1;   end
        if (bhat ~= b), efade = efade + 1; end  % Count errors 

            %%%%%%%%%%%%%%%%   SIGN BASED    %%%%%%%%%%%%%%%
        if ( sign(yIprev)==sign(yI) || sign(yQprev)==sign(yQ) ) bhat_s= 0;
        else bhat_s= 1; end
        if (bhat_s ~= b), efade_s = efade_s + 1; end  % Count errors 
        
        % ------------            No fading           -----------------
        yIgauss = s*c1 + sigma*randn;   %  in-phase symbol + AWGN
        yQgauss = s*c2 + sigma*randn;   %  quadrature symbol + AWGN
        
            %%%%%%%%%%%%%%%%   DOT PRODUCT   %%%%%%%%%%%%%%%
        r = ygaussIprev*yIgauss + ygaussQprev*yQgauss;
        
        if (r>0) bhat= 0;               % Decision device same as BPSK!
        else     bhat= 1;   end
        if (bhat ~= b), egauss = egauss + 1; end  % Count errors 
        
            %%%%%%%%%%%%%%%%   SIGN BASED    %%%%%%%%%%%%%%%
        if ( sign(ygaussIprev)==sign(yIgauss) || sign(ygaussQprev)==sign(yQgauss) ) bhat_s= 0;
        else bhat_s= 1; end
        if (bhat_s ~= b), egauss_s = egauss_s + 1; end  % Count errors 

        yIprev = yI; yQprev = yQ;
        ygaussIprev = yIgauss; ygaussQprev = yQgauss;

    end
    
    pe1(m)=efade/N;                     % BER flat Rayleigh fading
    pe2(m)=egauss/N;                    % BER AWGN channel
    pe1_s(m)=efade_s/N;                     % BER flat Rayleigh fading
    pe2_s(m)=egauss_s/N;                    % BER AWGN channel
    fprintf('%f \t %e\t %e\t %e\t %e\n',snr(m),pe2(m),pe1(m),pe2_s(m),pe1_s(m));
end
toc

semilogy(snr,pe1,'-ok'), hold on, semilogy(snr,pe2,'-*k')
semilogy(snr,pe1_s,'-^r'), semilogy(snr,pe2_s,'-sr')
axis([snr(1) snr(end) 1e-5 1]), grid on
semilogy(snr,1./(2*(1+10.^(snr/10))),'--sk')
semilogy(snr,(1/2)*exp(-10.^(snr/10)),'--^k'), hold off
xlabel('Average E_s/N_0 (dB)'), ylabel('Bit error rate')
title('Performance of sign and dot-product demodulators for DPSK')
legend('Simulation Rayleigh dot','Simulation AWGN dot',...
    'Simulation Rayleigh sign', 'Simulation AWGN sign',...
    'Theory Rayleigh', 'Theory AWGN')

