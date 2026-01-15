% File: plot_pam.m
% Plot PAM constellations
% EE161 - San Jose State University

clear
Es = 1;
ellmax = 5;
figure(100)

for ell=1:ellmax
    M = 2^ell;
    a = sqrt(3*Es/(M^2-1));
    clear s;
    for j=1:M
        s(j)=-(M-1)*a + 2*(j-1)*a;
    end

    subplot(ellmax,1,ell)
    stem(s,zeros(1,M),'-k'), xlim([-1.8 1.8]), grid on
    ylabel(strcat('M=',num2str(M)))
    if ell == 1, title('Unit-energy M-PAM signal constellations'), end
end