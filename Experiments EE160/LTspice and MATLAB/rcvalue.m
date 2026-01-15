% Matlab script to determine the time constant needed by an RC circuit used
% in an envelope detector. (This program was written by an EE160 student.)
% EE160. San Jose State University. Documented in Fall 2009 and Fall 2022

clc; clear all; 

fc = 20;                % Carrier signal frequency in kHz
Ac = 3;                 % Carrier signal amplitude in volts

fm = 0.2;               % Modulating frequency in kHz

tau = 0.4624;           % Time constant(ms) with R = 68 K and C = 6800 pF

a  = 0.50;              % Modulation index(must be between 0 and 1))


N = 1000;               % Number of samples per cycle 
tmax=2/fm;              % Simulate 2 periods (plot the second period)
tstep=tmax/(2*N);       % Simulation time step
t=0:tstep:tmax;         % Time values
wc=2*pi*fc;             % Carrier signal angular frequency
wm=2*pi*fm;             % Message signal angular frequency
Vm=Ac*(1+a*sin(wm*t));  % Envelope signal 
Vw=Vm.*cos(wc*t);       % Conventional AM (DSB-LC) signal
Vr=max(Vw-0.7,0);       % Half-rectifier (diode) outout with Vd = 0.7 V

Ve(1)=1;                % Initial enveope detector value
fac = exp(-tstep/tau);  % Decay factor (RC circuit response) over time

for n=2:length(Vr)      % Simulate the envelope detector
    Ve(n)=max(Vr(n),fac*Ve(n-1)); 
end 

% Plot both envelope and detected waveforms in the time domain
plot(t(1:N),Ve(N+1:2*N),'-k',t(1:N),Vm(N+1:2*N), '-k')
grid on, axis ([ 0 tmax/2 -0.1 2*Ac+0.1])
xlabel('t msec')
ylabel('Envelope Detector Output, Vo(t)')
title([ sprintf('Response for fc = %g kHz, fm = %g kHz, a = %g, ', ...
    fc, fm, a), sprintf(' RC = %g ms', tau) ])