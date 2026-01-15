% Plot the reponse of the Manchester matched filter

M = 1000;                                 % Oversampling ratio (must be even)
p_M(1:M/2)=1; p_M(M/2:M)=-1;             % Manchester pulse
t1 = (1:M)/M;
% Impulse response of matched filter
for i=1:M, h(i) = p_M(M-i+1); end

% Matched filter response for Manchester pulse
t2 = (0:2*M-1)/M;
for i=1:M/2, y_M(i) = -i/M; end
for i=1:M/2, y_M(M/2+i) = 3*i/M-1/2; end
for i=1:M/2, y_M(M+i) = (M-3*i)/M; end
for i=1:M/2, y_M(3*M/2+i) = (-M/2+i)/M; end

figure
subplot(3,1,1)
plot(t1,p_M,'-k'), grid on, axis([0 1 -1.15 1.15])
title('Manchester pulse'), ylabel('s(t)')
subplot(3,1,2)
plot(t1,h,'-k'), grid on, axis([0 1 -1.15 1.15])
title('Impulse response'), ylabel('h(t)=s(-(t-T))')
subplot(3,1,3)
plot(t2,y_M,'-k'), grid on, axis([0 2 -0.65 1.15])
% hold on, stem(1,1,'--r'), hold off
title('Matched filter output'), ylabel('y_{MF}(t)')
xlabel('t')
% Using the 'conv' command
figure
y_MF = conv(p_M,h);
plot((0:2*(M-1))/M,y_MF/M,'-k')
grid on, axis([0 2 -0.55 1.05]), xlabel('t'), ylabel('y_{MF}(t)')
title('Matched filter output using MATLAB command {\it conv}')