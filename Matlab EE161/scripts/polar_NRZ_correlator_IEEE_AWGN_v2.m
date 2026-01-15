% ----------------------------------------------------------------
% file: polar_NRZ_correlatoe_IEEE_AWGN_v2.m
% Description: Binary communication system using polar NRZ and a 
% correlator-based (integrate and dump) receiver
% EE161 - Spring 2004 - San Jose State University
% ----------------------------------------------------------------
% Modified in Spring 2014 by Robert Morelos-Zaragoza to fix a
% mismatch between mapper and decision device. Plot histogram of 
% received signal samples added.

clear

id = input('Enter your student ID (tower card) number: ');
a = input('Enter the pulse amplitude, a: ');
var = input('Variance of the AWGN samples: ');

sigma= sqrt(var);       % Standard deviation of the AWGN samples
T = 1;                  % Symbol (bit) duration = 1 sec
Ns=100;                 % 100 samples per symbol (bit)
Ts=T/Ns;                % Sample duration
Nb=30;                  % Number of simulated bits
Nt=Nb*Ns;               % Total number of simulated samples

rand('state',id)
randn('state',id)

% Rectangular pulse of amplitude a
n=1:Ns;
g(n) = a;

% Sequence of Nb bits and modulated pulses
for j=1:Nb
    bit(j)= floor(2*rand);          % Random bits
    amp(j)= 2*bit(j)-1;             % IEEE mapping: "0" --> -1, "1" --> +1
    for k=1:Ns
        s(k+(j-1)*Ns)=amp(j)*g(k);  % Transmitted signal
        bits(k+(j-1)*Ns)=bit(j);
    end
end

% Add AWGN and initialize correlator
for j=1:Nt
    y(j) = s(j) + sigma*randn;      % Add noise to transmitted sequence
    YT(j) = 0;                      % Initialize correlator output
end

% Integrate and dump receiver, integrator becomes a sum over samples ...
for j=1:Nb
    YT((j-1)*Ns+1) = y(1+(j-1)*Ns)*g(1)/Ns;
    for k=2:Ns
        % Multiply and accumulate!
        YT((j-1)*Ns+k) = YT((j-1)*Ns+k-1) + y(k+(j-1)*Ns)*g(k)/Ns;   
    end
end

% Decision device
for j=1:Nb
    if YT((j-1)*Ns+Ns-1) <= 0
        dec(j)=0;
    else
        dec(j)=1;
    end
    for k=1:Ns
        bithat(k+(j-1)*Ns)=dec(j);
    end
end


% Plot signals
figure(1)
subplot(4,1,1), plot((1:Nt)/Ns,s,'-k'), grid on
axis([ 1 Nb -1.5*a 1.5*a]), title('Polar NRZ: Transmitted pulse sequence')
subplot(4,1,2), plot((1:Nt)/Ns,y,'-k'), grid on
axis([ 1 Nb -(1+3*sigma)*a (1+3*sigma)*a]), title('Received pulse sequence')
subplot(4,1,3), plot((1:Nt)/Ns,YT,'-k'), grid on
% axis([ 1 Nb -(1+sigma^2)*a^2 (1+sigma^2)*a^2]), 
axis tight, title('Correlator output')
subplot(4,1,4), plot((1:Nt)/Ns,bithat,'-k'), grid on
axis([ 1 Nb -0.15 1.15]), title('Estimated bit sequence')
xlabel('Normlized time t/T')

% Plot histogram of received signal
figure(2)
hist(y,100), title('Histogram of correlator outputs'), grid on

