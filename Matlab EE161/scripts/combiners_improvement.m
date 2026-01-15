% File: combiners_improvements.m
% Plot the postcombiner gain due to diversity combining
% EE161. Spring 2022. San Jose State University

clear

for D=1:10
    gSC(D)  = 10*log10(sum(1./(1:D))); 
    gEGC(D) = 10*log10(1 + (pi/4)*(D-1));
    gMRC(D) = 10*log10(D);
end

figure(100)
plot([1:10], gMRC,'-k^'); hold on, plot([1:10], gEGC,'-ks'), plot([1:10], gSC,'-ko')
legend('MRC','EGC','SC')
grid on, axis tight, legend, hold off
xlabel('Diversity order, D'), ylabel('SNR improvement (dB)')
title('Improvements with diversity combining techniques')