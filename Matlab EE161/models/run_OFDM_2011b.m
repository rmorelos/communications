% File: run_OFDM_2023.m
% Script to simulate the performance of OFDM with QPSK modulation
% with the number of carriers N as parameter. The cyclic prefix length
% is fixed to N/4 (25%) in the model.
% EE 161 - Spring 2011 - San Jose State University. Modified Spring 2015

seed=input('Enter the last five digits of your student ID: ');
rand('state',seed);
randn('state',seed);

K = input('Enter the number of carriers (power of two, greater than 4):');
h = input('Enter channel coefficients: ');

SNRVec = [20:5:100];

ser = []; 
for n = 1:length(SNRVec)
    SNR = SNRVec(n);
    sim('OFDM_system_QPSKmod_2023b');
    ser(n) = ErrorVec(1);
    fprintf('%5.2f\t%e\n',SNR,ser(n));
end;
semilogy(SNRVec,ser,'b-s')
axis tight, grid on, xlabel('E/N_0 (dB)'), ylabel('SER')
axis([SNRVec(1) SNRVec(length(SNRVec)) 1e-5 1e-1])
title('Montecarlo simulation of OFDM with QPSK modulation over a multipath channel')
hold on
