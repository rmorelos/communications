% File: run_RAKE.m
% Simulation of a RAKE receiver with BPSK modulation, using spread-spectrum
% pulses of length 31, over a two-path channel. 
% EE 161 - Spring 2014,2022 - SJSU.  

clear all
seed = input('Enter your student ID: ');
randn('state',seed)                 % Seeds set to produce same random numbers
rand('state',seed)
Nsim = 300000;                      % Maximum number of simulated bits
init=0; step=2; final=20;           % Initial, step and final SNR values
SNRVec = [init:step:final];
Tf=100;
Nav=4;

c = input('Four-path channel gains: ');
aest = input('Estimated four-path channel gains: ');

fprintf('\nSimulation of a four-finger RAKE receiver under Rayleigh fading')
fprintf('\nPlease be patient, as it will take several minutes to finish!!\n\n');

ser = []; 
for n = 1:length(SNRVec)
    SNR = SNRVec(n);
    sim('RAKE_SS_4F_Rayleigh_2024b');
    ser(n) = ErrorVec(1);
    fprintf('%5.2f\t%e\n', SNR,ser(n));
end;

semilogy(SNRVec,ser,'-s')
axis([init final 1e-4 5e-1])
grid on
%legend(strcat('Est=[',num2str(aest),']'));
xlabel('E/N_0 (dB)'); ylabel('BER')
title('Spread-spectrum and BPSK modulation with a four-finger RAKE receiver')
hold on
