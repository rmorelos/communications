% FM signals.m
% Note: You need scripts u.m (unit step function), P.m (unit rectangular 
% pulse) and D.m (unit triangular pulse)
% EE160 - Fall 2022. San Jose State University
clear all

clear 
seed = input('Enter your student ID: ');
rand('state',seed);

fc=40; Ac=1;                        % Carrier signal parameters
kf=2; kp = 1.5*pi;                  % Deviation constants
t=-0.5:1e-4:0.5;                    % Time sample vector

% Message signal:
m = 2*cos(2*pi*t);
% m = 5*D(2*t); 
% m = 10*( P(2*(t+0.25))- P(2*(t-0.25)) );
% m = 3*sinc(8*t);

fi = fc + kf*m;                     % Instantaneous freuqency
u_FM = Ac * cos(2*pi*fi.*t - 2*pi*rand);        % FM signal
u_PM = Ac * cos(2*pi*fc*t + kp*m - 2*pi*rand);  % PM signal

% Plots:
figure(1)
subplot(4,1,1), plot(t,m,'-k'), xlabel('t (sec)'),ylabel('m(t)')
axis ([t(1) t(length(t)) min(m)-0.1 max(m)+0.1]) , grid on
title('Message signal, m(t)')

subplot(4,1,2), plot(t,fi,'-k'), xlabel('t (sec)'),ylabel('f_i(t)')
axis ([t(1) t(length(t)) min(fi)-0.5 max(fi)+0.5]), grid on
title(strcat('Instantaneous frequency, f_i(t) with f_c= ', ...
    num2str(fc),' Hz and k_f= ', num2str(kf)))

subplot(4,1,3), plot(t,u_FM,'-k'), xlabel('t (sec)'),ylabel('u_{FM}(t)')
axis tight, grid on
title(strcat('FM signal, u_{FM}(t) with f_c= ', ...
    num2str(fc),' Hz and k_f= ', num2str(kf)))

subplot(4,1,4), plot(t,u_PM,'-k'), xlabel('t (sec)'),ylabel('u_{PM}(t)')
axis tight, grid on
title(strcat('PM signal, u_{PM}(t) with f_c= ', ...
    num2str(fc),' Hz and k_p= ', num2str(kp)))
