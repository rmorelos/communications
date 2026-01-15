% Fourier series coefficients of a clipped sinusoidal signal
% Copyright (c) 2008, 2014, 2023. Robert Morelos-Zaragoza. SJSU
clear all
theta = 0:pi/1000:pi;
d=theta/pi;
for n=1:5
    c(n,:)=(d/2).*(sinc(d*(n-1))+sinc(d*(n+1))-2*cos(theta).*sinc(d*n));
    % c(n,:) = abs(c(n,:));
end

figure(1)
% Plot the power of each harmonic in dBV
subplot(5,1,1),plot(d,c(1,:),'-k'), ylabel('x_1'), axis tight, grid on
subplot(5,1,2),plot(d,c(2,:),'-k'), ylabel('x_2'), axis tight, grid on
subplot(5,1,3),plot(d,c(3,:),'-k'), ylabel('x_3'), axis tight, grid on
subplot(5,1,4),plot(d,c(4,:),'-k'), ylabel('x_4'), axis tight, grid on
subplot(5,1,5),plot(d,c(5,:),'-k'), ylabel('x_5'), axis tight, grid on
xlabel('Duty cycle, \tau/T_0')

c = abs(c);
figure(2)
% Plot the power of each harmonic in dBV
subplot(5,1,1),plot(d,20*log10(c(1,:)),'-k'), ylabel('|x_1| (dBV)'), axis([0 1 -90 0]), grid on
subplot(5,1,2),plot(d,20*log10(c(2,:)),'-k'), ylabel('|x_2| (dBV)'), axis([0 1 -90 0]), grid on
subplot(5,1,3),plot(d,20*log10(c(3,:)),'-k'), ylabel('|x_3| (dBV)'), axis([0 1 -90 0]), grid on
subplot(5,1,4),plot(d,20*log10(c(4,:)),'-k'), ylabel('|x_4| (dBV)'), axis([0 1 -90 0]), grid on
subplot(5,1,5),plot(d,20*log10(c(5,:)),'-k'), ylabel('|x_5| (dBV)'), axis([0 1 -90 0]), grid on
xlabel('Duty cycle, \tau/T_0')