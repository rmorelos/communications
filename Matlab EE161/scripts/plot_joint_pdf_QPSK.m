% File: plot_joint_pdf_QPSK.m
% Plots the joint PDF of a QPSK constellation with AWGN
% Copyrigth (c) 2007. Robert Morelos-Zaragoza. SJSU.

clear all;
en0 = input('Energy-to-noise ratio? ');
S = [  1  1                             % Signal points
      -1  1
      -1 -1
       1 -1]/sqrt(2);               
sx = sqrt(10^(-en0/10)/2);              % Noise standard deviation
sy = sqrt(10^(-en0/10)/2);
xmin = -5.*sx+min(S(:,1));      xmax = 5.*sx+max(S(:,1));
ymin = -5.*sy+min(S(:,2));      ymax = 5.*sy+max(S(:,2));
deltax = (xmax-xmin)/60;        deltay = (ymax-ymin)/60;
[x,y] = meshgrid(xmin:deltax:xmax,ymin:deltay:ymax);
for m=1:4
    if m==1
        z = 0.25 * exp(-( ((x-S(m,1))/sx).^2+((y-S(m,2))/sy).^2)/2) ...
            /(2*pi*sx*sy);
    else
        z = z + 0.25 * exp(-( ((x-S(m,1))/sx).^2+((y-S(m,2))/sy).^2)/2) ...
            /(2*pi*sx*sy);
    end
end
figure
meshc(x,y,z);
axis tight
title(['QPSK likelihoods with E_s/N_0 = ',num2str(en0),' dB'])
xlabel('y_1'), ylabel('y_2'), zlabel('p_{Y_1,Y_2}(y_1,y_2)')
az = 55; el = 67; view(az, el);