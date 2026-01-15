% File: dpsk_deltaf.m
% Simulation of the bit error rate (BER) of DPSK modulation over an
% AWGN channel with random phase and frequency error
% EE 252 - Fall 2013 - San Jose State University

clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);
deltafT = input('Enter the normalized frequency error deltafT: ');

N=5000000; snr=2:1:11;
fprintf('\n   E/No   \t    BER\n');


for m=1:size(snr,2)
    err = 0;
    No = 10^(-snr(m)/10);           % AWGN single-sided power
    sigma = sqrt(No/2);             % AWGN standard deviation
    
    phi = 2*pi*rand;                % Uniform random (but constant) phase
    
    dprev = 0;                      % Inital state of differential encoder
    yIprev = 1;                     % Initial in-phase delay output
    yQprev = 1;                     % Initial quadrature delay output
    
    for n=1:N
        b = round(rand);            % Random bit
        d = mod(b+dprev, 2);        % Differential encoding
        dprev = d;
        
        s=2*d-1;                    % BPSK (polar) mapping
        
        phi = phi + 2*pi*deltafT;   % Phase rotation due to frequency error
        
        yI = s*cos(phi) + sigma*randn;    % in-phase symbol + AWGN
        yQ = s*sin(phi) + sigma*randn;    % quadrature symbol + AWGN
        
        r = yIprev*yI + yQprev*yQ;
        yIprev = yI; yQprev = yQ;
        
        if (r>0) bhat= 0;           % Decision device same as BPSK!
        else     bhat= 1;   end
        
        if (bhat ~= b) err = err + 1; end  % Count errors
    end
    
    pe(m)=err/N;                  % BER
    fprintf('%f \t %e\n',snr(m),pe(m));
end

%figure
semilogy(snr,pe,'-ok'), grid on, hold on
%axis([2 11 9.99999e-6 1e-1])
%semilogy(snr,0.5*exp(-10.^(snr/10)),'-*k')
%semilogy(snr,0.5*qfunc(sqrt(2*10.^(snr/10))),'-^k')
%legend('DPSK sim','DPSK theory','BPSK coherent')
%title(strcat('Performance of DPSK with normalized frequency error, \Delta fT=', ...
%    num2str(deltafT)))
%hold off
