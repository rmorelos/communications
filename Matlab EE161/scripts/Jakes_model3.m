% file: Jakes_model3.m
% -----------------------------------------------------------------------
% Simulation of multipath Rayleigh fading using Jakes' model
% Reference: Willian C. Jakes, Ed., Microwave Mobile Communications, IEEE
% Press, 1974, Chapter 1, Section 1.7 "Laboratory Simulation of Multipath
% Intereference"
% EE 161 - Spring 2013 - San Jose State University
% -----------------------------------------------------------------------
% Modified in Spring 2019: Histogram, autocorrelation and power spectrum
% -----------------------------------------------------------------------

clear

seed=input('Enter your student ID: ');
rand('state',seed);

fm = input('Enter the maximum Doppler frequency, fm = ');

Ns = 10000; 
tinit = rand*13/fm;                         % Random inital time
tfinal = tinit+10/fm;                       % Time range = 10 * Tc
dt = (tfinal-tinit)/Ns;
t = tinit:dt:tfinal;

NO = 8; % Number of oscillators
n = 1:NO;
gamma = 2*pi*(round(rand*NO)-1)/(NO+1);     % Random 
beta_n = gamma + pi*n/NO;                   % Phases
fn = fm * cos(2*pi*n/NO);                   % Doppler shifts

for i=1:length(t)
    xc(i) = (1/sqrt(2))*cos(2*pi*fm*t(i)) ...
                                 + 2*sum(cos(beta_n).*cos(2*pi*fn*t(i)));
    xs(i) = (1/sqrt(2))*cos(2*pi*fm*t(i)) ...
                                 + 2*sum(sin(beta_n).*cos(2*pi*fn*t(i)));
end

fade = sqrt(xc.^2 + xs.^2);
phase = atan2(xs,xc);

figure(1)
plot(t-tinit,20*log10(fade),'-k'), axis tight, grid on
xlabel('time (sec)'), ylabel('Fading envelope (dB)')
title(strcat('Jakes'' model of multipath Rayleigh fading. Maximum Doppler frequency, fm = ',...
    num2str(fm), ' Hz'))

figure(2)
hist(fade,30), axis tight, grid on
title(strcat('Histogram of Jakes model fading, fm = ',num2str(fm), ' Hz'))

% C = xcorr(fade);
% S = fft(C);
% figure(3)
% plot(10*log(abs(S))), axis tight, grid on
% xlabel('Frequency'), ylabel('Power spectral density (dBW)')
% title(strcat('Jakes'' model of multipath Rayleigh fading. Maximum Doppler frequency, fm = ',...
%     num2str(fm), ' Hz'))