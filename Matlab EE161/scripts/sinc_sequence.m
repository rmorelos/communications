% Sequence of polar amplitude sinc pulses to show no ISI
% EE161 - Spring 2023 - San Jose State University

amp = [1 -1 -1 1 -1 -1 -1 1 -1];
T=1;                                        % Symbol duration
t = -6*T:T/1000:T*length(amp)+6*T;
eT = 0.0*T;                                 % Timing error

figure(101), hold on
s = 0;
for i=0:length(amp)-1
    plot(t,amp(i+1)*sinc((t-eT-i*T)/T),'--b')
    s = s + amp(i+1)*sinc((t-eT-i*T)/T);
end

plot(t,s,'-k'), grid on, axis tight
stem([-6:1:length(amp)+6],[zeros(1,6) amp zeros(1,7)],'r')
hold off, title('A sequence of sinc pulses with polar mapping')
xlabel('Normalized time, t/T'), ylabel('s(t), A[n]'), hold off