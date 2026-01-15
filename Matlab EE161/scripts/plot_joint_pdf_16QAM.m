% File: plot_joint_pdf_16QAM.m
% Plots the joint PDF of a 16-QAM constellation with AWGN
% Copyrigth (c) 2007. Robert Morelos-Zaragoza. SJSU.
% You get the idea, the joint PDF for any constellation can be plotted ...

clear all;
esn0 = input('Energy-to-noise ratio? ');
S = (1/sqrt(10)) * [  1  1              % Signal points
                      3  1
                      1  3
                      3  3
                     -1  1
                     -3  1
                     -1  3
                     -3  3
                      1 -1
                      3 -1
                      1 -3
                      3 -3
                     -1 -1
                     -3 -1
                     -1 -3
                     -3 -3 ]/sqrt(10);
sx = sqrt(10^(-esn0/10)/2);              % Noise standard deviation
sy = sqrt(10^(-esn0/10)/2);
xmin = -5.*sx+min(S(:,1));     xmax = 5.*sx+max(S(:,1));
ymin = -5.*sy+min(S(:,2));     ymax = 5.*sy+max(S(:,2));
deltax = (xmax-xmin)/80;   deltay = (ymax-ymin)/80;
[x,y] = meshgrid(xmin:deltax:xmax,ymin:deltay:ymax);
for m=1:length(S)
    if m==1
        z = (1/length(S)) * exp(-(((x-S(m,1))/sx).^2+((y-S(m,2))/sy).^2)/2) ...
            /(2*pi*sx*sy);
    else
        z = z + (1/length(S)) * exp(-(((x-S(m,1))/sx).^2+((y-S(m,2))/sy).^2)/2) ...
            /(2*pi*sx*sy);
    end
end
figure
meshc(x,y,z);
axis tight
title(['The Joint PDF of a 16-QAM receiver with E_s/N_0 = ',num2str(esn0),' dB'])
xlabel('y_1'), ylabel('y_2'), zlabel('p_{Y_1,Y_2}(y_1,y_2)')
az = 55; el = 45; view(az, el);