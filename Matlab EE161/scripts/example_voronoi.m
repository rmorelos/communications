% File: example_voronoi.m
% EE251. San Jose State University. Fall 2020
% Modified for EE161 in Spring 2022


figure

% Random points
y1 = 1-2*rand(1,4);
y2 = 1-2*rand(1,4);
voronoi(y1,y2), axis([-2 2 -2 2])
title('Decision regions')
xlabel('y_1'), ylabel('y_2')