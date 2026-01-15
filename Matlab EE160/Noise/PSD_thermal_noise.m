% PSD_thermal_noise.m
% Power spectral density of thermal noise. From "Introduction to Wireless
% Systems", 2011, Prentice Hall. Modified 2019.
% EE160. San Jose State University
%
R = 1e6;            % Resistance of noise source in ohms
T = 295;            % Room temperature in degrees Kelvin
k = 1.38e-23;       % Boltzmann's constant
h = 6.63e-34;       % Planck's constant
f = 0:1e8:3e13;     % Frequency range
S = (2*h*abs(f)*R)./(exp(h*abs(f)./(k*T))-1);
semilogx(f,10*log10(S/1e-3),'-k')
axis([1e8 2e13 -120 -110])
grid on, ylabel('S_N(f) in dBm/Hz'), xlabel('Frequency in Hz')
title('Power Spectral Density of Thermal Noise')