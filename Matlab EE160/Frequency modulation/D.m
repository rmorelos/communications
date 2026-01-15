% The unit triangular pulse
% EE 112 - Spring 2010. San Jose State University
function y=D(t)
y = (1-abs(t)).*P(t/2);
