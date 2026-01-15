clear
t=-2:1/10000:2; N = length(t);
for n=1:N
    % Amplitude is a rectangular pulse
    if (t(n) >= -1.5) && (t(n) <= 1.5)
        a(n) = 1;
    else
        a(n)=0;
    end
    % Phase is a unit triangular pulse
    if (t(n) >= -0.5) && (t(n) <=0)
        theta(n) = pi*(1 + 2*t(n));
    elseif (t(n) > 0) && (t(n) <=0.5)
        theta(n) = pi*(1 - 2*t(n));
    else
        theta(n) = 0;
    end
end
x = a.*cos(24*pi*t+ theta);

subplot(3,1,1), plot(t,a,'-k'), grid on, axis([t(1) t(N) -0.2 1.2])
subplot(3,1,2), plot(t, theta,'-k'), grid on, axis([t(1) t(N) -0.2 1.2*pi])
subplot(3,1,3), plot(t, x,'-k'), grid on, axis([t(1) t(N) -1.2 1.2])