x = -3:.01:3;
plot(x,tanh(x),'k')
axis([-3 3 -1.1 1.1]), grid on, hold on
a = x - (1/3)*x.^3 + (2/15)*x.^5 - (12/315)*x.^7 + (62/2835)*x.^9 ...
      - (1382/155925) * x.^11;
plot(x,a,'k--')
plot(x,x,'r-.')
legend('tanh(x)','polynomial','linear'), xlabel('x')

