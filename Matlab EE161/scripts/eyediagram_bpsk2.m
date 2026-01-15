% File: eyediagram_bpsk.m
% Eye diagrams of raised cosine pulses with three rolloff factor values.
% San Jose State University. Copyright (c) 2013. Robert Morelos-Zaragoza.
% Modified Spring 2014 and Spring 2022

clear
seed = input('Enter your student ID: ');
rand('state',seed)

T=1;            % Symbol period
No = 10;        % Oversampling factor
av=[0.25 0.5 0.9];   % Rolloff factor values

figure(300)
for n=1:length(av)
    a = av(n);
    
    % Raised-cosine pulse in the interval [-5T,5T]
    t=-5*T:T/No+eps:5*T+T/No;
    x = (sin(pi*t/T)./(pi*t/T)) .* cos(a.*pi*t/T)./((1-4*a^2.*(t/T).^2));
    tT = eps:T/No+eps:T;

    % Data sequence of 300 bits with polar mapping ...
    data = 1-2*round(rand(1,300));

    % Corresponding RC pulse sequence
    N = length(x)+(length(data)+1)*length(tT);
    rcseq = zeros(1,N);
    for i=1:length(data)
        rcseq = rcseq + [zeros(1,length(tT)*(i-1)) x*data(i) ...
            zeros(1,N-length(tT)*(i-1)-length(x))];
    end

    % Plot the eye diagram
    hold on
    for i=1:length(data)-1
        if n == 1
            subplot(3,1,1), hold on
            plot(rcseq(ceil(length(tT)*(i-1)+5.5*length(tT))+1:...
                ceil(length(tT)*(i-1)+6.5*length(tT))+1),'k');
        elseif n == 2
            subplot(3,1,2), hold on
            plot(rcseq(ceil(length(tT)*(i-1)+5.5*length(tT))+1:...
                ceil(length(tT)*(i-1)+6.5*length(tT))+1),'k');
        else
            subplot(3,1,3), hold on
            plot(rcseq(ceil(length(tT)*(i-1)+5.5*length(tT))+1:...
                ceil(length(tT)*(i-1)+6.5*length(tT))+1),'k');
        end
    end
end
labels = [(-ceil(No/2):1:ceil(No/2)+1)/No];
subplot(3,1,1), axis tight, set(gca,'XTickLabel',labels), grid on
title('Eye diagram for \alpha = 0.25'), hold off
subplot(3,1,2), axis tight, set(gca,'XTickLabel',labels), grid on
title('Eye diagram for \alpha = 0.59'), hold off
subplot(3,1,3), axis tight, set(gca,'XTickLabel',labels), grid on
title('Eye diagram for \alpha = 0.90'), hold off
% you get the idea ... can modify the length of the pulse and alpha ...