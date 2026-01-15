clear
t=-2:1/10000:2;
for n=1:length(t)
    % Phase is a unit rectangular pulse
    if (t(n) >= -0.5) && (t(n) <= 0.5)
        theta(n) = pi;
    else
        theta(n)=0;
    end
    % Ampltiude is a unit triangular pulse
    if (t(n) >= -1) && (t(n) <=0)
        a(n) = 1 + t(n);
    elseif (t(n) > 0) && (t(n) <=1)
        a(n) = 1 - t(n);
    else
        a(n) = 0;
    end
end
x = a.*cos(20*pi*t+ theta);

subplot(3,1,1), plot(t,a)
subplot(3,1,2), plot(t, theta)
subplot(3,1,3), plot(t, x)