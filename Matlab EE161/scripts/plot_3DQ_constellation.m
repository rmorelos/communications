% File: plot_3DQ_constellation.m
% Plots the three-dimensional constellation "3DQ" associated with a
% binary parity-check code and 2-PAM modulation
% EE 161 - Spring 2012, 2021 - San Jose State University

%%%% Does not display properly in 2011b ????

clear all
% Four signal points:
X = zeros(4,3);
X(1,:) = [ -1 -1 -1];
X(2,:) = [ -1  1  1];
X(3,:) = [  1 -1  1];
X(4,:) = [  1  1 -1];

% Compute the delaunay triangulation.
tri = delaunayn(X);
figure(1)
% Plot the constellation
tetramesh(tri,X,'FaceAlpha',0.3,'FaceColor','green'); camorbit(73,5); box on, rotate3d on
title('The 3DQ constellation: Vertices of a tetrahedron!')

figure(2)
% Plot the constellation
tetramesh(tri,X,'FaceAlpha',0.3,'FaceColor','green'); view(90,0);; box on, rotate3d on
title('The 3DQ constellation is a lifted QPSK contellation')

% DT = delaunayTriangulation(X);
% figure(2)
% [V,R] = voronoiDiagram(DT);
% tid = nearestNeighbor(DT,0,0,0);
% XR10 = V(R{tid},:);
% K = convhull(XR10);
% defaultFaceColor  = [0.6875 0.8750 0.8984];
% trisurf(K, XR10(:,1) ,XR10(:,2) ,XR10(:,3) , ...
%         'FaceColor', defaultFaceColor, 'FaceAlpha',0.8)
% title('3-D Voronoi Region')