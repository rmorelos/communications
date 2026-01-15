% Plot of an FM signal modulated by a sinusoidal
% EE160 - Fall 2010 - San Jose State University

fprintf('Plot of a unit-amplitude FM signal of center frequency 100 Hz\n')
fprintf('modulated by a 10-Hz unit-amplitude sinusoidal signal\n')
Ac=1; fc=100; a=1; fm=10; 
Bf=input('Enter the value of the modulation index: ');

kf =Bf*fm;

t=0:1e-5:0.5;
m=a*cos(2*pi*fm*t);
fi=fc+kf*m;
u=Ac*cos(2*pi*fc*t + Bf*sin(2*pi*fm*t));

clf reset
subplot(3,1,1), plot(t,m,'-k'), axis([t(1) t(length(t)) -1.1 1.1])
ylabel('m(t)'), title('Message signal, m(t)'), grid on
subplot(3,1,2), plot(t,fi,'-k'), axis([t(1) t(length(t)) 0 1.1*(fc+kf)])
ylabel('f_i(t)'), title('Instantaneous frequency, f_i(t)'), grid on
subplot(3,1,3), plot(t,u,'-k'), axis([t(1) t(length(t)) -1.1 1.1])
xlabel('t (sec)'), ylabel('u(t)'), grid on
title('Frequency modulated signal, u(t)')