% File: polar_sinc_pulses.m
% Polar mapping and sinc pulses for communication over a bandlimited channel
% EE161 - Spring 2018 - San Jose State University
% Modified in Spring 2019 to use student ID

clear all
seed = input('Enter your student ID: ');
rand('state',seed)

B = round(rand(1,8));   % Bit sequence
A = 2*B - 1;                    % Polar mapping

N=100;
dt = 1/N+eps; tp = -5:dt:10;

figure(1)
for i=1:length(B)
    for j=1:length(tp)
        S(i,j) = A(i)*sinc(tp(j));
        Si(j) = A(i)*sinc(tp(j)-i+1);
    end
    plot(Si,'--r'), hold on
end
grid on, axis tight

Ss = zeros(1,(15+length(B)-1)*N);
for i=1:length(B)
    for j=1:length(tp)
        Ss((i-1)*N+j) = Ss((i-1)*N+j)+S(i,j);
    end
end
plot(Ss(1:15*N+1),'-k'),grid on, axis tight
title(strcat('sinc pulse sequence, B = [',num2str(B,'%2d'),' ]'))
hold on, stem([500:100:1200],A)
hold off, set(gca,'XTicklabel',-3:2:10)
xlabel('Normalized time, t/T')