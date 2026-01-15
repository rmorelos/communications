% File: outages.m
% EE 161 - Spring 2023 - San Jose State University
 
clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

% Outage threshold
gamma_T = input('Enter the value of threshold Es/No in dB:'); %%%5; 

N=1000000;
x=randn(1,N)/sqrt(2); y=randn(1,N)/sqrt(2);
p=x.^2 + y.^2;                      % Fading Power
a=sqrt(p);                          % Fading Amplitude

EsNo_dB = (0.7+2*rand)*10;            % Average Es/No
EsNo = 10^(EsNo_dB/10);
p_dBm = EsNo_dB + 10*log10(p);

figure(1)
subplot(2,1,1)
histogram(a,100), grid on, axis tight, title('Normalized fading amplitude distribution')
subplot(2,1,2)
histogram(p*EsNo,100), grid on, axis tight, title('Normalized power distribution')

figure(2)
No = 250;                           % Number of samples to plot

% Average Es.No (dB)
gamma0 = EsNo_dB + 10*log10(mean(p))*ones(1,No);

% Outage rate
Po = sum(p_dBm < gamma_T)/length(p);

plot(1:No, p_dBm(1:No)), hold on, plot(1:No, gamma0, '--b')
plot(1:No, gamma_T*ones(1,No), '-r')
hold off, grid on, axis tight
title(strcat('Received E_s/N_0 (dB). Mean = ', num2str(EsNo_dB), ...
    ' dB, Threshold = ',num2str(gamma_T), ' dB, P_o = ', num2str(Po,'%.3f')));
xlabel('Sample'), ylabel('E_s/N_o (dB)')

