% File: frequency_response_multipath.m
% Plot frequency response amplitude of a symbol-spaced multipath channel 
% EE161. Spring 2022. 
% San Jose State University
clear
c = input('Enter the channel coefficients: ');

f = -0.501:0.001:0.501;
C = zeros(1,length(c));
for n=1:length(f)
    C(n) = 0;
    for m=1:length(c)
        C(n) = C(n) + c(m)*exp(-01i*2*pi*f(n)*(m-1));
    end
end
% Plot channel frequency response normalized with respect to 1/T
plot(f,abs(C),'-k'), xlabel('Normalized frequency, fT'), grid on
axis tight, ylabel('|C(f)|')
title(strcat('Multipath channel. Coefficients: ',num2str(c)))