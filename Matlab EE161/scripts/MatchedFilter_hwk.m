% File: MatchedFilter_hwk.m
% Illustration of pulse-shaping schemes and correlator/matched filter outputs
% EE 161. Spring 2018. San Jose State University.

clear
A = 1;                                   % Pulse amplitude
T = 1;                                   % Bit duration

seed = input('Enter your student ID: ');
rand('state',seed)
N = 8;                                   % Number of bits  
bit = round(rand(1,N));                  % Bit sequence
%%%% bit = [ 1 0 1 1 0 0 0 1];   N = length(bit);

polar = [ -A A ];                        % Polar mapping
M = 100;                                 % Oversampling ratio (must be even)
T_bits = T*length(bit);                  % Duration of bit stream
t = 1/M:1/M:T_bits ;                     % Time scale

bit_M= [];
for i=1:length(bit)
    bit_M = [bit_M bit(i)*ones(1,M)];    % Oversampled bit stream
end

p_NRZ(1:M)=1;                            % NRZ pulse
p_RZ(1:M/2)=1; p_RZ(M/2:M)=0;            % RZ pulse
p_M(1:M/2)=-1; p_M(M/2:M)=1;             % Manchester pulse

% Matched filter responses:
% (1) NRZ pulse 
for i=1:M, y_NRZ(i) = i/M; end
for i=1:M, y_NRZ(M+i) = (M-i)/M; end

% (2) RZ pulse
for i=1:M/2, y_RZ(i) = 0; end
for i=1:M/2, y_RZ(M/2+i) = 2*i/M; end
for i=1:M/2, y_RZ(M+i) = (M-2*i)/M; end
for i=1:M/2, y_RZ(3*M/2+i) = 0; end

% (3) Manchester pulse
for i=1:M/2, y_M(i) = -i/M; end
for i=1:M/2, y_M(M/2+i) = 3*i/M-1/2; end
for i=1:M/2, y_M(M+i) = (M-3*i)/M; end
for i=1:M/2, y_M(3*M/2+i) = (-M/2+i)/M; end

% -------------------------------------
%               MF outputs
% -------------------------------------

% (a) Unipolar NRZ
y1 = [bit(1)*A*y_NRZ zeros(1,M)];
for i=2:length(bit)
    ytemp = [zeros(1,(i-1)*M) bit(i)*A*y_NRZ];
    y1 = y1 + ytemp;
    y1 = [y1 zeros(1,M)];
end

% (b) Unipolar RZ
y2 = [bit(1)*A*y_RZ zeros(1,M)];
for i=2:length(bit)
    ytemp = [zeros(1,(i-1)*M) bit(i)*A*y_RZ];
    y2 = y2 + ytemp;
    y2 = [y2 zeros(1,M)];
end

% (c) Polar NRZ
y3 = [polar(bit(1)+1)*A*y_NRZ zeros(1,M)];
for i=2:length(bit)
    ytemp = [zeros(1,(i-1)*M) polar(bit(i)+1)*A*y_NRZ];
    y3 = y3 + ytemp;
    y3 = [y3 zeros(1,M)];
end

% (d) Polar RZ
y4 = [polar(bit(1)+1)*A*y_RZ zeros(1,M)];
for i=2:length(bit)
    ytemp = [zeros(1,(i-1)*M) polar(bit(i)+1)*A*y_RZ];
    y4 = y4 + ytemp;
    y4 = [y4 zeros(1,M)];
end

% (e) AMI NRZ
st = -A;                    % Inital amplitude -A
if bit(1)
  st = -st;
  y5 = [st*y_NRZ zeros(1,M)]; 
else 
  y5 = [0*y_NRZ zeros(1,M)]; 
end
for i=2:length(bit)
    if bit(i), st = -st; end
    ytemp = [zeros(1,(i-1)*M) bit(i)*st*y_NRZ];
    y5 = y5 + ytemp;
    y5 = [y5 zeros(1,M)];
end

% (f) AMI RZ
st = -A;                    % Inital amplitude -A
if bit(1)
  st = -st;
  y6 = [st*y_RZ zeros(1,M)];
else
  y6 = [0*y_RZ zeros(1,M)];
end
for i=2:length(bit)
    if bit(i), st = -st; end
    ytemp = [zeros(1,(i-1)*M) bit(i)*st*y_RZ];
    y6 = y6 + ytemp;
    y6 = [y6 zeros(1,M)];
end

% (g) Manchester
y7 = [polar(bit(1)+1)*A*y_M zeros(1,M)];
for i=2:length(bit)
    ytemp = [zeros(1,(i-1)*M) polar(bit(i)+1)*A*y_M];
    y7 = y7 + ytemp;
    y7 = [y7 zeros(1,M)];
end

% -------------------------------------
%          Correlator outputs
% -------------------------------------

% (a) Unipolar NRZ
for i=1:length(bit)
    sum = 0;
    for j=(i-1)*M+1:i*M
        corr_UNRZ(j) = sum;
        s_UNRZ(j) = bit(i)*A*p_NRZ(j-(i-1)*M);  
        sum = sum + bit(i)*A*p_NRZ(j-(i-1)*M)*p_NRZ(j-(i-1)*M)/M;
    end
end

% (b) Unipolar RZ
for i=1:length(bit)
    sum = 0;
    for j=(i-1)*M+1:i*M
        corr_URZ(j) = sum;
        s_URZ(j) = bit(i)*A*p_RZ(j-(i-1)*M);
        sum = sum + 2*bit(i)*A*p_RZ(j-(i-1)*M)*p_RZ(j-(i-1)*M)/M;
    end
end

