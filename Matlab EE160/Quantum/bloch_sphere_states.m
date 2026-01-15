% File: bloch_sphere_states.m
% Visualize States of Single Qubit in Bloch Sphere
% EE160 - Fall 2023 - SJSU

i = 01i;

figure(101)
plotBlochSphere([1; 0])
title('|0> state on Bloch sphere')

figure(102)
plotBlochSphere([0; 1])
title('|1> state on Bloch sphere')

figure(103)
plotBlochSphere([1; 1]/sqrt(2))
title('|+> state on Bloch sphere')

figure(104)
plotBlochSphere([1; -1]/sqrt(2))
title('|-> state on Bloch sphere')

figure(105)
plotBlochSphere([1; 1i]/sqrt(2))
title('|R> state on Bloch sphere')

figure(106)
plotBlochSphere([1; -1i]/sqrt(2))
title('|L> state on Bloch sphere')

