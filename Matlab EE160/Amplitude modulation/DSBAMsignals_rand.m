% File: DSBAMsignals_rand.m 
% Examples of conventional DSB-AM modulated signals with a
% narrowband sinusoidal message signal.
% Copyright (c) 2019,2022. San Jose State University.

clear 
seed = input('Enter your student ID: ');
rand('state',seed);

clear all
fm=1000;        % Message frequency
fc=40000;       % Carrier frequency
t=0:1e-6:2e-3;  % Time range

a=input('Enter the modulation index, a: ');
u = (1+a*cos(2*pi*fm*t+rand*2*pi)).*cos(2*pi*fc*t);

plot(t,u), grid on, xlabel('t (sec)')
title(strcat('A DSB-LC signal with modulation index a = ', num2str(a)))
axis([0 2e-3 -3 3])
