% Plot the power spectral densities of OOK, ASK and FSK
% Prelab work for lab experiment 4: Digital wireless transmission
% EE160. Fall 2021, San Jose State University. Modified Fall 2022

clear
seed = input('Enter your student ID: ');
rand('state',seed);

% Normalized frequency f/T
fT=-4:0.025:4;
a=1; T=1;

for i=1:length(fT)
    
    % OOK (Unipolar NRZ)
    S_up(i) = (a^2*T/4)*sinc(fT(i))^2;
    if fT(i) == 0
        S_up(i) = S_up(i) + a^2/4;
    end
    
    % ASK (Polar NRZ)
    S_p(i) = (a^2*T)*sinc(fT(i))^2; 
    
    % FSK 
    if fT(i) == -1/(2*T)
        S_f(i) = a^2/4; 
    elseif fT(i) == 1/(2*T)
        S_f(i) = a^2/4;
    else
        S_f(i) = (a^2*T/4)*( (2*a*cos(pi*fT(i))) / (pi*(1-(2*fT(i))^2)) )^2;
    end
    
end

figure
subplot(3,1,1)
plot(fT,S_up,'-k'), grid on, xlabel('Normalized frequency, (f-f_c)/T')
ylabel('S_X(f) (W/Hz)')
title(strcat('PSD of OOK (Unipolar NRZ), a = T = 1, ID=',num2str(mod(seed,1000))))
axis([-4 4 0 0.55])
subplot(3,1,2)
plot(fT,S_p,'-k'), grid on, xlabel('Normalized frequency, (f-f_c)/T')
ylabel('S_s(f) (W/Hz)'), title('PSD of ASK (Polar NRZ), a = T = 1')
axis([-4 4 0 1.05])
subplot(3,1,3)
plot(fT,S_f,'-k'), grid on, xlabel('Normalized frequency, (f-f_c)/T')
ylabel('S_s(f) (W/Hz)'), title('PSD of FSK, a = T = 1')
axis([-4 4 0 0.275])