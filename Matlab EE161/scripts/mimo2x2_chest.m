% Model of a two-by-two MIMO system. Complex baseband model.
% EE 161 - Spring 2011 - San Jose State University
% Modified for EE 252 - Fall 2012 and Fall 2013 and EE 161 Spring 2015.

clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);

mod = input('Enter modulation (1=BPSK,2=QPSK,3=8PSK,4=16QAM): ');
ideal = input('Ideal channel estimation (yes=1/no=0)? ');
if ideal == 0
    estvar = input('Estimation error variance: ');
end
totsim = input('Number of transmitted symbols: ');
snrinit = input('Initial value of SNR in dB: ');
snrfinal = input('Final value of SNR in dB: ');
snrstep = input('Increment of SNR in dB: ');

index = 1;        % Used for SNR and SER vectors
b = 2^mod;        % Number of signal constellation points
k = 2;
rate = 2*mod;

% Comment out the following line, if interested in Eb/No
rate = 1;

fprintf('\nSIMULATION OF A 2x2 MIMO SYSTEM UNDER FLAT RAYLEIGH FADING\n');
fprintf('rate = %f bps/Hz\n', rate);
fprintf('modulation format = %d\n', mod);
fprintf('%.0f block (2 symbols) simulations \n', totsim);
fprintf('SNR: %f to %f in increments of %f (dB)\n\n', snrinit, snrfinal, snrstep);
fprintf('  SNR        BER\n')
fprintf('---------------------\n')
% REFERENCE CONSTELLATION POINTS
switch mod
    case 1 % --- BPSK
        ref(1) = +1;  ref(2) = -1;
    case 2 % --- QPSK (GRAY)
        ref(1) = 1;  ref(2) = 01i; ref(3) = -1;  ref(4) = -01i;
    case 3 % --- 8PSK (GRAY)
        ct = sqrt(2);
        ref(1) = 1;  ref(2) = (1+01i)/ct; ref(3) = 01i; ref(4) = (-1+01i)/ct;
        ref(5) = -1; ref(6) = (-1-01i)/ct;ref(7) = -01i; ref(8) = (1-01i)/ct;
    case 4 % --- 16QAM (GRAY)
        x1 = 1/sqrt(10);
        x3 = 3/sqrt(10);
        x4 = 4/sqrt(10); % To normalize energy to unity
        ref(1) = x3+01i*x1; ref(2) = x3+01i*x3; ref(3) = x1+01i*x3; ref(4) = x1+01i*x1;
        ref(5) = ref(1)-x4; ref(6) = ref(2)-x4; ref(7) = ref(3)-x4; ref(8) = ref(4)-x4;
        ref(9) = ref(5)-01i*x4; ref(10) = ref(6)-01i*x4; ref(11) = ref(7)-01i*x4; ref(12) = ref(8)-01i*x4;
        ref(13) = ref(9)+x4; ref(14) = ref(10)+x4; ref(15) = ref(11)+x4; ref(16) = ref(12)+x4;
end

