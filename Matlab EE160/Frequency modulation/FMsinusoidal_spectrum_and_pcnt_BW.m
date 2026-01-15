% file: FMsinusoidal_spectrum_and_pcnt_BW.m
% EE160 - Fall 2012 - San Jose State University
% Modified to computation of any percent power bandwidth, Fall 2016/2017

fprintf('Computation of the bandwidth of a sinusoidal modulated FM signal\n');
beta = input('Value of modulation index \beta: '); % Magic numbers: 2.4, 5.53, 8.65, 11.79, 14.93, 18.07
pct = input('Percentage of power that the bandwidth contains (0-100): ');
pct = pct/100;
Nmax=round(2*(beta+2)); n=0:1:Nmax;
un = besselj(n,beta); un = [zeros(1,Nmax) un];
for i=1:Nmax
    un(i)=un(2*Nmax-i+2);           % Even symmetry
end
m=[-Nmax:-1 n];
stem(m,abs(un),'k'), axis tight, grid on
xlabel('n=(f\pm f_c)/f_m'), ylabel('Fourier series coefficients, u_n')
title(strcat('Discrete amplitude spectrum of an FM sinusoidal signal', ...
    ', \beta =', num2str(beta,'%5.2f')))

% Determine the percentage bandwidth
P = sum(abs(un).^2);
Ps = abs(un(Nmax+1))^2;             % Power of center frequency component
n=1;
while (Ps < pct*P) && ( n <= Nmax) 
    Ps = Ps + 2*abs(un(Nmax+1-n))^2;
    n = n+1;
end
fprintf('Normalized %2d-percent power bandwidth, B_{%2d}/f_m = %d\n', ...
    pct*100, pct*100, 2*n);
fprintf('Carson''s rule, B_c/f_m = %.1f\n', 2*(1+beta));