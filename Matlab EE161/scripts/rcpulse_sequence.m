% file: rcpulse_sequence.m
% Plot RC pulses associated with a random bit sequence and BPSK
% Needs function rcpulse.m
% EE161 - Spring 2022. San Jose State University

clear
seed = input('Enter your student ID: ');
rand('state',seed)
a = input('Enter the rolloff factor value: ');   

T = 1;          % Normalized symbp; duration
Ns = 100;       % Number of samples per T
Nbits = 30;     % Number of bits

t=-0:T/Ns:Nbits*T+10;
y=zeros(size(t));
for n=1:Nbits
    amp(n) = 2*round(rand) -1;                  % Polar mapping, ala IEEE
    y = y + amp(n)*rcpulse(t-n*T,T,a);          % Matched-filter output
end

plot(t,y,'-k'), grid on, axis([0, Nbits -2.5 2.5]), hold on
stem(1:Nbits, amp, '-b')
ylabel('y(t)'), xlabel('t/T')
title(strcat('Raised-cosine pulses (noiseless MF output) for \alpha=',num2str(a))), hold off
