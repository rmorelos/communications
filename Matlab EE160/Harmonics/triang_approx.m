% Approximation of a triangular waveform signal by sinusoidals
% EE 161. San Jose State University. Spring 2007, Fall 2021
clear all

t = -1.5:0.01:1.5;              % Time axis values

x1 = 2*sinc(1/2)^2*cos(2*pi*t);
subplot(4,1,1);
plot(t,x1);
axis([-1.5 1.5 -1 1]);
title('Fundamental');
ylabel('x_1(t)')
grid on

x2 = x1 + 2*sinc(3/2)^2*cos(6*pi*t);
subplot(4,1,2);
plot(t,x2);
axis([-1.5 1.5 -1 1]);
title('Fundamental and 3rd harmonic');
ylabel('x_3(t)')
grid on

x3 = x2 + 2*sinc(5/2)^2*cos(10*pi*t);
subplot(4,1,3);
plot(t,x3);
axis([-1.5 1.5 -1 1]);
title('Up to 5th harmonic');
ylabel('x_5(t)')
grid on

x4 = x3 + 2*sinc(7/2)^2*cos(14*pi*t) + 2*sinc(9/2)^2*cos(18*pi*t) ...
        + 2*sinc(11/2)^2*cos(22*pi*t) + 2*sinc(13/2)^2*cos(26*pi*t) ...
        + 2*sinc(15/2)^2*cos(30*pi*t) + 2*sinc(17/2)^2*cos(34*pi*t);
subplot(4,1,4);
plot(t,x4);
axis([-1.5 1.5 -1 1]);
title('Up to 17th harmonic');
ylabel('x_{13}(t)')
xlabel('t (sec)')
grid on