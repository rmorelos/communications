% file: alamouti_bpsk2_chest_errors.m
% Simulation of Alamouti's transmit diversity scheme under flat Rayleigh
% fading amplitude (assumed to be constant over two symbols or codewords) 
% and random uniformly distributed phase (path delay). Perfect channel
% estimation and with channel estimation errors
% 
% EE 161 - San Jose State University - Spring 2019. Revised 2024

clear

seed = input('Enter your student ID: ');
randn('state',seed)  % Seeds set to produce same random number sequence
rand('state',seed)

N = 150000; 
totsim = N;
snrinit = 2; snrfinal = 22; snrstep = 2;

cheststd = input('Enter the variance of the estimation error: ');
%%%%%%%%%%%%%%%  0.1;   % Standard deviation of channel estimation errors 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%   Single transmit antenna: Uncoded BPSK modulation                %
%   Diversity order = 1                                             %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\nUNCODED BPSK MODULATION UNDER RAYLEIGH FADING:\n\n');

snr=snrinit:snrstep:snrfinal;
for m=1:size(snr,2)
    efade = 0;
    egaus = 0;
    No=10^(-snr(m)/10);             % AWGN single-sided power
    sigma= sqrt(No/2);              % AWGN standard deviation
    for n=1:N
        s=(-1)^round(rand);
        x=randn/sqrt(2); y=randn/sqrt(2);
        p=x^2 + y^2;                % Fading Power
        a=sqrt(p);                  % Fading Amplitude
        r=a*s + sigma*randn;        % faded signal + AWGN
        rg = s + sigma*randn;       % unfaded signal + AWGN
        if (r>0) shat=+1;           % Decision device
        else     shat=-1;   end
        if (rg>0)  sh=+1;           % Decision device
        else       sh=-1;   end
        if (shat ~= s) efade = efade + 1; end  % Error with fading
        if (sh ~= s)   egaus = egaus + 1; end  % Error without fading
    end
    pe(m)=efade/N;                  % BER flat Rayleigh fading
    peg(m)=egaus/N;                 % BER AWGN only
    fprintf('%8.5f \t %e\n',snr(m),pe(m));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%   Dual transmit antenna: Alamouti's scheme with BPSK modulation   %
%   Diversity order = 2                                             %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
index = 1;        % Used for SNR and SER vectors
k = 2; rate = 1;  % One symbol per channel use, same as single antenna
fprintf('\nSPACE-TIME BLOCK CODING (ALAMOUTI) UNDER RAYLEIGH FADING\n\n');
fprintf(' Es/No(dB) \t BER (ideal)     BER (estimation errors)\n')
fprintf('--------------------------------------------------------\n')
% REFERENCE CONSTELLATION POINTS
ref(1) = +1;  ref(2) = -1;
f = sqrt(2); % --- Normalization factor so that Es=1

% --- SNR loop to compute BER
for snri = snrinit:snrstep:snrfinal
    esno(index) = snri;
    amp = sqrt(2*rate*10^(snri/10));
    errcnt = 0;     % Errors perfect channel estimation
    err2 = 0;       % Errors imperfect channel estimation
    
    for nsim = 1:1:totsim
        u = rand(1,k);
        u = 1+floor(2.*u);
        v = ref(u);
        
        % --- SPACE-TIME ENCODING
        x(1,1) = v(1);          x(1,2) = v(2);
        x(2,1) = -conj(v(2));   x(2,2) = conj(v(1));
        
        % --- MISO CHANNEL WITH RAYLEIGH FADING and AWGN
        xc=randn/sqrt(2);yc=randn/sqrt(2);p=xc^2+yc^2;  % Amplitude
        phase=2*pi*rand;                                % Phase
        fade(1) = sqrt(p)*exp(01i*phase);
        xc=randn/sqrt(2);yc=randn/sqrt(2);p=xc^2+yc^2;  % Amplitude
        phase=2*pi*rand;                                % Phase
        fade(2) = sqrt(p)*exp(01i*phase);
        noise(1) = (randn + 01i*randn)/amp;
        noise(2) = (randn + 01i*randn)/amp;
        
        y(1) = ( fade(1)*x(1,1) + fade(2)*x(1,2) ) / f + noise(1);
        y(2) = ( fade(1)*x(2,1) + fade(2)*x(2,2) ) / f + noise(2);
        
        
        %         ======= PERFECT CHANNEL ESTIMATION =======
        e = ( -1 + abs(fade(1)).^2 + abs(fade(2)).^2 ) * abs(ref).^2;
        m1 = y(1)*conj(fade(1)) + conj(y(2))*fade(2) - ref;
        m1 = m1 .* conj(m1);
        m1 = m1 + e;
        if m1(1) < m1(2)
            uhat(1) = 1;
        else    uhat(1) = 2;    end
%         [c,uhat(1)] = min(m1);
        m2 = y(1)*conj(fade(2)) - conj(y(2))*fade(1) - ref;
        m2 = m2 .* conj(m2);
        m2 = m2 + e;
        if m2(1) < m2(2)
            uhat(2) = 1;
        else    uhat(2) = 2;    end
%        [c,uhat(2)] = min(m2);
        % --- ERROR RATE COMPUTATION
        error = 0;
        for ind = 1:k
            if (u(ind) ~= uhat(ind))
                error = error + 1;
            end
        end
        errcnt = errcnt + error;
        

        %         =======  CHANNEL ESTIMATION  ERRORS =======
        fade(1) = fade(1) + (randn + 01i*randn)*cheststd/sqrt(2);
        fade(2) = fade(2) + (randn + 01i*randn)*cheststd/sqrt(2);

        e = ( -1 + abs(fade(1)).^2 + abs(fade(2)).^2 ) * abs(ref).^2;
        m1 = y(1)*conj(fade(1)) + conj(y(2))*fade(2) - ref;
        m1 = m1 .* conj(m1);
        m1 = m1 + e;
        if m1(1) < m1(2)
            uhat(1) = 1;
        else    uhat(1) = 2;    end
%         [c,uhat(1)] = min(m1);
        m2 = y(1)*conj(fade(2)) - conj(y(2))*fade(1) - ref;
        m2 = m2 .* conj(m2);
        m2 = m2 + e;
        if m2(1) < m2(2)
            uhat(2) = 1;
        else    uhat(2) = 2;    end
%        [c,uhat(2)] = min(m2);
        % --- ERROR RATE COMPUTATION
        error = 0;
        for ind = 1:k
            if (u(ind) ~= uhat(ind))
                error = error + 1;
            end
        end
        err2 = err2 + error;

    end
    
    % COMPUTE THE ERROR RATES
    ser(index) = errcnt / (totsim*k);
    ser2(index) = err2 / (totsim*k);
    fprintf('%8.5f \t %e\t %e\n', esno(index), ser(index), ser2(index));
    index = index + 1;
end

% Plot
figure
semilogy(snr,pe,'-ok'), hold on, semilogy(esno,ser2,'-^r')
semilogy(esno,ser,'-sk')  %%, semilogy(snr,peg,'-+k')
legend('BPSK Rayleigh','Estimation errors','Ideal') %% 'BPSK AWGN')
ylabel('Bit Error Rate'), xlabel('Average E_b/N_0 (dB)')
title('Alamouti transmit diversity scheme under flat Rayleigh fading');
axis tight, grid on, hold off