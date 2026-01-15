% File: baseline_wander2.m
% Compute the running average of several pulse shaping techniques
% The average is computed over Nb=10 bits
% A tail of 10 zeros is appended at the end of the bit sequence
% EE 160 - Fall 2012 - San Jose State University
% Modified June 2013 and Fall 2021 

clear
seed = mod(1e6*now, 100000);
rand('state',seed)

Tb=1/10;        % Bit duration
N= 10;          % Samples per bit (must be even)
Nb=10;          % Window size in bits
Nw=N*Nb;        % Window size in samples
Nsim=10*Nb;     % Number of bits simulated (must a multiple of Nb)
Ns=N*Nsim;      % Total number of samples simulated

P0=input('Probability of a zero: ');
fprintf('Be patient ...\n');

% Bit sequence
bits = rand(1,Nsim) > P0;

% Signal samples
s_UNRZ = [];    % Unipolar NRZ
s_PNRZ = [];    % Polar NRZ
s_PRZ  = [];    % Polar RZ
s_M    = [];    % Polar Manchester
for i=1:Nsim
    s_UNRZ = [s_UNRZ bits(i)*ones(1,N)];
    s_PNRZ = [s_PNRZ (2*bits(i)-1)*ones(1,N)];
    s_PRZ  = [s_PRZ  (2*bits(i)-1)*[ones(1,N/2) zeros(1,N/2)]];
    s_M    = [s_M    (2*bits(i)-1)*[ones(1,N/2) -ones(1,N/2)]];
end

% -------------------------------------------------------------
% Add a tail of zeros
s_UNRZ = [s_UNRZ zeros(1,Nw)];
s_PNRZ = [s_PNRZ zeros(1,Nw)];
s_PRZ  = [s_PRZ  zeros(1,Nw)];
s_M =    [s_M    zeros(1,Nw)];
% -------------------------------------------------------------

figure

% Plot signals
subplot(4,1,1), plot(s_UNRZ(1:Ns),'-k'), axis([0 Ns -0.1 1.1]), grid on
title('Unipolar NRZ signal'), hold on
subplot(4,1,2), plot(s_PNRZ(1:Ns),'-k'), axis([0 Ns -1.1 1.1]), grid on
title('Polar NRZ signal'), hold on
subplot(4,1,3), plot(s_PRZ(1:Ns),'-k'), axis([0 Ns -1.1 1.1]), grid on
title('Polar RZ signal'), hold on
subplot(4,1,4), plot(s_M(1:Ns),'-k'), axis([0 Ns -1.1 1.1]), grid on
title('Polar Manchester signal'), hold on

% Running average for Unipolar NRZ
w1 = s_UNRZ(1:Nw);
for i=1:Ns
    av_UNRZ(i) = sum(w1)/Nw;
    % Slide the window
%     for j=0:Nw-2
%         w1(Nw-j) = w1(Nw-j-1);
%     end
    for j=1:Nw-1
        w1(Nw-j+1) = w1(Nw-j);
    end
    % New sample
    w1(1)=s_UNRZ(Nw+i);
end
subplot(4,1,1), plot(av_UNRZ(1:Ns),'b'), hold off

% Running average for Polar NRZ
w2 = s_PNRZ(1:Nw);
for i=1:Ns
    av_PNRZ(i) = sum(w2)/Nw;
    % Slide the window
    for j=0:Nw-2
        w2(Nw-j) = w2(Nw-j-1);
    end
    % New sample
    w2(1)=s_PNRZ(Nw+i);
end
subplot(4,1,2), plot(av_PNRZ(1:Ns),'b'), hold off

% Running average for Polar RZ
w3 = s_PRZ(1:Nw);
for i=1:Ns
    av_PRZ(i) = sum(w3)/Nw;
    % Slide the window
    for j=0:Nw-2
        w3(Nw-j) = w3(Nw-j-1);
    end
    % New sample
    w3(1)=s_PRZ(Nw+i);
end
subplot(4,1,3), plot(av_PRZ(1:Ns),'b'), hold off

% Running average for (polar) Manchester
w4 = s_M(1:Nw);
for i=1:Ns
    av_M(i) = sum(w4)/Nw;
    % Slide the window
    for j=0:Nw-2
        w4(Nw-j) = w4(Nw-j-1);
    end
    % New sample
    w4(1)=s_M(Nw+i);
end
subplot(4,1,4), plot(av_M(1:Ns),'b'), hold off
xlabel('sample index, n (10 samples per bit)')