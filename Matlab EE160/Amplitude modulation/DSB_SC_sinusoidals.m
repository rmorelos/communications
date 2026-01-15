% File: DSB_SC_sinusoidals.m
% ---------------------------------------------------------------
% Plots of signals associated with DSB-SC AM
% m   : Message signal, fm = 1 kHz, amplitude = 1
% c   : Carrier signal, fc = 10 kHz, amplitude = 1
% cLO : Local oscillator (LO) signal, fLO = 20 kHz, amplitude = 1
% z   : Multiplier (mixer) output
% y   : Lowpass filter (LPF) output
% ---------------------------------------------------------------
% Script to fix the sketch done in the whiteboard, which did not show the
% mixer output as a double-frequency sinusoidal ...
%
% EE160 - Fall 2021 - San Jose State University

clear 
seed = input('Enter your student ID: ');
rand('state',seed);
%%%%%%%%%%%%%%%%%%%%%%%%   MODULATOR   %%%%%%%%%%%%%%%%%%%%%%%%%%
% Message signal
fm = 1000;  t = -1/fm : 4e-6 : 1/fm; m = cos(2*pi*fm*t + rand*2*pi);
% Carrier signal
fc = 20000; c = cos(2*pi*fc*t);
% DSC-SC AM signal
u = m .* c;

figure(1)
subplot(3,1,1), plot(t,m,'-k'), axis tight
title('Message signal: m(t), 1 kHz'), grid on
axis([t(10) t(end-10) -1.1 1.1])
subplot(3,1,2), plot(t,c,'-k'), axis tight
title('Carrier signal: c(t), 20 kHz'), grid on
axis([t(10) t(end-10) -1.1 1.1])
subplot(3,1,3), plot(t,u,'-k'), axis tight
title('DSB-SC signal: u(t)'), grid on
axis([t(10) t(end-10) -1.1 1.1])

%%%%%%%%%%%%%%%%%%%%%%%   DEMODULATOR   %%%%%%%%%%%%%%%%%%%%%%%%%
% LO signal
fLO = 20000; cLO = 2*cos(2*pi*fLO*t);
% Mixer output
z = u .* cLO;
% Lowpass filter output
y = lowpass(z, 1.5e3, 1e6);

figure(2)
subplot(3,1,1), plot(t,cLO,'-k'), axis tight
title('LO carrier signal: c_{LO}(t), 20 kHz'), grid on
axis([t(10) t(end-10) -2.2 2.2])
subplot(3,1,2), plot(t,z,'-k'), axis tight
title('Mixer output: z(t), 40 kHz'), grid on
axis([t(10) t(end-10) -2.2 2.2])
subplot(3,1,3), plot(t,y,'-k'), axis tight
title('Lowpass filter output: y(t), 1 kHz'), grid on
axis([t(10) t(end-10) -1.1 1.1])

