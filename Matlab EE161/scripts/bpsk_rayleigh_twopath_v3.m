% file: bpsk_rayleigh_twopath_v3.m
% Simulation of the error performance of BPSK modulation over a symbol-
% spaced two-path channel under Rayleigh fading 
% EE 252 - San Jose State University. 

clear
seed = input('Enter your student ID: ');
rand('seed',seed); randn('seed',seed);

p(1) = input('Enter the first element of the power delay profile in dB: ');
p(2) = input('Enter the second element of the power delay profile in dB: ');

P1 = 10^(p(1)/10);
P2 = 10^(p(2)/10);
PM =  P1 + P2; 

p_n=P1/PM;
p_n_1=P2/PM;

N=1000000;
snr=0:5:40;
for m=1:size(snr,2)
    efade = 0;
    No=10^(-snr(m)/10);             % PSD of AWGN
    sigma= sqrt(No/2);              % Standard deviation
    s_n_1 = 0;
    a_n_1 = 1;
    for n=1:N
        s=(-1)^round(rand);
        x=randn/sqrt(2);
        y=randn/sqrt(2);
        p=x^2 + y^2;                % Fading Power
        a=sqrt(p);                  % Fading Amplitude
        r_n = sqrt(p_n)*a*s + sqrt(p_n_1)*a_n_1*s_n_1;
        a_n_1 = a;
        s_n_1 = s;
        r=r_n + sigma*randn;        % faded signal + AWGN
        if (r>0)
            shat=+1;
        else
            shat=-1;
        end
        if (shat ~= s)
            efade = efade + 1;
        end
    end
    pe(m)=efade/N;                  % BER
    fprintf('%f \t %e\n',snr(m),pe(m));
end

semilogy(snr,pe,'-s')
ylabel('Bit Error Rate');
xlabel('Average E/N_0 (dB)');
title('Perfomance of BPSK modulation over a two-path Rayleigh channel');
axis([ snr(1) snr(end) 1e-3 1])
grid on
hold on