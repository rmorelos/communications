% sinusoidal_plus_AWGN_SNR2.m
% EE 160 - Fall 2016,2017 - San Jose State University
% Illustration of AWGN effects on a received signal. The channel is
% bandpass with fc=10kHz and B=2W=2 kHz.
% The received signal is a 10 kHz sinusoidal of 1 mW power
% Noise power is computed from a given (S/N) value in dB
% Modified in Fall 2021. EE160. San Jose State University

seed = round(1e7*(now-round(now)));
randn('state',seed);

Pr = 1e-3;              % Normalized power of sinusoidal signal = 1 mW
A = sqrt(2*Pr);         % RMS amplitude of sinusoidal signal
A = sqrt(2)*A;          % Amplitude of sinusoidal
fc = 10000;             % Fundamental frequency 
Tc = 1/fc;              % Period 
B = 2000;               % Channel bandwidth

SNR_dB = input('Enter the SNR value in dB: ');
SNR = 10^(SNR_dB/10);   % SNR as a ratio
N0 = (2*Pr/B)/SNR;      % Noise power

t = -0.8*Tc:Tc/250:0.8*Tc;      % Time range of signals

% Sinusoidal signal
r = A*cos(2*pi*fc*t);

% AWGN signal with samples of variance N0*B/2
n = sqrt(N0*B)*randn(1,length(t));

plot(t, r+n,'-k'), grid on, xlabel('time'),ylabel('r(t)+n(t)')
axis ([min(t) max(t) -max(abs(r+n))*1.05 max(abs(r+n))*1.05])
title(strcat('Sinusoidal plus AWGN signal at S/N = ',num2str(SNR_dB), ...
    ' dB (', num2str(B),' Hz bandwidth)'))
hold on, plot(t,r,'--k'), hold off