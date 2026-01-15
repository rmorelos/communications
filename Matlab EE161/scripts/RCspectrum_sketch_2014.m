% File: RCspectrum_sketch.m
% EE161 - Spring 2014. San Jose State University

W=1e6;                    % Lowpass (equivalent) bandwidth in Hz
alpha=[1 0.35 0.1];      % Rolloff values
f = -1.125*W:W/100:1.125*W; % Frequency range
clear X

for j = 1:length(alpha)
    a = alpha(j);           % Rollof factor
    T = (1+a)/(2*W);        % Symbol duration
    % Raised cosine spectrum
    for k = 1:length(f)
        if ( (abs(f(k)) >= 0) && (abs(f(k)) < (1-a)/(2*T)) )
            X(j,k) = T;
        elseif ( (abs(f(k)) >= (1-a)/(2*T)) && (abs(f(k)) < (1+a)/(2*T)) )
            X(j,k) = (T/2)*(1+cos((pi*T/a)*(abs(f(k))-(1-a)/(2*T))));
        else
            X(j,k) = 0;
        end
    end
end

figure(4)
for j = 1:length(alpha)
    if j==1, plot(f,X(j,:),'-k'), axis tight, hold on
    elseif j==2, plot(f,X(j,:),'--k')
    else plot(f,X(j,:),'-.k'), end
end
hold off
xlabel('Frequency, f (Hz)'), ylabel('|X(f)|'), grid on
legend('\alpha = 1', '\alpha = 0.35', '\alpha = 0.1')