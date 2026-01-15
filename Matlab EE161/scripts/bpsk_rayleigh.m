% Simulation of the bit error rate (BER) of BPSK modulation over a 
% flat Rayleigh fading channel 
% EE 161 - Spring 2011 - San Jose State University
% Modified Spring 2013 and Spring 2024

clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

N=500000; snr=0:1:30;
fprintf('\n   E/No   \t    BER\n');

for m=1:size(snr,2)
    efade = 0;
    egaus = 0;
    No=10^(-snr(m)/10);             % AWGN single-sided power
    sigma= sqrt(No/2);              % AWGN standard deviation
    for n=1:N
        s=(-1)^round(rand);
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x^2 + y^2;                % Fading Power
        a=sqrt(p);                  % Fading Amplitude
        r=a*s + sigma*randn;        % faded signal + AWGN
        rg = s + sigma*randn;       % unfaded signal + AWGN
        if (r>0) shat=+1;           % Decision device
        else     shat=-1;   end
        if (rg>0)  sh=+1;           % Decision device
        else       sh=-1;   end
        if (shat ~= s) efade = efade + 1; end  % Error with fading
        if (sh ~= s)   egaus = egaus + 1; end  % Error without fading
    end
    pe(m)=efade/N;                  % BER flat Rayleigh fading
    peg(m)=egaus/N;                 % BER AWGN only
    fprintf('%f \t %e\n',snr(m),pe(m));
end

semilogy(snr,pe,'-k^'), hold on, semilogy(snr,peg,'--k*')
legend('Rayleigh channel','AWGN channel');
ylabel('Bit Error Rate'); xlabel('Average E_b/N_0 (dB)');
title('Perfomance of BPSK over flat-Rayleigh and AWGN channels');
axis([ snr(1) snr(end) 1e-4 1e-1]), grid on, hold on