% --- SNR loop to compute BER
for snr = snrinit:snrstep:snrfinal

    esno(index) = snr;
    % --- NOISE LEVEL from the SNR per bit ('rate' used)
    amp = sqrt(2*rate*10^(snr/10));
    errcnt = 0; % Error counter

    % --- Simulation loop
    for nsim = 1:1:totsim

        % --- SOURCE SYMBOLS
        u = rand(1,k);
        switch mod
            case 1      % --- BPSK MODULATION
                u = 1+floor(2.*u);
            case 2      % --- QPSK MODULATION
                u = 1+floor(4.*u);
            case 3      % --- 8PSK MODULATION
                u = 1+floor(8.*u);
            case 4      % --- 16QAM MODULATION
                u = 1+floor(16.*u);
        end
        
        % --- MODULATION
        v = ref(u);
        
        % --- TWO-ANTENNA TRANSMISSION
        x(1) = v(1);      x(2) = v(2);
        
        % --- 2x2 MIMO CHANNEL WITH RAYLEIGH FADING and AWGN
        %     (ASSUMING EQUAL UNIT-ENERGY CHANNELS)
        xc=randn/sqrt(2); yc=randn/sqrt(2);  fade(1,1) = xc + 01i*yc;
        xc=randn/sqrt(2); yc=randn/sqrt(2);  fade(1,2) = xc + 01i*yc;
        xc=randn/sqrt(2); yc=randn/sqrt(2);  fade(2,1) = xc + 01i*yc;
        xc=randn/sqrt(2); yc=randn/sqrt(2);  fade(2,2) = xc + 01i*yc;
        noise(1) = (randn + 01i*randn)/amp; noise(2) = (randn + 01i*randn)/amp;
        f = sqrt(2); % --- Normalize transmitted power equal to unity
        y(1) = ( fade(1,1)*x(1) + fade(2,1)*x(2) ) / f + noise(1);
        y(2) = ( fade(1,2)*x(1) + fade(2,2)*x(2) ) / f + noise(2);

        % --- CHANNEL ESTIMATION
        if ideal ~= 1
            % Channel estimation error variance same as channel shown in
            % class
%             fade_hat(1,1) = fade(1,1) + (randn + i*randn)/amp; 
%             fade_hat(1,2) = fade(1,2) + (randn + i*randn)/amp;
%             fade_hat(2,1) = fade(2,1) + (randn + i*randn)/amp;
%             fade_hat(2,2) = fade(2,2) + (randn + i*randn)/amp;
            fade_hat(1,1) = fade(1,1) + sqrt(estvar)*(randn + 01i*randn); 
            fade_hat(1,2) = fade(1,2) + sqrt(estvar)*(randn + 01i*randn);
            fade_hat(2,1) = fade(2,1) + sqrt(estvar)*(randn + 01i*randn);
            fade_hat(2,2) = fade(2,2) + sqrt(estvar)*(randn + 01i*randn);
        else
            fade_hat(1,1) = fade(1,1);
            fade_hat(1,2) = fade(1,2);
            fade_hat(2,1) = fade(2,1);
            fade_hat(2,2) = fade(2,2);
        end
        
        % --- 2x2 MIMO RECEIVER.
        dt = fade_hat(1,1)*fade_hat(2,2) - fade_hat(1,2)*fade_hat(2,1);
        % Extract first symbol from receive antenna 1
        m1 = (  fade_hat(2,2)*y(1) - fade_hat(2,1)*y(2) )/dt - ref;
        [c,uhat(1)] = min(m1);
        % Extract second symbol from receive antenna 2
        m2 = ( -fade_hat(1,2)*y(1) + fade_hat(1,1)*y(2) )/dt - ref;
        [c,uhat(2)] = min(m2);
        
        % --- SYMBOL ERROR RATE COMPUTATION
        error = 0;
        for ind = 1:1:k
            if (u(ind) ~= uhat(ind))
                error = error + 1;
            end
        end
        errcnt = errcnt + error;
    end
    
    % COMPUTE THE ___SYMBOL___ ERROR RATE
    ser(index) = errcnt / (totsim*k);
    fprintf('%8.5f %e\n', esno(index), ser(index));
    index = index + 1;
    
end

% Plot Es/No versus symbol error probability
semilogy(esno,ser,'-ok'), grid on
xlabel('E_s/N_0 (dB)'), ylabel('Symbol Error Rate')
hold on
switch mod
    case 1      % --- BPSK MODULATION
        title('Performance of a 2x2 MIMO system with BPSK modulation under flat Rayleigh fading')
    case 2      % --- QPSK MODULATION
        title('Performance of a 2x2 MIMO system with QPSK modulation under flat Rayleigh fading')
    case 3      % --- 8PSK MODULATION
        title('Performance of a 2x2 MIMO system with 8-PSK modulation under flat Rayleigh fading')
    case 4      % --- 16QAM MODULATION
        title('Performance of a 2x2 MIMO system with 16-QAM modulation under flat Rayleigh fading')
end
