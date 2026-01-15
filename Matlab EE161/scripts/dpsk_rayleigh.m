% Simulation of the bit error rate (BER) of DPSK modulation over a 
% flat Rayleigh fading channel with random phase
% EE 161 - Spring 2013 - San Jose State University

clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

N=2000000; snr=6:2:40;
fprintf('\n   E/No   \t    BER\n');


for m=1:size(snr,2)
    efade = 0;
    No = 10^(-snr(m)/10);           % AWGN single-sided power
    sigma = sqrt(No/2);             % AWGN standard deviation

    phi = 2*pi*rand;                % Uniform random phase
    c1 = cos(phi);
    c2 = sin(phi);
    
    dprev = 0;                      % Inital state of differential encoder
    yIprev = 1;                     % Initial in-phase delay output
    yQprev = 1;                     % Initial quadrature delay output
    
    for n=1:N
        b = round(rand);            % Random bit
        d = mod(b+dprev, 2);        % Differential encoding
        dprev = d;
        
        s=(-1)^d;                   % BPSK (polar) mapping
        
        % Simulate Rayleigh fading amplitude
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x^2 + y^2;                % Fading Power
        a=sqrt(p);                  % Fading Amplitude
        
        yI = a*s*c1 + sigma*randn;  % faded in-phase symbol + AWGN
        yQ = a*s*c2 + sigma*randn;  % faded quadrature symbol + AWGN
        
        r = yIprev*yI + yQprev*yQ;
        yIprev = yI; yQprev = yQ;
        
        if (r>0) bhat= 0;           % Decision device same as BPSK!
        else     bhat= 1;   end
        
        if (bhat ~= b) efade = efade + 1; end  % Count errors 
    end
    
    pe(m)=efade/N;                  % BER flat Rayleigh fading
    fprintf('%f \t %e\n',snr(m),pe(m));
end

semilogy(snr,pe,'-ok'), axis([snr(1) snr(end) 1e-5 1e-1])
hold on, grid on, title('Performance of DPSK under Rayleigh fading')
semilogy(snr,1./(2*10.^(snr/10)),'--')
xlabel('Average E_s/N_0 (dB)'), ylabel('P_b')
legend('Simulation','Theory'), hold off