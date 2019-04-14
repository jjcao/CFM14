function areaOfFacet = FacetArea(V,F)
% Compute the area of each triangle
%
% Baochang Han
% 2012-09-22

A = cross(V(F(:,2),:)- V(F(:,1),:), V(F(:,3),:)- V(F(:,1),:));
areaOfFacet = 0.5 * sqrt(A(:,1).^2+A(:,2).^2+A(:,3).^2);
