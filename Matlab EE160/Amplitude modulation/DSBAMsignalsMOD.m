% File: DSBAMsignals.m 
% Examples of conventional DSB-AM modulated signals with a
% narrowband sinusoidal message signal.
% Copyright (c) 2009. San Jose State University.
clear all
fm=1000;        % Message frequency
fc=40000;       % Carrier frequency
t=0:1e-6:2e-3;  % Time range

a=0.25;          % Modulation index
u = (1+a*cos(2*pi*fm*t)).*cos(2*pi*fc*t);
subplot(2,2,1)
plot(t,u), grid on, xlabel('t (sec)'), title('DSB signal (a=0.25)')
axis([0 2e-3 -3 3])

a=0.5;          % Modulation index
u = (1+a*cos(2*pi*fm*t)).*cos(2*pi*fc*t);
subplot(2,2,2)
plot(t,u), grid on, xlabel('t (sec)'), title('DSB signal (a=0.5)')
axis([0 2e-3 -3 3])

a=0.75;          % Modulation index
u = (1+a*cos(2*pi*fm*t)).*cos(2*pi*fc*t);
subplot(2,2,3)
plot(t,u), grid on, xlabel('t (sec)'), title('DSB signal (a=0.75)')
axis([0 2e-3 -3 3])

a=1.5;          % Modulation index
u = (1+a*cos(2*pi*fm*t)).*cos(2*pi*fc*t);
subplot(2,2,4)
plot(t,u), grid on, xlabel('t (sec)'), title('DSB signal (a=1.5 Overmodulation)')
axis([0 2e-3 -3 3])
