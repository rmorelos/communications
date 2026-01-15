% File: pulse_shaping2.m
% Description: Illustration of line coding schemes
% EE 160. Fall 2006. San Jose State University.
% Modified Spring 2014 and 2015 for EE161. Fall 2016 for EE160.

clear

A = 1;                                   % Pulse amplitude
T = 1;                                   % Bit duration
bit = input('Input the bit sequence (example [1 0 0 1]): ');
N = length(bit);

% Uncomment the four lines below if random bits are to be generated ...
% seed = input('Enter your student ID: ');
% rand('state',seed)
% N = 20;                                  % Number of bits  
% bit = round(rand(1,N));                  % Bit sequence

polar = [ -A +A ];                       % Polar mapping
M = 32;                                  % Oversampling ratio (must be even)
T_bits = T*length(bit);                  % Duration of bit stream
t = 1/M:1/M:T_bits ;                     % Time scale

bit_M= [];
for i=1:length(bit)
    bit_M = [bit_M bit(i)*ones(1,M)];    % Oversampled bit stream
end

p_NRZ(1:M)=1;                            % NRZ pulse
p_RZ(1:M/2)=1; p_RZ(M/2:M)=0;            % RZ pulse
p_M(1:M/2)=-1; p_M(M/2:M)=1;             % Manchester pulse

% (a) Unipolar NRZ
for i=1:length(bit)
    for j=(i-1)*M+1:i*M
        s_UNRZ(j) = bit(i)*A*p_NRZ(j-(i-1)*M);
    end
end

% (b) Unipolar RZ
for i=1:length(bit)
    for j=(i-1)*M+1:i*M
        s_URZ(j) = bit(i)*A*p_RZ(j-(i-1)*M);
    end
end

% (c) Polar NRZ
for i=1:length(bit)
    for j=(i-1)*M+1:i*M
        s_PNRZ(j) = polar(bit(i)+1)*p_NRZ(j-(i-1)*M);
    end
end

% (d) Polar RZ
for i=1:length(bit)
    for j=(i-1)*M+1:i*M
        s_PRZ(j) = polar(bit(i)+1)*p_RZ(j-(i-1)*M);
    end
end

% (e) AMI NRZ
st = [-A*ones(1,M)];                    % Inital amplitude -A
for i=1:length(bit)
    if bit(i), st = -st; end
    for j=(i-1)*M+1:i*M
        AMI_NRZ(j) = bit(i)*st(j-(i-1)*M)*p_NRZ(j-(i-1)*M);
    end
end

% (f) AMI RZ
st = [-A*ones(1,M)];                    % Inital amplitude -A
for i=1:length(bit)
    if bit(i), st = -st; end
    for j=(i-1)*M+1:i*M
        AMI_RZ(j) = bit(i)*st(j-(i-1)*M)*p_RZ(j-(i-1)*M);
    end
end

% (g) Manchester
for i=1:length(bit)
    for j=(i-1)*M+1:i*M
        s_M(j) = polar(bit(i)+1)*p_M(j-(i-1)*M);
    end
end

% Plot all signals
subplot(7,1,1)
plot(t,bit_M,'k'); ylabel ('Bits'); axis ([ 0 T_bits  -0.1 1.1 ])
set(gca,'YTick',[0 1])
title('Examples of line coding schemes - SJSU - EE161 - S14')
subplot(7,1,2)
plot(t,s_UNRZ,'k'); ylabel ('U-NRZ'); axis ([ 0 T_bits  -0.1*A 1.1*A ])
subplot(7,1,3)
plot(t,s_URZ,'k'); ylabel ('U-RZ'); axis ([ 0 T_bits  -0.1*A 1.1*A ]);
subplot(7,1,4)
plot(t,AMI_RZ,'k'); ylabel ('AMI-RZ'); axis ([ 0 T_bits  -1.1*A 1.1*A ]);
subplot(7,1,5)
plot(t,s_PNRZ,'k'); ylabel ('P-NRZ'); axis ([ 0 T_bits  -1.1*A 1.1*A ])
subplot(7,1,6)
plot(t,s_PRZ,'k'); ylabel ('P-RZ'); axis ([ 0 T_bits  -1.1*A 1.1*A ])
subplot(7,1,7)
plot(t,s_M,'k'); ylabel ('Manchester'); axis ([ 0 T_bits  -1.1*A 1.1*A ])

