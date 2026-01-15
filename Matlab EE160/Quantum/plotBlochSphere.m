function plotBlochSphere(u)
% Plot Bloch sphere representation from 2-D complex amplitudes

%   Copyright 2021-2023 The MathWorks, Inc.

arguments
    u {mustBeNumeric,mustBeVector}
end

% Compute Bloch sphere representation (3-D real) from a 2-D complex vector
P = mapToBlochSphere(u);

% Grid view of the sphere
alpha = linspace(0,2,101)';
alpha(end+1) = NaN;
beta = linspace(0,1,7);
beta(end) = [];
gamma = linspace(-0.5,0.5,7);

% Meridian lines
meridianCoordinates = cat(3, cospi(beta).*cospi(alpha), ...
    sinpi(beta).*cospi(alpha), repmat(sinpi(alpha), 1, length(beta)));

% Latitude circles
latitudeCoordinates = cat(3, cospi(gamma).*cospi(alpha), ...
    cospi(gamma).*sinpi(alpha), repmat(sinpi(gamma), length(alpha), 1));

xyz = [reshape(meridianCoordinates,[],3); reshape(latitudeCoordinates,[],3)];

% Plot the grid and coordinate system
plot3(xyz(:,1), xyz(:,2), xyz(:,3), "k-", Color=0.8*[1 1 1])
hold on
plot3([1 0 0; -1 0 0], [0 1 0; 0 -1 0], [0 0 1; 0 0 -1], "b")

% Label qubit basis vectors for X basis and Z basis
text([0 0 1.2 -1.2], [0 0 0 0], [1.2 -1.2 0 0], ["|0>" "|1>" "|+>" "|->"], ...
    FontWeight="bold")

% Configure axis view
xlabel("x")
ylabel("y")
zlabel("z")
axis equal

% Plot the vector
plot3([0 P(1)], [0 P(2)], [0 P(3)], "r-", LineWidth=2)
plot3([0 P(1) P(1)], [0 P(2) P(2)], [0 0 P(3)], "r--")

hold off
end


function P = mapToBlochSphere(u)
% Compute Bloch sphere representation (3-D real) from a 2-D complex vector

theta = 2*atan2(abs(u(2)),abs(u(1)));
phi = angle(u(2)*conj(u(1)));
P =  [sin(theta)*cos(phi) sin(theta)*sin(phi) cos(theta)];

end