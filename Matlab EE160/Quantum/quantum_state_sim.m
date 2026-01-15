% File: quantum_state_sim.m
% Local Quantum State Simulation
% EE160 - Fall 2023 - SJSU

gates = [hGate(1);
         cxGate(1,2);
         cxGate(1,3)];
C = quantumCircuit(gates);

figure(1), plot(C)

S = simulate(C,"111")

S.BasisStates

S.Amplitudes

f = formula(S)

f2 = formula(S,Basis="X")

figure(2), histogram(S)