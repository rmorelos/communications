d=0.00001:0.00001:1;
thd = (0.5*((1-d).^2+d.*(1-d)) - d.*sinc(d).^2)./(d.*sinc(d).^2);
plot(d,thd,'-k'), axis([0 1 0 10]), grid on
xlabel('Duty cycle, d'), ylabel('THD')
title('Total Harmonic Distortion of a train of rectangular pulses')
