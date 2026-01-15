% file: papr_ofdm_ifft.m
% Compute the peak-to-average power ratio of OFDM signals
% QPSK modulated bits. 
%%%%%%%%%  Theoretical expression is offset by + 5 to account for CP
% San Jose State University. Spring 2019

clear
seed=input('Enter the last five digits of your student ID: ');
rand('state',seed);
randn('state',seed);
K_array = [ 8 16 32 64 128 256 512 1024 2048 4096 8192 ];

fprintf('\nPlease be patient ...\n')
fprintf('-------------------\n')
fprintf('  K       PAPR(dB)\n')
fprintf('-------------------\n')
for k = 1:length(K_array)
    K = K_array(k); nu = K/4;
    Nsim =200000; peak = 0; ave = 0;
    for j=1:Nsim
        data = (2*round(rand(1,K))-1 + 01i*(2*round(rand(1,K))-1))/sqrt(2);
        ofdm_data = ifft(data) * sqrt(K);
        % ofdm_symbol = [ ofdm_data ofdm_data(1:nu) ]; % With CP
        % Uncomment above line and comment below if CP inserted
        ofdm_symbol = [ ofdm_data ]; % No CP
        power = abs(sum(ofdm_symbol)).^2;
        peak = max(peak, power);
        ave = ave + sum(power)/K;
    end
    ave = ave/Nsim; papr(k) = 10*log10(peak/ave);
    fprintf('%5d %10.2f\n', K, papr(k));
end
figure, plot(log2(K_array),papr,'--+'), 
xlabel('log2(K)'), ylabel('PAPR (dB)')
hold on
% papr_theory = 10*log10(K_array) + 5; % With CP
% Uncomment above line and comment below if CP inserted
papr_theory = 10*log10(K_array); % No CP
plot(log2(K_array),papr_theory,'-o'), axis tight, grid on
legend('Simulation','Theory','location','southeast')
title('Simulated PAPR of QPSK modulated CP-OFDM signals'), hold off