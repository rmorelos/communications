% Abdallah Obidat 10-16-2021
clc
clear
% %% Create a normalized raised-cosine (RC) pulse, centered at 0 Hz
% % set parameters of raised-cosine pulse

fc = 895e6; % carrier frequency
fb = 250e3; % bit rate

%  alpha = 0.1; % rolloff parameter
% 
%  % create pulse and plot it on a new figure
%  [f1, RC1] = normalized_RC_pulse(alpha, fb);
%  plot(f1, RC1), title("normalized raised-cosine centered at origin")
%  xlabel("frequency, Hz"), ylabel("magnitude")
%  %% Plot RC pulse after modulating with carrier frequency
% 
%  [f2, RC2] = normalized_RC_pulse(alpha, fb);
%  f2_pos = (f2+fc)./1e6;
%  f2_neg = (f2-fc)./1e6;
% 
%  figure
%  plot(f2_pos, RC2), title("Normalized RC Pulse at +f_c")
%  xlabel("frequency, MHz"), ylabel("magnitude")
%  figure
%  plot(f2_neg, RC2), title("Normalized RC Pulse at -f_c")
%  xlabel("frequency, MHz"), ylabel("magnitude")

 %% Generate "Power Content" curves for RC pulses at +/- fc

 [f_0p01, RC3_alpha_0p01] = normalized_RC_pulse(0.01, fb);
 f_0p01 = (f_0p01+fc)./1e6;

 [f_0p35, RC3_alpha_0p35] = normalized_RC_pulse(0.35, fb);
 f_0p35 = (f_0p35+fc)./1e6;

 [f_0p99, RC3_alpha_0p99] = normalized_RC_pulse(0.99, fb);
 f_0p99 = (f_0p99+fc)./1e6;

 power_content_alpha_0p01 = 20.*log10(RC3_alpha_0p01);
 power_content_alpha_0p35 = 20.*log10(RC3_alpha_0p35);
 power_content_alpha_0p99 = 20.*log10(RC3_alpha_0p99);

 figure(1)
 subplot(3,1,1)
 plot(f_0p01, power_content_alpha_0p01,'-k'), grid on
 ylim([-41, 10])
 title("Power spectrum, \alpha  = 0.01")
 xlabel("frequency (MHz)"), ylabel("magnitude, dB")
 subplot(3,1,2)
 plot(f_0p35, power_content_alpha_0p35,'-k'), grid on
 ylim([-41, 10])
 title("Power spectrum, \alpha  = 0.35")
 xlabel("frequency (MHz)"), ylabel("magnitude, dB")
 subplot(3,1,3)
 plot(f_0p99, power_content_alpha_0p99,'-k'), grid on
 ylim([-41, 10])
 title("Power spectrum, \alpha  = 0.99")
 xlabel("frequency (MHz)"), ylabel("magnitude, dB")

 %% raised-cosine function generator function
 function [freq, RC] = normalized_RC_pulse(roll_off, bit_rate)
 %%
 % generates a raised-cosine pulse centered at f = 0 Hz
 % rolloff must be between 0 and 1
 %%
 T = 1/bit_rate;

 f1 = (-1/(2*T))-(roll_off/(2*T)):10:(-1/(2*T))+(roll_off/(2*T));
 f2 = (-1/(2*T))+(roll_off/(2*T)):10:(1/(2*T))-(roll_off/(2*T));
 f3 = (1/(2*T))-(roll_off/(2*T)):10:(1/(2*T))+(roll_off/(2*T));

 raised_cosine_center = T+zeros(1,length(f2));
 raised_cosine_left = T/2.*(1+cos(((pi.*T)./roll_off).*(-f1-((1-roll_off)./(2.*T)))));
 raised_cosine_right = T/2.*(1+cos(((pi.*T)./roll_off).*(f3-((1-roll_off)./(2.*T)))));

 freq = [f1, f2, f3];
 RC = [raised_cosine_left, raised_cosine_center, raised_cosine_right]./T;
 end