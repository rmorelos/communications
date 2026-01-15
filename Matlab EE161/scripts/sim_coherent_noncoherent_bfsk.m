% file: sim_coherent_noncoherent_bfsk.m
% -------------------------------------------------------------------------
% Simulation of coherent and noncoherent binary frequency-shift keying
% Complex baseband model. NO PULSES, CORRELATORS OR FILTERS !!!
% EE161 - Spring 2022. San Jose State University
% -------------------------------------------------------------------------
clear
id = input('Enter your student ID (tower card) number: ');
rand('state',id), randn('state',id)

N = 5000000;                % Number of simulated symbols
s1 = [1 0]; s2 = [0 1];     % BFSK signal constellation points

init = 0; inc = 1; final = 14;
esn0_dB = init:inc:final;
for n=1:length(esn0_dB)
    No=10^(-esn0_dB(n)/10); % AWGN single-sided power
    sigma = sqrt(No/2);     % AWGN standard deviation
    
    error_c = 0; error_nc = 0;
    for i=1:N
        
        % Random information bit
        b = round(rand);
        
        % Binary orthogonal mapping:
        if b, s = s2;
        else  s = s1; end
        
        % ------- Coherent BFSK -------
        
        % Matched filter outputs:
        Y = s + sigma*randn(1,2);
        % Decision device
        if Y(1) > Y(2), bhat = 0;
        else bhat = 1; end
        error_c = error_c + (b ~= bhat);
        
        % ----- Noncoherent BFSK ------
        
        % Random phase
        tetha = rand*2*pi;
        % Matched filter outputs and decision variables:
        X11=s(1)*cos(tetha) + sigma*randn;  % In-phase + AWGN
        X12=s(1)*sin(tetha) + sigma*randn;  % Quadrature + AWGN
        Y1 = X11^2 + X12^2;
        X21=s(2)*cos(tetha) + sigma*randn;  % In-phase + AWGN
        X22=s(2)*sin(tetha) + sigma*randn;  % Quadrature + AWGN
        Y2 = X21^2 + X22^2;
        % Decision device
        if (Y1>Y2) nbhat=0;
        else     nbhat=1;   end
        error_nc = error_nc + (b ~= nbhat);
        
    end
    ber_c(n) = error_c/N; ber_nc(n) = error_nc/N;
    fprintf('%5.2f\t %e  %e\n', esn0_dB(n), ber_c(n), ber_nc(n));
    
end

figure(1), semilogy(esn0_dB, ber_nc,'--k'), grid on, hold on, axis tight
semilogy(esn0_dB, ber_c,'-k')
esn0=10.^(esn0_dB/10); 
semilogy(esn0_dB, (1/2)*exp(-esn0/2),'--sk')
semilogy(esn0_dB, qfunc(sqrt(esn0)),'-ok'), hold off
xlabel('E_s/N_0 (dB)'), ylabel('BER')
legend('Sim NC-BFSK','Sim BFSK','Theory NC-BFSK','Theory BFSK')
title('Simulation of coherent and non-coherent (NC) detection of BFSK')