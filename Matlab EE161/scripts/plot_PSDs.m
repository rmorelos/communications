% Plot the PSD's of various combinations of pulse shapes and mappings of
% bits to amplitudes ("line codes") 
% EE 160 - Fall 2010 - San Jose State University (c) 2010.

clear all
a=10^(-3); T=1/10;
fTinit = -6.5; fTstop = -fTinit; % Assuming symmetric interval
nopoints = 50000;
fTinc = (fTstop-fTinit)/nopoints;
fT = [fTinit:fTinc:fTstop];
mid = round(length(fT)/2)+1;
% (1) Polar NRZ
Spnrz = a^2*T*(sinc(fT)).^2;
% (2) Polar RZ
Sprz = (a^2*T/4)*(sinc(fT./2)).^2;
% (3) Unipolar NRZ
Sunrz = (a^2*T/4)*(sinc(fT)).^2;   Sunrz(mid)=Sunrz(mid)+a^2/4;
% (4) Unipolar RZ
Surz = (a^2*T/16)*(sinc(fT./2)).^2; Surz(mid) = (1+1/T)*Surz(mid);
for i = 1:round(fTstop)-1
    Surz(mid+i*round(1/fTinc)) = (1+1/T)*Surz(mid+i*round(1/fTinc));
    Surz(mid-i*round(1/fTinc)) = (1+1/T)*Surz(mid-i*round(1/fTinc));
end
% (5) AMI NRZ
Saminrz = a^2*T*(sinc(fT)).^2.*(sin(pi*fT)).^2;
% (6) AMI RZ
Samirz = (a^2*T/4)*(sinc(fT./2)).^2.*(sin(pi*fT)).^2;
% (7) Manchester
Sman = a^2*T*(sinc(fT./2)).^2.*(sin(pi*fT./2)).^2;

% Plots:
figure(1), plot(fT, Spnrz, '-k'), axis tight, grid on
xlabel('Normalized frequency, fT_b'), ylabel('S_s(f)')
title('PSD of Polar NRZ, A=10^{-3}, T_b=10^{-7}')
figure(2), plot(fT, Sprz, '-k'), axis tight, grid on
xlabel('Normalized frequency, fT_b'), ylabel('S_s(f)')
title('PSD of Polar RZ, A=10^{-3}, T_b=10^{-7}')
figure(3), plot(fT, Sunrz, '-k'), axis tight, grid on
xlabel('Normalized frequency, fT_b'), ylabel('S_s(f)')
title('PSD of Unipolar NRZ, A=10^{-3}, T_b=10^{-7}')
figure(4), plot(fT, Surz, '-k'), axis tight, grid on
xlabel('Normalized frequency, fT_b'), ylabel('S_s(f)')
title('PSD of Unipolar RZ, A=10^{-3}, T_b=10^{-7}')
figure(5), plot(fT, Saminrz, '-k'), axis tight, grid on
xlabel('Normalized frequency, fT_b'), ylabel('S_s(f)')
title('PSD of AMI NRZ, A=10^{-3}, T_b=10^{-7}')
figure(6), plot(fT, Samirz, '-k'), axis tight, grid on
xlabel('Normalized frequency, fT_b'), ylabel('S_s(f)')
title('PSD of AMI RZ, A=10^{-3}, T_b=10^{-7}')
figure(7), plot(fT, Sman, '-k'), axis tight, grid on
xlabel('Normalized frequency, fT_b'), ylabel('S_s(f)')
title('PSD of Manchester code, A=10^{-3}, T_b=10^{-7}')

