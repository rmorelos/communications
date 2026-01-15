% File: bpsk_rayleigh_D_branch_diversity.m
% Comparison of combining techniques using three diversity branches,
% BPSK modulation and flat Rayleigh fading.
% EE 160 - Spring 2016 - San Jose State University
% Modified Spring 2022, 2024

clear

seed=input('Enter your student ID: ');
rand('state',seed);
randn('state',seed);
D = input('Enter the number of diversity branches: ');

fprintf('\nPlease be patient, the cript takes a while to finish ...\n')
N=50e6; snr=0:2.5:20;

fprintf('\n   E/No   \t    BER SC\t       BER MRC\t      BER EGC\n');
fprintf('-----------------------------------------------------------\n');

for m=1:size(snr,2)

    eSC  = 0;      eMRC = 0;        eEGC = 0;
    aveSC(m) = 0;  aveMRC(m) = 0;   aveEGC(m) = 0;

    No=10^(-snr(m)/10);                         % AWGN single-sided power
    sigma = sqrt(No/2);                         % AWGN standard deviation
    x=[]; y=[];

    for n=1:N

        s=(-1)^round(rand);                     % BPSK symbol (baseband)
        
        % DIVERSITY BRANCHES
        for i=1:D
            x(i)=randn/sqrt(2); y(i)=randn/sqrt(2);
            p(i)=x(i)^2 + y(i)^2;               % Fading Power
            a(i)=sqrt(p(i));                    % Fading Amplitude
            r(i)=a(i)*s + sigma*randn;          % faded signal + AWGN
        end

        % ---------------------   SELECTION COMBINING (SC)
        max = -inf;
        for i=1:D
            if (r(i)^2 > max)                   % SELECT THE LARGEST
                max = r(i)^2; sel = i;
            end
        end
        recSC = r(sel);
        aveSC(m) = aveSC(m)+recSC^2;            % Received S+N with SC
        % Detector
        if (recSC>0), shat=1; else,     shat=-1;   end
        if (shat ~= s), eSC = eSC + 1; end       % Error with SC

        % ---------------------   MAXIMAL-RATIO COMBINING (MRC)
        recMRC = 0;
        for i=1:D, recMRC = recMRC + a(i)*r(i);    end
        aveMRC(m) = aveMRC(m)+recMRC^2/3;       % Received S+N with MRC
        % Detector
        if (recMRC>0), shat=1; else,     shat=-1;   end
        if (shat ~= s), eMRC = eMRC + 1; end     % Error with MRC

        % ---------------------   EQUAL-GAIN COMBINING (EGC)
        recEGC = 0;
        for i=1:D, recEGC = recEGC + r(i);    end
        aveEGC(m) = aveEGC(m)+recEGC^2/3;       % Received S+N with EGC
        % Detector
        if (recEGC>0), shat=1; else,     shat=-1;   end
        if (shat ~= s), eEGC = eEGC + 1; end     % Error with EGC
        
    end

    peSC(m)=eSC/N;                              % BER of SC
    peMRC(m)=eMRC/N;                            % BER of MRC
    peEGC(m)=eEGC/N;                            % BER of EGC
    fprintf('%f \t %e \t %e \t %e\n',snr(m),peSC(m),peMRC(m),peEGC(m));
end

figure(1)
semilogy(snr,peSC,'-sk'), hold on
semilogy(snr,peEGC,'-^k'), semilogy(snr,peMRC,'-ok') 
ylabel('Bit Error Rate'); xlabel('Average E_b/N_0 (dB)'); legend('SC','EGC','MRC')
axis ([0 snr(end) peMRC(end)/5 1e-1]), grid on, hold off
title(strcat('Performance of BPSK with ',num2str(D),'-branch diversity'))
figure(2)
plot(snr,10*log10(aveMRC/N),'-ok'), hold on, plot(snr,10*log10(aveEGC/N),'-^k'), 
plot(snr,10*log10(aveSC/N),'-sk'), grid on
xlabel('Average SNR per branch (dB)'), ylabel('Post-combiner average S+N (dB)')
legend('MRC','EGC','SC')
axis tight