% (c) Polar NRZ
for i=1:length(bit)
    sum = 0;
    for j=(i-1)*M+1:i*M
        corr_PNRZ(j) = sum;
        s_PNRZ(j) = polar(bit(i)+1)*p_NRZ(j-(i-1)*M);
        sum = sum + polar(bit(i)+1)*p_NRZ(j-(i-1)*M)*p_NRZ(j-(i-1)*M)/M;
    end
end

% (d) Polar RZ
for i=1:length(bit)
    sum = 0;
    for j=(i-1)*M+1:i*M
        corr_PRZ(j) = sum;
        s_PRZ(j) = polar(bit(i)+1)*p_RZ(j-(i-1)*M);
        sum = sum + 2*polar(bit(i)+1)*p_RZ(j-(i-1)*M)*p_RZ(j-(i-1)*M)/M;
    end
end

% (e) AMI NRZ
st = [-A*ones(1,M)];                    % Inital amplitude -A
for i=1:length(bit)
    sum = 0;
    if bit(i), st = -st; end
    for j=(i-1)*M+1:i*M
        corr_AMI_NRZ(j) = sum;
        AMI_NRZ(j) = bit(i)*st(j-(i-1)*M)*p_NRZ(j-(i-1)*M);
        sum = sum + bit(i)*st(j-(i-1)*M)*p_NRZ(j-(i-1)*M)*p_NRZ(j-(i-1)*M)/M;
    end
end

% (f) AMI RZ
st = [-A*ones(1,M)];                    % Inital amplitude -A
for i=1:length(bit)
    sum = 0;
    if bit(i), st = -st; end
    for j=(i-1)*M+1:i*M
        corr_AMI_RZ(j) = sum;
        AMI_RZ(j) = bit(i)*st(j-(i-1)*M)*p_RZ(j-(i-1)*M);
        sum = sum + 2*bit(i)*st(j-(i-1)*M)*p_RZ(j-(i-1)*M)*p_RZ(j-(i-1)*M)/M;
    end
end

% (g) Manchester
for i=1:length(bit)
    sum = 0;
    for j=(i-1)*M+1:i*M
        corr_M(j) = sum;
        s_M(j) = polar(bit(i)+1)*p_M(j-(i-1)*M);
        sum = sum + polar(bit(i)+1)*p_M(j-(i-1)*M)*p_M(j-(i-1)*M)/M;
    end
end

% -------------------------------------
% Plot signals
% -------------------------------------

figure(1)
subplot(4,1,1)
plot(t,bit_M,'k'); ylabel ('Bits'); axis ([ 0 T_bits  -0.1 1.1 ]), grid on
set(gca,'YTick',[0 1])
title('Example of pulse shaping of an 8-bit sequence')
subplot(4,1,2)
plot(t,s_PNRZ,'k'); ylabel ('Polar NRZ'); axis ([ 0 T_bits  -1.1*A 1.1*A ]), grid on
subplot(4,1,3)
plot(t,AMI_RZ,'k'); ylabel ('AMI RZ'); axis ([ 0 T_bits  -1.1*A 1.1*A ]), grid on
subplot(4,1,4)
plot(t,s_M,'k'); ylabel ('Manchester'); axis ([ 0 T_bits  -1.1*A 1.1*A ]), grid on

% PLOT polar NRZ waveforms
figure(2)
subplot(4,1,1)
plot(t,bit_M,'k'); ylabel ('Bits'); axis ([ 0 T_bits  -0.1 1.1 ]), grid on
set(gca,'YTick',[0 1])
title('8-bit sequence')
subplot(4,1,2)
plot(t,s_PNRZ,'k'); ylabel ('Polar NRZ'); axis ([ 0 T_bits -1.1*A 1.1*A ]), grid on
subplot(4,1,3)
plot(t,corr_PNRZ,'k'); ylabel ('Correlator'); axis ([ 0 T_bits -1.1*A 1.1*A ]), grid on
subplot(4,1,4)
plot(t,y3(1:length(y3)-2*M),'k'); ylabel ('Matched filter'); axis ([ 0 T_bits  -1.1*A 1.1*A ]), grid on

% PLOT AMI RZ waveforms
figure(3)
subplot(4,1,1)
plot(t,bit_M,'k'); ylabel ('Bits'); axis ([ 0 T_bits  -0.1 1.1 ]), grid on
set(gca,'YTick',[0 1])
title('8-bit sequence')
subplot(4,1,2)
plot(t,AMI_RZ,'k'); ylabel ('AMI RZ'); axis ([ 0 T_bits -1.1*A 1.1*A ]), grid on
subplot(4,1,3)
plot(t,corr_AMI_RZ,'k'); ylabel ('Correlator'); axis ([ 0 T_bits -1.1*A 1.1*A ]), grid on
subplot(4,1,4)
plot(t,y6(1:length(y6)-2*M),'k'); ylabel ('Matched filter'); axis ([ 0 T_bits  -1.1*A 1.1*A ]), grid on

% PLOT polar Manchester waveforms
figure(4)
subplot(4,1,1)
plot(t,bit_M,'k'); ylabel ('Bits'); axis ([ 0 T_bits  -0.1 1.1 ]), grid on
set(gca,'YTick',[0 1])
title('8-bit sequence')
subplot(4,1,2)
plot(t,s_M,'k'); ylabel ('Manchester'); axis ([ 0 T_bits -1.1*A 1.1*A ]), grid on
subplot(4,1,3)
plot(t,corr_M,'k'); ylabel ('Correlator'); axis ([ 0 T_bits -1.1*A 1.1*A ]), grid on
subplot(4,1,4)
plot(t,y7(1:length(y7)-2*M),'k'); ylabel ('MF output'); axis ([ 0 T_bits -1.1*A 1.1*A ]), grid on
