% File: voronoi_regions.m
% EE251. San Jose State University. Fall 2020
% Modified for EE161 in Spring 2022

clear
s = input('Enter your student ID number: ');
randn('seed',s); rand('seed',s)

% Random points
y1 = 1-2*rand(1,4);
y2 = 1-2*rand(1,4);

figure(300)
voronoi(y1,y2,'-k'), axis([-2 2 -2 2]), grid on
title('Voronoi regions of four random points in a plane')
xlabel('y_1'), ylabel('y_2')